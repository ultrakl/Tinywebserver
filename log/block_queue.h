/*************************************************************
 *循环数组实现的阻塞队列，m_back = (m_back + 1) % m_max_size;
 *线程安全，每个操作前都要先加互斥锁，操作完后，再解锁
 **************************************************************/

#ifndef BLOCK_QUEUE_H
#define BLOCK_QUEUE_H

#include "../lock/locker.h"
#include <iostream>
#include <pthread.h>
#include <stdlib.h>
#include <sys/time.h>
using namespace std;

template <class T> class block_queue {
public:
  block_queue(int max_size = 1000) {
    if (max_size <= 0) {
      exit(-1);
    }

    m_max_size = max_size;
    m_array = new T[max_size];
    m_size = 0;
    m_front = -1;
    m_back = -1;
  }

  void clear() {
    m_mutex.lock();
    m_size = 0;
    m_front = -1;
    m_back = -1;
    m_mutex.unlock();
  }

  ~block_queue() {
    m_mutex.lock();
    if (m_array != NULL)
      delete[] m_array;

    m_mutex.unlock();
  }
  // 判断队列是否满了
  bool full() {
    m_mutex.lock();
    if (m_size >= m_max_size) {

      m_mutex.unlock();
      return true;
    }
    m_mutex.unlock();
    return false;
  }
  // 判断队列是否为空
  bool empty() {
    m_mutex.lock();
    if (0 == m_size) {
      m_mutex.unlock();
      return true;
    }
    m_mutex.unlock();
    return false;
  }
  // 返回队首元素
  bool front(T &value) {
    m_mutex.lock();
    if (0 == m_size) {
      m_mutex.unlock();
      return false;
    }
    value = m_array[m_front];
    m_mutex.unlock();
    return true;
  }
  // 返回队尾元素
  bool back(T &value) {
    m_mutex.lock();
    if (0 == m_size) {
      m_mutex.unlock();
      return false;
    }
    value = m_array[m_back];
    m_mutex.unlock();
    return true;
  }

  int size() {
    int tmp = 0;

    m_mutex.lock();
    tmp = m_size;

    m_mutex.unlock();
    return tmp;
  }

  int max_size() {
    int tmp = 0;

    m_mutex.lock();
    tmp = m_max_size;

    m_mutex.unlock();
    return tmp;
  }
  // 往队列添加元素，需要将所有使用队列的线程先唤醒
  // 当有元素push进队列,相当于生产者生产了一个元素
  // 若当前没有线程等待条件变量,则唤醒无意义
  /* bool push(T&& item)
  {

      m_mutex.lock();
      if (m_size >= m_max_size)
      {

          m_cond.broadcast();
          m_mutex.unlock();
          return false;
      }

      m_back = (m_back + 1) % m_max_size;
      m_array[m_back] = move(item);
      m_size++;

      m_cond.broadcast();
      m_mutex.unlock();
      return true;
  } */

  bool push(const T& item) {
      m_mutex.lock();
      if (m_size >= m_max_size)
      {

          m_cond.broadcast();
          m_mutex.unlock();
          return false;
      }

      m_back = (m_back + 1) % m_max_size;
      m_array[m_back] = item;
      m_size++;

      m_cond.broadcast();
      m_mutex.unlock();
      return true;
  }
  /* template <class U> bool push(U &&item) {
    static_assert(is_constructible<T, U>::value,
                  "Parameter item can't be used to construct a element");
    // boost::core::demangle();
    m_mutex.lock();
    if (m_size >= m_max_size) {
      m_cond.broadcast();
      m_mutex.unlock();
      return false;
    }

    m_back = (m_back + 1) % m_max_size;
    m_array[m_back] = std::forward<U>(item);
    m_size++;

    m_cond.broadcast();
    m_mutex.unlock();
    return true;
  } */
  
  // pop时,如果当前队列没有元素,将会等待条件变量
  bool pop(T& item) {
    m_mutex.lock();
    while (m_size <= 0) {

      if (!m_cond.wait(m_mutex.get())) {
        m_mutex.unlock();
        return false;
      }
    }

    m_front = (m_front + 1) % m_max_size;
    item = m_array[m_front];
    m_size--;
    m_mutex.unlock();
    return true;
  }

  // 增加了超时处理, 此时item不一定非要被赋值，也就是说若出现虚假唤醒，直接返回即可
  // 当然这里的超时处理我也不满意，若虚假唤醒后时间仍然很充裕呢
  bool pop(T &item, int ms_timeout) {
    struct timespec t = {0, 0};
    struct timeval now = {0, 0};
    gettimeofday(&now, NULL);
    m_mutex.lock();
    if (m_size <= 0) {
      t.tv_sec = now.tv_sec + ms_timeout / 1000;
      t.tv_nsec = (ms_timeout % 1000) * 1000000;
      //   clock_gettime(CLOCK_REALTIME, &t);
    //   struct tm tmp = {.tm_mon = 3, .tm_year = 20};
    //   mktime(&tmp);
    //   char mkbtr[20];
    //   strftime(mkbtr, 19, "%D %T", &tmp);
    //   localtime_r(&t.tv_sec, &tmp);
      if (!m_cond.timewait(m_mutex.get(), t)) {
        m_mutex.unlock();
        return false;
      }
    }
    if (m_size <= 0) {
      m_mutex.unlock();
      return false;
    }

    m_front = (m_front + 1) % m_max_size;
    item = m_array[m_front];
    m_size--;
    m_mutex.unlock();
    return true;
  }

private:
  locker m_mutex;
  cond m_cond;

  T *m_array;
  int m_size;     // 阻塞队列当前长度
  int m_max_size; // 阻塞队列最大容量
  int m_front;    // 队首元素索引
  int m_back;     // 队末元素索引
};

#endif
