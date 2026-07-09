#include <chrono>
#include <condition_variable>
#include <iostream>
#include <mutex>
#include <queue>
#include <thread>

using namespace std;

queue<int> jobs;
mutex jobs_mutex;
condition_variable jobs_ready;
bool finished = false;

void producer() {
    for (int i = 1; i <= 5; ++i) {
        this_thread::sleep_for(chrono::milliseconds(200));

        {
            lock_guard<mutex> lock(jobs_mutex);
            jobs.push(i);
            cout << "producer: push job " << i << endl;
        }

        jobs_ready.notify_one();
    }

    {
        lock_guard<mutex> lock(jobs_mutex);
        finished = true;
    }
    jobs_ready.notify_one();
}

void consumer() {
    while (true) {
        unique_lock<mutex> lock(jobs_mutex);
        jobs_ready.wait(lock, [] {
            return !jobs.empty() || finished;
        });

        if (jobs.empty() && finished) {
            break;
        }

        int job = jobs.front();
        jobs.pop();
        lock.unlock();

        cout << "consumer: handle job " << job << endl;
    }
}

int main() {
    thread t1(producer);
    thread t2(consumer);

    t1.join();
    t2.join();

    cout << "demo done" << endl;
    return 0;
}
