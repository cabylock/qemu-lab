#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include "helper.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("cabylock");
MODULE_DESCRIPTION("Hello LKM split into two source files");

static int __init hello_multi_init(void)
{
    printk(KERN_INFO "hello_multi: module loaded\n");
    helper_greet();
    return 0;
}

static void __exit hello_multi_exit(void)
{
    printk(KERN_INFO "hello_multi: module unloaded\n");
}

module_init(hello_multi_init);
module_exit(hello_multi_exit);
