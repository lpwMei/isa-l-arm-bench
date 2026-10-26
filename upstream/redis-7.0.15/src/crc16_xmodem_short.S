/////////////////////////////////////////////////////////////////////////
// XMODEM CRC16 — Short buffer NEON/PMULL path (1-63 bytes)
//
// For len < 64: processes data in 16B NEON chunks using P1 fold (x^128).
// Faster than byte-by-byte serial table lookup.  Handles 1-63 bytes.
//
// uint16_t crc16_xmodem_short(uint16_t seed, const uint8_t *buf, uint64_t len);
/////////////////////////////////////////////////////////////////////////

	.arch armv8-a+crc+crypto
	.text
	.align	3
	.global	crc16_xmodem_short
#ifndef __APPLE__
	.type	crc16_xmodem_short, %function
#endif

crc16_xmodem_short:
	/* Assumes len >= 16 (dispatch handles < 16 via scalar). */
	/* Scale seed to 32-bit domain: bits [47:32] */
	uxth	w0, w0
	fmov	d0, x0
	fmov	d1, xzr
	dup	d16, v1.d[0]
	shl	d0, d0, 48
	ins	v16.d[1], v0.d[0]

	/* Load shuffle mask and P1 fold constant */
#ifndef __APPLE__
	adrp	x5, .shuffle_mask_lanchor_short
	ldr	q7, [x5, :lo12:.shuffle_mask_lanchor_short]
#else
	adrp	x5, .shuffle_mask_lanchor_short@PAGE
	ldr	q7, [x5, .shuffle_mask_lanchor_short@PAGEOFF]
#endif
	ldr	q17, fold_constant_p1

	/* x3 = processed flag: 0 = first chunk, 1 = fold needed */
	mov	x3, 0

	/* ---- Load first/next 16B chunk ---- */
.crc_short_chunk:
	cmp	x2, 16
	b.lt	.crc_short_tail		/* < 16 bytes remaining */

	/* Full 16B chunk: direct load */
	ld1	{v28.16b}, [x1], #16
	sub	x2, x2, 16
	b	.crc_short_process

	/* Finish full chunks; consume the exact tail after reduction. */
.crc_short_tail:
	b	.crc_short_finish

	/* ---- Process loaded 16B chunk ---- */
.crc_short_process:
	tbl	v28.16b, {v28.16b}, v7.16b

	cbnz	x3, .crc_short_fold
	/* First chunk: XOR seed */
	eor	v2.16b, v16.16b, v28.16b
	mov	x3, 1
	b	.crc_short_chunk

	/* Subsequent chunk: fold previous state, XOR new data */
.crc_short_fold:
	pmull2	v24.1q, v2.2d, v17.2d
	pmull	v2.1q,  v2.1d, v17.1d
	eor	v2.16b, v24.16b, v2.16b
	eor	v2.16b, v2.16b,  v28.16b
	b	.crc_short_chunk

	/* ---- Finish up ---- */
.crc_short_finish:
	/* If no data was processed at all (shouldn't happen), return seed */
	cbnz	x3, .crc_short_p0
	mov	x0, x0
	ret

/* ================================================================= */
/* P0 fold + Barrett reduction                                       */
/* ================================================================= */
.crc_short_p0:
	movi	v7.4s, 0

	mov	x6, 0xEB230000		/* P0_hi */
	fmov	d16, x6
	mov	x7, 0xAA510000		/* P0_lo */
	fmov	d4, x7

	ext	v0.16b, v7.16b, v2.16b, 8
	ext	v0.16b, v0.16b, v7.16b, 4

	dup	d1, v2.d[1]
	pmull	v16.1q, v1.1d, v16.1d
	eor	v0.16b, v0.16b, v16.16b

	dup	d6, v0.d[1]
	pmull	v6.1q, v6.1d, v4.1d
	eor	v2.16b, v0.16b, v6.16b

	/* Barrett reduction */
	mov	x6, 0x3471
	movk	x6, 0x1130, lsl 16
	movk	x6, 0x1, lsl 32
	fmov	d3, x6

	dup	d1, v2.d[0]
	dup	d1, v1.d[0]
	ext	v1.16b, v1.16b, v7.16b, 4
	pmull	v4.1q, v1.1d, v3.1d

	ext	v1.16b, v4.16b, v7.16b, 4
	mov	x6, 0x10210000
	movk	x6, 0x1, lsl 32
	fmov	d5, x6
	pmull	v5.1q, v1.1d, v5.1d
	eor	v2.16b, v2.16b, v5.16b

	umov	x0, v2.d[0]
	ubfx	x0, x0, 16, 16
	/* x1 points to the remaining 0..15 bytes, x2 is their exact length.
	 * Continue from the reduced CRC; do not hash zero padding. */
	b	crc16_xmodem_pmull

#ifndef __APPLE__
	.size	crc16_xmodem_short, .-crc16_xmodem_short
#endif

/* ================================================================= */
/* Constants                                                         */
/* ================================================================= */
	.align	4
fold_constant_p1:
	.word	0x45630000	/* P1_lo = x^128 mod P_scaled */
	.word	0x00000000
	.word	0xD5F60000	/* P1_hi = x^192 mod P_scaled */
	.word	0x00000000

	.align	4
shuffle_mask_short:
	.byte	15, 14, 13, 12, 11, 10, 9, 8
	.byte	7,   6,  5,  4,  3,  2, 1, 0
	.align	4
.shuffle_mask_lanchor_short = shuffle_mask_short

