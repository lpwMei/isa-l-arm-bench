/////////////////////////////////////////////////////////////////////////
// XMODEM CRC16 PMULL-optimized AARCH64 implementation (v2)
// Polynomial: 0x1021 (CRC-16/XMODEM, CRC-16-CCITT)
//
// Optimizations over v1:
//   1. LD1 4-register form (replaces 2×LDP, saves 2 instr/iter)
//   2. Loop unrolling ×2 (128B per branch, halves loop overhead)
//   3. Interleaved instruction scheduling (hides PMULL/TBL latency)
//
// uint16_t crc16_xmodem_pmull_opt(uint16_t seed, const uint8_t *buf, uint64_t len);
/////////////////////////////////////////////////////////////////////////

	.arch armv8-a+crc+crypto
	.text
	.align	3
	.global	crc16_xmodem_pmull_opt
#ifndef __APPLE__
	.type	crc16_xmodem_pmull_opt, %function
#endif

/* ================================================================= */
/* Entry point                                                       */
/* ================================================================= */
crc16_xmodem_pmull_opt:
	cmp	x2, 63
	sub	sp, sp, #16
	uxth	w0, w0
	bhi	.crc_fold

/* ================================================================= */
/* Scalar table path: < 64 bytes                                     */
/* ================================================================= */
	mov	x5, 0
	mov	w3, 0

.crc_table_loop_pre:
	cmp	x2, x5
	bhi	1f
	b	.end
1:
#ifndef __APPLE__
	sxtw	x3, w3
	adrp	x4, .LANCHOR0
	sub	x1, x1, x3
	add	x4, x4, :lo12:.LANCHOR0
#else
	sxtw	x3, w3
	adrp	x4, .LANCHOR0@PAGE
	sub	x1, x1, x3
	add	x4, x4, .LANCHOR0@PAGEOFF
#endif
	.align 2
.crc_table_loop:
	ldrb	w5, [x1, x3]
	add	x3, x3, 1
	cmp	x2, x3
	eor	w5, w5, w0, lsr 8
	ldrh	w5, [x4, w5, sxtw 1]
	eor	w0, w5, w0, lsl 8
	uxth	w0, w0
	bhi	.crc_table_loop

.end:
	add	sp, sp, 16
	ret

/* ================================================================= */
/* PMULL folding: buffer >= 64 bytes                                 */
/* ================================================================= */
	.align 3
.crc_fold:
	/* Scale 16-bit seed to 32-bit: bits [47:32] */
	fmov	d0, x0
	fmov	d1, xzr
	dup	d16, v1.d[0]
	shl	d0, d0, 48
	ins	v16.d[1], v0.d[0]

	/* Load byte-reverse shuffle mask */
#ifndef __APPLE__
	adrp	x5, .shuffle_mask_lanchor
	ldr	q7, [x5, :lo12:.shuffle_mask_lanchor]
#else
	adrp	x5, .shuffle_mask_lanchor@PAGE
	ldr	q7, [x5, .shuffle_mask_lanchor@PAGEOFF]
#endif

	/* Load main loop fold constant */
	ldr	q17, fold_constant

	/* Round length to 128-byte boundary */
	and	x3, x2, -128
	cmp	x3, 128
	blt	.crc_single_loop

	/* Pre-load first 128B (two 64B blocks) */
	ld1	{v28.16b-v31.16b}, [x1], #64

	/* Init: first block XOR seed, TBL byte-reverse */
	tbl	v0.16b, {v28.16b}, v7.16b
	eor	v2.16b, v16.16b, v0.16b
	tbl	v3.16b, {v29.16b}, v7.16b
	tbl	v4.16b, {v30.16b}, v7.16b
	tbl	v5.16b, {v31.16b}, v7.16b

	/* Load second block, fold first into accumulators */
	ld1	{v28.16b-v31.16b}, [x1], #64

	pmull2	v24.1q, v2.2d, v17.2d
	tbl	v28.16b, {v28.16b}, v7.16b
	pmull	v2.1q, v2.1d, v17.1d

	pmull2	v25.1q, v3.2d, v17.2d
	tbl	v29.16b, {v29.16b}, v7.16b
	pmull	v3.1q, v3.1d, v17.1d

	eor	v2.16b, v24.16b, v2.16b

	pmull2	v26.1q, v4.2d, v17.2d
	tbl	v30.16b, {v30.16b}, v7.16b
	eor	v2.16b, v2.16b, v28.16b

	pmull	v4.1q, v4.1d, v17.1d
	eor	v3.16b, v25.16b, v3.16b

	pmull2	v27.1q, v5.2d, v17.2d
	tbl	v31.16b, {v31.16b}, v7.16b
	eor	v3.16b, v3.16b, v29.16b

	pmull	v5.1q, v5.1d, v17.1d
	eor	v4.16b, v26.16b, v4.16b
	eor	v4.16b, v4.16b, v30.16b

	eor	v5.16b, v27.16b, v5.16b
	eor	v5.16b, v5.16b, v31.16b

	sub	x3, x3, 128
	cbz	x3, .crc_mid_check

/* ================================================================= */
/* Main loop: 128B per iteration (2×64B unrolled, interleaved)       */
/* ================================================================= */
	.align 3
.crc_fold_loop:
	/* ---- Block 1 ---- */
	ld1	{v28.16b-v31.16b}, [x1], #64

	pmull2	v24.1q, v2.2d, v17.2d
	tbl	v28.16b, {v28.16b}, v7.16b
	pmull	v2.1q, v2.1d, v17.1d

	pmull2	v25.1q, v3.2d, v17.2d
	tbl	v29.16b, {v29.16b}, v7.16b
	pmull	v3.1q, v3.1d, v17.1d

	eor	v2.16b, v24.16b, v2.16b

	pmull2	v26.1q, v4.2d, v17.2d
	tbl	v30.16b, {v30.16b}, v7.16b
	eor	v2.16b, v2.16b, v28.16b

	pmull	v4.1q, v4.1d, v17.1d
	eor	v3.16b, v25.16b, v3.16b

	pmull2	v27.1q, v5.2d, v17.2d
	tbl	v31.16b, {v31.16b}, v7.16b
	eor	v3.16b, v3.16b, v29.16b

	prfm	pldl2strm, [x1, 1024]

	pmull	v5.1q, v5.1d, v17.1d
	eor	v4.16b, v26.16b, v4.16b
	eor	v4.16b, v4.16b, v30.16b

	eor	v5.16b, v27.16b, v5.16b
	eor	v5.16b, v5.16b, v31.16b

	/* ---- Block 2 ---- */
	ld1	{v28.16b-v31.16b}, [x1], #64

	pmull2	v24.1q, v2.2d, v17.2d
	tbl	v28.16b, {v28.16b}, v7.16b
	pmull	v2.1q, v2.1d, v17.1d

	pmull2	v25.1q, v3.2d, v17.2d
	tbl	v29.16b, {v29.16b}, v7.16b
	pmull	v3.1q, v3.1d, v17.1d

	eor	v2.16b, v24.16b, v2.16b

	pmull2	v26.1q, v4.2d, v17.2d
	tbl	v30.16b, {v30.16b}, v7.16b
	eor	v2.16b, v2.16b, v28.16b

	pmull	v4.1q, v4.1d, v17.1d
	eor	v3.16b, v25.16b, v3.16b

	pmull2	v27.1q, v5.2d, v17.2d
	tbl	v31.16b, {v31.16b}, v7.16b
	eor	v3.16b, v3.16b, v29.16b

	prfm	pldl2strm, [x1, 1024]

	pmull	v5.1q, v5.1d, v17.1d
	eor	v4.16b, v26.16b, v4.16b
	eor	v4.16b, v4.16b, v30.16b

	sub	x3, x3, 128

	eor	v5.16b, v27.16b, v5.16b
	eor	v5.16b, v5.16b, v31.16b

	cbnz	x3, .crc_fold_loop

	/* After 128B blocks, process remaining 64B block if any */
.crc_mid_check:
	tbz	x2, 6, .crc_fold_loop_end

	ld1	{v28.16b-v31.16b}, [x1], #64

	pmull2	v24.1q, v2.2d, v17.2d
	tbl	v28.16b, {v28.16b}, v7.16b
	pmull	v2.1q, v2.1d, v17.1d

	pmull2	v25.1q, v3.2d, v17.2d
	tbl	v29.16b, {v29.16b}, v7.16b
	pmull	v3.1q, v3.1d, v17.1d

	eor	v2.16b, v24.16b, v2.16b

	pmull2	v26.1q, v4.2d, v17.2d
	tbl	v30.16b, {v30.16b}, v7.16b
	eor	v2.16b, v2.16b, v28.16b

	pmull	v4.1q, v4.1d, v17.1d
	eor	v3.16b, v25.16b, v3.16b

	pmull2	v27.1q, v5.2d, v17.2d
	tbl	v31.16b, {v31.16b}, v7.16b
	eor	v3.16b, v3.16b, v29.16b

	pmull	v5.1q, v5.1d, v17.1d
	eor	v4.16b, v26.16b, v4.16b
	eor	v4.16b, v4.16b, v30.16b

	eor	v5.16b, v27.16b, v5.16b
	eor	v5.16b, v5.16b, v31.16b

	b	.crc_fold_loop_end

/* ================================================================= */
/* Single iteration: 1-2 × 64B blocks (for 64-127 byte total)        */
/* ================================================================= */
	.align 3
.crc_single_loop:
	and	x3, x2, -64
	cmp	x3, 64
	blt	.crc_fold_loop_end

	ld1	{v28.16b-v31.16b}, [x1], #64

	tbl	v0.16b, {v28.16b}, v7.16b
	eor	v2.16b, v16.16b, v0.16b
	tbl	v3.16b, {v29.16b}, v7.16b
	tbl	v4.16b, {v30.16b}, v7.16b
	tbl	v5.16b, {v31.16b}, v7.16b

	sub	x3, x3, 64
	cbz	x3, .crc_fold_loop_end

	.align 2
1:	ld1	{v28.16b-v31.16b}, [x1], #64

	pmull2	v24.1q, v2.2d, v17.2d
	tbl	v28.16b, {v28.16b}, v7.16b
	pmull	v2.1q, v2.1d, v17.1d

	pmull2	v25.1q, v3.2d, v17.2d
	tbl	v29.16b, {v29.16b}, v7.16b
	pmull	v3.1q, v3.1d, v17.1d

	eor	v2.16b, v24.16b, v2.16b

	pmull2	v26.1q, v4.2d, v17.2d
	tbl	v30.16b, {v30.16b}, v7.16b
	eor	v2.16b, v2.16b, v28.16b

	pmull	v4.1q, v4.1d, v17.1d
	eor	v3.16b, v25.16b, v3.16b

	pmull2	v27.1q, v5.2d, v17.2d
	tbl	v31.16b, {v31.16b}, v7.16b
	eor	v3.16b, v3.16b, v29.16b

	pmull	v5.1q, v5.1d, v17.1d
	eor	v4.16b, v26.16b, v4.16b
	eor	v4.16b, v4.16b, v30.16b

	sub	x3, x3, 64

	eor	v5.16b, v27.16b, v5.16b
	eor	v5.16b, v5.16b, v31.16b

	cbnz	x3, 1b

/* ================================================================= */
/* Post-loop: 512-bit → 128-bit fold (P1 constants)                  */
/* ================================================================= */
.crc_fold_loop_end:
	/* w3=x5=len_aligned for scalar tail: x1 already advanced by LD1 */
	and	w3, w2, -64
	sxtw	x5, w3

	mov	x6, 0x45630000		/* P1_lo = x^128 mod P_scaled */
	fmov	d1, x6
	mov	x6, 0xD5F60000		/* P1_hi = x^192 mod P_scaled */
	fmov	d0, x6

	/* Fold acc0 → acc1 */
	dup	d6, v2.d[1]
	dup	d16, v2.d[0]
	pmull	v6.1q, v6.1d, v0.1d
	pmull	v16.1q, v16.1d, v1.1d
	eor	v6.16b, v6.16b, v16.16b
	eor	v3.16b, v6.16b, v3.16b

	/* Fold acc1 → acc2 */
	dup	d6, v3.d[1]
	dup	d16, v3.d[0]
	pmull	v6.1q, v6.1d, v0.1d
	pmull	v16.1q, v16.1d, v1.1d
	eor	v6.16b, v6.16b, v16.16b
	eor	v4.16b, v6.16b, v4.16b

	/* Fold acc2 → acc3 (final 128-bit) */
	dup	d6, v4.d[1]
	dup	d16, v4.d[0]
	pmull	v6.1q, v6.1d, v0.1d
	pmull	v16.1q, v16.1d, v1.1d
	eor	v6.16b, v6.16b, v16.16b
	eor	v2.16b, v6.16b, v5.16b

/* ================================================================= */
/* CRC16-specific 128→32 fold (P0 constants)                         */
/* ================================================================= */
	movi	v7.4s, 0			/* v7 now zero (perm mask done) */

	mov	x6, 0xEB230000		/* P0_hi = (x^80 mod P) << 16 */
	fmov	d16, x6
	mov	x7, 0xAA510000		/* P0_lo = (x^48 mod P) << 16 */
	fmov	d4, x7

	ext	v0.16b, v7.16b, v2.16b, 8
	ext	v0.16b, v0.16b, v7.16b, 4

	dup	d1, v2.d[1]
	pmull	v16.1q, v1.1d, v16.1d
	eor	v0.16b, v0.16b, v16.16b

	dup	d6, v0.d[1]
	pmull	v6.1q, v6.1d, v4.1d
	eor	v2.16b, v0.16b, v6.16b

/* ================================================================= */
/* Barrett reduction: 32→16 bit CRC                                  */
/* ================================================================= */
	mov	x6, 0x3471			/* mu[15:0]  */
	movk	x6, 0x1130, lsl 16		/* mu[31:16] */
	movk	x6, 0x1, lsl 32		/* mu[32]    */
	fmov	d3, x6

	dup	d1, v2.d[0]
	dup	d1, v1.d[0]
	ext	v1.16b, v1.16b, v7.16b, 4
	pmull	v4.1q, v1.1d, v3.1d

	ext	v1.16b, v4.16b, v7.16b, 4
	mov	x6, 0x10210000		/* P_scaled[31:0] */
	movk	x6, 0x1, lsl 32		/* P_scaled[32]   */
	fmov	d5, x6
	pmull	v5.1q, v1.1d, v5.1d
	eor	v2.16b, v2.16b, v5.16b

	umov	x0, v2.d[0]
	ubfx	x0, x0, 16, 16
	b	.crc_table_loop_pre

#ifndef __APPLE__
	.size	crc16_xmodem_pmull_opt, .-crc16_xmodem_pmull_opt
#endif

/* ================================================================= */
/* Constants                                                         */
/* ================================================================= */
	.align	4
fold_constant:
	.word	0x59B00000
	.word	0x00000000
	.word	0x60190000
	.word	0x00000000

	.align	4
shuffle_mask_xm:
	.byte	15, 14, 13, 12, 11, 10, 9, 8
	.byte	7,   6,  5,  4,  3,  2, 1, 0
	.align	4
.shuffle_mask_lanchor = shuffle_mask_xm

/* ================================================================= */
/* XMODEM CRC16 Lookup Table                                         */
/* ================================================================= */
	.align	4
.LANCHOR0 = . + 0
crc16tab_xmodem:
	.hword	0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50A5, 0x60C6, 0x70E7
	.hword	0x8108, 0x9129, 0xA14A, 0xB16B, 0xC18C, 0xD1AD, 0xE1CE, 0xF1EF
	.hword	0x1231, 0x0210, 0x3273, 0x2252, 0x52B5, 0x4294, 0x72F7, 0x62D6
	.hword	0x9339, 0x8318, 0xB37B, 0xA35A, 0xD3BD, 0xC39C, 0xF3FF, 0xE3DE
	.hword	0x2462, 0x3443, 0x0420, 0x1401, 0x64E6, 0x74C7, 0x44A4, 0x5485
	.hword	0xA56A, 0xB54B, 0x8528, 0x9509, 0xE5EE, 0xF5CF, 0xC5AC, 0xD58D
	.hword	0x3653, 0x2672, 0x1611, 0x0630, 0x76D7, 0x66F6, 0x5695, 0x46B4
	.hword	0xB75B, 0xA77A, 0x9719, 0x8738, 0xF7DF, 0xE7FE, 0xD79D, 0xC7BC
	.hword	0x48C4, 0x58E5, 0x6886, 0x78A7, 0x0840, 0x1861, 0x2802, 0x3823
	.hword	0xC9CC, 0xD9ED, 0xE98E, 0xF9AF, 0x8948, 0x9969, 0xA90A, 0xB92B
	.hword	0x5AF5, 0x4AD4, 0x7AB7, 0x6A96, 0x1A71, 0x0A50, 0x3A33, 0x2A12
	.hword	0xDBFD, 0xCBDC, 0xFBBF, 0xEB9E, 0x9B79, 0x8B58, 0xBB3B, 0xAB1A
	.hword	0x6CA6, 0x7C87, 0x4CE4, 0x5CC5, 0x2C22, 0x3C03, 0x0C60, 0x1C41
	.hword	0xEDAE, 0xFD8F, 0xCDEC, 0xDDCD, 0xAD2A, 0xBD0B, 0x8D68, 0x9D49
	.hword	0x7E97, 0x6EB6, 0x5ED5, 0x4EF4, 0x3E13, 0x2E32, 0x1E51, 0x0E70
	.hword	0xFF9F, 0xEFBE, 0xDFDD, 0xCFFC, 0xBF1B, 0xAF3A, 0x9F59, 0x8F78
	.hword	0x9188, 0x81A9, 0xB1CA, 0xA1EB, 0xD10C, 0xC12D, 0xF14E, 0xE16F
	.hword	0x1080, 0x00A1, 0x30C2, 0x20E3, 0x5004, 0x4025, 0x7046, 0x6067
	.hword	0x83B9, 0x9398, 0xA3FB, 0xB3DA, 0xC33D, 0xD31C, 0xE37F, 0xF35E
	.hword	0x02B1, 0x1290, 0x22F3, 0x32D2, 0x4235, 0x5214, 0x6277, 0x7256
	.hword	0xB5EA, 0xA5CB, 0x95A8, 0x8589, 0xF56E, 0xE54F, 0xD52C, 0xC50D
	.hword	0x34E2, 0x24C3, 0x14A0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405
	.hword	0xA7DB, 0xB7FA, 0x8799, 0x97B8, 0xE75F, 0xF77E, 0xC71D, 0xD73C
	.hword	0x26D3, 0x36F2, 0x0691, 0x16B0, 0x6657, 0x7676, 0x4615, 0x5634
	.hword	0xD94C, 0xC96D, 0xF90E, 0xE92F, 0x99C8, 0x89E9, 0xB98A, 0xA9AB
	.hword	0x5844, 0x4865, 0x7806, 0x6827, 0x18C0, 0x08E1, 0x3882, 0x28A3
	.hword	0xCB7D, 0xDB5C, 0xEB3F, 0xFB1E, 0x8BF9, 0x9BD8, 0xABBB, 0xBB9A
	.hword	0x4A75, 0x5A54, 0x6A37, 0x7A16, 0x0AF1, 0x1AD0, 0x2AB3, 0x3A92
	.hword	0xFD2E, 0xED0F, 0xDD6C, 0xCD4D, 0xBDAA, 0xAD8B, 0x9DE8, 0x8DC9
	.hword	0x7C26, 0x6C07, 0x5C64, 0x4C45, 0x3CA2, 0x2C83, 0x1CE0, 0x0CC1
	.hword	0xEF1F, 0xFF3E, 0xCF5D, 0xDF7C, 0xAF9B, 0xBFBA, 0x8FD9, 0x9FF8
	.hword	0x6E17, 0x7E36, 0x4E55, 0x5E74, 0x2E93, 0x3EB2, 0x0ED1, 0x1EF0
