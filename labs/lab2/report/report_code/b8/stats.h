#ifndef STATS_H
#define STATS_H

struct stats_result {
    long long sum;
    long long avg;
    int max;
    int min;
};

int compute_stats(const int *arr, int count, struct stats_result *out);

#endif
