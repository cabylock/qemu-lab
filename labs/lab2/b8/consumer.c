#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include "stats.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("cabylock");
MODULE_DESCRIPTION("Consumer: uses compute_stats() from provider");

static int __init consumer_init(void)
{
    int data[] = { 10, 20, 30, 40, 50 };
    int n = sizeof(data) / sizeof(data[0]);
    struct stats_result r;
    int ret;

    ret = compute_stats(data, n, &r);
    if (ret != 0) {
        printk(KERN_ERR "consumer: compute_stats failed (%d)\n", ret);
        return ret;
    }

    printk(KERN_INFO "consumer: input = {10, 20, 30, 40, 50}\n");
    printk(KERN_INFO "consumer: sum = %lld\n", r.sum);
    printk(KERN_INFO "consumer: avg = %lld\n", r.avg);
    printk(KERN_INFO "consumer: max = %d\n", r.max);
    printk(KERN_INFO "consumer: min = %d\n", r.min);
    return 0;
}

static void __exit consumer_exit(void)
{
    printk(KERN_INFO "consumer: unloaded\n");
}

module_init(consumer_init);
module_exit(consumer_exit);
