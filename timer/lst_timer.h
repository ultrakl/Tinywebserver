#ifndef LST_TIMER
#define LST_TIMER

#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <assert.h>
#include <sys/stat.h>
#include <string.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <stdarg.h>
#include <errno.h>
#include <sys/wait.h>
#include <sys/uio.h>

#include <time.h>
#include "../log/log.h"

class util_timer;

/**
 * @brief Represents client data structure. This structure holds information about the client, such as the client's address, socket file descriptor, and a pointer to the associated timer.
 */
struct client_data
{
    sockaddr_in address;    ///< The client's address
    int sockfd;             ///< The client's socket file descriptor
    util_timer *timer;      ///< Pointer to the associated timer
};

/**
 * @brief Represents a timer node in a linked list.
 */
class util_timer 
{
public:
    util_timer() : prev(NULL), next(NULL) {}

public:
    time_t expire;              ///< The expiration time of the timer (absolute time)
    void (* cb_func)(client_data *);    ///< Callback function to be triggered when the timer expires
    client_data *user_data;     ///< Pointer to the client data associated with the timer
    util_timer *prev;           ///< Pointer to the previous timer node
    util_timer *next;           ///< Pointer to the next timer node
};


class sort_timer_lst //管理链表
{
public:
    sort_timer_lst();
    ~sort_timer_lst();

    void add_timer(util_timer *timer);
    void adjust_timer(util_timer *timer);
    void del_timer(util_timer *timer);
    void tick();

private:
    void add_timer(util_timer *timer, util_timer *lst_head);

    util_timer *head;   ///< Pointer to the head of the timer linked list
    util_timer *tail;   ///< Pointer to the tail of the timer linked list
};

class Utils
{
public:
    Utils() {}
    ~Utils() {}

    void init(int timeslot);

    //对文件描述符设置非阻塞
    int setnonblocking(int fd);

    //将内核事件表注册读事件，ET模式，选择开启EPOLLONESHOT
    void addfd(int epollfd, int fd, bool one_shot, int TRIGMode);

    //信号处理函数
    static void sig_handler(int sig);

    //设置信号函数
    void addsig(int sig, void(handler)(int), bool restart = true);

    //定时处理任务，重新定时以不断触发SIGALRM信号
    void timer_handler();

    void show_error(int connfd, const char *info);

public:
    static int *u_pipefd;
    sort_timer_lst m_timer_lst;
    static int u_epollfd;
    int m_TIMESLOT;
};

void cb_func(client_data *user_data);

#endif
