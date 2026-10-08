#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/sched.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("cabylock");
MODULE_DESCRIPTION("Print current process name and PID");

static int __init hello_proc_init(void)
{
    printk(KERN_INFO "hello_proc: loaded by process \"%s\" (pid=%d)\n",
           current->comm, current->pid);
    return 0;
}

static void __exit hello_proc_exit(void)
{
    printk(KERN_INFO "hello_proc: unloaded\n");
}

module_init(hello_proc_init);
module_exit(hello_proc_exit);
