#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include "stats.h"

MODULE_LICENSE("GPL");
MODULE_AUTHOR("cabylock");
MODULE_DESCRIPTION("Provider: exports compute_stats()");

int compute_stats(const int *arr, int count, struct stats_result *out)
{
    int i;
    long long sum = 0;

    if (!arr || count <= 0 || !out)
        return -EINVAL;

    out->min = arr[0];
    out->max = arr[0];

    for (i = 0; i < count; i++) {
        sum += arr[i];
        if (arr[i] < out->min)
            out->min = arr[i];
        if (arr[i] > out->max)
            out->max = arr[i];
    }

    out->sum = sum;
    out->avg = sum / count;   /* integer division */
    return 0;
}
EXPORT_SYMBOL(compute_stats);

static int __init provider_init(void)
{
    printk(KERN_INFO "provider: loaded (exports compute_stats)\n");
    return 0;
}

static void __exit provider_exit(void)
{
    printk(KERN_INFO "provider: unloaded\n");
}

module_init(provider_init);
module_exit(provider_exit);
