/* Auto-generated PMULL folding constants for XMODEM CRC16 (poly=0x1021) */
#ifndef CRC16_XMODEM_CONSTANTS_H
#define CRC16_XMODEM_CONSTANTS_H

/* Main loop fold constant (scaled domain) */
#define FOLD_CONST_LO  0x0000000059B00000ULL
#define FOLD_CONST_HI  0x0000000060190000ULL

/* P1 fold (scaled domain) */
#define FOLD_P1_LO     0x0000000045630000ULL
#define FOLD_P1_HI     0x00000000D5F60000ULL

/* P0 CRC16 fold (unscaled domain, then << 16) */
#define FOLD_P0_LO     0x00000000AA510000ULL
#define FOLD_P0_HI     0x00000000EB230000ULL

/* Barrett reduction */
#define BARRETT_MU     0x0000000111303471ULL
#define BARRETT_POLY   0x0000000110210000ULL

/* XMODEM polynomial */
#define CRC16_XMODEM_POLY 0x1021

#endif
