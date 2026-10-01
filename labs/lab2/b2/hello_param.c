#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Your Name");
MODULE_DESCRIPTION("Hello LKM with parameters");

static char *whom = "world";
module_param(whom, charp, 0644);
MODULE_PARM_DESC(whom, "Whom to greet (default: world)");

static int howmany = 1;
module_param(howmany, int, 0644);
MODULE_PARM_DESC(howmany, "Number of greetings (default: 1)");

static int __init hello_param_init(void)
{
    int i;

    if (howmany < 1) {
        printk(KERN_INFO "hello_param: howmany must be >= 1, using 1\n");
        howmany = 1;
    }

    for (i = 1; i <= howmany; i++) {
        printk(KERN_INFO "hello_param: Hello, %s! [%d/%d]\n",
               whom, i, howmany);
    }
    return 0;
}

static void __exit hello_param_exit(void)
{
    printk(KERN_INFO "hello_param: Bye, %s!\n", whom);
}

module_init(hello_param_init);
module_exit(hello_param_exit);
