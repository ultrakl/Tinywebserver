#ifndef LOG_H
#define LOG_H

// #include <atomic>
// #include <mutex>
#include <stdio.h>
#include <iostream>
#include <string>
#include <stdarg.h>
#include <pthread.h>
#include "block_queue.h"

// using namespace std;

class Log
{
public:
    //c++11 内存屏障 + 释放-获取语义实现懒汉版本单例模式，
    /* static Log* get_instance() {
        Log* tmp = instance.load(memory_order_relaxed);
        atomic_thread_fence(memory_order_acquire);
        // 和release配对，保证instance的写操作对其他线程可见，若没有该屏障，则不能保证即使该单例指针已经可见，
        // 单例的构造函数也已经执行完毕,即保证下面一句和new语句的同步
        if(tmp == NULL) {
            lock_guard<mutex> lock(glomutex); 
            tmp = instance.load(memory_order_relaxed);
            if(tmp == NULL) {
                tmp = new Log;
                atomic_thread_fence(memory_order_release);
                instance.store(tmp, memory_order_relaxed);
            }
        }
        return tmp;
    } */
    //C++11以后,使用局部变量懒汉不用加锁
    static Log *get_instance()
    {
        static Log instance;
        return &instance;
    }

    static void *flush_log_thread(void *args)
    {
        get_instance()->async_write_log();
        return nullptr;
    }
    //可选择的参数有日志文件、日志缓冲区大小、最大行数以及最长日志条队列
    bool init(const char *file_name, int log_buf_size = 8192, int split_lines = 5000000, int max_queue_size = 0);

    void write_log(int level, const char *format, ...);

    void flush(void);

private:
    Log();
    virtual ~Log();
    void *async_write_log()
    {
        string single_log;
        //从阻塞队列中取出一个日志string，写入文件
        while (m_log_queue->pop(single_log))
        {
            m_mutex.lock();
            fputs(single_log.c_str(), m_fp);
            m_mutex.unlock();
        }
        return nullptr;
    }

private:
    char dir_name[128]; //路径名
    char log_name[128]; //log文件名
    int m_split_lines;  //日志最大行数
    int m_log_buf_size; //日志缓冲区大小
    long long m_count;  //日志行数记录
    int m_today;        //因为按天分类,记录当前时间是那一天
    FILE *m_fp;         //打开log的文件指针
    char *m_buf;
    block_queue<string> *m_log_queue; //阻塞队列
    bool m_is_async;                  //是否同步标志位
    locker m_mutex;
    // static atomic<Log*> instance;
    // static mutex glomutex;
};

// static Log::atomic<Log*> instance {nullptr};

#define LOG_DEBUG(format, ...) if(0 == m_close_log) {Log::get_instance()->write_log(0, format, ##__VA_ARGS__); Log::get_instance()->flush();}
#define LOG_INFO(format, ...) if(0 == m_close_log) {Log::get_instance()->write_log(1, format, ##__VA_ARGS__); Log::get_instance()->flush();}
#define LOG_WARN(format, ...) if(0 == m_close_log) {Log::get_instance()->write_log(2, format, ##__VA_ARGS__); Log::get_instance()->flush();}
#define LOG_ERROR(format, ...) if(0 == m_close_log) {Log::get_instance()->write_log(3, format, ##__VA_ARGS__); Log::get_instance()->flush();}

#endif
