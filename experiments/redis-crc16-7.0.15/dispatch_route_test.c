#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

uint16_t crc16(const char *, int);
uint16_t __real_crc16_xmodem(uint16_t, const uint8_t *, uint64_t);
uint16_t __real_crc16_xmodem_short(uint16_t, const uint8_t *, uint64_t);
uint16_t __real_crc16_xmodem_pmull(uint16_t, const uint8_t *, uint64_t);
static unsigned dispatch_calls, short_calls, pmull_calls;
uint16_t __wrap_crc16_xmodem(uint16_t seed, const uint8_t *p, uint64_t len) {
    ++dispatch_calls;
    return __real_crc16_xmodem(seed, p, len);
}
uint16_t __wrap_crc16_xmodem_short(uint16_t seed, const uint8_t *p, uint64_t len) {
    ++short_calls;
    assert(len >= 16 && len < 64);
    return __real_crc16_xmodem_short(seed, p, len);
}
uint16_t __wrap_crc16_xmodem_pmull(uint16_t seed, const uint8_t *p, uint64_t len) {
    ++pmull_calls;
    return __real_crc16_xmodem_pmull(seed, p, len);
}
int main(void) {
    char p[256];
    memset(p, 'a', sizeof(p));
    for (int len = 0; len <= 128; ++len) {
        unsigned before = dispatch_calls, short_before = short_calls, pmull_before = pmull_calls;
        (void)crc16(p, len);
        assert(dispatch_calls == before + 1);
        if (len < 16) {
            assert(short_calls == short_before && pmull_calls == pmull_before);
        } else if (len < 64) {
            assert(short_calls == short_before + 1);
        } else {
            assert(short_calls == short_before && pmull_calls == pmull_before + 1);
        }
    }
    assert(crc16(NULL, -1) == 0);
    assert(dispatch_calls == 129);
    printf("PASS all 129 nonnegative lengths pass through upstream dispatch; "
           "<16 scalar, 16..63 short, >=64 four-way; short_calls=%u pmull_calls=%u\n",
           short_calls, pmull_calls);
    return 0;
}
