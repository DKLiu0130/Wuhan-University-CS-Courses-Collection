#include <rthw.h>
#include <rtthread.h>
#include "appdef.h"

static rt_thread_t tid1 = RT_NULL;
static rt_thread_t tid2 = RT_NULL;
/* 同时访问的全局变量 */
static rt_uint32_t cnt;
void thread_entry(void *parameter)
{
    rt_uint32_t no;
    rt_uint32_t level;

    no = (rt_uint32_t) parameter;
    while (1)
    {
        /* 关闭全局中断 */
        level = rt_hw_interrupt_disable();
        cnt += no;
        /* 恢复全局中断 */
        rt_hw_interrupt_enable(level);

        rt_kprintf("protect thread[%d]'s counter is %d\n", no, cnt);
        rt_thread_mdelay(no * 10);
    }
}
static rt_thread_t tid_exit = RT_NULL;
void exitApp11(void *parameter){
    while(1){
        if(READ_SW()>>14==1){
            rt_kprintf("准备退出dynmem_sample\n");
            rt_thread_delete(tid1);
            rt_thread_delete(tid2);
            rt_kprintf("成功退出dynmem_sample\n");
            //startApp();
            // resume_appStart();
            continue_next();
            return;
        }
        rt_thread_delay(100);
    }
}
/* 用户应用程序入口 */
int interrupt_sample(void *parameter)
{
    cnt=0;
    /* 创建 t1 线程 */
    tid1 = rt_thread_create("thread1", thread_entry, (void *)10,
                              THREAD_STACK_SIZE,
                              THREAD_PRIORITY, THREAD_TIMESLICE);
    if (tid1 != RT_NULL)
        rt_thread_startup(tid1);


    /* 创建 t2 线程 */
    tid2 = rt_thread_create("thread2", thread_entry, (void *)20,
                              THREAD_STACK_SIZE,
                              THREAD_PRIORITY, THREAD_TIMESLICE);
    if (tid2 != RT_NULL)
        rt_thread_startup(tid2);

    tid_exit = rt_thread_create("extAppb",
                            exitApp11, RT_NULL,
                            THREAD_STACK_SIZE,
                            THREAD_PRIORITY, THREAD_TIMESLICE);

    /* 如果获得线程控制块，启动这个线程 */
    if (tid_exit != RT_NULL)
        rt_thread_startup(tid_exit);
    return 0;
}

/* 导出到 msh 命令列表中 */
MSH_CMD_EXPORT(interrupt_sample, interrupt sample);
