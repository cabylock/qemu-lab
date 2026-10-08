#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("cabylock");
MODULE_DESCRIPTION("Print 1..n and sum of squares");

static int n = 1;
module_param(n, int, 0644);
MODULE_PARM_DESC(n, "Upper bound (default: 1)");

static int __init ini_mod(void)
{
    int i;
    long long s = 0;

    if (n < 1) {
        printk(KERN_INFO "b3: n must be >= 1, using 1\n");
        n = 1;
    }

    for (i = 1; i <= n; i++) {
        printk(KERN_INFO "b3: i = %d\n", i);
        s += (long long)i * i;
    }

    printk(KERN_INFO "b3: sum of squares 1..%d = %lld\n", n, s);
    return 0;
}

static void __exit exit_mod(void)
{
    printk(KERN_INFO "Done with n=%d\n", n);
}

module_init(ini_mod);
module_exit(exit_mod);
