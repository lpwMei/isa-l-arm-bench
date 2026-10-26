	.file	"gf_nvect_dot_prod_sve.c"
	.text
	.globl	gf_vect_dot_prod_sve            // -- Begin function gf_vect_dot_prod_sve
	.p2align	2
	.type	gf_vect_dot_prod_sve,@function
gf_vect_dot_prod_sve:                   // @gf_vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
	b.ge	.LBB0_2
.LBB0_1:
	ret
.LBB0_2:
	rdvl	x13, #1
	cmp	w1, #1
	lsr	x11, x13, #4
	b.lt	.LBB0_12
// %bb.3:
	mov	w8, w1
	mov	x10, xzr
	lsl	x8, x8, #5
	sub	x12, x8, #32
.LBB0_4:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB0_4
// %bb.5:
	add	w12, w11, w11, lsl #1
	lsl	w11, w11, #5
	ptrue	p0.b
	mov	x10, xzr
	mov	w13, w13
	mov	w14, #16                        // =0x10
	lsl	w12, w12, #4
	rdvl	x15, #4
	b	.LBB0_7
.LBB0_6:                                //   in Loop: Header=BB0_7 Depth=1
	st1b	{ z2.b }, p1, [x4, x10]
	add	x10, x10, x15
	cmp	w0, w10
	st1b	{ z1.b }, p3, [x4, x16]
	st1b	{ z3.b }, p4, [x4, x17]
	st1b	{ z0.b }, p2, [x4, x1]
	b.le	.LBB0_1
.LBB0_7:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB0_10 Depth 2
	whilelt	p1.b, w10, w0
	b.eq	.LBB0_1
// %bb.8:                               //   in Loop: Header=BB0_7 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	add	x16, x10, x13
	movi	v3.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	add	x17, x10, x11
	add	x1, x10, x12
	whilelt	p3.b, w16, w0
	mov	x18, xzr
	whilelt	p4.b, w17, w0
	mov	x5, x3
	whilelt	p2.b, w1, w0
	b	.LBB0_10
.LBB0_9:                                //   in Loop: Header=BB0_10 Depth=2
	eor	z2.d, z2.d, z7.d
	eor	z1.d, z1.d, z6.d
	add	x18, x18, #32
	eor	z3.d, z3.d, z4.d
	eor	z0.d, z0.d, z5.d
	cmp	x8, x18
	b.eq	.LBB0_6
.LBB0_10:                               //   Parent Loop BB0_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x6, [x5], #8
	cmp	w9, #1
	ld1b	{ z7.b }, p1/z, [x6, x10]
	ld1b	{ z6.b }, p3/z, [x6, x16]
	ld1b	{ z4.b }, p4/z, [x6, x17]
	ld1b	{ z5.b }, p2/z, [x6, x1]
	b.eq	.LBB0_9
// %bb.11:                              //   in Loop: Header=BB0_10 Depth=2
	sxtw	x6, w18
	movprfx	z16, z7
	and	z16.b, z16.b, #0xf
	lsr	z7.b, z7.b, #4
	movprfx	z17, z6
	and	z17.b, z17.b, #0xf
	movprfx	z19, z4
	and	z19.b, z19.b, #0xf
	movprfx	z20, z5
	and	z20.b, z20.b, #0xf
	add	x7, x2, x6
	ld1b	{ z18.b }, p0/z, [x2, x6]
	lsr	z6.b, z6.b, #4
	ld1b	{ z21.b }, p0/z, [x7, x14]
	lsr	z4.b, z4.b, #4
	lsr	z5.b, z5.b, #4
	tbl	z16.b, { z18.b }, z16.b
	tbl	z17.b, { z18.b }, z17.b
	tbl	z19.b, { z18.b }, z19.b
	tbl	z18.b, { z18.b }, z20.b
	tbl	z7.b, { z21.b }, z7.b
	tbl	z6.b, { z21.b }, z6.b
	tbl	z4.b, { z21.b }, z4.b
	tbl	z5.b, { z21.b }, z5.b
	eor	z7.d, z16.d, z7.d
	eor	z6.d, z17.d, z6.d
	eor	z4.d, z19.d, z4.d
	eor	z5.d, z18.d, z5.d
	b	.LBB0_9
.LBB0_12:
	add	w10, w11, w11, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w11, #5
	mov	w11, w13
	mov	x8, xzr
	rdvl	x15, #4
	lsl	w10, w10, #4
	add	x12, x4, x11
	add	x13, x4, x9
	add	x14, x4, x10
.LBB0_13:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB0_1
// %bb.14:                              //   in Loop: Header=BB0_13 Depth=1
	add	w16, w11, w8
	add	w17, w9, w8
	st1b	{ z0.b }, p0, [x4, x8]
	whilelt	p1.b, w16, w0
	add	w16, w10, w8
	whilelt	p0.b, w17, w0
	whilelt	p2.b, w16, w0
	st1b	{ z0.b }, p1, [x12, x8]
	st1b	{ z0.b }, p0, [x13, x8]
	st1b	{ z0.b }, p2, [x14, x8]
	add	x8, x8, x15
	cmp	w0, w8
	b.gt	.LBB0_13
	b	.LBB0_1
.Lfunc_end0:
	.size	gf_vect_dot_prod_sve, .Lfunc_end0-gf_vect_dot_prod_sve
                                        // -- End function
	.globl	gf_2vect_dot_prod_sve           // -- Begin function gf_2vect_dot_prod_sve
	.p2align	2
	.type	gf_2vect_dot_prod_sve,@function
gf_2vect_dot_prod_sve:                  // @gf_2vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB1_21
// %bb.1:
	str	d12, [sp, #-80]!                // 8-byte Folded Spill
	rdvl	x15, #1
	cmp	w1, #1
	stp	d11, d10, [sp, #16]             // 16-byte Folded Spill
	lsr	x13, x15, #4
	stp	d9, d8, [sp, #32]               // 16-byte Folded Spill
	stp	x22, x21, [sp, #48]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #64]             // 16-byte Folded Spill
	b.lt	.LBB1_17
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB1_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB1_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x14, x11, #1
	mov	w12, w10
.LBB1_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	add	w12, w12, #32
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	ccmp	x14, #0, #4, eq
	sub	x14, x14, #1
	b.ne	.LBB1_5
// %bb.6:
	add	w14, w13, w13, lsl #1
	cmp	w9, #1
	lsl	w13, w13, #5
	ccmp	w11, #1, #0, eq
	ptrue	p0.b
	mov	x12, xzr
	lsl	w14, w14, #4
	mov	w15, w15
	cset	w16, ne
	mov	w17, #16                        // =0x10
	rdvl	x18, #4
	b	.LBB1_8
.LBB1_7:                                //   in Loop: Header=BB1_8 Depth=1
	ldr	x6, [x4, #8]
	st1b	{ z4.b }, p1, [x6, x12]
	ldr	x6, [x4, #8]
	st1b	{ z5.b }, p2, [x6, x1]
	ldr	x6, [x4, #8]
	st1b	{ z6.b }, p4, [x6, x5]
	ldr	x6, [x4, #8]
	st1b	{ z7.b }, p3, [x6, x7]
	ldr	x6, [x4]
	st1b	{ z3.b }, p1, [x6, x12]
	add	x12, x12, x18
	ldr	x6, [x4]
	cmp	w0, w12
	st1b	{ z2.b }, p2, [x6, x1]
	ldr	x1, [x4]
	st1b	{ z1.b }, p4, [x1, x5]
	ldr	x1, [x4]
	st1b	{ z0.b }, p3, [x1, x7]
	b.le	.LBB1_20
.LBB1_8:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB1_12 Depth 2
	whilelt	p1.b, w12, w0
	b.eq	.LBB1_20
// %bb.9:                               //   in Loop: Header=BB1_8 Depth=1
	movi	v3.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	add	x1, x12, x15
	movi	v2.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	add	x5, x12, x13
	movi	v1.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	add	x7, x12, x14
	movi	v0.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x6, xzr
	whilelt	p2.b, w1, w0
	mov	x19, x3
	mov	w20, w10
	whilelt	p4.b, w5, w0
	whilelt	p3.b, w7, w0
	b	.LBB1_12
.LBB1_10:                               //   in Loop: Header=BB1_12 Depth=2
	eor	z3.d, z3.d, z18.d
	eor	z2.d, z2.d, z19.d
	eor	z1.d, z1.d, z16.d
	eor	z0.d, z0.d, z17.d
.LBB1_11:                               //   in Loop: Header=BB1_12 Depth=2
	eor	z4.d, z4.d, z18.d
	eor	z5.d, z5.d, z19.d
	add	x6, x6, #32
	eor	z6.d, z6.d, z16.d
	eor	z7.d, z7.d, z17.d
	cmp	x8, x6
	add	w20, w20, #32
	b.eq	.LBB1_7
.LBB1_12:                               //   Parent Loop BB1_8 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x21, [x19], #8
	ld1b	{ z18.b }, p1/z, [x21, x12]
	ld1b	{ z19.b }, p2/z, [x21, x1]
	ld1b	{ z16.b }, p4/z, [x21, x5]
	ld1b	{ z17.b }, p3/z, [x21, x7]
	tbz	w16, #0, .LBB1_10
// %bb.13:                              //   in Loop: Header=BB1_12 Depth=2
	lsr	z20.b, z18.b, #4
	lsr	z21.b, z19.b, #4
	cmp	w9, #1
	lsr	z22.b, z16.b, #4
	lsr	z23.b, z17.b, #4
	movprfx	z24, z18
	and	z24.b, z24.b, #0xf
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	movprfx	z25, z19
	and	z25.b, z25.b, #0xf
	mov	z30.d, z16.d
	mov	z31.d, z17.d
	movprfx	z26, z16
	and	z26.b, z26.b, #0xf
	movprfx	z27, z17
	and	z27.b, z27.b, #0xf
	b.eq	.LBB1_15
// %bb.14:                              //   in Loop: Header=BB1_12 Depth=2
	sxtw	x21, w6
	add	x22, x2, x21
	ld1b	{ z28.b }, p0/z, [x2, x21]
	ld1b	{ z29.b }, p0/z, [x22, x17]
	tbl	z30.b, { z28.b }, z24.b
	tbl	z31.b, { z28.b }, z25.b
	tbl	z8.b, { z28.b }, z26.b
	tbl	z9.b, { z28.b }, z27.b
	tbl	z28.b, { z29.b }, z20.b
	tbl	z10.b, { z29.b }, z21.b
	tbl	z11.b, { z29.b }, z22.b
	tbl	z12.b, { z29.b }, z23.b
	eor	z28.d, z30.d, z28.d
	eor	z29.d, z31.d, z10.d
	eor	z30.d, z8.d, z11.d
	eor	z31.d, z9.d, z12.d
.LBB1_15:                               //   in Loop: Header=BB1_12 Depth=2
	eor	z3.d, z3.d, z28.d
	eor	z2.d, z2.d, z29.d
	cmp	w11, #1
	eor	z1.d, z1.d, z30.d
	eor	z0.d, z0.d, z31.d
	b.eq	.LBB1_11
// %bb.16:                              //   in Loop: Header=BB1_12 Depth=2
	sxtw	x21, w20
	add	x22, x2, x21
	ld1b	{ z16.b }, p0/z, [x2, x21]
	ld1b	{ z17.b }, p0/z, [x22, x17]
	tbl	z18.b, { z16.b }, z24.b
	tbl	z19.b, { z16.b }, z25.b
	tbl	z24.b, { z16.b }, z26.b
	tbl	z25.b, { z16.b }, z27.b
	tbl	z16.b, { z17.b }, z20.b
	tbl	z20.b, { z17.b }, z21.b
	tbl	z21.b, { z17.b }, z22.b
	tbl	z17.b, { z17.b }, z23.b
	eor	z18.d, z18.d, z16.d
	eor	z19.d, z19.d, z20.d
	eor	z16.d, z24.d, z21.d
	eor	z17.d, z25.d, z17.d
	b	.LBB1_11
.LBB1_17:
	add	w10, w13, w13, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w13, #5
	mov	x8, xzr
	mov	w11, w15
	rdvl	x12, #4
	lsl	w10, w10, #4
.LBB1_18:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB1_20
// %bb.19:                              //   in Loop: Header=BB1_18 Depth=1
	ldr	x13, [x4, #8]
	add	x14, x11, x8
	add	x15, x9, x8
	whilelt	p1.b, w14, w0
	add	x16, x10, x8
	st1b	{ z0.b }, p0, [x13, x8]
	whilelt	p2.b, w15, w0
	ldr	x13, [x4, #8]
	whilelt	p3.b, w16, w0
	st1b	{ z0.b }, p1, [x14, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p2, [x15, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p3, [x16, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p0, [x13, x8]
	add	x8, x8, x12
	ldr	x13, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p1, [x14, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p2, [x15, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p3, [x16, x13]
	b.gt	.LBB1_18
.LBB1_20:
	ldp	x20, x19, [sp, #64]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #48]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #32]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #16]             // 16-byte Folded Reload
	ldr	d12, [sp], #80                  // 8-byte Folded Reload
.LBB1_21:
	ret
.Lfunc_end1:
	.size	gf_2vect_dot_prod_sve, .Lfunc_end1-gf_2vect_dot_prod_sve
                                        // -- End function
	.globl	gf_3vect_dot_prod_sve           // -- Begin function gf_3vect_dot_prod_sve
	.p2align	2
	.type	gf_3vect_dot_prod_sve,@function
gf_3vect_dot_prod_sve:                  // @gf_3vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB2_26
// %bb.1:
	str	x21, [sp, #-32]!                // 8-byte Folded Spill
	cmp	w1, #1
	rdvl	x14, #1
	stp	x20, x19, [sp, #16]             // 16-byte Folded Spill
	b.lt	.LBB2_23
// %bb.2:
	mov	w8, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x9, x8, #5
	sub	x11, x9, #32
.LBB2_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB2_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x13, x8, #1
	sub	x15, x8, #1
	mov	w12, w10
.LBB2_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x15, x15, #1
	cset	w16, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB2_7
// %bb.6:                               //   in Loop: Header=BB2_5 Depth=1
	add	w12, w12, #32
	tbnz	w16, #0, .LBB2_5
.LBB2_7:
	lsl	w15, w1, #6
.LBB2_8:                                // =>This Inner Loop Header: Depth=1
	add	x12, x2, w15, sxtw
	subs	x13, x13, #1
	cset	w16, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB2_10
// %bb.9:                               //   in Loop: Header=BB2_8 Depth=1
	add	w15, w15, #32
	tbnz	w16, #0, .LBB2_8
.LBB2_10:
	lsl	x13, x8, #6
	cmp	w11, #1
	mov	w14, w14
	b.ne	.LBB2_27
// %bb.11:
	cmp	w9, #1
	b.ne	.LBB2_27
// %bb.12:
	cmp	w12, #1
	b.ne	.LBB2_27
// %bb.13:
	mov	x15, xzr
	rdvl	x16, #1
	rdvl	x17, #2
	mov	w18, #16                        // =0x10
	b	.LBB2_15
.LBB2_14:                               //   in Loop: Header=BB2_15 Depth=1
	ldr	x1, [x4, #16]
	st1b	{ z4.b }, p2, [x1, x15]
	ldr	x1, [x4, #16]
	add	x1, x1, x15
	st1b	{ z5.b }, p1, [x1, x14]
	ldr	x1, [x4, #8]
	st1b	{ z2.b }, p2, [x1, x15]
	ldr	x1, [x4, #8]
	add	x1, x1, x15
	st1b	{ z3.b }, p1, [x1, x14]
	ldr	x1, [x4]
	st1b	{ z1.b }, p2, [x1, x15]
	ldr	x1, [x4]
	add	x1, x1, x15
	add	x15, x15, x17
	cmp	w0, w15
	st1b	{ z0.b }, p1, [x1, x14]
	b.le	.LBB2_25
.LBB2_15:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB2_17 Depth 2
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	w6, w16, w15
	movi	v4.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	mov	x1, x8
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	x5, x3
	whilelt	p2.b, w15, w0
	mov	w7, w10
	mov	x19, x13
	whilelt	p1.b, w6, w0
	mov	x6, x2
	b	.LBB2_17
.LBB2_16:                               //   in Loop: Header=BB2_17 Depth=2
	eor	z1.d, z1.d, z16.d
	eor	z0.d, z0.d, z17.d
	subs	x1, x1, #1
	eor	z2.d, z2.d, z18.d
	eor	z3.d, z3.d, z19.d
	add	x19, x19, #32
	eor	z4.d, z4.d, z6.d
	eor	z5.d, z5.d, z7.d
	add	w7, w7, #32
	add	x6, x6, #32
	b.eq	.LBB2_14
.LBB2_17:                               //   Parent Loop BB2_15 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x20, [x5], #8
	cmp	w9, #1
	add	x21, x20, x15
	ld1b	{ z6.b }, p2/z, [x20, x15]
	ld1b	{ z7.b }, p1/z, [x21, x14]
	mov	z16.d, z6.d
	mov	z17.d, z7.d
	b.ne	.LBB2_20
// %bb.18:                              //   in Loop: Header=BB2_17 Depth=2
	mov	z18.d, z6.d
	mov	z19.d, z7.d
	cmp	w11, #1
	b.ne	.LBB2_21
.LBB2_19:                               //   in Loop: Header=BB2_17 Depth=2
	cmp	w12, #1
	b.eq	.LBB2_16
	b	.LBB2_22
.LBB2_20:                               //   in Loop: Header=BB2_17 Depth=2
	ld1b	{ z16.b }, p0/z, [x6]
	ld1b	{ z17.b }, p0/z, [x6, x18]
	fmov	w20, s16
	fmov	w21, s17
	eor	w20, w20, w21
	mov	z16.b, w20
	mov	z17.d, z16.d
	mov	z18.d, z6.d
	mov	z19.d, z7.d
	cmp	w11, #1
	b.eq	.LBB2_19
.LBB2_21:                               //   in Loop: Header=BB2_17 Depth=2
	mov	w20, w7
	add	x21, x2, x20
	ld1b	{ z18.b }, p0/z, [x2, x20]
	ld1b	{ z19.b }, p0/z, [x21, x18]
	fmov	w20, s18
	fmov	w21, s19
	eor	w20, w20, w21
	mov	z18.b, w20
	mov	z19.d, z18.d
	cmp	w12, #1
	b.eq	.LBB2_16
.LBB2_22:                               //   in Loop: Header=BB2_17 Depth=2
	and	x20, x19, #0xffffffe0
	add	x21, x2, x20
	ld1b	{ z6.b }, p0/z, [x2, x20]
	ld1b	{ z7.b }, p0/z, [x21, x18]
	fmov	w20, s6
	fmov	w21, s7
	eor	w20, w20, w21
	mov	z6.b, w20
	mov	z7.d, z6.d
	b	.LBB2_16
.LBB2_23:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w14
	mov	w10, w0
	rdvl	x11, #2
.LBB2_24:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	ldr	x12, [x4, #16]
	add	x13, x9, x8
	whilelt	p1.b, w13, w0
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4]
	st1b	{ z0.b }, p0, [x12, x8]
	add	x8, x8, x11
	ldr	x12, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p1, [x13, x12]
	b.lo	.LBB2_24
.LBB2_25:
	ldp	x20, x19, [sp, #16]             // 16-byte Folded Reload
	ldr	x21, [sp], #32                  // 8-byte Folded Reload
.LBB2_26:
	ret
.LBB2_27:
	mov	x15, xzr
	rdvl	x16, #1
	rdvl	x17, #2
	mov	w18, #16                        // =0x10
	b	.LBB2_29
.LBB2_28:                               //   in Loop: Header=BB2_29 Depth=1
	ldr	x1, [x4, #16]
	st1b	{ z4.b }, p2, [x1, x15]
	ldr	x1, [x4, #16]
	add	x1, x1, x15
	st1b	{ z5.b }, p1, [x1, x14]
	ldr	x1, [x4, #8]
	st1b	{ z2.b }, p2, [x1, x15]
	ldr	x1, [x4, #8]
	add	x1, x1, x15
	st1b	{ z3.b }, p1, [x1, x14]
	ldr	x1, [x4]
	st1b	{ z1.b }, p2, [x1, x15]
	ldr	x1, [x4]
	add	x1, x1, x15
	add	x15, x15, x17
	cmp	w0, w15
	st1b	{ z0.b }, p1, [x1, x14]
	b.le	.LBB2_25
.LBB2_29:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB2_31 Depth 2
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	w6, w16, w15
	movi	v4.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	mov	x1, x8
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	x5, x3
	whilelt	p2.b, w15, w0
	mov	w7, w10
	mov	x19, x13
	whilelt	p1.b, w6, w0
	mov	x6, x2
	b	.LBB2_31
.LBB2_30:                               //   in Loop: Header=BB2_31 Depth=2
	eor	z1.d, z1.d, z20.d
	eor	z0.d, z0.d, z21.d
	subs	x1, x1, #1
	eor	z2.d, z2.d, z22.d
	eor	z3.d, z3.d, z23.d
	add	x19, x19, #32
	eor	z4.d, z4.d, z6.d
	eor	z5.d, z5.d, z7.d
	add	w7, w7, #32
	add	x6, x6, #32
	b.eq	.LBB2_28
.LBB2_31:                               //   Parent Loop BB2_29 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x20, [x5], #8
	cmp	w9, #1
	add	x21, x20, x15
	ld1b	{ z6.b }, p2/z, [x20, x15]
	ld1b	{ z7.b }, p1/z, [x21, x14]
	lsr	z19.b, z6.b, #4
	mov	z20.d, z6.d
	movprfx	z18, z6
	and	z18.b, z18.b, #0xf
	lsr	z17.b, z7.b, #4
	mov	z21.d, z7.d
	movprfx	z16, z7
	and	z16.b, z16.b, #0xf
	b.ne	.LBB2_34
// %bb.32:                              //   in Loop: Header=BB2_31 Depth=2
	mov	z22.d, z6.d
	mov	z23.d, z7.d
	cmp	w11, #1
	b.ne	.LBB2_35
.LBB2_33:                               //   in Loop: Header=BB2_31 Depth=2
	cmp	w12, #1
	b.eq	.LBB2_30
	b	.LBB2_36
.LBB2_34:                               //   in Loop: Header=BB2_31 Depth=2
	ld1b	{ z20.b }, p0/z, [x6]
	ld1b	{ z21.b }, p0/z, [x6, x18]
	tbl	z22.b, { z20.b }, z18.b
	tbl	z23.b, { z21.b }, z19.b
	tbl	z24.b, { z20.b }, z16.b
	tbl	z21.b, { z21.b }, z17.b
	eor	z20.d, z22.d, z23.d
	eor	z21.d, z24.d, z21.d
	mov	z22.d, z6.d
	mov	z23.d, z7.d
	cmp	w11, #1
	b.eq	.LBB2_33
.LBB2_35:                               //   in Loop: Header=BB2_31 Depth=2
	mov	w20, w7
	add	x21, x2, x20
	ld1b	{ z22.b }, p0/z, [x2, x20]
	ld1b	{ z23.b }, p0/z, [x21, x18]
	tbl	z24.b, { z22.b }, z18.b
	tbl	z26.b, { z22.b }, z16.b
	tbl	z25.b, { z23.b }, z19.b
	tbl	z23.b, { z23.b }, z17.b
	eor	z22.d, z24.d, z25.d
	eor	z23.d, z26.d, z23.d
	cmp	w12, #1
	b.eq	.LBB2_30
.LBB2_36:                               //   in Loop: Header=BB2_31 Depth=2
	and	x20, x19, #0xffffffe0
	add	x21, x2, x20
	ld1b	{ z6.b }, p0/z, [x2, x20]
	ld1b	{ z7.b }, p0/z, [x21, x18]
	tbl	z18.b, { z6.b }, z18.b
	tbl	z16.b, { z6.b }, z16.b
	tbl	z19.b, { z7.b }, z19.b
	tbl	z7.b, { z7.b }, z17.b
	eor	z6.d, z18.d, z19.d
	eor	z7.d, z16.d, z7.d
	b	.LBB2_30
.Lfunc_end2:
	.size	gf_3vect_dot_prod_sve, .Lfunc_end2-gf_3vect_dot_prod_sve
                                        // -- End function
	.globl	gf_4vect_dot_prod_sve           // -- Begin function gf_4vect_dot_prod_sve
	.p2align	2
	.type	gf_4vect_dot_prod_sve,@function
gf_4vect_dot_prod_sve:                  // @gf_4vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB3_32
// %bb.1:
	stp	x24, x23, [sp, #-48]!           // 16-byte Folded Spill
	cmp	w1, #1
	rdvl	x15, #1
	stp	x22, x21, [sp, #16]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #32]             // 16-byte Folded Spill
	b.lt	.LBB3_29
// %bb.2:
	mov	w8, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x9, x8, #5
	sub	x11, x9, #32
.LBB3_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB3_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x14, x8, #1
	sub	x13, x8, #1
	mov	w12, w10
.LBB3_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w16, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB3_7
// %bb.6:                               //   in Loop: Header=BB3_5 Depth=1
	add	w12, w12, #32
	tbnz	w16, #0, .LBB3_5
.LBB3_7:
	lsl	w13, w1, #6
	sub	x16, x8, #1
.LBB3_8:                                // =>This Inner Loop Header: Depth=1
	add	x12, x2, w13, sxtw
	subs	x16, x16, #1
	cset	w17, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB3_10
// %bb.9:                               //   in Loop: Header=BB3_8 Depth=1
	add	w13, w13, #32
	tbnz	w17, #0, .LBB3_8
.LBB3_10:
	add	w13, w1, w1, lsl #1
	lsl	w16, w13, #5
.LBB3_11:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w16, sxtw
	subs	x14, x14, #1
	cset	w17, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB3_13
// %bb.12:                              //   in Loop: Header=BB3_11 Depth=1
	add	w16, w16, #32
	tbnz	w17, #0, .LBB3_11
.LBB3_13:
	lsl	x14, x8, #6
	cmp	w11, #1
	mov	w15, w15
	b.ne	.LBB3_33
// %bb.14:
	cmp	w9, #1
	b.ne	.LBB3_33
// %bb.15:
	cmp	w12, #1
	b.ne	.LBB3_33
// %bb.16:
	cmp	w13, #1
	b.ne	.LBB3_33
// %bb.17:
	add	x17, x8, x8, lsl #1
	mov	x16, xzr
	rdvl	x18, #1
	rdvl	x1, #2
	mov	w5, #16                         // =0x10
	lsl	x17, x17, #5
	b	.LBB3_19
.LBB3_18:                               //   in Loop: Header=BB3_19 Depth=1
	ldr	x6, [x4, #24]
	st1b	{ z6.b }, p2, [x6, x16]
	ldr	x6, [x4, #24]
	add	x6, x6, x16
	st1b	{ z7.b }, p1, [x6, x15]
	ldr	x6, [x4, #16]
	st1b	{ z4.b }, p2, [x6, x16]
	ldr	x6, [x4, #16]
	add	x6, x6, x16
	st1b	{ z5.b }, p1, [x6, x15]
	ldr	x6, [x4, #8]
	st1b	{ z2.b }, p2, [x6, x16]
	ldr	x6, [x4, #8]
	add	x6, x6, x16
	st1b	{ z3.b }, p1, [x6, x15]
	ldr	x6, [x4]
	st1b	{ z1.b }, p2, [x6, x16]
	ldr	x6, [x4]
	add	x6, x6, x16
	add	x16, x16, x1
	cmp	w0, w16
	st1b	{ z0.b }, p1, [x6, x15]
	b.le	.LBB3_31
.LBB3_19:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB3_21 Depth 2
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	w20, w18, w16
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x6, x8
	movi	v0.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	mov	x7, x3
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x19, x17
	whilelt	p2.b, w16, w0
	mov	w21, w10
	mov	x22, x14
	whilelt	p1.b, w20, w0
	mov	x20, x2
	b	.LBB3_21
.LBB3_20:                               //   in Loop: Header=BB3_21 Depth=2
	eor	z1.d, z1.d, z18.d
	eor	z0.d, z0.d, z19.d
	add	x22, x22, #32
	eor	z2.d, z2.d, z20.d
	eor	z3.d, z3.d, z21.d
	subs	x6, x6, #1
	eor	z4.d, z4.d, z22.d
	eor	z5.d, z5.d, z23.d
	add	w21, w21, #32
	eor	z6.d, z6.d, z16.d
	eor	z7.d, z7.d, z17.d
	add	x20, x20, #32
	add	x19, x19, #32
	b.eq	.LBB3_18
.LBB3_21:                               //   Parent Loop BB3_19 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x23, [x7], #8
	cmp	w9, #1
	add	x24, x23, x16
	ld1b	{ z16.b }, p2/z, [x23, x16]
	ld1b	{ z17.b }, p1/z, [x24, x15]
	mov	z18.d, z16.d
	mov	z19.d, z17.d
	b.ne	.LBB3_25
// %bb.22:                              //   in Loop: Header=BB3_21 Depth=2
	mov	z20.d, z16.d
	mov	z21.d, z17.d
	cmp	w11, #1
	b.ne	.LBB3_26
.LBB3_23:                               //   in Loop: Header=BB3_21 Depth=2
	mov	z22.d, z16.d
	mov	z23.d, z17.d
	cmp	w12, #1
	b.ne	.LBB3_27
.LBB3_24:                               //   in Loop: Header=BB3_21 Depth=2
	cmp	w13, #1
	b.eq	.LBB3_20
	b	.LBB3_28
.LBB3_25:                               //   in Loop: Header=BB3_21 Depth=2
	ld1b	{ z18.b }, p0/z, [x20]
	ld1b	{ z19.b }, p0/z, [x20, x5]
	fmov	w23, s18
	fmov	w24, s19
	eor	w23, w23, w24
	mov	z18.b, w23
	mov	z19.d, z18.d
	mov	z20.d, z16.d
	mov	z21.d, z17.d
	cmp	w11, #1
	b.eq	.LBB3_23
.LBB3_26:                               //   in Loop: Header=BB3_21 Depth=2
	mov	w23, w21
	add	x24, x2, x23
	ld1b	{ z20.b }, p0/z, [x2, x23]
	ld1b	{ z21.b }, p0/z, [x24, x5]
	fmov	w23, s20
	fmov	w24, s21
	eor	w23, w23, w24
	mov	z20.b, w23
	mov	z21.d, z20.d
	mov	z22.d, z16.d
	mov	z23.d, z17.d
	cmp	w12, #1
	b.eq	.LBB3_24
.LBB3_27:                               //   in Loop: Header=BB3_21 Depth=2
	and	x23, x22, #0xffffffe0
	add	x24, x2, x23
	ld1b	{ z22.b }, p0/z, [x2, x23]
	ld1b	{ z23.b }, p0/z, [x24, x5]
	fmov	w23, s22
	fmov	w24, s23
	eor	w23, w23, w24
	mov	z22.b, w23
	mov	z23.d, z22.d
	cmp	w13, #1
	b.eq	.LBB3_20
.LBB3_28:                               //   in Loop: Header=BB3_21 Depth=2
	and	x23, x19, #0xffffffe0
	add	x24, x2, x23
	ld1b	{ z16.b }, p0/z, [x2, x23]
	ld1b	{ z17.b }, p0/z, [x24, x5]
	fmov	w23, s16
	fmov	w24, s17
	eor	w23, w23, w24
	mov	z16.b, w23
	mov	z17.d, z16.d
	b	.LBB3_20
.LBB3_29:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w15
	mov	w10, w0
	rdvl	x11, #2
.LBB3_30:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	ldr	x12, [x4, #24]
	add	x13, x9, x8
	whilelt	p1.b, w13, w0
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #24]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4]
	st1b	{ z0.b }, p0, [x12, x8]
	add	x8, x8, x11
	ldr	x12, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p1, [x13, x12]
	b.lo	.LBB3_30
.LBB3_31:
	ldp	x20, x19, [sp, #32]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             // 16-byte Folded Reload
	ldp	x24, x23, [sp], #48             // 16-byte Folded Reload
.LBB3_32:
	ret
.LBB3_33:
	add	x17, x8, x8, lsl #1
	mov	x16, xzr
	rdvl	x18, #1
	rdvl	x1, #2
	mov	w5, #16                         // =0x10
	lsl	x17, x17, #5
	b	.LBB3_35
.LBB3_34:                               //   in Loop: Header=BB3_35 Depth=1
	ldr	x6, [x4, #24]
	st1b	{ z6.b }, p2, [x6, x16]
	ldr	x6, [x4, #24]
	add	x6, x6, x16
	st1b	{ z7.b }, p1, [x6, x15]
	ldr	x6, [x4, #16]
	st1b	{ z4.b }, p2, [x6, x16]
	ldr	x6, [x4, #16]
	add	x6, x6, x16
	st1b	{ z5.b }, p1, [x6, x15]
	ldr	x6, [x4, #8]
	st1b	{ z2.b }, p2, [x6, x16]
	ldr	x6, [x4, #8]
	add	x6, x6, x16
	st1b	{ z3.b }, p1, [x6, x15]
	ldr	x6, [x4]
	st1b	{ z1.b }, p2, [x6, x16]
	ldr	x6, [x4]
	add	x6, x6, x16
	add	x16, x16, x1
	cmp	w0, w16
	st1b	{ z0.b }, p1, [x6, x15]
	b.le	.LBB3_31
.LBB3_35:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB3_37 Depth 2
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	w20, w18, w16
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x6, x8
	movi	v0.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	mov	x7, x3
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x19, x17
	whilelt	p2.b, w16, w0
	mov	w21, w10
	mov	x22, x14
	whilelt	p1.b, w20, w0
	mov	x20, x2
	b	.LBB3_37
.LBB3_36:                               //   in Loop: Header=BB3_37 Depth=2
	eor	z1.d, z1.d, z22.d
	eor	z0.d, z0.d, z23.d
	add	x22, x22, #32
	eor	z2.d, z2.d, z24.d
	eor	z3.d, z3.d, z25.d
	subs	x6, x6, #1
	eor	z4.d, z4.d, z26.d
	eor	z5.d, z5.d, z27.d
	add	w21, w21, #32
	eor	z6.d, z6.d, z16.d
	eor	z7.d, z7.d, z17.d
	add	x20, x20, #32
	add	x19, x19, #32
	b.eq	.LBB3_34
.LBB3_37:                               //   Parent Loop BB3_35 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x23, [x7], #8
	cmp	w9, #1
	add	x24, x23, x16
	ld1b	{ z16.b }, p2/z, [x23, x16]
	ld1b	{ z17.b }, p1/z, [x24, x15]
	lsr	z21.b, z16.b, #4
	mov	z22.d, z16.d
	movprfx	z20, z16
	and	z20.b, z20.b, #0xf
	lsr	z19.b, z17.b, #4
	mov	z23.d, z17.d
	movprfx	z18, z17
	and	z18.b, z18.b, #0xf
	b.ne	.LBB3_41
// %bb.38:                              //   in Loop: Header=BB3_37 Depth=2
	mov	z24.d, z16.d
	mov	z25.d, z17.d
	cmp	w11, #1
	b.ne	.LBB3_42
.LBB3_39:                               //   in Loop: Header=BB3_37 Depth=2
	mov	z26.d, z16.d
	mov	z27.d, z17.d
	cmp	w12, #1
	b.ne	.LBB3_43
.LBB3_40:                               //   in Loop: Header=BB3_37 Depth=2
	cmp	w13, #1
	b.eq	.LBB3_36
	b	.LBB3_44
.LBB3_41:                               //   in Loop: Header=BB3_37 Depth=2
	ld1b	{ z22.b }, p0/z, [x20]
	ld1b	{ z23.b }, p0/z, [x20, x5]
	tbl	z24.b, { z22.b }, z20.b
	tbl	z25.b, { z23.b }, z21.b
	tbl	z26.b, { z22.b }, z18.b
	tbl	z23.b, { z23.b }, z19.b
	eor	z22.d, z24.d, z25.d
	eor	z23.d, z26.d, z23.d
	mov	z24.d, z16.d
	mov	z25.d, z17.d
	cmp	w11, #1
	b.eq	.LBB3_39
.LBB3_42:                               //   in Loop: Header=BB3_37 Depth=2
	mov	w23, w21
	add	x24, x2, x23
	ld1b	{ z24.b }, p0/z, [x2, x23]
	ld1b	{ z25.b }, p0/z, [x24, x5]
	tbl	z26.b, { z24.b }, z20.b
	tbl	z28.b, { z24.b }, z18.b
	tbl	z27.b, { z25.b }, z21.b
	tbl	z25.b, { z25.b }, z19.b
	eor	z24.d, z26.d, z27.d
	eor	z25.d, z28.d, z25.d
	mov	z26.d, z16.d
	mov	z27.d, z17.d
	cmp	w12, #1
	b.eq	.LBB3_40
.LBB3_43:                               //   in Loop: Header=BB3_37 Depth=2
	and	x23, x22, #0xffffffe0
	add	x24, x2, x23
	ld1b	{ z26.b }, p0/z, [x2, x23]
	ld1b	{ z27.b }, p0/z, [x24, x5]
	tbl	z28.b, { z26.b }, z20.b
	tbl	z30.b, { z26.b }, z18.b
	tbl	z29.b, { z27.b }, z21.b
	tbl	z27.b, { z27.b }, z19.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	cmp	w13, #1
	b.eq	.LBB3_36
.LBB3_44:                               //   in Loop: Header=BB3_37 Depth=2
	and	x23, x19, #0xffffffe0
	add	x24, x2, x23
	ld1b	{ z16.b }, p0/z, [x2, x23]
	ld1b	{ z17.b }, p0/z, [x24, x5]
	tbl	z20.b, { z16.b }, z20.b
	tbl	z18.b, { z16.b }, z18.b
	tbl	z21.b, { z17.b }, z21.b
	tbl	z17.b, { z17.b }, z19.b
	eor	z16.d, z20.d, z21.d
	eor	z17.d, z18.d, z17.d
	b	.LBB3_36
.Lfunc_end3:
	.size	gf_4vect_dot_prod_sve, .Lfunc_end3-gf_4vect_dot_prod_sve
                                        // -- End function
	.globl	gf_5vect_dot_prod_sve           // -- Begin function gf_5vect_dot_prod_sve
	.p2align	2
	.type	gf_5vect_dot_prod_sve,@function
gf_5vect_dot_prod_sve:                  // @gf_5vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB4_44
// %bb.1:
	str	d10, [sp, #-112]!               // 8-byte Folded Spill
	cmp	w1, #1
	rdvl	x16, #1
	stp	d9, d8, [sp, #16]               // 16-byte Folded Spill
	stp	x28, x27, [sp, #32]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             // 16-byte Folded Spill
	b.lt	.LBB4_41
// %bb.2:
	mov	w8, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x9, x8, #5
	sub	x11, x9, #32
.LBB4_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB4_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x15, x8, #1
	sub	x13, x8, #1
	mov	w12, w10
.LBB4_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB4_7
// %bb.6:                               //   in Loop: Header=BB4_5 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB4_5
.LBB4_7:
	lsl	w13, w1, #6
	sub	x14, x8, #1
.LBB4_8:                                // =>This Inner Loop Header: Depth=1
	add	x12, x2, w13, sxtw
	subs	x14, x14, #1
	cset	w17, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB4_10
// %bb.9:                               //   in Loop: Header=BB4_8 Depth=1
	add	w13, w13, #32
	tbnz	w17, #0, .LBB4_8
.LBB4_10:
	add	w13, w1, w1, lsl #1
	sub	x17, x8, #1
	lsl	w14, w13, #5
.LBB4_11:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x17, x17, #1
	cset	w18, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB4_13
// %bb.12:                              //   in Loop: Header=BB4_11 Depth=1
	add	w14, w14, #32
	tbnz	w18, #0, .LBB4_11
.LBB4_13:
	lsl	w17, w1, #7
.LBB4_14:                               // =>This Inner Loop Header: Depth=1
	add	x14, x2, w17, sxtw
	subs	x15, x15, #1
	cset	w18, hs
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	b.ne	.LBB4_16
// %bb.15:                              //   in Loop: Header=BB4_14 Depth=1
	add	w17, w17, #32
	tbnz	w18, #0, .LBB4_14
.LBB4_16:
	cmp	w11, #1
	add	x1, x8, x8, lsl #1
	lsl	x17, x8, #6
	ccmp	w9, #1, #0, eq
	lsl	x18, x8, #7
	mov	x15, xzr
	ccmp	w12, #1, #0, eq
	lsl	x1, x1, #5
	mov	w16, w16
	ccmp	w13, #1, #0, eq
	rdvl	x6, #1
	mov	w7, #16                         // =0x10
	ccmp	w14, #1, #0, eq
	rdvl	x19, #2
	cset	w5, eq
	b	.LBB4_18
.LBB4_17:                               //   in Loop: Header=BB4_18 Depth=1
	ldr	x20, [x4, #32]
	st1b	{ z16.b }, p2, [x20, x15]
	ldr	x20, [x4, #32]
	add	x20, x20, x15
	st1b	{ z17.b }, p1, [x20, x16]
	ldr	x20, [x4, #24]
	st1b	{ z6.b }, p2, [x20, x15]
	ldr	x20, [x4, #24]
	add	x20, x20, x15
	st1b	{ z7.b }, p1, [x20, x16]
	ldr	x20, [x4, #16]
	st1b	{ z4.b }, p2, [x20, x15]
	ldr	x20, [x4, #16]
	add	x20, x20, x15
	st1b	{ z5.b }, p1, [x20, x16]
	ldr	x20, [x4, #8]
	st1b	{ z2.b }, p2, [x20, x15]
	ldr	x20, [x4, #8]
	add	x20, x20, x15
	st1b	{ z3.b }, p1, [x20, x16]
	ldr	x20, [x4]
	st1b	{ z0.b }, p2, [x20, x15]
	ldr	x20, [x4]
	add	x20, x20, x15
	add	x15, x15, x19
	cmp	w0, w15
	st1b	{ z1.b }, p1, [x20, x16]
	b.le	.LBB4_43
.LBB4_18:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB4_31 Depth 2
                                        //     Child Loop BB4_20 Depth 2
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	w20, w6, w15
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x21, x3
	movi	v16.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x22, x1
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	x23, x2
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	w24, w10
	whilelt	p2.b, w15, w0
	mov	x25, x17
	mov	x26, x18
	whilelt	p1.b, w20, w0
	mov	x20, x8
	tbnz	w5, #0, .LBB4_20
	b	.LBB4_31
.LBB4_19:                               //   in Loop: Header=BB4_20 Depth=2
	eor	z0.d, z0.d, z20.d
	eor	z1.d, z1.d, z21.d
	add	x26, x26, #32
	eor	z2.d, z2.d, z22.d
	eor	z3.d, z3.d, z23.d
	add	x25, x25, #32
	eor	z4.d, z4.d, z24.d
	eor	z5.d, z5.d, z25.d
	subs	x20, x20, #1
	eor	z6.d, z6.d, z26.d
	eor	z7.d, z7.d, z27.d
	add	w24, w24, #32
	eor	z16.d, z16.d, z18.d
	eor	z17.d, z17.d, z19.d
	add	x23, x23, #32
	add	x22, x22, #32
	b.eq	.LBB4_17
.LBB4_20:                               //   Parent Loop BB4_18 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x27, [x21], #8
	cmp	w9, #1
	add	x28, x27, x15
	ld1b	{ z18.b }, p2/z, [x27, x15]
	ld1b	{ z19.b }, p1/z, [x28, x16]
	mov	z20.d, z18.d
	mov	z21.d, z19.d
	b.ne	.LBB4_25
// %bb.21:                              //   in Loop: Header=BB4_20 Depth=2
	mov	z22.d, z18.d
	mov	z23.d, z19.d
	cmp	w11, #1
	b.ne	.LBB4_26
.LBB4_22:                               //   in Loop: Header=BB4_20 Depth=2
	mov	z24.d, z18.d
	mov	z25.d, z19.d
	cmp	w12, #1
	b.ne	.LBB4_27
.LBB4_23:                               //   in Loop: Header=BB4_20 Depth=2
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w13, #1
	b.ne	.LBB4_28
.LBB4_24:                               //   in Loop: Header=BB4_20 Depth=2
	cmp	w14, #1
	b.eq	.LBB4_19
	b	.LBB4_29
.LBB4_25:                               //   in Loop: Header=BB4_20 Depth=2
	ld1b	{ z20.b }, p0/z, [x23]
	ld1b	{ z21.b }, p0/z, [x23, x7]
	fmov	w27, s20
	fmov	w28, s21
	eor	w27, w27, w28
	mov	z20.b, w27
	mov	z21.d, z20.d
	mov	z22.d, z18.d
	mov	z23.d, z19.d
	cmp	w11, #1
	b.eq	.LBB4_22
.LBB4_26:                               //   in Loop: Header=BB4_20 Depth=2
	mov	w27, w24
	add	x28, x2, x27
	ld1b	{ z22.b }, p0/z, [x2, x27]
	ld1b	{ z23.b }, p0/z, [x28, x7]
	fmov	w27, s22
	fmov	w28, s23
	eor	w27, w27, w28
	mov	z22.b, w27
	mov	z23.d, z22.d
	mov	z24.d, z18.d
	mov	z25.d, z19.d
	cmp	w12, #1
	b.eq	.LBB4_23
.LBB4_27:                               //   in Loop: Header=BB4_20 Depth=2
	and	x27, x25, #0xffffffe0
	add	x28, x2, x27
	ld1b	{ z24.b }, p0/z, [x2, x27]
	ld1b	{ z25.b }, p0/z, [x28, x7]
	fmov	w27, s24
	fmov	w28, s25
	eor	w27, w27, w28
	mov	z24.b, w27
	mov	z25.d, z24.d
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w13, #1
	b.eq	.LBB4_24
.LBB4_28:                               //   in Loop: Header=BB4_20 Depth=2
	and	x27, x22, #0xffffffe0
	add	x28, x2, x27
	ld1b	{ z26.b }, p0/z, [x2, x27]
	ld1b	{ z27.b }, p0/z, [x28, x7]
	fmov	w27, s26
	fmov	w28, s27
	eor	w27, w27, w28
	mov	z26.b, w27
	mov	z27.d, z26.d
	cmp	w14, #1
	b.eq	.LBB4_19
.LBB4_29:                               //   in Loop: Header=BB4_20 Depth=2
	and	x27, x26, #0xffffffe0
	add	x28, x2, x27
	ld1b	{ z18.b }, p0/z, [x2, x27]
	ld1b	{ z19.b }, p0/z, [x28, x7]
	fmov	w27, s18
	fmov	w28, s19
	eor	w27, w27, w28
	mov	z18.b, w27
	mov	z19.d, z18.d
	b	.LBB4_19
.LBB4_30:                               //   in Loop: Header=BB4_31 Depth=2
	eor	z0.d, z0.d, z24.d
	eor	z1.d, z1.d, z25.d
	add	x26, x26, #32
	eor	z2.d, z2.d, z26.d
	eor	z3.d, z3.d, z27.d
	add	x25, x25, #32
	eor	z4.d, z4.d, z28.d
	eor	z5.d, z5.d, z29.d
	subs	x20, x20, #1
	eor	z6.d, z6.d, z30.d
	eor	z7.d, z7.d, z31.d
	add	w24, w24, #32
	eor	z16.d, z16.d, z18.d
	eor	z17.d, z17.d, z19.d
	add	x23, x23, #32
	add	x22, x22, #32
	b.eq	.LBB4_17
.LBB4_31:                               //   Parent Loop BB4_18 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x27, [x21], #8
	cmp	w9, #1
	add	x28, x27, x15
	ld1b	{ z18.b }, p2/z, [x27, x15]
	ld1b	{ z19.b }, p1/z, [x28, x16]
	lsr	z23.b, z18.b, #4
	mov	z24.d, z18.d
	movprfx	z22, z18
	and	z22.b, z22.b, #0xf
	lsr	z21.b, z19.b, #4
	mov	z25.d, z19.d
	movprfx	z20, z19
	and	z20.b, z20.b, #0xf
	b.ne	.LBB4_36
// %bb.32:                              //   in Loop: Header=BB4_31 Depth=2
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w11, #1
	b.ne	.LBB4_37
.LBB4_33:                               //   in Loop: Header=BB4_31 Depth=2
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	cmp	w12, #1
	b.ne	.LBB4_38
.LBB4_34:                               //   in Loop: Header=BB4_31 Depth=2
	mov	z30.d, z18.d
	mov	z31.d, z19.d
	cmp	w13, #1
	b.ne	.LBB4_39
.LBB4_35:                               //   in Loop: Header=BB4_31 Depth=2
	cmp	w14, #1
	b.eq	.LBB4_30
	b	.LBB4_40
.LBB4_36:                               //   in Loop: Header=BB4_31 Depth=2
	ld1b	{ z24.b }, p0/z, [x23]
	ld1b	{ z25.b }, p0/z, [x23, x7]
	tbl	z26.b, { z24.b }, z22.b
	tbl	z27.b, { z25.b }, z23.b
	tbl	z28.b, { z24.b }, z20.b
	tbl	z25.b, { z25.b }, z21.b
	eor	z24.d, z26.d, z27.d
	eor	z25.d, z28.d, z25.d
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w11, #1
	b.eq	.LBB4_33
.LBB4_37:                               //   in Loop: Header=BB4_31 Depth=2
	mov	w27, w24
	add	x28, x2, x27
	ld1b	{ z26.b }, p0/z, [x2, x27]
	ld1b	{ z27.b }, p0/z, [x28, x7]
	tbl	z28.b, { z26.b }, z22.b
	tbl	z30.b, { z26.b }, z20.b
	tbl	z29.b, { z27.b }, z23.b
	tbl	z27.b, { z27.b }, z21.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	cmp	w12, #1
	b.eq	.LBB4_34
.LBB4_38:                               //   in Loop: Header=BB4_31 Depth=2
	and	x27, x25, #0xffffffe0
	add	x28, x2, x27
	ld1b	{ z28.b }, p0/z, [x2, x27]
	ld1b	{ z29.b }, p0/z, [x28, x7]
	tbl	z30.b, { z28.b }, z22.b
	tbl	z8.b, { z28.b }, z20.b
	tbl	z31.b, { z29.b }, z23.b
	tbl	z29.b, { z29.b }, z21.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
	mov	z30.d, z18.d
	mov	z31.d, z19.d
	cmp	w13, #1
	b.eq	.LBB4_35
.LBB4_39:                               //   in Loop: Header=BB4_31 Depth=2
	and	x27, x22, #0xffffffe0
	add	x28, x2, x27
	ld1b	{ z30.b }, p0/z, [x2, x27]
	ld1b	{ z31.b }, p0/z, [x28, x7]
	tbl	z8.b, { z30.b }, z22.b
	tbl	z10.b, { z30.b }, z20.b
	tbl	z9.b, { z31.b }, z23.b
	tbl	z31.b, { z31.b }, z21.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	cmp	w14, #1
	b.eq	.LBB4_30
.LBB4_40:                               //   in Loop: Header=BB4_31 Depth=2
	and	x27, x26, #0xffffffe0
	add	x28, x2, x27
	ld1b	{ z18.b }, p0/z, [x2, x27]
	ld1b	{ z19.b }, p0/z, [x28, x7]
	tbl	z22.b, { z18.b }, z22.b
	tbl	z20.b, { z18.b }, z20.b
	tbl	z23.b, { z19.b }, z23.b
	tbl	z19.b, { z19.b }, z21.b
	eor	z18.d, z22.d, z23.d
	eor	z19.d, z20.d, z19.d
	b	.LBB4_30
.LBB4_41:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w16
	mov	w10, w0
	rdvl	x11, #2
.LBB4_42:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	ldr	x12, [x4, #32]
	add	x13, x9, x8
	whilelt	p1.b, w13, w0
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #32]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #24]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #24]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4]
	st1b	{ z0.b }, p0, [x12, x8]
	add	x8, x8, x11
	ldr	x12, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p1, [x13, x12]
	b.lo	.LBB4_42
.LBB4_43:
	ldp	x20, x19, [sp, #96]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             // 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               // 16-byte Folded Reload
	ldr	d10, [sp], #112                 // 8-byte Folded Reload
.LBB4_44:
	ret
.Lfunc_end4:
	.size	gf_5vect_dot_prod_sve, .Lfunc_end4-gf_5vect_dot_prod_sve
                                        // -- End function
	.globl	gf_6vect_dot_prod_sve           // -- Begin function gf_6vect_dot_prod_sve
	.p2align	2
	.type	gf_6vect_dot_prod_sve,@function
gf_6vect_dot_prod_sve:                  // @gf_6vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB5_51
// %bb.1:
	str	d14, [sp, #-160]!               // 8-byte Folded Spill
	cmp	w1, #1
	rdvl	x17, #1
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             // 16-byte Folded Spill
	stp	x28, x27, [sp, #80]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #96]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #112]            // 16-byte Folded Spill
	stp	x22, x21, [sp, #128]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #144]            // 16-byte Folded Spill
	b.lt	.LBB5_48
// %bb.2:
	mov	w8, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x9, x8, #5
	sub	x11, x9, #32
.LBB5_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB5_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x16, x8, #1
	sub	x13, x8, #1
	mov	w12, w10
.LBB5_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB5_7
// %bb.6:                               //   in Loop: Header=BB5_5 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB5_5
.LBB5_7:
	lsl	w13, w1, #6
	sub	x14, x8, #1
.LBB5_8:                                // =>This Inner Loop Header: Depth=1
	add	x12, x2, w13, sxtw
	subs	x14, x14, #1
	cset	w15, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB5_10
// %bb.9:                               //   in Loop: Header=BB5_8 Depth=1
	add	w13, w13, #32
	tbnz	w15, #0, .LBB5_8
.LBB5_10:
	add	w13, w1, w1, lsl #1
	sub	x15, x8, #1
	lsl	w14, w13, #5
.LBB5_11:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w18, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB5_13
// %bb.12:                              //   in Loop: Header=BB5_11 Depth=1
	add	w14, w14, #32
	tbnz	w18, #0, .LBB5_11
.LBB5_13:
	lsl	w15, w1, #7
	sub	x18, x8, #1
.LBB5_14:                               // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	subs	x18, x18, #1
	cset	w5, hs
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	b.ne	.LBB5_16
// %bb.15:                              //   in Loop: Header=BB5_14 Depth=1
	add	w15, w15, #32
	tbnz	w5, #0, .LBB5_14
.LBB5_16:
	add	w15, w1, w1, lsl #2
	lsl	w18, w15, #5
.LBB5_17:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w18, sxtw
	subs	x16, x16, #1
	cset	w1, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB5_19
// %bb.18:                              //   in Loop: Header=BB5_17 Depth=1
	add	w18, w18, #32
	tbnz	w1, #0, .LBB5_17
.LBB5_19:
	cmp	w11, #1
	add	x5, x8, x8, lsl #1
	add	x6, x8, x8, lsl #2
	ccmp	w9, #1, #0, eq
	lsl	x18, x8, #6
	lsl	x1, x8, #7
	ccmp	w12, #1, #0, eq
	lsl	x5, x5, #5
	lsl	x6, x6, #5
	ccmp	w13, #1, #0, eq
	mov	x16, xzr
	mov	w17, w17
	ccmp	w14, #1, #0, eq
	mov	w20, #16                        // =0x10
	rdvl	x21, #2
	ccmp	w15, #1, #0, eq
	cset	w7, eq
	b	.LBB5_21
.LBB5_20:                               //   in Loop: Header=BB5_21 Depth=1
	ldr	x19, [x4, #40]
	st1b	{ z17.b }, p2, [x19, x16]
	ldr	x19, [x4, #40]
	add	x19, x19, x16
	st1b	{ z19.b }, p1, [x19, x17]
	ldr	x19, [x4, #32]
	st1b	{ z7.b }, p2, [x19, x16]
	ldr	x19, [x4, #32]
	add	x19, x19, x16
	st1b	{ z18.b }, p1, [x19, x17]
	ldr	x19, [x4, #24]
	st1b	{ z5.b }, p2, [x19, x16]
	ldr	x19, [x4, #24]
	add	x19, x19, x16
	st1b	{ z16.b }, p1, [x19, x17]
	ldr	x19, [x4, #16]
	st1b	{ z3.b }, p2, [x19, x16]
	ldr	x19, [x4, #16]
	add	x19, x19, x16
	st1b	{ z6.b }, p1, [x19, x17]
	ldr	x19, [x4, #8]
	st1b	{ z2.b }, p2, [x19, x16]
	ldr	x19, [x4, #8]
	add	x19, x19, x16
	st1b	{ z4.b }, p1, [x19, x17]
	ldr	x19, [x4]
	st1b	{ z0.b }, p2, [x19, x16]
	ldr	x19, [x4]
	add	x19, x19, x16
	add	x16, x16, x21
	cmp	w0, w16
	st1b	{ z1.b }, p1, [x19, x17]
	b.le	.LBB5_50
.LBB5_21:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB5_36 Depth 2
                                        //     Child Loop BB5_23 Depth 2
	rdvl	x19, #1
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	add	w22, w19, w16
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	x23, x3
	movi	v1.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	x24, x6
	movi	v6.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	mov	x25, x5
	movi	v18.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	x26, x2
	whilelt	p2.b, w16, w0
	mov	w27, w10
	mov	x28, x18
	whilelt	p1.b, w22, w0
	mov	x22, x8
	mov	x29, x1
	tbnz	w7, #0, .LBB5_23
	b	.LBB5_36
.LBB5_22:                               //   in Loop: Header=BB5_23 Depth=2
	eor	z0.d, z0.d, z22.d
	eor	z1.d, z1.d, z23.d
	add	x29, x29, #32
	eor	z2.d, z2.d, z24.d
	eor	z4.d, z4.d, z25.d
	add	x28, x28, #32
	eor	z3.d, z3.d, z26.d
	eor	z6.d, z6.d, z27.d
	add	w27, w27, #32
	eor	z5.d, z5.d, z28.d
	eor	z16.d, z16.d, z29.d
	subs	x22, x22, #1
	eor	z7.d, z7.d, z30.d
	eor	z18.d, z18.d, z31.d
	add	x26, x26, #32
	eor	z17.d, z17.d, z20.d
	eor	z19.d, z19.d, z21.d
	add	x25, x25, #32
	add	x24, x24, #32
	b.eq	.LBB5_20
.LBB5_23:                               //   Parent Loop BB5_21 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x19, [x23], #8
	cmp	w9, #1
	add	x30, x19, x16
	ld1b	{ z20.b }, p2/z, [x19, x16]
	ld1b	{ z21.b }, p1/z, [x30, x17]
	mov	z22.d, z20.d
	mov	z23.d, z21.d
	b.ne	.LBB5_29
// %bb.24:                              //   in Loop: Header=BB5_23 Depth=2
	mov	z24.d, z20.d
	mov	z25.d, z21.d
	cmp	w11, #1
	b.ne	.LBB5_30
.LBB5_25:                               //   in Loop: Header=BB5_23 Depth=2
	mov	z26.d, z20.d
	mov	z27.d, z21.d
	cmp	w12, #1
	b.ne	.LBB5_31
.LBB5_26:                               //   in Loop: Header=BB5_23 Depth=2
	mov	z28.d, z20.d
	mov	z29.d, z21.d
	cmp	w13, #1
	b.ne	.LBB5_32
.LBB5_27:                               //   in Loop: Header=BB5_23 Depth=2
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w14, #1
	b.ne	.LBB5_33
.LBB5_28:                               //   in Loop: Header=BB5_23 Depth=2
	cmp	w15, #1
	b.eq	.LBB5_22
	b	.LBB5_34
.LBB5_29:                               //   in Loop: Header=BB5_23 Depth=2
	ld1b	{ z22.b }, p0/z, [x26]
	ld1b	{ z23.b }, p0/z, [x26, x20]
	fmov	w19, s22
	fmov	w30, s23
	eor	w19, w19, w30
	mov	z22.b, w19
	mov	z23.d, z22.d
	mov	z24.d, z20.d
	mov	z25.d, z21.d
	cmp	w11, #1
	b.eq	.LBB5_25
.LBB5_30:                               //   in Loop: Header=BB5_23 Depth=2
	mov	w19, w27
	add	x30, x2, x19
	ld1b	{ z24.b }, p0/z, [x2, x19]
	ld1b	{ z25.b }, p0/z, [x30, x20]
	fmov	w19, s24
	fmov	w30, s25
	eor	w19, w19, w30
	mov	z24.b, w19
	mov	z25.d, z24.d
	mov	z26.d, z20.d
	mov	z27.d, z21.d
	cmp	w12, #1
	b.eq	.LBB5_26
.LBB5_31:                               //   in Loop: Header=BB5_23 Depth=2
	and	x19, x28, #0xffffffe0
	add	x30, x2, x19
	ld1b	{ z26.b }, p0/z, [x2, x19]
	ld1b	{ z27.b }, p0/z, [x30, x20]
	fmov	w19, s26
	fmov	w30, s27
	eor	w19, w19, w30
	mov	z26.b, w19
	mov	z27.d, z26.d
	mov	z28.d, z20.d
	mov	z29.d, z21.d
	cmp	w13, #1
	b.eq	.LBB5_27
.LBB5_32:                               //   in Loop: Header=BB5_23 Depth=2
	and	x19, x25, #0xffffffe0
	add	x30, x2, x19
	ld1b	{ z28.b }, p0/z, [x2, x19]
	ld1b	{ z29.b }, p0/z, [x30, x20]
	fmov	w19, s28
	fmov	w30, s29
	eor	w19, w19, w30
	mov	z28.b, w19
	mov	z29.d, z28.d
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w14, #1
	b.eq	.LBB5_28
.LBB5_33:                               //   in Loop: Header=BB5_23 Depth=2
	and	x19, x29, #0xffffffe0
	add	x30, x2, x19
	ld1b	{ z30.b }, p0/z, [x2, x19]
	ld1b	{ z31.b }, p0/z, [x30, x20]
	fmov	w19, s30
	fmov	w30, s31
	eor	w19, w19, w30
	mov	z30.b, w19
	mov	z31.d, z30.d
	cmp	w15, #1
	b.eq	.LBB5_22
.LBB5_34:                               //   in Loop: Header=BB5_23 Depth=2
	and	x19, x24, #0xffffffe0
	add	x30, x2, x19
	ld1b	{ z20.b }, p0/z, [x2, x19]
	ld1b	{ z21.b }, p0/z, [x30, x20]
	fmov	w19, s20
	fmov	w30, s21
	eor	w19, w19, w30
	mov	z20.b, w19
	mov	z21.d, z20.d
	b	.LBB5_22
.LBB5_35:                               //   in Loop: Header=BB5_36 Depth=2
	eor	z0.d, z0.d, z26.d
	eor	z1.d, z1.d, z27.d
	add	x29, x29, #32
	eor	z2.d, z2.d, z28.d
	eor	z4.d, z4.d, z29.d
	add	x28, x28, #32
	eor	z3.d, z3.d, z30.d
	eor	z6.d, z6.d, z31.d
	add	w27, w27, #32
	eor	z5.d, z5.d, z8.d
	eor	z16.d, z16.d, z9.d
	subs	x22, x22, #1
	eor	z7.d, z7.d, z10.d
	eor	z18.d, z18.d, z11.d
	add	x26, x26, #32
	eor	z17.d, z17.d, z20.d
	eor	z19.d, z19.d, z21.d
	add	x25, x25, #32
	add	x24, x24, #32
	b.eq	.LBB5_20
.LBB5_36:                               //   Parent Loop BB5_21 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x30, [x23], #8
	cmp	w9, #1
	add	x19, x30, x16
	ld1b	{ z20.b }, p2/z, [x30, x16]
	ld1b	{ z21.b }, p1/z, [x19, x17]
	lsr	z25.b, z20.b, #4
	mov	z26.d, z20.d
	movprfx	z24, z20
	and	z24.b, z24.b, #0xf
	lsr	z23.b, z21.b, #4
	mov	z27.d, z21.d
	movprfx	z22, z21
	and	z22.b, z22.b, #0xf
	b.ne	.LBB5_42
// %bb.37:                              //   in Loop: Header=BB5_36 Depth=2
	mov	z28.d, z20.d
	mov	z29.d, z21.d
	cmp	w11, #1
	b.ne	.LBB5_43
.LBB5_38:                               //   in Loop: Header=BB5_36 Depth=2
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w12, #1
	b.ne	.LBB5_44
.LBB5_39:                               //   in Loop: Header=BB5_36 Depth=2
	mov	z8.d, z20.d
	mov	z9.d, z21.d
	cmp	w13, #1
	b.ne	.LBB5_45
.LBB5_40:                               //   in Loop: Header=BB5_36 Depth=2
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	cmp	w14, #1
	b.ne	.LBB5_46
.LBB5_41:                               //   in Loop: Header=BB5_36 Depth=2
	cmp	w15, #1
	b.eq	.LBB5_35
	b	.LBB5_47
.LBB5_42:                               //   in Loop: Header=BB5_36 Depth=2
	ld1b	{ z26.b }, p0/z, [x26]
	ld1b	{ z27.b }, p0/z, [x26, x20]
	tbl	z28.b, { z26.b }, z24.b
	tbl	z29.b, { z27.b }, z25.b
	tbl	z30.b, { z26.b }, z22.b
	tbl	z27.b, { z27.b }, z23.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	mov	z28.d, z20.d
	mov	z29.d, z21.d
	cmp	w11, #1
	b.eq	.LBB5_38
.LBB5_43:                               //   in Loop: Header=BB5_36 Depth=2
	mov	w19, w27
	add	x30, x2, x19
	ld1b	{ z28.b }, p0/z, [x2, x19]
	ld1b	{ z29.b }, p0/z, [x30, x20]
	tbl	z30.b, { z28.b }, z24.b
	tbl	z8.b, { z28.b }, z22.b
	tbl	z31.b, { z29.b }, z25.b
	tbl	z29.b, { z29.b }, z23.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w12, #1
	b.eq	.LBB5_39
.LBB5_44:                               //   in Loop: Header=BB5_36 Depth=2
	and	x19, x28, #0xffffffe0
	add	x30, x2, x19
	ld1b	{ z30.b }, p0/z, [x2, x19]
	ld1b	{ z31.b }, p0/z, [x30, x20]
	tbl	z8.b, { z30.b }, z24.b
	tbl	z10.b, { z30.b }, z22.b
	tbl	z9.b, { z31.b }, z25.b
	tbl	z31.b, { z31.b }, z23.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	mov	z8.d, z20.d
	mov	z9.d, z21.d
	cmp	w13, #1
	b.eq	.LBB5_40
.LBB5_45:                               //   in Loop: Header=BB5_36 Depth=2
	and	x19, x25, #0xffffffe0
	add	x30, x2, x19
	ld1b	{ z8.b }, p0/z, [x2, x19]
	ld1b	{ z9.b }, p0/z, [x30, x20]
	tbl	z10.b, { z8.b }, z24.b
	tbl	z12.b, { z8.b }, z22.b
	tbl	z11.b, { z9.b }, z25.b
	tbl	z9.b, { z9.b }, z23.b
	eor	z8.d, z10.d, z11.d
	eor	z9.d, z12.d, z9.d
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	cmp	w14, #1
	b.eq	.LBB5_41
.LBB5_46:                               //   in Loop: Header=BB5_36 Depth=2
	and	x19, x29, #0xffffffe0
	add	x30, x2, x19
	ld1b	{ z10.b }, p0/z, [x2, x19]
	ld1b	{ z11.b }, p0/z, [x30, x20]
	tbl	z12.b, { z10.b }, z24.b
	tbl	z14.b, { z10.b }, z22.b
	tbl	z13.b, { z11.b }, z25.b
	tbl	z11.b, { z11.b }, z23.b
	eor	z10.d, z12.d, z13.d
	eor	z11.d, z14.d, z11.d
	cmp	w15, #1
	b.eq	.LBB5_35
.LBB5_47:                               //   in Loop: Header=BB5_36 Depth=2
	and	x19, x24, #0xffffffe0
	add	x30, x2, x19
	ld1b	{ z20.b }, p0/z, [x2, x19]
	ld1b	{ z21.b }, p0/z, [x30, x20]
	tbl	z24.b, { z20.b }, z24.b
	tbl	z22.b, { z20.b }, z22.b
	tbl	z25.b, { z21.b }, z25.b
	tbl	z21.b, { z21.b }, z23.b
	eor	z20.d, z24.d, z25.d
	eor	z21.d, z22.d, z21.d
	b	.LBB5_35
.LBB5_48:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w17
	mov	w10, w0
	rdvl	x11, #2
.LBB5_49:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	ldr	x12, [x4, #40]
	add	x13, x9, x8
	whilelt	p1.b, w13, w0
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #40]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #32]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #32]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #24]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #24]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4]
	st1b	{ z0.b }, p0, [x12, x8]
	add	x8, x8, x11
	ldr	x12, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p1, [x13, x12]
	b.lo	.LBB5_49
.LBB5_50:
	ldp	x20, x19, [sp, #144]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #128]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #112]            // 16-byte Folded Reload
	ldp	x26, x25, [sp, #96]             // 16-byte Folded Reload
	ldp	x28, x27, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x30, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldr	d14, [sp], #160                 // 8-byte Folded Reload
.LBB5_51:
	ret
.Lfunc_end5:
	.size	gf_6vect_dot_prod_sve, .Lfunc_end5-gf_6vect_dot_prod_sve
                                        // -- End function
	.globl	gf_7vect_dot_prod_sve           // -- Begin function gf_7vect_dot_prod_sve
	.p2align	2
	.type	gf_7vect_dot_prod_sve,@function
gf_7vect_dot_prod_sve:                  // @gf_7vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB6_45
// %bb.1:
	stp	d15, d14, [sp, #-144]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x27, [sp, #64]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #80]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #96]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #112]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #128]            // 16-byte Folded Spill
	addvl	sp, sp, #-2
	cmp	w1, #1
	rdvl	x18, #1
	b.lt	.LBB6_42
// %bb.2:
	mov	w5, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x8, x5, #5
	sub	x11, x8, #32
.LBB6_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB6_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x17, x5, #1
	sub	x13, x5, #1
	mov	w12, w10
.LBB6_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB6_7
// %bb.6:                               //   in Loop: Header=BB6_5 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB6_5
.LBB6_7:
	lsl	w13, w1, #6
	sub	x14, x5, #1
.LBB6_8:                                // =>This Inner Loop Header: Depth=1
	add	x12, x2, w13, sxtw
	subs	x14, x14, #1
	cset	w15, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB6_10
// %bb.9:                               //   in Loop: Header=BB6_8 Depth=1
	add	w13, w13, #32
	tbnz	w15, #0, .LBB6_8
.LBB6_10:
	add	w16, w1, w1, lsl #1
	sub	x15, x5, #1
	lsl	w14, w16, #5
.LBB6_11:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w6, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB6_13
// %bb.12:                              //   in Loop: Header=BB6_11 Depth=1
	add	w14, w14, #32
	tbnz	w6, #0, .LBB6_11
.LBB6_13:
	lsl	w15, w1, #7
	sub	x6, x5, #1
.LBB6_14:                               // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	subs	x6, x6, #1
	cset	w7, hs
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	b.ne	.LBB6_16
// %bb.15:                              //   in Loop: Header=BB6_14 Depth=1
	add	w15, w15, #32
	tbnz	w7, #0, .LBB6_14
.LBB6_16:
	add	w15, w1, w1, lsl #2
	sub	x6, x5, #1
	lsl	w1, w15, #5
.LBB6_17:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w1, sxtw
	subs	x6, x6, #1
	cset	w7, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB6_19
// %bb.18:                              //   in Loop: Header=BB6_17 Depth=1
	add	w1, w1, #32
	tbnz	w7, #0, .LBB6_17
.LBB6_19:
	lsl	w1, w16, #6
.LBB6_20:                               // =>This Inner Loop Header: Depth=1
	add	x16, x2, w1, sxtw
	subs	x17, x17, #1
	cset	w6, hs
	ldrb	w16, [x16, #1]
	cmp	w16, #1
	b.ne	.LBB6_22
// %bb.21:                              //   in Loop: Header=BB6_20 Depth=1
	add	w1, w1, #32
	tbnz	w6, #0, .LBB6_20
.LBB6_22:
	cmp	w11, #1
	add	x19, x5, x5, lsl #1
	add	x7, x5, x5, lsl #2
	ccmp	w9, #1, #0, eq
	lsl	x1, x5, #6
	lsl	x5, x5, #7
	ccmp	w12, #1, #0, eq
	lsl	x6, x19, #5
	lsl	x7, x7, #5
	ccmp	w13, #1, #0, eq
	lsl	x19, x19, #6
	mov	x17, xzr
	ccmp	w14, #1, #0, eq
	mov	w18, w18
	rdvl	x21, #1
	ccmp	w15, #1, #0, eq
	rdvl	x22, #2
	mov	w23, #16                        // =0x10
	ccmp	w16, #1, #0, eq
	cset	w20, eq
	b	.LBB6_24
.LBB6_23:                               //   in Loop: Header=BB6_24 Depth=1
	ldr	x24, [x4, #48]
	st1b	{ z20.b }, p2, [x24, x17]
	ldr	x24, [x4, #48]
	add	x24, x24, x17
	st1b	{ z21.b }, p1, [x24, x18]
	ldr	x24, [x4, #40]
	st1b	{ z18.b }, p2, [x24, x17]
	ldr	x24, [x4, #40]
	add	x24, x24, x17
	st1b	{ z19.b }, p1, [x24, x18]
	ldr	x24, [x4, #32]
	st1b	{ z16.b }, p2, [x24, x17]
	ldr	x24, [x4, #32]
	add	x24, x24, x17
	st1b	{ z17.b }, p1, [x24, x18]
	ldr	x24, [x4, #24]
	st1b	{ z6.b }, p2, [x24, x17]
	ldr	x24, [x4, #24]
	add	x24, x24, x17
	st1b	{ z7.b }, p1, [x24, x18]
	ldr	x24, [x4, #16]
	st1b	{ z4.b }, p2, [x24, x17]
	ldr	x24, [x4, #16]
	add	x24, x24, x17
	st1b	{ z5.b }, p1, [x24, x18]
	ldr	x24, [x4, #8]
	st1b	{ z2.b }, p2, [x24, x17]
	ldr	x24, [x4, #8]
	add	x24, x24, x17
	st1b	{ z3.b }, p1, [x24, x18]
	ldr	x24, [x4]
	st1b	{ z1.b }, p2, [x24, x17]
	ldr	x24, [x4]
	add	x24, x24, x17
	add	x17, x17, x22
	cmp	w0, w17
	st1b	{ z0.b }, p1, [x24, x18]
	b.le	.LBB6_44
.LBB6_24:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB6_26 Depth 2
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	w25, w21, w17
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x24, xzr
	movi	v16.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	whilelt	p2.b, w17, w0
	whilelt	p1.b, w25, w0
	mov	x25, x3
	b	.LBB6_26
.LBB6_25:                               //   in Loop: Header=BB6_26 Depth=2
	ldr	z24, [sp, #1, mul vl]           // 16-byte Folded Reload
	eor	z1.d, z1.d, z28.d
	eor	z0.d, z0.d, z29.d
	eor	z2.d, z2.d, z30.d
	eor	z3.d, z3.d, z31.d
	add	x24, x24, #32
	eor	z4.d, z4.d, z8.d
	eor	z5.d, z5.d, z9.d
	cmp	x8, x24
	eor	z6.d, z6.d, z10.d
	eor	z7.d, z7.d, z11.d
	eor	z16.d, z16.d, z24.d
	eor	z17.d, z17.d, z13.d
	eor	z18.d, z18.d, z15.d
	eor	z19.d, z19.d, z14.d
	eor	z20.d, z20.d, z22.d
	eor	z21.d, z21.d, z23.d
	b.eq	.LBB6_23
.LBB6_26:                               //   Parent Loop BB6_24 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x26, [x25], #8
	add	x27, x26, x17
	ld1b	{ z22.b }, p2/z, [x26, x17]
	ld1b	{ z23.b }, p1/z, [x27, x18]
	tbz	w20, #0, .LBB6_35
// %bb.27:                              //   in Loop: Header=BB6_26 Depth=2
	movi	v24.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	mov	z28.d, z22.d
	mov	z29.d, z23.d
	cmp	w9, #1
	b.eq	.LBB6_29
.LBB6_28:                               //   in Loop: Header=BB6_26 Depth=2
	add	x26, x2, x24
	ld1b	{ z28.b }, p0/z, [x2, x24]
	ld1b	{ z29.b }, p0/z, [x26, x23]
	tbl	z30.b, { z28.b }, z27.b
	tbl	z8.b, { z28.b }, z25.b
	tbl	z31.b, { z29.b }, z26.b
	tbl	z29.b, { z29.b }, z24.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
.LBB6_29:                               //   in Loop: Header=BB6_26 Depth=2
	mov	z30.d, z22.d
	mov	z31.d, z23.d
	cmp	w11, #1
	b.ne	.LBB6_36
// %bb.30:                              //   in Loop: Header=BB6_26 Depth=2
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	cmp	w12, #1
	b.ne	.LBB6_37
.LBB6_31:                               //   in Loop: Header=BB6_26 Depth=2
	mov	z10.d, z22.d
	mov	z11.d, z23.d
	cmp	w13, #1
	b.ne	.LBB6_38
.LBB6_32:                               //   in Loop: Header=BB6_26 Depth=2
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w14, #1
	b.ne	.LBB6_39
.LBB6_33:                               //   in Loop: Header=BB6_26 Depth=2
	str	z12, [sp, #1, mul vl]           // 16-byte Folded Spill
	mov	z12.d, z24.d
	mov	z15.d, z22.d
	mov	z14.d, z23.d
	cmp	w15, #1
	b.ne	.LBB6_40
.LBB6_34:                               //   in Loop: Header=BB6_26 Depth=2
	cmp	w16, #1
	b.eq	.LBB6_25
	b	.LBB6_41
.LBB6_35:                               //   in Loop: Header=BB6_26 Depth=2
	lsr	z26.b, z22.b, #4
	lsr	z24.b, z23.b, #4
	movprfx	z27, z22
	and	z27.b, z27.b, #0xf
	movprfx	z25, z23
	and	z25.b, z25.b, #0xf
	mov	z28.d, z22.d
	mov	z29.d, z23.d
	cmp	w9, #1
	b.ne	.LBB6_28
	b	.LBB6_29
.LBB6_36:                               //   in Loop: Header=BB6_26 Depth=2
	add	w26, w10, w24
	add	x27, x2, x26
	ld1b	{ z30.b }, p0/z, [x2, x26]
	ld1b	{ z31.b }, p0/z, [x27, x23]
	tbl	z8.b, { z30.b }, z27.b
	tbl	z10.b, { z30.b }, z25.b
	tbl	z9.b, { z31.b }, z26.b
	tbl	z31.b, { z31.b }, z24.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	cmp	w12, #1
	b.eq	.LBB6_31
.LBB6_37:                               //   in Loop: Header=BB6_26 Depth=2
	add	w26, w1, w24
	and	x26, x26, #0xffffffe0
	add	x27, x2, x26
	ld1b	{ z8.b }, p0/z, [x2, x26]
	ld1b	{ z9.b }, p0/z, [x27, x23]
	tbl	z10.b, { z8.b }, z27.b
	tbl	z12.b, { z8.b }, z25.b
	tbl	z11.b, { z9.b }, z26.b
	tbl	z9.b, { z9.b }, z24.b
	eor	z8.d, z10.d, z11.d
	eor	z9.d, z12.d, z9.d
	mov	z10.d, z22.d
	mov	z11.d, z23.d
	cmp	w13, #1
	b.eq	.LBB6_32
.LBB6_38:                               //   in Loop: Header=BB6_26 Depth=2
	add	w26, w6, w24
	and	x26, x26, #0xffffffe0
	add	x27, x2, x26
	ld1b	{ z10.b }, p0/z, [x2, x26]
	ld1b	{ z11.b }, p0/z, [x27, x23]
	tbl	z12.b, { z10.b }, z27.b
	tbl	z14.b, { z10.b }, z25.b
	tbl	z13.b, { z11.b }, z26.b
	tbl	z11.b, { z11.b }, z24.b
	eor	z10.d, z12.d, z13.d
	eor	z11.d, z14.d, z11.d
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w14, #1
	b.eq	.LBB6_33
.LBB6_39:                               //   in Loop: Header=BB6_26 Depth=2
	add	w26, w5, w24
	str	z10, [sp, #1, mul vl]           // 16-byte Folded Spill
	mov	z10.d, z9.d
	and	x26, x26, #0xffffffe0
	mov	z9.d, z21.d
	mov	z21.d, z20.d
	add	x27, x2, x26
	ld1b	{ z12.b }, p0/z, [x2, x26]
	mov	z20.d, z19.d
	ld1b	{ z13.b }, p0/z, [x27, x23]
	mov	z19.d, z18.d
	mov	z18.d, z17.d
	mov	z17.d, z16.d
	mov	z16.d, z7.d
	mov	z7.d, z6.d
	tbl	z14.b, { z12.b }, z27.b
	mov	z6.d, z5.d
	mov	z5.d, z4.d
	tbl	z15.b, { z13.b }, z26.b
	mov	z4.d, z3.d
	mov	z3.d, z2.d
	mov	z2.d, z1.d
	mov	z1.d, z0.d
	mov	z0.d, z8.d
	mov	z8.d, z31.d
	mov	z31.d, z30.d
	mov	z30.d, z29.d
	mov	z29.d, z28.d
	tbl	z28.b, { z12.b }, z25.b
	tbl	z13.b, { z13.b }, z24.b
	eor	z12.d, z14.d, z15.d
	eor	z13.d, z28.d, z13.d
	mov	z28.d, z29.d
	mov	z29.d, z30.d
	mov	z30.d, z31.d
	mov	z31.d, z8.d
	mov	z8.d, z0.d
	mov	z0.d, z1.d
	mov	z1.d, z2.d
	mov	z2.d, z3.d
	mov	z3.d, z4.d
	mov	z4.d, z5.d
	mov	z5.d, z6.d
	mov	z6.d, z7.d
	mov	z7.d, z16.d
	mov	z16.d, z17.d
	mov	z17.d, z18.d
	mov	z18.d, z19.d
	mov	z19.d, z20.d
	mov	z20.d, z21.d
	mov	z21.d, z9.d
	mov	z9.d, z10.d
	ldr	z10, [sp, #1, mul vl]           // 16-byte Folded Reload
	str	z12, [sp, #1, mul vl]           // 16-byte Folded Spill
	mov	z12.d, z24.d
	mov	z15.d, z22.d
	mov	z14.d, z23.d
	cmp	w15, #1
	b.eq	.LBB6_34
.LBB6_40:                               //   in Loop: Header=BB6_26 Depth=2
	add	w26, w7, w24
	str	z21, [sp]                       // 16-byte Folded Spill
	mov	z21.d, z20.d
	and	x26, x26, #0xffffffe0
	mov	z20.d, z19.d
	mov	z19.d, z18.d
	add	x27, x2, x26
	mov	z18.d, z17.d
	mov	z17.d, z16.d
	mov	z16.d, z7.d
	mov	z7.d, z6.d
	mov	z6.d, z5.d
	mov	z5.d, z4.d
	mov	z4.d, z3.d
	ld1b	{ z14.b }, p0/z, [x27, x23]
	mov	z3.d, z2.d
	mov	z2.d, z1.d
	mov	z1.d, z0.d
	mov	z0.d, z8.d
	mov	z8.d, z30.d
	mov	z30.d, z28.d
	ld1b	{ z28.b }, p0/z, [x2, x26]
	mov	z24.d, z11.d
	mov	z11.d, z10.d
	mov	z10.d, z9.d
	mov	z9.d, z31.d
	mov	z31.d, z29.d
	tbl	z29.b, { z14.b }, z26.b
	tbl	z14.b, { z14.b }, z12.b
	tbl	z15.b, { z28.b }, z27.b
	tbl	z28.b, { z28.b }, z25.b
	eor	z15.d, z15.d, z29.d
	mov	z29.d, z31.d
	mov	z31.d, z9.d
	mov	z9.d, z10.d
	mov	z10.d, z11.d
	mov	z11.d, z24.d
	eor	z14.d, z28.d, z14.d
	mov	z28.d, z30.d
	mov	z30.d, z8.d
	mov	z8.d, z0.d
	mov	z0.d, z1.d
	mov	z1.d, z2.d
	mov	z2.d, z3.d
	mov	z3.d, z4.d
	mov	z4.d, z5.d
	mov	z5.d, z6.d
	mov	z6.d, z7.d
	mov	z7.d, z16.d
	mov	z16.d, z17.d
	mov	z17.d, z18.d
	mov	z18.d, z19.d
	mov	z19.d, z20.d
	mov	z20.d, z21.d
	ldr	z21, [sp]                       // 16-byte Folded Reload
	cmp	w16, #1
	b.eq	.LBB6_25
.LBB6_41:                               //   in Loop: Header=BB6_26 Depth=2
	add	w26, w19, w24
	and	x26, x26, #0xffffffe0
	add	x27, x2, x26
	ld1b	{ z22.b }, p0/z, [x2, x26]
	ld1b	{ z23.b }, p0/z, [x27, x23]
	tbl	z27.b, { z22.b }, z27.b
	tbl	z25.b, { z22.b }, z25.b
	tbl	z26.b, { z23.b }, z26.b
	tbl	z23.b, { z23.b }, z12.b
	eor	z22.d, z27.d, z26.d
	eor	z23.d, z25.d, z23.d
	b	.LBB6_25
.LBB6_42:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w18
	mov	w10, w0
	rdvl	x11, #2
.LBB6_43:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	ldr	x12, [x4, #48]
	add	x13, x9, x8
	whilelt	p1.b, w13, w0
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #48]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #40]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #40]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #32]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #32]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #24]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #24]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p1, [x13, x12]
	ldr	x12, [x4]
	st1b	{ z0.b }, p0, [x12, x8]
	add	x8, x8, x11
	ldr	x12, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p1, [x13, x12]
	b.lo	.LBB6_43
.LBB6_44:
	addvl	sp, sp, #2
	ldp	x20, x19, [sp, #128]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x27, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #144            // 16-byte Folded Reload
.LBB6_45:
	ret
.Lfunc_end6:
	.size	gf_7vect_dot_prod_sve, .Lfunc_end6-gf_7vect_dot_prod_sve
                                        // -- End function
	.globl	gf_vect_dot_prod_sve2           // -- Begin function gf_vect_dot_prod_sve2
	.p2align	2
	.type	gf_vect_dot_prod_sve2,@function
gf_vect_dot_prod_sve2:                  // @gf_vect_dot_prod_sve2
// %bb.0:
	cmp	w0, #16
	b.ge	.LBB7_2
.LBB7_1:
	ret
.LBB7_2:
	rdvl	x13, #1
	cmp	w1, #1
	lsr	x11, x13, #4
	b.lt	.LBB7_12
// %bb.3:
	mov	w8, w1
	mov	x10, xzr
	lsl	x8, x8, #5
	sub	x12, x8, #32
.LBB7_4:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB7_4
// %bb.5:
	add	w12, w11, w11, lsl #1
	lsl	w11, w11, #5
	ptrue	p0.b
	mov	x10, xzr
	mov	w13, w13
	mov	w14, #16                        // =0x10
	lsl	w12, w12, #4
	b	.LBB7_7
.LBB7_6:                                //   in Loop: Header=BB7_7 Depth=1
	st1b	{ z2.b }, p1, [x4, x10]
	incb	x10, all, mul #4
	st1b	{ z1.b }, p3, [x4, x15]
	st1b	{ z3.b }, p4, [x4, x16]
	cmp	w0, w10
	st1b	{ z0.b }, p2, [x4, x18]
	b.le	.LBB7_1
.LBB7_7:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB7_10 Depth 2
	whilelt	p1.b, w10, w0
	b.eq	.LBB7_1
// %bb.8:                               //   in Loop: Header=BB7_7 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	add	x15, x10, x13
	movi	v3.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	add	x16, x10, x11
	add	x18, x10, x12
	whilelt	p3.b, w15, w0
	mov	x17, xzr
	whilelt	p4.b, w16, w0
	mov	x1, x3
	whilelt	p2.b, w18, w0
	b	.LBB7_10
.LBB7_9:                                //   in Loop: Header=BB7_10 Depth=2
	eor	z2.d, z2.d, z7.d
	eor	z1.d, z1.d, z6.d
	add	x17, x17, #32
	eor	z3.d, z3.d, z4.d
	eor	z0.d, z0.d, z5.d
	cmp	x8, x17
	b.eq	.LBB7_6
.LBB7_10:                               //   Parent Loop BB7_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x5, [x1], #8
	cmp	w9, #1
	ld1b	{ z7.b }, p1/z, [x5, x10]
	ld1b	{ z6.b }, p3/z, [x5, x15]
	ld1b	{ z4.b }, p4/z, [x5, x16]
	ld1b	{ z5.b }, p2/z, [x5, x18]
	b.eq	.LBB7_9
// %bb.11:                              //   in Loop: Header=BB7_10 Depth=2
	sxtw	x5, w17
	movprfx	z16, z7
	and	z16.b, z16.b, #0xf
	lsr	z7.b, z7.b, #4
	movprfx	z17, z6
	and	z17.b, z17.b, #0xf
	movprfx	z19, z4
	and	z19.b, z19.b, #0xf
	movprfx	z20, z5
	and	z20.b, z20.b, #0xf
	add	x6, x2, x5
	ld1b	{ z18.b }, p0/z, [x2, x5]
	lsr	z6.b, z6.b, #4
	ld1b	{ z21.b }, p0/z, [x6, x14]
	lsr	z4.b, z4.b, #4
	lsr	z5.b, z5.b, #4
	tbl	z16.b, { z18.b }, z16.b
	tbl	z17.b, { z18.b }, z17.b
	tbl	z19.b, { z18.b }, z19.b
	tbl	z18.b, { z18.b }, z20.b
	tbl	z7.b, { z21.b }, z7.b
	tbl	z6.b, { z21.b }, z6.b
	tbl	z4.b, { z21.b }, z4.b
	tbl	z5.b, { z21.b }, z5.b
	eor	z7.d, z16.d, z7.d
	eor	z6.d, z17.d, z6.d
	eor	z4.d, z19.d, z4.d
	eor	z5.d, z18.d, z5.d
	b	.LBB7_9
.LBB7_12:
	add	w10, w11, w11, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w11, #5
	mov	w11, w13
	mov	x8, xzr
	lsl	w10, w10, #4
	add	x12, x4, x11
	add	x13, x4, x9
	add	x14, x4, x10
.LBB7_13:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB7_1
// %bb.14:                              //   in Loop: Header=BB7_13 Depth=1
	add	w15, w11, w8
	add	w16, w9, w8
	st1b	{ z0.b }, p0, [x4, x8]
	whilelt	p1.b, w15, w0
	add	w15, w10, w8
	whilelt	p0.b, w16, w0
	whilelt	p2.b, w15, w0
	st1b	{ z0.b }, p1, [x12, x8]
	st1b	{ z0.b }, p0, [x13, x8]
	st1b	{ z0.b }, p2, [x14, x8]
	incb	x8, all, mul #4
	cmp	w0, w8
	b.gt	.LBB7_13
	b	.LBB7_1
.Lfunc_end7:
	.size	gf_vect_dot_prod_sve2, .Lfunc_end7-gf_vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_2vect_dot_prod_sve2          // -- Begin function gf_2vect_dot_prod_sve2
	.p2align	2
	.type	gf_2vect_dot_prod_sve2,@function
gf_2vect_dot_prod_sve2:                 // @gf_2vect_dot_prod_sve2
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB8_21
// %bb.1:
	str	d12, [sp, #-64]!                // 8-byte Folded Spill
	rdvl	x15, #1
	cmp	w1, #1
	stp	d11, d10, [sp, #8]              // 16-byte Folded Spill
	lsr	x13, x15, #4
	stp	d9, d8, [sp, #24]               // 16-byte Folded Spill
	str	x21, [sp, #40]                  // 8-byte Spill
	stp	x20, x19, [sp, #48]             // 16-byte Folded Spill
	b.lt	.LBB8_17
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB8_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB8_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x14, x11, #1
	mov	w12, w10
.LBB8_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	add	w12, w12, #32
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	ccmp	x14, #0, #4, eq
	sub	x14, x14, #1
	b.ne	.LBB8_5
// %bb.6:
	add	w14, w13, w13, lsl #1
	cmp	w9, #1
	lsl	w13, w13, #5
	ccmp	w11, #1, #0, eq
	ptrue	p0.b
	mov	x12, xzr
	lsl	w14, w14, #4
	mov	w15, w15
	cset	w16, ne
	mov	w17, #16                        // =0x10
	b	.LBB8_8
.LBB8_7:                                //   in Loop: Header=BB8_8 Depth=1
	ldr	x5, [x4, #8]
	st1b	{ z4.b }, p1, [x5, x12]
	ldr	x5, [x4, #8]
	st1b	{ z5.b }, p3, [x5, x1]
	ldr	x5, [x4, #8]
	st1b	{ z6.b }, p4, [x5, x18]
	ldr	x5, [x4, #8]
	st1b	{ z7.b }, p2, [x5, x6]
	ldr	x5, [x4]
	st1b	{ z2.b }, p1, [x5, x12]
	incb	x12, all, mul #4
	ldr	x5, [x4]
	st1b	{ z3.b }, p3, [x5, x1]
	cmp	w0, w12
	ldr	x1, [x4]
	st1b	{ z1.b }, p4, [x1, x18]
	ldr	x18, [x4]
	st1b	{ z0.b }, p2, [x18, x6]
	b.le	.LBB8_20
.LBB8_8:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB8_12 Depth 2
	whilelt	p1.b, w12, w0
	b.eq	.LBB8_20
// %bb.9:                               //   in Loop: Header=BB8_8 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	add	x1, x12, x15
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	add	x18, x12, x13
	movi	v1.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	add	x6, x12, x14
	movi	v0.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x5, xzr
	whilelt	p3.b, w1, w0
	mov	x7, x3
	mov	w19, w10
	whilelt	p4.b, w18, w0
	whilelt	p2.b, w6, w0
	b	.LBB8_12
.LBB8_10:                               //   in Loop: Header=BB8_12 Depth=2
	eor	z2.d, z2.d, z18.d
	eor	z3.d, z3.d, z19.d
	eor	z1.d, z1.d, z16.d
	eor	z0.d, z0.d, z17.d
.LBB8_11:                               //   in Loop: Header=BB8_12 Depth=2
	eor	z4.d, z4.d, z18.d
	eor	z5.d, z5.d, z19.d
	add	x5, x5, #32
	eor	z6.d, z6.d, z16.d
	eor	z7.d, z7.d, z17.d
	cmp	x8, x5
	add	w19, w19, #32
	b.eq	.LBB8_7
.LBB8_12:                               //   Parent Loop BB8_8 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x20, [x7], #8
	ld1b	{ z18.b }, p1/z, [x20, x12]
	ld1b	{ z19.b }, p3/z, [x20, x1]
	ld1b	{ z16.b }, p4/z, [x20, x18]
	ld1b	{ z17.b }, p2/z, [x20, x6]
	tbz	w16, #0, .LBB8_10
// %bb.13:                              //   in Loop: Header=BB8_12 Depth=2
	lsr	z20.b, z18.b, #4
	lsr	z21.b, z19.b, #4
	cmp	w9, #1
	lsr	z22.b, z16.b, #4
	lsr	z23.b, z17.b, #4
	movprfx	z24, z18
	and	z24.b, z24.b, #0xf
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	movprfx	z25, z19
	and	z25.b, z25.b, #0xf
	mov	z30.d, z16.d
	mov	z31.d, z17.d
	movprfx	z26, z16
	and	z26.b, z26.b, #0xf
	movprfx	z27, z17
	and	z27.b, z27.b, #0xf
	b.eq	.LBB8_15
// %bb.14:                              //   in Loop: Header=BB8_12 Depth=2
	sxtw	x20, w5
	add	x21, x2, x20
	ld1b	{ z28.b }, p0/z, [x2, x20]
	ld1b	{ z29.b }, p0/z, [x21, x17]
	tbl	z30.b, { z28.b }, z24.b
	tbl	z31.b, { z28.b }, z25.b
	tbl	z8.b, { z28.b }, z26.b
	tbl	z9.b, { z28.b }, z27.b
	tbl	z28.b, { z29.b }, z20.b
	tbl	z10.b, { z29.b }, z21.b
	tbl	z11.b, { z29.b }, z22.b
	tbl	z12.b, { z29.b }, z23.b
	eor	z28.d, z30.d, z28.d
	eor	z29.d, z31.d, z10.d
	eor	z30.d, z8.d, z11.d
	eor	z31.d, z9.d, z12.d
.LBB8_15:                               //   in Loop: Header=BB8_12 Depth=2
	eor	z2.d, z2.d, z28.d
	eor	z3.d, z3.d, z29.d
	cmp	w11, #1
	eor	z1.d, z1.d, z30.d
	eor	z0.d, z0.d, z31.d
	b.eq	.LBB8_11
// %bb.16:                              //   in Loop: Header=BB8_12 Depth=2
	sxtw	x20, w19
	add	x21, x2, x20
	ld1b	{ z16.b }, p0/z, [x2, x20]
	ld1b	{ z17.b }, p0/z, [x21, x17]
	tbl	z18.b, { z16.b }, z24.b
	tbl	z19.b, { z16.b }, z25.b
	tbl	z24.b, { z16.b }, z26.b
	tbl	z25.b, { z16.b }, z27.b
	tbl	z16.b, { z17.b }, z20.b
	tbl	z20.b, { z17.b }, z21.b
	tbl	z21.b, { z17.b }, z22.b
	tbl	z17.b, { z17.b }, z23.b
	eor	z18.d, z18.d, z16.d
	eor	z19.d, z19.d, z20.d
	eor	z16.d, z24.d, z21.d
	eor	z17.d, z25.d, z17.d
	b	.LBB8_11
.LBB8_17:
	add	w10, w13, w13, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w13, #5
	mov	x8, xzr
	mov	w11, w15
	lsl	w10, w10, #4
.LBB8_18:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB8_20
// %bb.19:                              //   in Loop: Header=BB8_18 Depth=1
	ldr	x12, [x4, #8]
	add	x13, x11, x8
	add	x14, x9, x8
	whilelt	p3.b, w13, w0
	add	x15, x10, x8
	st1b	{ z0.b }, p0, [x12, x8]
	whilelt	p2.b, w14, w0
	ldr	x12, [x4, #8]
	whilelt	p1.b, w15, w0
	st1b	{ z0.b }, p3, [x13, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p2, [x14, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p1, [x15, x12]
	ldr	x12, [x4]
	st1b	{ z0.b }, p0, [x12, x8]
	incb	x8, all, mul #4
	ldr	x12, [x4]
	st1b	{ z0.b }, p3, [x13, x12]
	cmp	w0, w8
	ldr	x12, [x4]
	st1b	{ z0.b }, p2, [x14, x12]
	ldr	x12, [x4]
	st1b	{ z0.b }, p1, [x15, x12]
	b.gt	.LBB8_18
.LBB8_20:
	ldp	x20, x19, [sp, #48]             // 16-byte Folded Reload
	ldr	x21, [sp, #40]                  // 8-byte Reload
	ldp	d9, d8, [sp, #24]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #8]              // 16-byte Folded Reload
	ldr	d12, [sp], #64                  // 8-byte Folded Reload
.LBB8_21:
	ret
.Lfunc_end8:
	.size	gf_2vect_dot_prod_sve2, .Lfunc_end8-gf_2vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_3vect_dot_prod_sve2          // -- Begin function gf_3vect_dot_prod_sve2
	.p2align	2
	.type	gf_3vect_dot_prod_sve2,@function
gf_3vect_dot_prod_sve2:                 // @gf_3vect_dot_prod_sve2
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB9_26
// %bb.1:
	str	x19, [sp, #-16]!                // 8-byte Folded Spill
	cmp	w1, #1
	rdvl	x14, #1
	b.lt	.LBB9_23
// %bb.2:
	mov	w8, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x9, x8, #5
	sub	x11, x9, #32
.LBB9_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB9_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x13, x8, #1
	sub	x15, x8, #1
	mov	w12, w10
.LBB9_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x15, x15, #1
	cset	w16, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB9_7
// %bb.6:                               //   in Loop: Header=BB9_5 Depth=1
	add	w12, w12, #32
	tbnz	w16, #0, .LBB9_5
.LBB9_7:
	lsl	w15, w1, #6
.LBB9_8:                                // =>This Inner Loop Header: Depth=1
	add	x12, x2, w15, sxtw
	subs	x13, x13, #1
	cset	w16, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB9_10
// %bb.9:                               //   in Loop: Header=BB9_8 Depth=1
	add	w15, w15, #32
	tbnz	w16, #0, .LBB9_8
.LBB9_10:
	lsl	x13, x8, #6
	cmp	w11, #1
	mov	w14, w14
	b.ne	.LBB9_27
// %bb.11:
	cmp	w9, #1
	b.ne	.LBB9_27
// %bb.12:
	cmp	w12, #1
	b.ne	.LBB9_27
// %bb.13:
	mov	x15, xzr
	mov	w16, #16                        // =0x10
	b	.LBB9_15
.LBB9_14:                               //   in Loop: Header=BB9_15 Depth=1
	ldr	x17, [x4, #16]
	st1b	{ z4.b }, p2, [x17, x15]
	ldr	x17, [x4, #16]
	add	x17, x17, x15
	st1b	{ z5.b }, p1, [x17, x14]
	ldr	x17, [x4, #8]
	st1b	{ z2.b }, p2, [x17, x15]
	ldr	x17, [x4, #8]
	add	x17, x17, x15
	st1b	{ z3.b }, p1, [x17, x14]
	ldr	x17, [x4]
	st1b	{ z1.b }, p2, [x17, x15]
	ldr	x17, [x4]
	add	x17, x17, x15
	incb	x15, all, mul #2
	st1b	{ z0.b }, p1, [x17, x14]
	cmp	w0, w15
	b.le	.LBB9_25
.LBB9_15:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB9_17 Depth 2
	mov	w17, w15
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	incb	x17
	movi	v4.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	x18, x3
	whilelt	p2.b, w15, w0
	mov	x1, x2
	mov	w5, w10
	whilelt	p1.b, w17, w0
	mov	x17, x8
	mov	x6, x13
	b	.LBB9_17
.LBB9_16:                               //   in Loop: Header=BB9_17 Depth=2
	eor	z1.d, z1.d, z16.d
	eor	z0.d, z0.d, z17.d
	subs	x17, x17, #1
	eor	z2.d, z2.d, z18.d
	eor	z3.d, z3.d, z19.d
	add	x6, x6, #32
	eor	z4.d, z4.d, z6.d
	eor	z5.d, z5.d, z7.d
	add	w5, w5, #32
	add	x1, x1, #32
	b.eq	.LBB9_14
.LBB9_17:                               //   Parent Loop BB9_15 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x7, [x18], #8
	cmp	w9, #1
	add	x19, x7, x15
	ld1b	{ z6.b }, p2/z, [x7, x15]
	ld1b	{ z7.b }, p1/z, [x19, x14]
	mov	z16.d, z6.d
	mov	z17.d, z7.d
	b.ne	.LBB9_20
// %bb.18:                              //   in Loop: Header=BB9_17 Depth=2
	mov	z18.d, z6.d
	mov	z19.d, z7.d
	cmp	w11, #1
	b.ne	.LBB9_21
.LBB9_19:                               //   in Loop: Header=BB9_17 Depth=2
	cmp	w12, #1
	b.eq	.LBB9_16
	b	.LBB9_22
.LBB9_20:                               //   in Loop: Header=BB9_17 Depth=2
	ld1b	{ z16.b }, p0/z, [x1]
	ld1b	{ z17.b }, p0/z, [x1, x16]
	fmov	w7, s16
	fmov	w19, s17
	eor	w7, w7, w19
	mov	z16.b, w7
	mov	z17.d, z16.d
	mov	z18.d, z6.d
	mov	z19.d, z7.d
	cmp	w11, #1
	b.eq	.LBB9_19
.LBB9_21:                               //   in Loop: Header=BB9_17 Depth=2
	mov	w7, w5
	add	x19, x2, x7
	ld1b	{ z18.b }, p0/z, [x2, x7]
	ld1b	{ z19.b }, p0/z, [x19, x16]
	fmov	w7, s18
	fmov	w19, s19
	eor	w7, w7, w19
	mov	z18.b, w7
	mov	z19.d, z18.d
	cmp	w12, #1
	b.eq	.LBB9_16
.LBB9_22:                               //   in Loop: Header=BB9_17 Depth=2
	and	x7, x6, #0xffffffe0
	add	x19, x2, x7
	ld1b	{ z6.b }, p0/z, [x2, x7]
	ld1b	{ z7.b }, p0/z, [x19, x16]
	fmov	w7, s6
	fmov	w19, s7
	eor	w7, w7, w19
	mov	z6.b, w7
	mov	z7.d, z6.d
	b	.LBB9_16
.LBB9_23:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w14
	mov	w10, w0
.LBB9_24:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	ldr	x11, [x4, #16]
	add	x12, x9, x8
	whilelt	p1.b, w12, w0
	st1b	{ z0.b }, p0, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p1, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p0, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p0, [x11, x8]
	incb	x8, all, mul #2
	ldr	x11, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p1, [x12, x11]
	b.lo	.LBB9_24
.LBB9_25:
	ldr	x19, [sp], #16                  // 8-byte Folded Reload
.LBB9_26:
	ret
.LBB9_27:
	mov	x15, xzr
	mov	w16, #16                        // =0x10
	b	.LBB9_29
.LBB9_28:                               //   in Loop: Header=BB9_29 Depth=1
	ldr	x17, [x4, #16]
	st1b	{ z4.b }, p2, [x17, x15]
	ldr	x17, [x4, #16]
	add	x17, x17, x15
	st1b	{ z5.b }, p1, [x17, x14]
	ldr	x17, [x4, #8]
	st1b	{ z2.b }, p2, [x17, x15]
	ldr	x17, [x4, #8]
	add	x17, x17, x15
	st1b	{ z3.b }, p1, [x17, x14]
	ldr	x17, [x4]
	st1b	{ z1.b }, p2, [x17, x15]
	ldr	x17, [x4]
	add	x17, x17, x15
	incb	x15, all, mul #2
	st1b	{ z0.b }, p1, [x17, x14]
	cmp	w0, w15
	b.le	.LBB9_25
.LBB9_29:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB9_31 Depth 2
	mov	w17, w15
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	incb	x17
	movi	v4.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	x18, x3
	whilelt	p2.b, w15, w0
	mov	x1, x2
	mov	w5, w10
	whilelt	p1.b, w17, w0
	mov	x17, x8
	mov	x6, x13
	b	.LBB9_31
.LBB9_30:                               //   in Loop: Header=BB9_31 Depth=2
	eor	z1.d, z1.d, z20.d
	eor	z0.d, z0.d, z21.d
	subs	x17, x17, #1
	eor	z2.d, z2.d, z22.d
	eor	z3.d, z3.d, z23.d
	add	x6, x6, #32
	eor	z4.d, z4.d, z6.d
	eor	z5.d, z5.d, z7.d
	add	w5, w5, #32
	add	x1, x1, #32
	b.eq	.LBB9_28
.LBB9_31:                               //   Parent Loop BB9_29 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x7, [x18], #8
	cmp	w9, #1
	add	x19, x7, x15
	ld1b	{ z6.b }, p2/z, [x7, x15]
	ld1b	{ z7.b }, p1/z, [x19, x14]
	lsr	z19.b, z6.b, #4
	mov	z20.d, z6.d
	movprfx	z18, z6
	and	z18.b, z18.b, #0xf
	lsr	z17.b, z7.b, #4
	mov	z21.d, z7.d
	movprfx	z16, z7
	and	z16.b, z16.b, #0xf
	b.ne	.LBB9_34
// %bb.32:                              //   in Loop: Header=BB9_31 Depth=2
	mov	z22.d, z6.d
	mov	z23.d, z7.d
	cmp	w11, #1
	b.ne	.LBB9_35
.LBB9_33:                               //   in Loop: Header=BB9_31 Depth=2
	cmp	w12, #1
	b.eq	.LBB9_30
	b	.LBB9_36
.LBB9_34:                               //   in Loop: Header=BB9_31 Depth=2
	ld1b	{ z20.b }, p0/z, [x1]
	ld1b	{ z21.b }, p0/z, [x1, x16]
	tbl	z22.b, { z20.b }, z18.b
	tbl	z23.b, { z21.b }, z19.b
	tbl	z24.b, { z20.b }, z16.b
	tbl	z21.b, { z21.b }, z17.b
	eor	z20.d, z22.d, z23.d
	eor	z21.d, z24.d, z21.d
	mov	z22.d, z6.d
	mov	z23.d, z7.d
	cmp	w11, #1
	b.eq	.LBB9_33
.LBB9_35:                               //   in Loop: Header=BB9_31 Depth=2
	mov	w7, w5
	add	x19, x2, x7
	ld1b	{ z22.b }, p0/z, [x2, x7]
	ld1b	{ z23.b }, p0/z, [x19, x16]
	tbl	z24.b, { z22.b }, z18.b
	tbl	z26.b, { z22.b }, z16.b
	tbl	z25.b, { z23.b }, z19.b
	tbl	z23.b, { z23.b }, z17.b
	eor	z22.d, z24.d, z25.d
	eor	z23.d, z26.d, z23.d
	cmp	w12, #1
	b.eq	.LBB9_30
.LBB9_36:                               //   in Loop: Header=BB9_31 Depth=2
	and	x7, x6, #0xffffffe0
	add	x19, x2, x7
	ld1b	{ z6.b }, p0/z, [x2, x7]
	ld1b	{ z7.b }, p0/z, [x19, x16]
	tbl	z18.b, { z6.b }, z18.b
	tbl	z16.b, { z6.b }, z16.b
	tbl	z19.b, { z7.b }, z19.b
	tbl	z7.b, { z7.b }, z17.b
	eor	z6.d, z18.d, z19.d
	eor	z7.d, z16.d, z7.d
	b	.LBB9_30
.Lfunc_end9:
	.size	gf_3vect_dot_prod_sve2, .Lfunc_end9-gf_3vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_4vect_dot_prod_sve2          // -- Begin function gf_4vect_dot_prod_sve2
	.p2align	2
	.type	gf_4vect_dot_prod_sve2,@function
gf_4vect_dot_prod_sve2:                 // @gf_4vect_dot_prod_sve2
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB10_32
// %bb.1:
	stp	x22, x21, [sp, #-32]!           // 16-byte Folded Spill
	cmp	w1, #1
	rdvl	x15, #1
	stp	x20, x19, [sp, #16]             // 16-byte Folded Spill
	b.lt	.LBB10_29
// %bb.2:
	mov	w8, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x9, x8, #5
	sub	x11, x9, #32
.LBB10_3:                               // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB10_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x14, x8, #1
	sub	x13, x8, #1
	mov	w12, w10
.LBB10_5:                               // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w16, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB10_7
// %bb.6:                               //   in Loop: Header=BB10_5 Depth=1
	add	w12, w12, #32
	tbnz	w16, #0, .LBB10_5
.LBB10_7:
	lsl	w13, w1, #6
	sub	x16, x8, #1
.LBB10_8:                               // =>This Inner Loop Header: Depth=1
	add	x12, x2, w13, sxtw
	subs	x16, x16, #1
	cset	w17, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB10_10
// %bb.9:                               //   in Loop: Header=BB10_8 Depth=1
	add	w13, w13, #32
	tbnz	w17, #0, .LBB10_8
.LBB10_10:
	add	w13, w1, w1, lsl #1
	lsl	w16, w13, #5
.LBB10_11:                              // =>This Inner Loop Header: Depth=1
	add	x13, x2, w16, sxtw
	subs	x14, x14, #1
	cset	w17, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB10_13
// %bb.12:                              //   in Loop: Header=BB10_11 Depth=1
	add	w16, w16, #32
	tbnz	w17, #0, .LBB10_11
.LBB10_13:
	lsl	x14, x8, #6
	cmp	w11, #1
	mov	w15, w15
	b.ne	.LBB10_33
// %bb.14:
	cmp	w9, #1
	b.ne	.LBB10_33
// %bb.15:
	cmp	w12, #1
	b.ne	.LBB10_33
// %bb.16:
	cmp	w13, #1
	b.ne	.LBB10_33
// %bb.17:
	add	x17, x8, x8, lsl #1
	mov	x16, xzr
	mov	w18, #16                        // =0x10
	lsl	x17, x17, #5
	b	.LBB10_19
.LBB10_18:                              //   in Loop: Header=BB10_19 Depth=1
	ldr	x1, [x4, #24]
	st1b	{ z6.b }, p1, [x1, x16]
	ldr	x1, [x4, #24]
	add	x1, x1, x16
	st1b	{ z7.b }, p2, [x1, x15]
	ldr	x1, [x4, #16]
	st1b	{ z4.b }, p1, [x1, x16]
	ldr	x1, [x4, #16]
	add	x1, x1, x16
	st1b	{ z5.b }, p2, [x1, x15]
	ldr	x1, [x4, #8]
	st1b	{ z2.b }, p1, [x1, x16]
	ldr	x1, [x4, #8]
	add	x1, x1, x16
	st1b	{ z3.b }, p2, [x1, x15]
	ldr	x1, [x4]
	st1b	{ z1.b }, p1, [x1, x16]
	ldr	x1, [x4]
	add	x1, x1, x16
	incb	x16, all, mul #2
	st1b	{ z0.b }, p2, [x1, x15]
	cmp	w0, w16
	b.le	.LBB10_31
.LBB10_19:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB10_21 Depth 2
	mov	w1, w16
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	incb	x1
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	mov	x5, x3
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x6, x17
	whilelt	p1.b, w16, w0
	mov	x7, x2
	mov	w19, w10
	whilelt	p2.b, w1, w0
	mov	x1, x8
	mov	x20, x14
	b	.LBB10_21
.LBB10_20:                              //   in Loop: Header=BB10_21 Depth=2
	eor	z1.d, z1.d, z18.d
	eor	z0.d, z0.d, z19.d
	add	x20, x20, #32
	eor	z2.d, z2.d, z20.d
	eor	z3.d, z3.d, z21.d
	subs	x1, x1, #1
	eor	z4.d, z4.d, z22.d
	eor	z5.d, z5.d, z23.d
	add	w19, w19, #32
	eor	z6.d, z6.d, z16.d
	eor	z7.d, z7.d, z17.d
	add	x7, x7, #32
	add	x6, x6, #32
	b.eq	.LBB10_18
.LBB10_21:                              //   Parent Loop BB10_19 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x21, [x5], #8
	cmp	w9, #1
	add	x22, x21, x16
	ld1b	{ z16.b }, p1/z, [x21, x16]
	ld1b	{ z17.b }, p2/z, [x22, x15]
	mov	z18.d, z16.d
	mov	z19.d, z17.d
	b.ne	.LBB10_25
// %bb.22:                              //   in Loop: Header=BB10_21 Depth=2
	mov	z20.d, z16.d
	mov	z21.d, z17.d
	cmp	w11, #1
	b.ne	.LBB10_26
.LBB10_23:                              //   in Loop: Header=BB10_21 Depth=2
	mov	z22.d, z16.d
	mov	z23.d, z17.d
	cmp	w12, #1
	b.ne	.LBB10_27
.LBB10_24:                              //   in Loop: Header=BB10_21 Depth=2
	cmp	w13, #1
	b.eq	.LBB10_20
	b	.LBB10_28
.LBB10_25:                              //   in Loop: Header=BB10_21 Depth=2
	ld1b	{ z18.b }, p0/z, [x7]
	ld1b	{ z19.b }, p0/z, [x7, x18]
	fmov	w21, s18
	fmov	w22, s19
	eor	w21, w21, w22
	mov	z18.b, w21
	mov	z19.d, z18.d
	mov	z20.d, z16.d
	mov	z21.d, z17.d
	cmp	w11, #1
	b.eq	.LBB10_23
.LBB10_26:                              //   in Loop: Header=BB10_21 Depth=2
	mov	w21, w19
	add	x22, x2, x21
	ld1b	{ z20.b }, p0/z, [x2, x21]
	ld1b	{ z21.b }, p0/z, [x22, x18]
	fmov	w21, s20
	fmov	w22, s21
	eor	w21, w21, w22
	mov	z20.b, w21
	mov	z21.d, z20.d
	mov	z22.d, z16.d
	mov	z23.d, z17.d
	cmp	w12, #1
	b.eq	.LBB10_24
.LBB10_27:                              //   in Loop: Header=BB10_21 Depth=2
	and	x21, x20, #0xffffffe0
	add	x22, x2, x21
	ld1b	{ z22.b }, p0/z, [x2, x21]
	ld1b	{ z23.b }, p0/z, [x22, x18]
	fmov	w21, s22
	fmov	w22, s23
	eor	w21, w21, w22
	mov	z22.b, w21
	mov	z23.d, z22.d
	cmp	w13, #1
	b.eq	.LBB10_20
.LBB10_28:                              //   in Loop: Header=BB10_21 Depth=2
	and	x21, x6, #0xffffffe0
	add	x22, x2, x21
	ld1b	{ z16.b }, p0/z, [x2, x21]
	ld1b	{ z17.b }, p0/z, [x22, x18]
	fmov	w21, s16
	fmov	w22, s17
	eor	w21, w21, w22
	mov	z16.b, w21
	mov	z17.d, z16.d
	b	.LBB10_20
.LBB10_29:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w15
	mov	w10, w0
.LBB10_30:                              // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ldr	x11, [x4, #24]
	add	x12, x9, x8
	whilelt	p0.b, w12, w0
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p1, [x11, x8]
	incb	x8, all, mul #2
	ldr	x11, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p0, [x12, x11]
	b.lo	.LBB10_30
.LBB10_31:
	ldp	x20, x19, [sp, #16]             // 16-byte Folded Reload
	ldp	x22, x21, [sp], #32             // 16-byte Folded Reload
.LBB10_32:
	ret
.LBB10_33:
	add	x17, x8, x8, lsl #1
	mov	x16, xzr
	mov	w18, #16                        // =0x10
	lsl	x17, x17, #5
	b	.LBB10_35
.LBB10_34:                              //   in Loop: Header=BB10_35 Depth=1
	ldr	x1, [x4, #24]
	st1b	{ z6.b }, p1, [x1, x16]
	ldr	x1, [x4, #24]
	add	x1, x1, x16
	st1b	{ z7.b }, p2, [x1, x15]
	ldr	x1, [x4, #16]
	st1b	{ z4.b }, p1, [x1, x16]
	ldr	x1, [x4, #16]
	add	x1, x1, x16
	st1b	{ z5.b }, p2, [x1, x15]
	ldr	x1, [x4, #8]
	st1b	{ z2.b }, p1, [x1, x16]
	ldr	x1, [x4, #8]
	add	x1, x1, x16
	st1b	{ z3.b }, p2, [x1, x15]
	ldr	x1, [x4]
	st1b	{ z1.b }, p1, [x1, x16]
	ldr	x1, [x4]
	add	x1, x1, x16
	incb	x16, all, mul #2
	st1b	{ z0.b }, p2, [x1, x15]
	cmp	w0, w16
	b.le	.LBB10_31
.LBB10_35:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB10_37 Depth 2
	mov	w1, w16
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	incb	x1
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	mov	x5, x3
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x6, x17
	whilelt	p1.b, w16, w0
	mov	x7, x2
	mov	w19, w10
	whilelt	p2.b, w1, w0
	mov	x1, x8
	mov	x20, x14
	b	.LBB10_37
.LBB10_36:                              //   in Loop: Header=BB10_37 Depth=2
	eor	z1.d, z1.d, z22.d
	eor	z0.d, z0.d, z23.d
	add	x20, x20, #32
	eor	z2.d, z2.d, z24.d
	eor	z3.d, z3.d, z25.d
	subs	x1, x1, #1
	eor	z4.d, z4.d, z26.d
	eor	z5.d, z5.d, z27.d
	add	w19, w19, #32
	eor	z6.d, z6.d, z16.d
	eor	z7.d, z7.d, z17.d
	add	x7, x7, #32
	add	x6, x6, #32
	b.eq	.LBB10_34
.LBB10_37:                              //   Parent Loop BB10_35 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x21, [x5], #8
	cmp	w9, #1
	add	x22, x21, x16
	ld1b	{ z16.b }, p1/z, [x21, x16]
	ld1b	{ z17.b }, p2/z, [x22, x15]
	lsr	z21.b, z16.b, #4
	mov	z22.d, z16.d
	movprfx	z20, z16
	and	z20.b, z20.b, #0xf
	lsr	z19.b, z17.b, #4
	mov	z23.d, z17.d
	movprfx	z18, z17
	and	z18.b, z18.b, #0xf
	b.ne	.LBB10_41
// %bb.38:                              //   in Loop: Header=BB10_37 Depth=2
	mov	z24.d, z16.d
	mov	z25.d, z17.d
	cmp	w11, #1
	b.ne	.LBB10_42
.LBB10_39:                              //   in Loop: Header=BB10_37 Depth=2
	mov	z26.d, z16.d
	mov	z27.d, z17.d
	cmp	w12, #1
	b.ne	.LBB10_43
.LBB10_40:                              //   in Loop: Header=BB10_37 Depth=2
	cmp	w13, #1
	b.eq	.LBB10_36
	b	.LBB10_44
.LBB10_41:                              //   in Loop: Header=BB10_37 Depth=2
	ld1b	{ z22.b }, p0/z, [x7]
	ld1b	{ z23.b }, p0/z, [x7, x18]
	tbl	z24.b, { z22.b }, z20.b
	tbl	z25.b, { z23.b }, z21.b
	tbl	z26.b, { z22.b }, z18.b
	tbl	z23.b, { z23.b }, z19.b
	eor	z22.d, z24.d, z25.d
	eor	z23.d, z26.d, z23.d
	mov	z24.d, z16.d
	mov	z25.d, z17.d
	cmp	w11, #1
	b.eq	.LBB10_39
.LBB10_42:                              //   in Loop: Header=BB10_37 Depth=2
	mov	w21, w19
	add	x22, x2, x21
	ld1b	{ z24.b }, p0/z, [x2, x21]
	ld1b	{ z25.b }, p0/z, [x22, x18]
	tbl	z26.b, { z24.b }, z20.b
	tbl	z28.b, { z24.b }, z18.b
	tbl	z27.b, { z25.b }, z21.b
	tbl	z25.b, { z25.b }, z19.b
	eor	z24.d, z26.d, z27.d
	eor	z25.d, z28.d, z25.d
	mov	z26.d, z16.d
	mov	z27.d, z17.d
	cmp	w12, #1
	b.eq	.LBB10_40
.LBB10_43:                              //   in Loop: Header=BB10_37 Depth=2
	and	x21, x20, #0xffffffe0
	add	x22, x2, x21
	ld1b	{ z26.b }, p0/z, [x2, x21]
	ld1b	{ z27.b }, p0/z, [x22, x18]
	tbl	z28.b, { z26.b }, z20.b
	tbl	z30.b, { z26.b }, z18.b
	tbl	z29.b, { z27.b }, z21.b
	tbl	z27.b, { z27.b }, z19.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	cmp	w13, #1
	b.eq	.LBB10_36
.LBB10_44:                              //   in Loop: Header=BB10_37 Depth=2
	and	x21, x6, #0xffffffe0
	add	x22, x2, x21
	ld1b	{ z16.b }, p0/z, [x2, x21]
	ld1b	{ z17.b }, p0/z, [x22, x18]
	tbl	z20.b, { z16.b }, z20.b
	tbl	z18.b, { z16.b }, z18.b
	tbl	z21.b, { z17.b }, z21.b
	tbl	z17.b, { z17.b }, z19.b
	eor	z16.d, z20.d, z21.d
	eor	z17.d, z18.d, z17.d
	b	.LBB10_36
.Lfunc_end10:
	.size	gf_4vect_dot_prod_sve2, .Lfunc_end10-gf_4vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_5vect_dot_prod_sve2          // -- Begin function gf_5vect_dot_prod_sve2
	.p2align	2
	.type	gf_5vect_dot_prod_sve2,@function
gf_5vect_dot_prod_sve2:                 // @gf_5vect_dot_prod_sve2
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB11_44
// %bb.1:
	str	d10, [sp, #-96]!                // 8-byte Folded Spill
	cmp	w1, #1
	rdvl	x5, #1
	stp	d9, d8, [sp, #16]               // 16-byte Folded Spill
	stp	x26, x25, [sp, #32]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #48]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #64]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #80]             // 16-byte Folded Spill
	b.lt	.LBB11_41
// %bb.2:
	mov	w8, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x9, x8, #5
	sub	x11, x9, #32
.LBB11_3:                               // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB11_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x15, x8, #1
	sub	x13, x8, #1
	mov	w12, w10
.LBB11_5:                               // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB11_7
// %bb.6:                               //   in Loop: Header=BB11_5 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB11_5
.LBB11_7:
	lsl	w13, w1, #6
	sub	x14, x8, #1
.LBB11_8:                               // =>This Inner Loop Header: Depth=1
	add	x12, x2, w13, sxtw
	subs	x14, x14, #1
	cset	w16, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB11_10
// %bb.9:                               //   in Loop: Header=BB11_8 Depth=1
	add	w13, w13, #32
	tbnz	w16, #0, .LBB11_8
.LBB11_10:
	add	w13, w1, w1, lsl #1
	sub	x16, x8, #1
	lsl	w14, w13, #5
.LBB11_11:                              // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x16, x16, #1
	cset	w17, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB11_13
// %bb.12:                              //   in Loop: Header=BB11_11 Depth=1
	add	w14, w14, #32
	tbnz	w17, #0, .LBB11_11
.LBB11_13:
	lsl	w16, w1, #7
.LBB11_14:                              // =>This Inner Loop Header: Depth=1
	add	x14, x2, w16, sxtw
	subs	x15, x15, #1
	cset	w17, hs
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	b.ne	.LBB11_16
// %bb.15:                              //   in Loop: Header=BB11_14 Depth=1
	add	w16, w16, #32
	tbnz	w17, #0, .LBB11_14
.LBB11_16:
	cmp	w11, #1
	add	x18, x8, x8, lsl #1
	lsl	x16, x8, #6
	ccmp	w9, #1, #0, eq
	lsl	x17, x8, #7
	mov	x15, xzr
	ccmp	w12, #1, #0, eq
	lsl	x18, x18, #5
	mov	w5, w5
	ccmp	w13, #1, #0, eq
	mov	w6, #16                         // =0x10
	ccmp	w14, #1, #0, eq
	cset	w1, eq
	b	.LBB11_18
.LBB11_17:                              //   in Loop: Header=BB11_18 Depth=1
	ldr	x7, [x4, #32]
	st1b	{ z16.b }, p2, [x7, x15]
	ldr	x7, [x4, #32]
	add	x7, x7, x15
	st1b	{ z17.b }, p1, [x7, x5]
	ldr	x7, [x4, #24]
	st1b	{ z6.b }, p2, [x7, x15]
	ldr	x7, [x4, #24]
	add	x7, x7, x15
	st1b	{ z7.b }, p1, [x7, x5]
	ldr	x7, [x4, #16]
	st1b	{ z4.b }, p2, [x7, x15]
	ldr	x7, [x4, #16]
	add	x7, x7, x15
	st1b	{ z5.b }, p1, [x7, x5]
	ldr	x7, [x4, #8]
	st1b	{ z2.b }, p2, [x7, x15]
	ldr	x7, [x4, #8]
	add	x7, x7, x15
	st1b	{ z3.b }, p1, [x7, x5]
	ldr	x7, [x4]
	st1b	{ z0.b }, p2, [x7, x15]
	ldr	x7, [x4]
	add	x7, x7, x15
	incb	x15, all, mul #2
	st1b	{ z1.b }, p1, [x7, x5]
	cmp	w0, w15
	b.le	.LBB11_43
.LBB11_18:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB11_31 Depth 2
                                        //     Child Loop BB11_20 Depth 2
	mov	w7, w15
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	incb	x7
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x19, x3
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	x20, x18
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	x21, x2
	whilelt	p2.b, w15, w0
	mov	w22, w10
	mov	x23, x16
	whilelt	p1.b, w7, w0
	mov	x7, x8
	mov	x24, x17
	tbnz	w1, #0, .LBB11_20
	b	.LBB11_31
.LBB11_19:                              //   in Loop: Header=BB11_20 Depth=2
	eor	z0.d, z0.d, z20.d
	eor	z1.d, z1.d, z21.d
	add	x24, x24, #32
	eor	z2.d, z2.d, z22.d
	eor	z3.d, z3.d, z23.d
	add	x23, x23, #32
	eor	z4.d, z4.d, z24.d
	eor	z5.d, z5.d, z25.d
	subs	x7, x7, #1
	eor	z6.d, z6.d, z26.d
	eor	z7.d, z7.d, z27.d
	add	w22, w22, #32
	eor	z16.d, z16.d, z18.d
	eor	z17.d, z17.d, z19.d
	add	x21, x21, #32
	add	x20, x20, #32
	b.eq	.LBB11_17
.LBB11_20:                              //   Parent Loop BB11_18 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x25, [x19], #8
	cmp	w9, #1
	add	x26, x25, x15
	ld1b	{ z18.b }, p2/z, [x25, x15]
	ld1b	{ z19.b }, p1/z, [x26, x5]
	mov	z20.d, z18.d
	mov	z21.d, z19.d
	b.ne	.LBB11_25
// %bb.21:                              //   in Loop: Header=BB11_20 Depth=2
	mov	z22.d, z18.d
	mov	z23.d, z19.d
	cmp	w11, #1
	b.ne	.LBB11_26
.LBB11_22:                              //   in Loop: Header=BB11_20 Depth=2
	mov	z24.d, z18.d
	mov	z25.d, z19.d
	cmp	w12, #1
	b.ne	.LBB11_27
.LBB11_23:                              //   in Loop: Header=BB11_20 Depth=2
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w13, #1
	b.ne	.LBB11_28
.LBB11_24:                              //   in Loop: Header=BB11_20 Depth=2
	cmp	w14, #1
	b.eq	.LBB11_19
	b	.LBB11_29
.LBB11_25:                              //   in Loop: Header=BB11_20 Depth=2
	ld1b	{ z20.b }, p0/z, [x21]
	ld1b	{ z21.b }, p0/z, [x21, x6]
	fmov	w25, s20
	fmov	w26, s21
	eor	w25, w25, w26
	mov	z20.b, w25
	mov	z21.d, z20.d
	mov	z22.d, z18.d
	mov	z23.d, z19.d
	cmp	w11, #1
	b.eq	.LBB11_22
.LBB11_26:                              //   in Loop: Header=BB11_20 Depth=2
	mov	w25, w22
	add	x26, x2, x25
	ld1b	{ z22.b }, p0/z, [x2, x25]
	ld1b	{ z23.b }, p0/z, [x26, x6]
	fmov	w25, s22
	fmov	w26, s23
	eor	w25, w25, w26
	mov	z22.b, w25
	mov	z23.d, z22.d
	mov	z24.d, z18.d
	mov	z25.d, z19.d
	cmp	w12, #1
	b.eq	.LBB11_23
.LBB11_27:                              //   in Loop: Header=BB11_20 Depth=2
	and	x25, x23, #0xffffffe0
	add	x26, x2, x25
	ld1b	{ z24.b }, p0/z, [x2, x25]
	ld1b	{ z25.b }, p0/z, [x26, x6]
	fmov	w25, s24
	fmov	w26, s25
	eor	w25, w25, w26
	mov	z24.b, w25
	mov	z25.d, z24.d
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w13, #1
	b.eq	.LBB11_24
.LBB11_28:                              //   in Loop: Header=BB11_20 Depth=2
	and	x25, x20, #0xffffffe0
	add	x26, x2, x25
	ld1b	{ z26.b }, p0/z, [x2, x25]
	ld1b	{ z27.b }, p0/z, [x26, x6]
	fmov	w25, s26
	fmov	w26, s27
	eor	w25, w25, w26
	mov	z26.b, w25
	mov	z27.d, z26.d
	cmp	w14, #1
	b.eq	.LBB11_19
.LBB11_29:                              //   in Loop: Header=BB11_20 Depth=2
	and	x25, x24, #0xffffffe0
	add	x26, x2, x25
	ld1b	{ z18.b }, p0/z, [x2, x25]
	ld1b	{ z19.b }, p0/z, [x26, x6]
	fmov	w25, s18
	fmov	w26, s19
	eor	w25, w25, w26
	mov	z18.b, w25
	mov	z19.d, z18.d
	b	.LBB11_19
.LBB11_30:                              //   in Loop: Header=BB11_31 Depth=2
	eor	z0.d, z0.d, z24.d
	eor	z1.d, z1.d, z25.d
	add	x24, x24, #32
	eor	z2.d, z2.d, z26.d
	eor	z3.d, z3.d, z27.d
	add	x23, x23, #32
	eor	z4.d, z4.d, z28.d
	eor	z5.d, z5.d, z29.d
	subs	x7, x7, #1
	eor	z6.d, z6.d, z30.d
	eor	z7.d, z7.d, z31.d
	add	w22, w22, #32
	eor	z16.d, z16.d, z18.d
	eor	z17.d, z17.d, z19.d
	add	x21, x21, #32
	add	x20, x20, #32
	b.eq	.LBB11_17
.LBB11_31:                              //   Parent Loop BB11_18 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x25, [x19], #8
	cmp	w9, #1
	add	x26, x25, x15
	ld1b	{ z18.b }, p2/z, [x25, x15]
	ld1b	{ z19.b }, p1/z, [x26, x5]
	lsr	z23.b, z18.b, #4
	mov	z24.d, z18.d
	movprfx	z22, z18
	and	z22.b, z22.b, #0xf
	lsr	z21.b, z19.b, #4
	mov	z25.d, z19.d
	movprfx	z20, z19
	and	z20.b, z20.b, #0xf
	b.ne	.LBB11_36
// %bb.32:                              //   in Loop: Header=BB11_31 Depth=2
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w11, #1
	b.ne	.LBB11_37
.LBB11_33:                              //   in Loop: Header=BB11_31 Depth=2
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	cmp	w12, #1
	b.ne	.LBB11_38
.LBB11_34:                              //   in Loop: Header=BB11_31 Depth=2
	mov	z30.d, z18.d
	mov	z31.d, z19.d
	cmp	w13, #1
	b.ne	.LBB11_39
.LBB11_35:                              //   in Loop: Header=BB11_31 Depth=2
	cmp	w14, #1
	b.eq	.LBB11_30
	b	.LBB11_40
.LBB11_36:                              //   in Loop: Header=BB11_31 Depth=2
	ld1b	{ z24.b }, p0/z, [x21]
	ld1b	{ z25.b }, p0/z, [x21, x6]
	tbl	z26.b, { z24.b }, z22.b
	tbl	z27.b, { z25.b }, z23.b
	tbl	z28.b, { z24.b }, z20.b
	tbl	z25.b, { z25.b }, z21.b
	eor	z24.d, z26.d, z27.d
	eor	z25.d, z28.d, z25.d
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w11, #1
	b.eq	.LBB11_33
.LBB11_37:                              //   in Loop: Header=BB11_31 Depth=2
	mov	w25, w22
	add	x26, x2, x25
	ld1b	{ z26.b }, p0/z, [x2, x25]
	ld1b	{ z27.b }, p0/z, [x26, x6]
	tbl	z28.b, { z26.b }, z22.b
	tbl	z30.b, { z26.b }, z20.b
	tbl	z29.b, { z27.b }, z23.b
	tbl	z27.b, { z27.b }, z21.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	cmp	w12, #1
	b.eq	.LBB11_34
.LBB11_38:                              //   in Loop: Header=BB11_31 Depth=2
	and	x25, x23, #0xffffffe0
	add	x26, x2, x25
	ld1b	{ z28.b }, p0/z, [x2, x25]
	ld1b	{ z29.b }, p0/z, [x26, x6]
	tbl	z30.b, { z28.b }, z22.b
	tbl	z8.b, { z28.b }, z20.b
	tbl	z31.b, { z29.b }, z23.b
	tbl	z29.b, { z29.b }, z21.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
	mov	z30.d, z18.d
	mov	z31.d, z19.d
	cmp	w13, #1
	b.eq	.LBB11_35
.LBB11_39:                              //   in Loop: Header=BB11_31 Depth=2
	and	x25, x20, #0xffffffe0
	add	x26, x2, x25
	ld1b	{ z30.b }, p0/z, [x2, x25]
	ld1b	{ z31.b }, p0/z, [x26, x6]
	tbl	z8.b, { z30.b }, z22.b
	tbl	z10.b, { z30.b }, z20.b
	tbl	z9.b, { z31.b }, z23.b
	tbl	z31.b, { z31.b }, z21.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	cmp	w14, #1
	b.eq	.LBB11_30
.LBB11_40:                              //   in Loop: Header=BB11_31 Depth=2
	and	x25, x24, #0xffffffe0
	add	x26, x2, x25
	ld1b	{ z18.b }, p0/z, [x2, x25]
	ld1b	{ z19.b }, p0/z, [x26, x6]
	tbl	z22.b, { z18.b }, z22.b
	tbl	z20.b, { z18.b }, z20.b
	tbl	z23.b, { z19.b }, z23.b
	tbl	z19.b, { z19.b }, z21.b
	eor	z18.d, z22.d, z23.d
	eor	z19.d, z20.d, z19.d
	b	.LBB11_30
.LBB11_41:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w5
	mov	w10, w0
.LBB11_42:                              // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ldr	x11, [x4, #32]
	add	x12, x9, x8
	whilelt	p0.b, w12, w0
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p1, [x11, x8]
	incb	x8, all, mul #2
	ldr	x11, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p0, [x12, x11]
	b.lo	.LBB11_42
.LBB11_43:
	ldp	x20, x19, [sp, #80]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #64]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               // 16-byte Folded Reload
	ldr	d10, [sp], #96                  // 8-byte Folded Reload
.LBB11_44:
	ret
.Lfunc_end11:
	.size	gf_5vect_dot_prod_sve2, .Lfunc_end11-gf_5vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_6vect_dot_prod_sve2          // -- Begin function gf_6vect_dot_prod_sve2
	.p2align	2
	.type	gf_6vect_dot_prod_sve2,@function
gf_6vect_dot_prod_sve2:                 // @gf_6vect_dot_prod_sve2
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB12_51
// %bb.1:
	str	d14, [sp, #-144]!               // 8-byte Folded Spill
	cmp	w1, #1
	rdvl	x7, #1
	stp	d13, d12, [sp, #8]              // 16-byte Folded Spill
	stp	d11, d10, [sp, #24]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #40]               // 16-byte Folded Spill
	str	x29, [sp, #56]                  // 8-byte Spill
	stp	x28, x27, [sp, #64]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #80]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #96]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #112]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #128]            // 16-byte Folded Spill
	b.lt	.LBB12_48
// %bb.2:
	mov	w8, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x9, x8, #5
	sub	x11, x9, #32
.LBB12_3:                               // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB12_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x16, x8, #1
	sub	x13, x8, #1
	mov	w12, w10
.LBB12_5:                               // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB12_7
// %bb.6:                               //   in Loop: Header=BB12_5 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB12_5
.LBB12_7:
	lsl	w13, w1, #6
	sub	x14, x8, #1
.LBB12_8:                               // =>This Inner Loop Header: Depth=1
	add	x12, x2, w13, sxtw
	subs	x14, x14, #1
	cset	w15, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB12_10
// %bb.9:                               //   in Loop: Header=BB12_8 Depth=1
	add	w13, w13, #32
	tbnz	w15, #0, .LBB12_8
.LBB12_10:
	add	w13, w1, w1, lsl #1
	sub	x15, x8, #1
	lsl	w14, w13, #5
.LBB12_11:                              // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w17, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB12_13
// %bb.12:                              //   in Loop: Header=BB12_11 Depth=1
	add	w14, w14, #32
	tbnz	w17, #0, .LBB12_11
.LBB12_13:
	lsl	w15, w1, #7
	sub	x17, x8, #1
.LBB12_14:                              // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	subs	x17, x17, #1
	cset	w18, hs
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	b.ne	.LBB12_16
// %bb.15:                              //   in Loop: Header=BB12_14 Depth=1
	add	w15, w15, #32
	tbnz	w18, #0, .LBB12_14
.LBB12_16:
	add	w15, w1, w1, lsl #2
	lsl	w17, w15, #5
.LBB12_17:                              // =>This Inner Loop Header: Depth=1
	add	x15, x2, w17, sxtw
	subs	x16, x16, #1
	cset	w18, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB12_19
// %bb.18:                              //   in Loop: Header=BB12_17 Depth=1
	add	w17, w17, #32
	tbnz	w18, #0, .LBB12_17
.LBB12_19:
	cmp	w11, #1
	add	x1, x8, x8, lsl #1
	add	x5, x8, x8, lsl #2
	ccmp	w9, #1, #0, eq
	lsl	x17, x8, #6
	lsl	x18, x8, #7
	ccmp	w12, #1, #0, eq
	lsl	x1, x1, #5
	lsl	x5, x5, #5
	ccmp	w13, #1, #0, eq
	mov	x16, xzr
	mov	w7, w7
	ccmp	w14, #1, #0, eq
	mov	w19, #16                        // =0x10
	ccmp	w15, #1, #0, eq
	cset	w6, eq
	b	.LBB12_21
.LBB12_20:                              //   in Loop: Header=BB12_21 Depth=1
	ldr	x20, [x4, #40]
	st1b	{ z17.b }, p2, [x20, x16]
	ldr	x20, [x4, #40]
	add	x20, x20, x16
	st1b	{ z19.b }, p1, [x20, x7]
	ldr	x20, [x4, #32]
	st1b	{ z7.b }, p2, [x20, x16]
	ldr	x20, [x4, #32]
	add	x20, x20, x16
	st1b	{ z18.b }, p1, [x20, x7]
	ldr	x20, [x4, #24]
	st1b	{ z5.b }, p2, [x20, x16]
	ldr	x20, [x4, #24]
	add	x20, x20, x16
	st1b	{ z16.b }, p1, [x20, x7]
	ldr	x20, [x4, #16]
	st1b	{ z3.b }, p2, [x20, x16]
	ldr	x20, [x4, #16]
	add	x20, x20, x16
	st1b	{ z6.b }, p1, [x20, x7]
	ldr	x20, [x4, #8]
	st1b	{ z2.b }, p2, [x20, x16]
	ldr	x20, [x4, #8]
	add	x20, x20, x16
	st1b	{ z4.b }, p1, [x20, x7]
	ldr	x20, [x4]
	st1b	{ z0.b }, p2, [x20, x16]
	ldr	x20, [x4]
	add	x20, x20, x16
	incb	x16, all, mul #2
	st1b	{ z1.b }, p1, [x20, x7]
	cmp	w0, w16
	b.le	.LBB12_50
.LBB12_21:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB12_36 Depth 2
                                        //     Child Loop BB12_23 Depth 2
	mov	w20, w16
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	incb	x20
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	x21, x3
	movi	v1.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	x22, x5
	movi	v6.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	mov	x23, x1
	movi	v18.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	x24, x2
	whilelt	p2.b, w16, w0
	mov	w25, w10
	mov	x26, x17
	whilelt	p1.b, w20, w0
	mov	x20, x8
	mov	x27, x18
	tbnz	w6, #0, .LBB12_23
	b	.LBB12_36
.LBB12_22:                              //   in Loop: Header=BB12_23 Depth=2
	eor	z0.d, z0.d, z22.d
	eor	z1.d, z1.d, z23.d
	add	x27, x27, #32
	eor	z2.d, z2.d, z24.d
	eor	z4.d, z4.d, z25.d
	add	x26, x26, #32
	eor	z3.d, z3.d, z26.d
	eor	z6.d, z6.d, z27.d
	add	w25, w25, #32
	eor	z5.d, z5.d, z28.d
	eor	z16.d, z16.d, z29.d
	subs	x20, x20, #1
	eor	z7.d, z7.d, z30.d
	eor	z18.d, z18.d, z31.d
	add	x24, x24, #32
	eor	z17.d, z17.d, z20.d
	eor	z19.d, z19.d, z21.d
	add	x23, x23, #32
	add	x22, x22, #32
	b.eq	.LBB12_20
.LBB12_23:                              //   Parent Loop BB12_21 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x28, [x21], #8
	cmp	w9, #1
	add	x29, x28, x16
	ld1b	{ z20.b }, p2/z, [x28, x16]
	ld1b	{ z21.b }, p1/z, [x29, x7]
	mov	z22.d, z20.d
	mov	z23.d, z21.d
	b.ne	.LBB12_29
// %bb.24:                              //   in Loop: Header=BB12_23 Depth=2
	mov	z24.d, z20.d
	mov	z25.d, z21.d
	cmp	w11, #1
	b.ne	.LBB12_30
.LBB12_25:                              //   in Loop: Header=BB12_23 Depth=2
	mov	z26.d, z20.d
	mov	z27.d, z21.d
	cmp	w12, #1
	b.ne	.LBB12_31
.LBB12_26:                              //   in Loop: Header=BB12_23 Depth=2
	mov	z28.d, z20.d
	mov	z29.d, z21.d
	cmp	w13, #1
	b.ne	.LBB12_32
.LBB12_27:                              //   in Loop: Header=BB12_23 Depth=2
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w14, #1
	b.ne	.LBB12_33
.LBB12_28:                              //   in Loop: Header=BB12_23 Depth=2
	cmp	w15, #1
	b.eq	.LBB12_22
	b	.LBB12_34
.LBB12_29:                              //   in Loop: Header=BB12_23 Depth=2
	ld1b	{ z22.b }, p0/z, [x24]
	ld1b	{ z23.b }, p0/z, [x24, x19]
	fmov	w28, s22
	fmov	w29, s23
	eor	w28, w28, w29
	mov	z22.b, w28
	mov	z23.d, z22.d
	mov	z24.d, z20.d
	mov	z25.d, z21.d
	cmp	w11, #1
	b.eq	.LBB12_25
.LBB12_30:                              //   in Loop: Header=BB12_23 Depth=2
	mov	w28, w25
	add	x29, x2, x28
	ld1b	{ z24.b }, p0/z, [x2, x28]
	ld1b	{ z25.b }, p0/z, [x29, x19]
	fmov	w28, s24
	fmov	w29, s25
	eor	w28, w28, w29
	mov	z24.b, w28
	mov	z25.d, z24.d
	mov	z26.d, z20.d
	mov	z27.d, z21.d
	cmp	w12, #1
	b.eq	.LBB12_26
.LBB12_31:                              //   in Loop: Header=BB12_23 Depth=2
	and	x28, x26, #0xffffffe0
	add	x29, x2, x28
	ld1b	{ z26.b }, p0/z, [x2, x28]
	ld1b	{ z27.b }, p0/z, [x29, x19]
	fmov	w28, s26
	fmov	w29, s27
	eor	w28, w28, w29
	mov	z26.b, w28
	mov	z27.d, z26.d
	mov	z28.d, z20.d
	mov	z29.d, z21.d
	cmp	w13, #1
	b.eq	.LBB12_27
.LBB12_32:                              //   in Loop: Header=BB12_23 Depth=2
	and	x28, x23, #0xffffffe0
	add	x29, x2, x28
	ld1b	{ z28.b }, p0/z, [x2, x28]
	ld1b	{ z29.b }, p0/z, [x29, x19]
	fmov	w28, s28
	fmov	w29, s29
	eor	w28, w28, w29
	mov	z28.b, w28
	mov	z29.d, z28.d
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w14, #1
	b.eq	.LBB12_28
.LBB12_33:                              //   in Loop: Header=BB12_23 Depth=2
	and	x28, x27, #0xffffffe0
	add	x29, x2, x28
	ld1b	{ z30.b }, p0/z, [x2, x28]
	ld1b	{ z31.b }, p0/z, [x29, x19]
	fmov	w28, s30
	fmov	w29, s31
	eor	w28, w28, w29
	mov	z30.b, w28
	mov	z31.d, z30.d
	cmp	w15, #1
	b.eq	.LBB12_22
.LBB12_34:                              //   in Loop: Header=BB12_23 Depth=2
	and	x28, x22, #0xffffffe0
	add	x29, x2, x28
	ld1b	{ z20.b }, p0/z, [x2, x28]
	ld1b	{ z21.b }, p0/z, [x29, x19]
	fmov	w28, s20
	fmov	w29, s21
	eor	w28, w28, w29
	mov	z20.b, w28
	mov	z21.d, z20.d
	b	.LBB12_22
.LBB12_35:                              //   in Loop: Header=BB12_36 Depth=2
	eor	z0.d, z0.d, z26.d
	eor	z1.d, z1.d, z27.d
	add	x27, x27, #32
	eor	z2.d, z2.d, z28.d
	eor	z4.d, z4.d, z29.d
	add	x26, x26, #32
	eor	z3.d, z3.d, z30.d
	eor	z6.d, z6.d, z31.d
	add	w25, w25, #32
	eor	z5.d, z5.d, z8.d
	eor	z16.d, z16.d, z9.d
	subs	x20, x20, #1
	eor	z7.d, z7.d, z10.d
	eor	z18.d, z18.d, z11.d
	add	x24, x24, #32
	eor	z17.d, z17.d, z20.d
	eor	z19.d, z19.d, z21.d
	add	x23, x23, #32
	add	x22, x22, #32
	b.eq	.LBB12_20
.LBB12_36:                              //   Parent Loop BB12_21 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x28, [x21], #8
	cmp	w9, #1
	add	x29, x28, x16
	ld1b	{ z20.b }, p2/z, [x28, x16]
	ld1b	{ z21.b }, p1/z, [x29, x7]
	lsr	z25.b, z20.b, #4
	mov	z26.d, z20.d
	movprfx	z24, z20
	and	z24.b, z24.b, #0xf
	lsr	z23.b, z21.b, #4
	mov	z27.d, z21.d
	movprfx	z22, z21
	and	z22.b, z22.b, #0xf
	b.ne	.LBB12_42
// %bb.37:                              //   in Loop: Header=BB12_36 Depth=2
	mov	z28.d, z20.d
	mov	z29.d, z21.d
	cmp	w11, #1
	b.ne	.LBB12_43
.LBB12_38:                              //   in Loop: Header=BB12_36 Depth=2
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w12, #1
	b.ne	.LBB12_44
.LBB12_39:                              //   in Loop: Header=BB12_36 Depth=2
	mov	z8.d, z20.d
	mov	z9.d, z21.d
	cmp	w13, #1
	b.ne	.LBB12_45
.LBB12_40:                              //   in Loop: Header=BB12_36 Depth=2
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	cmp	w14, #1
	b.ne	.LBB12_46
.LBB12_41:                              //   in Loop: Header=BB12_36 Depth=2
	cmp	w15, #1
	b.eq	.LBB12_35
	b	.LBB12_47
.LBB12_42:                              //   in Loop: Header=BB12_36 Depth=2
	ld1b	{ z26.b }, p0/z, [x24]
	ld1b	{ z27.b }, p0/z, [x24, x19]
	tbl	z28.b, { z26.b }, z24.b
	tbl	z29.b, { z27.b }, z25.b
	tbl	z30.b, { z26.b }, z22.b
	tbl	z27.b, { z27.b }, z23.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	mov	z28.d, z20.d
	mov	z29.d, z21.d
	cmp	w11, #1
	b.eq	.LBB12_38
.LBB12_43:                              //   in Loop: Header=BB12_36 Depth=2
	mov	w28, w25
	add	x29, x2, x28
	ld1b	{ z28.b }, p0/z, [x2, x28]
	ld1b	{ z29.b }, p0/z, [x29, x19]
	tbl	z30.b, { z28.b }, z24.b
	tbl	z8.b, { z28.b }, z22.b
	tbl	z31.b, { z29.b }, z25.b
	tbl	z29.b, { z29.b }, z23.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w12, #1
	b.eq	.LBB12_39
.LBB12_44:                              //   in Loop: Header=BB12_36 Depth=2
	and	x28, x26, #0xffffffe0
	add	x29, x2, x28
	ld1b	{ z30.b }, p0/z, [x2, x28]
	ld1b	{ z31.b }, p0/z, [x29, x19]
	tbl	z8.b, { z30.b }, z24.b
	tbl	z10.b, { z30.b }, z22.b
	tbl	z9.b, { z31.b }, z25.b
	tbl	z31.b, { z31.b }, z23.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	mov	z8.d, z20.d
	mov	z9.d, z21.d
	cmp	w13, #1
	b.eq	.LBB12_40
.LBB12_45:                              //   in Loop: Header=BB12_36 Depth=2
	and	x28, x23, #0xffffffe0
	add	x29, x2, x28
	ld1b	{ z8.b }, p0/z, [x2, x28]
	ld1b	{ z9.b }, p0/z, [x29, x19]
	tbl	z10.b, { z8.b }, z24.b
	tbl	z12.b, { z8.b }, z22.b
	tbl	z11.b, { z9.b }, z25.b
	tbl	z9.b, { z9.b }, z23.b
	eor	z8.d, z10.d, z11.d
	eor	z9.d, z12.d, z9.d
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	cmp	w14, #1
	b.eq	.LBB12_41
.LBB12_46:                              //   in Loop: Header=BB12_36 Depth=2
	and	x28, x27, #0xffffffe0
	add	x29, x2, x28
	ld1b	{ z10.b }, p0/z, [x2, x28]
	ld1b	{ z11.b }, p0/z, [x29, x19]
	tbl	z12.b, { z10.b }, z24.b
	tbl	z14.b, { z10.b }, z22.b
	tbl	z13.b, { z11.b }, z25.b
	tbl	z11.b, { z11.b }, z23.b
	eor	z10.d, z12.d, z13.d
	eor	z11.d, z14.d, z11.d
	cmp	w15, #1
	b.eq	.LBB12_35
.LBB12_47:                              //   in Loop: Header=BB12_36 Depth=2
	and	x28, x22, #0xffffffe0
	add	x29, x2, x28
	ld1b	{ z20.b }, p0/z, [x2, x28]
	ld1b	{ z21.b }, p0/z, [x29, x19]
	tbl	z24.b, { z20.b }, z24.b
	tbl	z22.b, { z20.b }, z22.b
	tbl	z25.b, { z21.b }, z25.b
	tbl	z21.b, { z21.b }, z23.b
	eor	z20.d, z24.d, z25.d
	eor	z21.d, z22.d, z21.d
	b	.LBB12_35
.LBB12_48:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w7
	mov	w10, w0
.LBB12_49:                              // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ldr	x11, [x4, #40]
	add	x12, x9, x8
	whilelt	p0.b, w12, w0
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #40]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p1, [x11, x8]
	incb	x8, all, mul #2
	ldr	x11, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p0, [x12, x11]
	b.lo	.LBB12_49
.LBB12_50:
	ldp	x20, x19, [sp, #128]            // 16-byte Folded Reload
	ldr	x29, [sp, #56]                  // 8-byte Reload
	ldp	x22, x21, [sp, #112]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             // 16-byte Folded Reload
	ldp	x28, x27, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #40]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #24]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #8]              // 16-byte Folded Reload
	ldr	d14, [sp], #144                 // 8-byte Folded Reload
.LBB12_51:
	ret
.Lfunc_end12:
	.size	gf_6vect_dot_prod_sve2, .Lfunc_end12-gf_6vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_7vect_dot_prod_sve2          // -- Begin function gf_7vect_dot_prod_sve2
	.p2align	2
	.type	gf_7vect_dot_prod_sve2,@function
gf_7vect_dot_prod_sve2:                 // @gf_7vect_dot_prod_sve2
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB13_45
// %bb.1:
	stp	d15, d14, [sp, #-128]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x25, [sp, #64]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #80]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            // 16-byte Folded Spill
	addvl	sp, sp, #-2
	cmp	w1, #1
	rdvl	x20, #1
	b.lt	.LBB13_42
// %bb.2:
	mov	w5, w1
	ptrue	p0.b, vl16
	mov	x10, xzr
	lsl	x8, x5, #5
	sub	x11, x8, #32
.LBB13_3:                               // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x11, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB13_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x17, x5, #1
	sub	x13, x5, #1
	mov	w12, w10
.LBB13_5:                               // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB13_7
// %bb.6:                               //   in Loop: Header=BB13_5 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB13_5
.LBB13_7:
	lsl	w13, w1, #6
	sub	x14, x5, #1
.LBB13_8:                               // =>This Inner Loop Header: Depth=1
	add	x12, x2, w13, sxtw
	subs	x14, x14, #1
	cset	w15, hs
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	b.ne	.LBB13_10
// %bb.9:                               //   in Loop: Header=BB13_8 Depth=1
	add	w13, w13, #32
	tbnz	w15, #0, .LBB13_8
.LBB13_10:
	add	w16, w1, w1, lsl #1
	sub	x15, x5, #1
	lsl	w14, w16, #5
.LBB13_11:                              // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w18, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB13_13
// %bb.12:                              //   in Loop: Header=BB13_11 Depth=1
	add	w14, w14, #32
	tbnz	w18, #0, .LBB13_11
.LBB13_13:
	lsl	w15, w1, #7
	sub	x18, x5, #1
.LBB13_14:                              // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	subs	x18, x18, #1
	cset	w6, hs
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	b.ne	.LBB13_16
// %bb.15:                              //   in Loop: Header=BB13_14 Depth=1
	add	w15, w15, #32
	tbnz	w6, #0, .LBB13_14
.LBB13_16:
	add	w15, w1, w1, lsl #2
	sub	x1, x5, #1
	lsl	w18, w15, #5
.LBB13_17:                              // =>This Inner Loop Header: Depth=1
	add	x15, x2, w18, sxtw
	subs	x1, x1, #1
	cset	w6, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB13_19
// %bb.18:                              //   in Loop: Header=BB13_17 Depth=1
	add	w18, w18, #32
	tbnz	w6, #0, .LBB13_17
.LBB13_19:
	lsl	w18, w16, #6
.LBB13_20:                              // =>This Inner Loop Header: Depth=1
	add	x16, x2, w18, sxtw
	subs	x17, x17, #1
	cset	w1, hs
	ldrb	w16, [x16, #1]
	cmp	w16, #1
	b.ne	.LBB13_22
// %bb.21:                              //   in Loop: Header=BB13_20 Depth=1
	add	w18, w18, #32
	tbnz	w1, #0, .LBB13_20
.LBB13_22:
	cmp	w11, #1
	add	x7, x5, x5, lsl #1
	add	x6, x5, x5, lsl #2
	ccmp	w9, #1, #0, eq
	lsl	x18, x5, #6
	lsl	x1, x5, #7
	ccmp	w12, #1, #0, eq
	lsl	x5, x7, #5
	lsl	x6, x6, #5
	ccmp	w13, #1, #0, eq
	lsl	x7, x7, #6
	mov	x17, xzr
	ccmp	w14, #1, #0, eq
	mov	w20, w20
	mov	w21, #16                        // =0x10
	ccmp	w15, #1, #0, eq
	ccmp	w16, #1, #0, eq
	cset	w19, eq
	b	.LBB13_24
.LBB13_23:                              //   in Loop: Header=BB13_24 Depth=1
	ldr	x22, [x4, #48]
	st1b	{ z20.b }, p2, [x22, x17]
	ldr	x22, [x4, #48]
	add	x22, x22, x17
	st1b	{ z21.b }, p1, [x22, x20]
	ldr	x22, [x4, #40]
	st1b	{ z18.b }, p2, [x22, x17]
	ldr	x22, [x4, #40]
	add	x22, x22, x17
	st1b	{ z19.b }, p1, [x22, x20]
	ldr	x22, [x4, #32]
	st1b	{ z16.b }, p2, [x22, x17]
	ldr	x22, [x4, #32]
	add	x22, x22, x17
	st1b	{ z17.b }, p1, [x22, x20]
	ldr	x22, [x4, #24]
	st1b	{ z6.b }, p2, [x22, x17]
	ldr	x22, [x4, #24]
	add	x22, x22, x17
	st1b	{ z7.b }, p1, [x22, x20]
	ldr	x22, [x4, #16]
	st1b	{ z4.b }, p2, [x22, x17]
	ldr	x22, [x4, #16]
	add	x22, x22, x17
	st1b	{ z5.b }, p1, [x22, x20]
	ldr	x22, [x4, #8]
	st1b	{ z2.b }, p2, [x22, x17]
	ldr	x22, [x4, #8]
	add	x22, x22, x17
	st1b	{ z3.b }, p1, [x22, x20]
	ldr	x22, [x4]
	st1b	{ z1.b }, p2, [x22, x17]
	ldr	x22, [x4]
	add	x22, x22, x17
	incb	x17, all, mul #2
	st1b	{ z0.b }, p1, [x22, x20]
	cmp	w0, w17
	b.le	.LBB13_44
.LBB13_24:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB13_26 Depth 2
	mov	w23, w17
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	incb	x23
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	mov	x22, xzr
	movi	v20.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	whilelt	p2.b, w17, w0
	whilelt	p1.b, w23, w0
	mov	x23, x3
	b	.LBB13_26
.LBB13_25:                              //   in Loop: Header=BB13_26 Depth=2
	ldr	z24, [sp, #1, mul vl]           // 16-byte Folded Reload
	eor	z1.d, z1.d, z28.d
	eor	z0.d, z0.d, z29.d
	eor	z2.d, z2.d, z30.d
	eor	z3.d, z3.d, z31.d
	add	x22, x22, #32
	eor	z4.d, z4.d, z8.d
	eor	z5.d, z5.d, z9.d
	cmp	x8, x22
	eor	z6.d, z6.d, z10.d
	eor	z7.d, z7.d, z11.d
	eor	z16.d, z16.d, z24.d
	eor	z17.d, z17.d, z13.d
	eor	z18.d, z18.d, z15.d
	eor	z19.d, z19.d, z14.d
	eor	z20.d, z20.d, z22.d
	eor	z21.d, z21.d, z23.d
	b.eq	.LBB13_23
.LBB13_26:                              //   Parent Loop BB13_24 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x24, [x23], #8
	add	x25, x24, x17
	ld1b	{ z22.b }, p2/z, [x24, x17]
	ld1b	{ z23.b }, p1/z, [x25, x20]
	tbz	w19, #0, .LBB13_35
// %bb.27:                              //   in Loop: Header=BB13_26 Depth=2
	movi	v24.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	mov	z28.d, z22.d
	mov	z29.d, z23.d
	cmp	w9, #1
	b.eq	.LBB13_29
.LBB13_28:                              //   in Loop: Header=BB13_26 Depth=2
	add	x24, x2, x22
	ld1b	{ z28.b }, p0/z, [x2, x22]
	ld1b	{ z29.b }, p0/z, [x24, x21]
	tbl	z30.b, { z28.b }, z27.b
	tbl	z8.b, { z28.b }, z25.b
	tbl	z31.b, { z29.b }, z26.b
	tbl	z29.b, { z29.b }, z24.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
.LBB13_29:                              //   in Loop: Header=BB13_26 Depth=2
	mov	z30.d, z22.d
	mov	z31.d, z23.d
	cmp	w11, #1
	b.ne	.LBB13_36
// %bb.30:                              //   in Loop: Header=BB13_26 Depth=2
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	cmp	w12, #1
	b.ne	.LBB13_37
.LBB13_31:                              //   in Loop: Header=BB13_26 Depth=2
	mov	z10.d, z22.d
	mov	z11.d, z23.d
	cmp	w13, #1
	b.ne	.LBB13_38
.LBB13_32:                              //   in Loop: Header=BB13_26 Depth=2
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w14, #1
	b.ne	.LBB13_39
.LBB13_33:                              //   in Loop: Header=BB13_26 Depth=2
	str	z12, [sp, #1, mul vl]           // 16-byte Folded Spill
	mov	z12.d, z24.d
	mov	z15.d, z22.d
	mov	z14.d, z23.d
	cmp	w15, #1
	b.ne	.LBB13_40
.LBB13_34:                              //   in Loop: Header=BB13_26 Depth=2
	cmp	w16, #1
	b.eq	.LBB13_25
	b	.LBB13_41
.LBB13_35:                              //   in Loop: Header=BB13_26 Depth=2
	lsr	z26.b, z22.b, #4
	lsr	z24.b, z23.b, #4
	movprfx	z27, z22
	and	z27.b, z27.b, #0xf
	movprfx	z25, z23
	and	z25.b, z25.b, #0xf
	mov	z28.d, z22.d
	mov	z29.d, z23.d
	cmp	w9, #1
	b.ne	.LBB13_28
	b	.LBB13_29
.LBB13_36:                              //   in Loop: Header=BB13_26 Depth=2
	add	w24, w10, w22
	add	x25, x2, x24
	ld1b	{ z30.b }, p0/z, [x2, x24]
	ld1b	{ z31.b }, p0/z, [x25, x21]
	tbl	z8.b, { z30.b }, z27.b
	tbl	z10.b, { z30.b }, z25.b
	tbl	z9.b, { z31.b }, z26.b
	tbl	z31.b, { z31.b }, z24.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	cmp	w12, #1
	b.eq	.LBB13_31
.LBB13_37:                              //   in Loop: Header=BB13_26 Depth=2
	add	w24, w18, w22
	and	x24, x24, #0xffffffe0
	add	x25, x2, x24
	ld1b	{ z8.b }, p0/z, [x2, x24]
	ld1b	{ z9.b }, p0/z, [x25, x21]
	tbl	z10.b, { z8.b }, z27.b
	tbl	z12.b, { z8.b }, z25.b
	tbl	z11.b, { z9.b }, z26.b
	tbl	z9.b, { z9.b }, z24.b
	eor	z8.d, z10.d, z11.d
	eor	z9.d, z12.d, z9.d
	mov	z10.d, z22.d
	mov	z11.d, z23.d
	cmp	w13, #1
	b.eq	.LBB13_32
.LBB13_38:                              //   in Loop: Header=BB13_26 Depth=2
	add	w24, w5, w22
	and	x24, x24, #0xffffffe0
	add	x25, x2, x24
	ld1b	{ z10.b }, p0/z, [x2, x24]
	ld1b	{ z11.b }, p0/z, [x25, x21]
	tbl	z12.b, { z10.b }, z27.b
	tbl	z14.b, { z10.b }, z25.b
	tbl	z13.b, { z11.b }, z26.b
	tbl	z11.b, { z11.b }, z24.b
	eor	z10.d, z12.d, z13.d
	eor	z11.d, z14.d, z11.d
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w14, #1
	b.eq	.LBB13_33
.LBB13_39:                              //   in Loop: Header=BB13_26 Depth=2
	add	w24, w1, w22
	str	z10, [sp, #1, mul vl]           // 16-byte Folded Spill
	mov	z10.d, z9.d
	and	x24, x24, #0xffffffe0
	mov	z9.d, z21.d
	mov	z21.d, z20.d
	add	x25, x2, x24
	ld1b	{ z12.b }, p0/z, [x2, x24]
	mov	z20.d, z19.d
	ld1b	{ z13.b }, p0/z, [x25, x21]
	mov	z19.d, z18.d
	mov	z18.d, z17.d
	mov	z17.d, z16.d
	mov	z16.d, z7.d
	mov	z7.d, z6.d
	tbl	z14.b, { z12.b }, z27.b
	mov	z6.d, z5.d
	mov	z5.d, z4.d
	tbl	z15.b, { z13.b }, z26.b
	mov	z4.d, z3.d
	mov	z3.d, z2.d
	mov	z2.d, z1.d
	mov	z1.d, z0.d
	mov	z0.d, z8.d
	mov	z8.d, z31.d
	mov	z31.d, z30.d
	mov	z30.d, z29.d
	mov	z29.d, z28.d
	tbl	z28.b, { z12.b }, z25.b
	tbl	z13.b, { z13.b }, z24.b
	eor	z12.d, z14.d, z15.d
	eor	z13.d, z28.d, z13.d
	mov	z28.d, z29.d
	mov	z29.d, z30.d
	mov	z30.d, z31.d
	mov	z31.d, z8.d
	mov	z8.d, z0.d
	mov	z0.d, z1.d
	mov	z1.d, z2.d
	mov	z2.d, z3.d
	mov	z3.d, z4.d
	mov	z4.d, z5.d
	mov	z5.d, z6.d
	mov	z6.d, z7.d
	mov	z7.d, z16.d
	mov	z16.d, z17.d
	mov	z17.d, z18.d
	mov	z18.d, z19.d
	mov	z19.d, z20.d
	mov	z20.d, z21.d
	mov	z21.d, z9.d
	mov	z9.d, z10.d
	ldr	z10, [sp, #1, mul vl]           // 16-byte Folded Reload
	str	z12, [sp, #1, mul vl]           // 16-byte Folded Spill
	mov	z12.d, z24.d
	mov	z15.d, z22.d
	mov	z14.d, z23.d
	cmp	w15, #1
	b.eq	.LBB13_34
.LBB13_40:                              //   in Loop: Header=BB13_26 Depth=2
	add	w24, w6, w22
	str	z21, [sp]                       // 16-byte Folded Spill
	mov	z21.d, z20.d
	and	x24, x24, #0xffffffe0
	mov	z20.d, z19.d
	mov	z19.d, z18.d
	add	x25, x2, x24
	mov	z18.d, z17.d
	mov	z17.d, z16.d
	mov	z16.d, z7.d
	mov	z7.d, z6.d
	mov	z6.d, z5.d
	mov	z5.d, z4.d
	mov	z4.d, z3.d
	ld1b	{ z14.b }, p0/z, [x25, x21]
	mov	z3.d, z2.d
	mov	z2.d, z1.d
	mov	z1.d, z0.d
	mov	z0.d, z8.d
	mov	z8.d, z30.d
	mov	z30.d, z28.d
	ld1b	{ z28.b }, p0/z, [x2, x24]
	mov	z24.d, z11.d
	mov	z11.d, z10.d
	mov	z10.d, z9.d
	mov	z9.d, z31.d
	mov	z31.d, z29.d
	tbl	z29.b, { z14.b }, z26.b
	tbl	z14.b, { z14.b }, z12.b
	tbl	z15.b, { z28.b }, z27.b
	tbl	z28.b, { z28.b }, z25.b
	eor	z15.d, z15.d, z29.d
	mov	z29.d, z31.d
	mov	z31.d, z9.d
	mov	z9.d, z10.d
	mov	z10.d, z11.d
	mov	z11.d, z24.d
	eor	z14.d, z28.d, z14.d
	mov	z28.d, z30.d
	mov	z30.d, z8.d
	mov	z8.d, z0.d
	mov	z0.d, z1.d
	mov	z1.d, z2.d
	mov	z2.d, z3.d
	mov	z3.d, z4.d
	mov	z4.d, z5.d
	mov	z5.d, z6.d
	mov	z6.d, z7.d
	mov	z7.d, z16.d
	mov	z16.d, z17.d
	mov	z17.d, z18.d
	mov	z18.d, z19.d
	mov	z19.d, z20.d
	mov	z20.d, z21.d
	ldr	z21, [sp]                       // 16-byte Folded Reload
	cmp	w16, #1
	b.eq	.LBB13_25
.LBB13_41:                              //   in Loop: Header=BB13_26 Depth=2
	add	w24, w7, w22
	and	x24, x24, #0xffffffe0
	add	x25, x2, x24
	ld1b	{ z22.b }, p0/z, [x2, x24]
	ld1b	{ z23.b }, p0/z, [x25, x21]
	tbl	z27.b, { z22.b }, z27.b
	tbl	z25.b, { z22.b }, z25.b
	tbl	z26.b, { z23.b }, z26.b
	tbl	z23.b, { z23.b }, z12.b
	eor	z22.d, z27.d, z26.d
	eor	z23.d, z25.d, z23.d
	b	.LBB13_25
.LBB13_42:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w20
	mov	w10, w0
.LBB13_43:                              // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ldr	x11, [x4, #48]
	add	x12, x9, x8
	whilelt	p0.b, w12, w0
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #48]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #40]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #40]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p1, [x11, x8]
	incb	x8, all, mul #2
	ldr	x11, [x4]
	cmp	x8, x10
	st1b	{ z0.b }, p0, [x12, x11]
	b.lo	.LBB13_43
.LBB13_44:
	addvl	sp, sp, #2
	ldp	x20, x19, [sp, #112]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #96]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x25, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #128            // 16-byte Folded Reload
.LBB13_45:
	ret
.Lfunc_end13:
	.size	gf_7vect_dot_prod_sve2, .Lfunc_end13-gf_7vect_dot_prod_sve2
                                        // -- End function
	.ident	"clang version 23.1.3 (https://github.com/llvm/llvm-project 0d261d1ca552c95a8f007e061c787ac7132fbcbc)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
