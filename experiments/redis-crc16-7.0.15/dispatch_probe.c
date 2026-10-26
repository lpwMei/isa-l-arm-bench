#include <stdint.h>
#include <stdio.h>
#include <string.h>

uint16_t crc16_xmodem(uint16_t, const uint8_t *, uint64_t);
uint16_t crc16_xmodem_pmull(uint16_t, const uint8_t *, uint64_t);

static uint16_t reference(uint16_t crc, const uint8_t *buf, int len) {
    for (int i = 0; i < len; ++i) {
        crc ^= (uint16_t)buf[i] << 8;
        for (int j = 0; j < 8; ++j)
            crc = (uint16_t)((crc << 1) ^ ((crc & 0x8000) ? 0x1021 : 0));
    }
    return crc;
}

int main(void) {
    uint8_t data[1024];
    memset(data, 'a', sizeof(data));
    const int lengths[] = {0, 1, 9, 15, 16, 17, 31, 32, 33, 47, 48, 49, 63, 64, 65};
    puts("length,expected,upstream_dispatch,pmull_direct,expected_slot,dispatch_slot");
    for (unsigned i = 0; i < sizeof(lengths)/sizeof(*lengths); ++i) {
        int n = lengths[i];
        uint16_t ref = reference(0, data, n), got = crc16_xmodem(0, data, n);
        printf("%d,%04x,%04x,%04x,%u,%u\n", n, ref, got,
               crc16_xmodem_pmull(0, data, n), ref & 16383, got & 16383);
    }
    unsigned failures = 0, cases = 0;
    const uint16_t seeds[] = {0, 1, 0xffff, 0x1234};
    for (unsigned i = 0; i < sizeof(data); ++i) data[i] = (uint8_t)(i * 7 + 13);
    for (unsigned s = 0; s < sizeof(seeds)/sizeof(*seeds); ++s)
        for (int offset = 0; offset < 64; ++offset)
            for (int n = 0; n <= 256; ++n) {
                ++cases;
                if (reference(seeds[s], data + offset, n) != crc16_xmodem(seeds[s], data + offset, n))
                    ++failures;
            }
    printf("cases=%u failures=%u\n", cases, failures);
    return failures != 0;
}
