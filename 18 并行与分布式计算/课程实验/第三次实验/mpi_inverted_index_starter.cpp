#include <mpi.h>

#include <algorithm>
#include <cctype>
#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <string>
#include <vector>

struct Document {
    int id = 0;
    std::string path;
    std::string title;
};

using InvertedIndex = std::map<std::string, std::set<int>>;

std::vector<Document> LoadManifest(const std::string& manifest_path) {
    std::ifstream fin(manifest_path);
    std::vector<Document> docs;
    std::string line;
    std::getline(fin, line);
    while (std::getline(fin, line)) {
        std::stringstream ss(line);
        std::string id_text;
        Document doc;
        std::getline(ss, id_text, '\t');
        std::getline(ss, doc.path, '\t');
        std::getline(ss, doc.title);
        if (id_text.empty() || doc.path.empty()) {
            continue;
        }
        doc.id = std::stoi(id_text);
        docs.push_back(doc);
    }
    return docs;
}

std::vector<Document> SelectLocalDocuments(const std::vector<Document>& docs, int rank, int size) {
    std::vector<Document> local;
    for (int i = 0; i < static_cast<int>(docs.size()); ++i) {
        if (i % size == rank) {
            local.push_back(docs[i]);
        }
    }
    return local;
}

InvertedIndex BuildLocalIndex(const std::vector<Document>& docs) {
    InvertedIndex index;
    for (const auto& doc : docs) {
        std::ifstream fin(doc.path);
        if (!fin) {
            continue;
        }

        std::set<std::string> unique_words;
        std::string line;
        while (std::getline(fin, line)) {
            std::string word;
            for (unsigned char ch : line) {
                if (std::isalpha(ch)) {
                    word.push_back(static_cast<char>(std::tolower(ch)));
                } else if (word.size() >= 2) {
                    unique_words.insert(word);
                    word.clear();
                } else {
                    word.clear();
                }
            }
            if (word.size() >= 2) {
                unique_words.insert(word);
            }
        }

        for (const auto& word : unique_words) {
            index[word].insert(doc.id);
        }
    }
    return index;
}

std::string SerializeIndex(const InvertedIndex& index) {
    std::ostringstream out;
    for (const auto& [word, docs] : index) {
        out << word << "\t";
        bool first = true;
        for (int doc_id : docs) {
            if (!first) {
                out << ",";
            }
            first = false;
            out << doc_id;
        }
        out << "\n";
    }
    return out.str();
}

void MergeSerializedIndex(InvertedIndex& global, const std::string& payload) {
    std::stringstream payload_stream(payload);
    std::string line;
    while (std::getline(payload_stream, line)) {
        if (line.empty()) {
            continue;
        }

        std::size_t tab = line.find('\t');
        if (tab == std::string::npos) {
            continue;
        }

        std::string word = line.substr(0, tab);
        std::string ids = line.substr(tab + 1);
        std::stringstream id_stream(ids);
        std::string id_text;
        while (std::getline(id_stream, id_text, ',')) {
            if (!id_text.empty()) {
                global[word].insert(std::stoi(id_text));
            }
        }
    }
}

void WriteIndex(const InvertedIndex& index, const std::string& output_path) {
    std::ofstream fout(output_path);
    for (const auto& [word, docs] : index) {
        fout << word << "\t";
        bool first = true;
        for (int doc_id : docs) {
            if (!first) {
                fout << ",";
            }
            first = false;
            fout << doc_id;
        }
        fout << "\n";
    }
}

long long CountPostingPairs(const InvertedIndex& index) {
    long long total = 0;
    for (const auto& [word, docs] : index) {
        total += static_cast<long long>(docs.size());
    }
    return total;
}

InvertedIndex ReadIndexFile(const std::string& path) {
    InvertedIndex index;
    std::ifstream fin(path);
    std::string line;
    while (std::getline(fin, line)) {
        if (line.empty()) {
            continue;
        }
        std::size_t tab = line.find('\t');
        if (tab == std::string::npos) {
            continue;
        }
        std::string word = line.substr(0, tab);
        std::string ids = line.substr(tab + 1);
        std::stringstream id_stream(ids);
        std::string id_text;
        while (std::getline(id_stream, id_text, ',')) {
            if (!id_text.empty()) {
                index[word].insert(std::stoi(id_text));
            }
        }
    }
    return index;
}

bool CompareIndex(const InvertedIndex& actual,
                  const InvertedIndex& expected,
                  std::string& message) {
    if (actual.size() != expected.size()) {
        message = "unique_terms mismatch";
        return false;
    }
    auto it_actual = actual.begin();
    auto it_expected = expected.begin();
    for (; it_actual != actual.end() && it_expected != expected.end(); ++it_actual, ++it_expected) {
        if (it_actual->first != it_expected->first) {
            message = "first mismatched term: actual=" + it_actual->first +
                      ", expected=" + it_expected->first;
            return false;
        }
        if (it_actual->second != it_expected->second) {
            message = "posting list mismatch for term: " + it_actual->first;
            return false;
        }
    }
    message = "matched";
    return true;
}

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);

    int rank = 0;
    int size = 0;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    std::string manifest_path = "data/books_manifest.tsv";
    std::string reference_path = "data/reference_index.tsv";
    if (argc >= 2) {
        manifest_path = argv[1];
    }
    if (argc >= 3) {
        reference_path = argv[2];
    }

    std::vector<Document> docs = LoadManifest(manifest_path);
    std::vector<Document> local_docs = SelectLocalDocuments(docs, rank, size);

    MPI_Barrier(MPI_COMM_WORLD);
    double t0 = MPI_Wtime();

    InvertedIndex local_index = BuildLocalIndex(local_docs);
    std::string payload = SerializeIndex(local_index);

    InvertedIndex global_index;
    if (rank == 0) {
        MergeSerializedIndex(global_index, payload);
        for (int src = 1; src < size; ++src) {
            int length = 0;
            MPI_Recv(&length, 1, MPI_INT, src, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            std::string received(length, '\0');
            if (length > 0) {
                MPI_Recv(received.data(), length, MPI_CHAR, src, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            }
            MergeSerializedIndex(global_index, received);
        }
    } else {
        int length = static_cast<int>(payload.size());
        MPI_Send(&length, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
        if (length > 0) {
            MPI_Send(payload.data(), length, MPI_CHAR, 0, 1, MPI_COMM_WORLD);
        }
    }

    MPI_Barrier(MPI_COMM_WORLD);
    double t1 = MPI_Wtime();

    int local_doc_count = static_cast<int>(local_docs.size());
    int total_doc_count = 0;
    MPI_Reduce(&local_doc_count, &total_doc_count, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        WriteIndex(global_index, "output_global_index.txt");
        InvertedIndex reference_index = ReadIndexFile(reference_path);
        std::string compare_message;
        bool reference_match = CompareIndex(global_index, reference_index, compare_message);
        long long posting_pairs = CountPostingPairs(global_index);
        bool pass = total_doc_count == static_cast<int>(docs.size()) &&
                    reference_match;
        std::cout << "mpi_size:        " << size << "\n";
        std::cout << "documents:       " << docs.size() << "\n";
        std::cout << "indexed_docs:    " << total_doc_count << "\n";
        std::cout << "unique_terms:    " << global_index.size() << "\n";
        std::cout << "reference_terms: " << reference_index.size() << "\n";
        std::cout << "posting_pairs:   " << posting_pairs << "\n";
        std::cout << "elapsed_sec:     " << (t1 - t0) << "\n";
        std::cout << "output:          output_global_index.txt\n";
        std::cout << "reference:       " << reference_path << "\n";
        std::cout << "check:           " << compare_message << "\n";
        std::cout << "status:          " << (pass ? "PASS" : "FAIL") << "\n";
    }

    MPI_Finalize();
    return 0;
}
