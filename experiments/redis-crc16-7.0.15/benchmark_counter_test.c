/* Compile the actual patched benchmark into the test to exercise its parser
 * and atomic counter types, without issuing ten billion network requests. */
#define main redisBenchmarkMain
#include "../baseline/src/redis-benchmark.c"
#undef main

int main(void) {
    char *args[] = {"redis-benchmark", "-n", "10000000000", NULL};
    assert(parseOptions(3, args) == 3);
    assert(config.requests == 10000000000LL);
    long long old;
    config.requests_issued = 2147483640LL;
    atomicGetIncr(config.requests_issued, old, 16);
    assert(old == 2147483640LL && config.requests_issued == 2147483656LL);
    config.requests_finished = 4294967295LL;
    atomicGetIncr(config.requests_finished, old, 1);
    assert(old == 4294967295LL && config.requests_finished == 4294967296LL);
    atomicSet(config.previous_requests_finished, 9999999999LL);
    atomicGet(config.previous_requests_finished, old);
    assert(old == 9999999999LL);
    puts("PASS -n 10000000000 parser; issued crosses INT32_MAX; finished crosses UINT32_MAX; previous counter is 64-bit");
    return 0;
}
