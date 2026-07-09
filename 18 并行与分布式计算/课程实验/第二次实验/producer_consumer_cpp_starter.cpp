#include <atomic>
#include <chrono>
#include <condition_variable>
#include <iostream>
#include <mutex>
#include <thread>
#include <vector>

using namespace std;

constexpr int BUFFER_CAPACITY = 16;
constexpr int PRODUCER_COUNT = 4;
constexpr int CONSUMER_COUNT = 4;
constexpr int ITEMS_PER_PRODUCER = 5000;
constexpr int TOTAL_ITEMS = PRODUCER_COUNT * ITEMS_PER_PRODUCER;
constexpr int STOP_ITEM = -1;

struct BoundedBuffer {
    vector<int> data;
    int head = 0;
    int tail = 0;
    int count = 0;

    mutex mtx;
    condition_variable not_full;
    condition_variable not_empty;
};

struct SharedStats {
    vector<int> seen;
    mutex mtx;
    atomic<int> produced{0};
    atomic<int> consumed{0};
    atomic<int> push_failed{0};
    atomic<int> pop_failed{0};
};

void InitBuffer(BoundedBuffer& buffer, int capacity) {
    buffer.data.assign(capacity, 0);
    buffer.head = 0;
    buffer.tail = 0;
    buffer.count = 0;
}

bool BufferPush(BoundedBuffer& buffer, int item) {
    // 1. 创建 unique_lock 锁定互斥量
    unique_lock<mutex> lock(buffer.mtx);

    // 2. 等待缓冲区不满 (Wait on buffer.not_full)
    // lambda 表达式返回 true 时停止等待
    buffer.not_full.wait(lock, [&buffer] {
        return buffer.count < static_cast<int>(buffer.data.size());
    });

    // 3. 将数据写入 buffer.tail 指向的位置
    buffer.data[buffer.tail] = item;

    // 4. 更新 tail（循环索引）并增加 count
    buffer.tail = (buffer.tail + 1) % buffer.data.size();
    buffer.count++;

    // 5. 解锁（lock 在作用域结束或手动解锁时释放）
    lock.unlock();

    // 6. 通知一个正在等待的消费者
    buffer.not_empty.notify_one();

    return true;
}

bool BufferPop(BoundedBuffer& buffer, int& item) {
    // 1. 创建 unique_lock 锁定互斥量
    unique_lock<mutex> lock(buffer.mtx);

    // 2. 等待缓冲区不为空 (Wait on buffer.not_empty)
    buffer.not_empty.wait(lock, [&buffer] {
        return buffer.count > 0;
    });

    // 3. 从 buffer.head 指向的位置读取数据
    item = buffer.data[buffer.head];

    // 4. 更新 head（循环索引）并减少 count
    buffer.head = (buffer.head + 1) % buffer.data.size();
    buffer.count--;

    // 5. 解锁
    lock.unlock();

    // 6. 通知一个正在等待的生产者
    buffer.not_full.notify_one();

    return true;
}

void ProducerThread(BoundedBuffer& buffer, SharedStats& stats, int producer_id) {
    int base = producer_id * ITEMS_PER_PRODUCER;
    for (int i = 0; i < ITEMS_PER_PRODUCER; ++i) {
        if (BufferPush(buffer, base + i)) {
            ++stats.produced;
        } else {
            ++stats.push_failed;
            return;
        }
    }
}

void ConsumerThread(BoundedBuffer& buffer, SharedStats& stats) {
    while (true) {
        int item = 0;
        if (!BufferPop(buffer, item)) {
            ++stats.pop_failed;
            return;
        }

        if (item == STOP_ITEM) {
            return;
        }

        if (item >= 0 && item < TOTAL_ITEMS) {
            lock_guard<mutex> lock(stats.mtx);
            ++stats.seen[item];
        }

        ++stats.consumed;
    }
}

bool CheckResult(const SharedStats& stats) {
    if (stats.produced != TOTAL_ITEMS || stats.consumed != TOTAL_ITEMS) {
        return false;
    }
    if (stats.push_failed != 0 || stats.pop_failed != 0) {
        return false;
    }
    for (int value : stats.seen) {
        if (value != 1) {
            return false;
        }
    }
    return true;
}

int main() {
    BoundedBuffer buffer;
    InitBuffer(buffer, BUFFER_CAPACITY);

    SharedStats stats;
    stats.seen.assign(TOTAL_ITEMS, 0);

    vector<thread> producers;
    vector<thread> consumers;

    auto t0 = chrono::steady_clock::now();

    for (int i = 0; i < CONSUMER_COUNT; ++i) {
        consumers.emplace_back(ConsumerThread, ref(buffer), ref(stats));
    }
    for (int i = 0; i < PRODUCER_COUNT; ++i) {
        producers.emplace_back(ProducerThread, ref(buffer), ref(stats), i);
    }

    for (thread& t : producers) {
        t.join();
    }

    for (int i = 0; i < CONSUMER_COUNT; ++i) {
        BufferPush(buffer, STOP_ITEM);
    }
    for (thread& t : consumers) {
        t.join();
    }

    auto t1 = chrono::steady_clock::now();
    long long elapsed_ms = chrono::duration_cast<chrono::milliseconds>(t1 - t0).count();

    bool pass = CheckResult(stats);
    cout << "producers:       " << PRODUCER_COUNT << endl;
    cout << "consumers:       " << CONSUMER_COUNT << endl;
    cout << "buffer_capacity: " << BUFFER_CAPACITY << endl;
    cout << "produced_total:  " << stats.produced << endl;
    cout << "consumed_total:  " << stats.consumed << endl;
    cout << "push_failed:     " << stats.push_failed << endl;
    cout << "pop_failed:      " << stats.pop_failed << endl;
    cout << "elapsed_ms:      " << elapsed_ms << endl;
    cout << "status:          " << (pass ? "PASS" : "FAIL") << endl;

    return pass ? 0 : 1;
}
