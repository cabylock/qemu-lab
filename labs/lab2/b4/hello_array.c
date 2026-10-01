#include <linux/module.h>
#include <linux/init.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("cabylock");
MODULE_DESCRIPTION("Hello LKM with array parameter");

#define MAX_NUMS 10

static int nums[MAX_NUMS];
static int nums_count = 1;
static int nums_argc = 0;

module_param_array(nums, int, &nums_argc, 0644);
MODULE_PARM_DESC(nums, "Array of integers (max 10 elements)");

static int __init hello_array_init(void)
{
    int i;
    long long sum = 0;

    if (nums_argc > MAX_NUMS) {
        printk(KERN_INFO "hello_array: too many elements (%d), truncating to %d\n",
               nums_argc, MAX_NUMS);
        nums_count = MAX_NUMS;
    } else if (nums_argc < 1) {
        printk(KERN_INFO "hello_array: no elements given, using default {0}\n");
        nums[0] = 0;
        nums_count = 1;
    } else {
        nums_count = nums_argc;
    }

    for (i = 0; i < nums_count; i++) {
        printk(KERN_INFO "hello_array: nums[%d] = %d\n", i, nums[i]);
        sum += nums[i];
    }

    printk(KERN_INFO "hello_array: sum = %lld\n", sum);
    return 0;
}

static void __exit hello_array_exit(void)
{
    printk(KERN_INFO "hello_array: unloaded\n");
}

module_init(hello_array_init);
module_exit(hello_array_exit);
