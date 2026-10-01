#ifndef STATS_H
#define STATS_H

struct stats_result {
    long long sum;
    long long avg;   /* integer average (truncated) */
    int max;
    int min;
};

/*
 * Compute basic statistics over an array of integers.
 *
 * @arr: pointer to the input array (must be non-NULL when count > 0)
 * @count: number of elements in the array (must be > 0)
 * @out: pointer to a stats_result that receives the result
 *
 * Returns 0 on success, -EINVAL on invalid arguments.
 */
int compute_stats(const int *arr, int count, struct stats_result *out);

#endif
