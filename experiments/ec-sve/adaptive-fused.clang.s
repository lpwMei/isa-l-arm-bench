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
	rdvl	x14, #1
	ptrue	p0.b, vl16
	cmp	w1, #1
	lsr	x12, x14, #4
	b.lt	.LBB0_14
// %bb.3:
	mov	w8, w1
	mov	x11, xzr
	lsl	x9, x8, #5
	sub	x13, x9, #32
.LBB0_4:                                // =>This Inner Loop Header: Depth=1
	add	x10, x2, w11, sxtw
	ldrb	w10, [x10, #1]
	cmp	w10, #1
	ccmp	x13, x11, #4, eq
	add	x11, x11, #32
	b.ne	.LBB0_4
// %bb.5:
	str	x19, [sp, #-16]!                // 8-byte Folded Spill
	add	w13, w12, w12, lsl #1
	lsl	w12, w12, #5
	mov	x11, xzr
	mov	w14, w14
	mov	w15, #16                        // =0x10
	rdvl	x16, #4
	lsl	w13, w13, #4
	b	.LBB0_7
.LBB0_6:                                //   in Loop: Header=BB0_7 Depth=1
	st1b	{ z2.b }, p1, [x4, x11]
	add	x11, x11, x16
	cmp	w0, w11
	st1b	{ z1.b }, p2, [x4, x17]
	st1b	{ z3.b }, p4, [x4, x1]
	st1b	{ z0.b }, p3, [x4, x18]
	b.le	.LBB0_13
.LBB0_7:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB0_12 Depth 2
                                        //     Child Loop BB0_10 Depth 2
	whilelt	p1.b, w11, w0
	ptest	p0, p1.b
	b.eq	.LBB0_13
// %bb.8:                               //   in Loop: Header=BB0_7 Depth=1
	add	x17, x11, x14
	add	x1, x11, x12
	add	x18, x11, x13
	whilelt	p2.b, w17, w0
	whilelt	p4.b, w1, w0
	whilelt	p3.b, w18, w0
	cmp	w10, #1
	b.eq	.LBB0_11
// %bb.9:                               //   in Loop: Header=BB0_7 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x5, xzr
	movi	v3.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	mov	x6, x3
.LBB0_10:                               //   Parent Loop BB0_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x7, [x6], #8
	sxtw	x19, w5
	add	x5, x5, #32
	ld1b	{ z4.b }, p1/z, [x7, x11]
	ld1b	{ z5.b }, p4/z, [x7, x1]
	ld1b	{ z6.b }, p2/z, [x7, x17]
	ld1b	{ z7.b }, p3/z, [x7, x18]
	add	x7, x2, x19
	ld1b	{ z16.b }, p0/z, [x2, x19]
	ld1b	{ z17.b }, p0/z, [x7, x15]
	cmp	x9, x5
	lsr	z18.b, z4.b, #4
	and	z4.b, z4.b, #0xf
	movprfx	z19, z5
	and	z19.b, z19.b, #0xf
	lsr	z20.b, z6.b, #4
	and	z6.b, z6.b, #0xf
	lsr	z21.b, z7.b, #4
	and	z7.b, z7.b, #0xf
	lsr	z5.b, z5.b, #4
	tbl	z4.b, { z16.b }, z4.b
	tbl	z18.b, { z17.b }, z18.b
	tbl	z19.b, { z16.b }, z19.b
	tbl	z6.b, { z16.b }, z6.b
	tbl	z20.b, { z17.b }, z20.b
	tbl	z5.b, { z17.b }, z5.b
	tbl	z7.b, { z16.b }, z7.b
	tbl	z16.b, { z17.b }, z21.b
	eor	z4.d, z4.d, z18.d
	eor	z6.d, z6.d, z20.d
	eor	z5.d, z19.d, z5.d
	eor	z7.d, z7.d, z16.d
	eor	z2.d, z2.d, z4.d
	eor	z1.d, z1.d, z6.d
	eor	z3.d, z3.d, z5.d
	eor	z0.d, z0.d, z7.d
	b.ne	.LBB0_10
	b	.LBB0_6
.LBB0_11:                               //   in Loop: Header=BB0_7 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x5, x8
	movi	v3.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	mov	x6, x3
.LBB0_12:                               //   Parent Loop BB0_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x7, [x6], #8
	subs	x5, x5, #1
	ld1b	{ z4.b }, p1/z, [x7, x11]
	ld1b	{ z5.b }, p2/z, [x7, x17]
	ld1b	{ z6.b }, p4/z, [x7, x1]
	ld1b	{ z7.b }, p3/z, [x7, x18]
	eor	z2.d, z2.d, z4.d
	eor	z1.d, z1.d, z5.d
	eor	z3.d, z3.d, z6.d
	eor	z0.d, z0.d, z7.d
	b.ne	.LBB0_12
	b	.LBB0_6
.LBB0_13:
	ldr	x19, [sp], #16                  // 8-byte Folded Reload
	ret
.LBB0_14:
	add	w10, w12, w12, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w12, #5
	mov	w11, w14
	mov	x8, xzr
	rdvl	x15, #4
	lsl	w10, w10, #4
	add	x12, x4, x11
	add	x13, x4, x9
	add	x14, x4, x10
.LBB0_15:                               // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB0_1
// %bb.16:                              //   in Loop: Header=BB0_15 Depth=1
	add	w16, w11, w8
	add	w17, w9, w8
	st1b	{ z0.b }, p1, [x4, x8]
	whilelt	p2.b, w16, w0
	add	w16, w10, w8
	whilelt	p1.b, w17, w0
	whilelt	p3.b, w16, w0
	st1b	{ z0.b }, p2, [x12, x8]
	st1b	{ z0.b }, p1, [x13, x8]
	st1b	{ z0.b }, p3, [x14, x8]
	add	x8, x8, x15
	cmp	w0, w8
	b.gt	.LBB0_15
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
	ptrue	p0.b, vl16
	cmp	w1, #1
	lsr	x13, x15, #4
	stp	d11, d10, [sp, #16]             // 16-byte Folded Spill
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
	mov	x12, xzr
	mov	w15, w15
	lsl	w14, w14, #4
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
	ptest	p0, p1.b
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
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB1_20
// %bb.19:                              //   in Loop: Header=BB1_18 Depth=1
	ldr	x13, [x4, #8]
	add	x14, x11, x8
	add	x15, x9, x8
	whilelt	p2.b, w14, w0
	add	x16, x10, x8
	st1b	{ z0.b }, p1, [x13, x8]
	whilelt	p3.b, w15, w0
	ldr	x13, [x4, #8]
	whilelt	p4.b, w16, w0
	st1b	{ z0.b }, p2, [x14, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p3, [x15, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p4, [x16, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p1, [x13, x8]
	add	x8, x8, x12
	ldr	x13, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x14, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p3, [x15, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p4, [x16, x13]
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
	b.lt	.LBB2_27
// %bb.1:
	stp	x22, x21, [sp, #-32]!           // 16-byte Folded Spill
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x16, #1
	stp	x20, x19, [sp, #16]             // 16-byte Folded Spill
	b.lt	.LBB2_23
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB2_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB2_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x14, x11, #1
	mov	x13, x14
	mov	w12, w10
.LBB2_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w15, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB2_7
// %bb.6:                               //   in Loop: Header=BB2_5 Depth=1
	add	w12, w12, #32
	tbnz	w15, #0, .LBB2_5
.LBB2_7:
	lsl	w12, w1, #6
	mov	w15, w12
.LBB2_8:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w15, sxtw
	subs	x14, x14, #1
	cset	w17, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB2_10
// %bb.9:                               //   in Loop: Header=BB2_8 Depth=1
	add	w15, w15, #32
	tbnz	w17, #0, .LBB2_8
.LBB2_10:
	cmp	w11, #1
	mov	x15, xzr
	mov	w16, w16
	ccmp	w9, #1, #0, eq
	rdvl	x17, #2
	mov	w18, #16                        // =0x10
	ccmp	w13, #1, #0, eq
	cset	w14, eq
	b	.LBB2_12
.LBB2_11:                               //   in Loop: Header=BB2_12 Depth=1
	ldr	x1, [x4, #16]
	cmp	w0, w6
	st1b	{ z4.b }, p1, [x1, x15]
	ldr	x1, [x4, #16]
	st1b	{ z5.b }, p2, [x1, x5]
	ldr	x1, [x4, #8]
	st1b	{ z2.b }, p1, [x1, x15]
	ldr	x1, [x4, #8]
	st1b	{ z3.b }, p2, [x1, x5]
	ldr	x1, [x4]
	st1b	{ z1.b }, p1, [x1, x15]
	ldr	x15, [x4]
	st1b	{ z0.b }, p2, [x15, x5]
	mov	x15, x6
	b.le	.LBB2_26
.LBB2_12:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB2_15 Depth 2
	whilelt	p1.b, w15, w0
	ptest	p0, p1.b
	b.eq	.LBB2_26
// %bb.13:                              //   in Loop: Header=BB2_12 Depth=1
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	x5, x15, x16
	movi	v4.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	mov	x1, xzr
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	add	x6, x15, x17
	whilelt	p2.b, w5, w0
	mov	x7, x3
	mov	w19, w10
	mov	w20, w12
	b	.LBB2_15
.LBB2_14:                               //   in Loop: Header=BB2_15 Depth=2
	eor	z1.d, z1.d, z20.d
	eor	z0.d, z0.d, z21.d
	add	x1, x1, #32
	eor	z2.d, z2.d, z22.d
	eor	z3.d, z3.d, z23.d
	cmp	x8, x1
	eor	z4.d, z4.d, z6.d
	eor	z5.d, z5.d, z7.d
	add	w20, w20, #32
	add	w19, w19, #32
	b.eq	.LBB2_11
.LBB2_15:                               //   Parent Loop BB2_12 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x21, [x7], #8
	ld1b	{ z6.b }, p1/z, [x21, x15]
	ld1b	{ z7.b }, p2/z, [x21, x5]
	tbz	w14, #0, .LBB2_20
// %bb.16:                              //   in Loop: Header=BB2_15 Depth=2
	movi	v16.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	z20.d, z6.d
	mov	z21.d, z7.d
	cmp	w9, #1
	b.eq	.LBB2_18
.LBB2_17:                               //   in Loop: Header=BB2_15 Depth=2
	sxtw	x21, w1
	add	x22, x2, x21
	ld1b	{ z20.b }, p0/z, [x2, x21]
	ld1b	{ z21.b }, p0/z, [x22, x18]
	tbl	z22.b, { z20.b }, z19.b
	tbl	z24.b, { z20.b }, z17.b
	tbl	z23.b, { z21.b }, z18.b
	tbl	z21.b, { z21.b }, z16.b
	eor	z20.d, z22.d, z23.d
	eor	z21.d, z24.d, z21.d
.LBB2_18:                               //   in Loop: Header=BB2_15 Depth=2
	mov	z22.d, z6.d
	mov	z23.d, z7.d
	cmp	w11, #1
	b.ne	.LBB2_21
// %bb.19:                              //   in Loop: Header=BB2_15 Depth=2
	cmp	w13, #1
	b.eq	.LBB2_14
	b	.LBB2_22
.LBB2_20:                               //   in Loop: Header=BB2_15 Depth=2
	lsr	z18.b, z6.b, #4
	lsr	z16.b, z7.b, #4
	movprfx	z19, z6
	and	z19.b, z19.b, #0xf
	movprfx	z17, z7
	and	z17.b, z17.b, #0xf
	mov	z20.d, z6.d
	mov	z21.d, z7.d
	cmp	w9, #1
	b.ne	.LBB2_17
	b	.LBB2_18
.LBB2_21:                               //   in Loop: Header=BB2_15 Depth=2
	sxtw	x21, w19
	add	x22, x2, x21
	ld1b	{ z22.b }, p0/z, [x2, x21]
	ld1b	{ z23.b }, p0/z, [x22, x18]
	tbl	z24.b, { z22.b }, z19.b
	tbl	z26.b, { z22.b }, z17.b
	tbl	z25.b, { z23.b }, z18.b
	tbl	z23.b, { z23.b }, z16.b
	eor	z22.d, z24.d, z25.d
	eor	z23.d, z26.d, z23.d
	cmp	w13, #1
	b.eq	.LBB2_14
.LBB2_22:                               //   in Loop: Header=BB2_15 Depth=2
	sxtw	x21, w20
	add	x22, x2, x21
	ld1b	{ z6.b }, p0/z, [x2, x21]
	ld1b	{ z7.b }, p0/z, [x22, x18]
	tbl	z19.b, { z6.b }, z19.b
	tbl	z17.b, { z6.b }, z17.b
	tbl	z18.b, { z7.b }, z18.b
	tbl	z7.b, { z7.b }, z16.b
	eor	z6.d, z19.d, z18.d
	eor	z7.d, z17.d, z7.d
	b	.LBB2_14
.LBB2_23:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w16
	rdvl	x10, #2
.LBB2_24:                               // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB2_26
// %bb.25:                              //   in Loop: Header=BB2_24 Depth=1
	ldr	x11, [x4, #16]
	add	x12, x9, x8
	whilelt	p2.b, w12, w0
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p1, [x11, x8]
	add	x8, x8, x10
	ldr	x11, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x12, x11]
	b.gt	.LBB2_24
.LBB2_26:
	ldp	x20, x19, [sp, #16]             // 16-byte Folded Reload
	ldp	x22, x21, [sp], #32             // 16-byte Folded Reload
.LBB2_27:
	ret
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
	str	x25, [sp, #-64]!                // 8-byte Folded Spill
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x18, #1
	stp	x24, x23, [sp, #16]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #32]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #48]             // 16-byte Folded Spill
	b.lt	.LBB3_28
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB3_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB3_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x16, x11, #1
	mov	x13, x16
	mov	w12, w10
.LBB3_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB3_7
// %bb.6:                               //   in Loop: Header=BB3_5 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB3_5
.LBB3_7:
	lsl	w12, w1, #6
	mov	x15, x16
	mov	w14, w12
.LBB3_8:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w17, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB3_10
// %bb.9:                               //   in Loop: Header=BB3_8 Depth=1
	add	w14, w14, #32
	tbnz	w17, #0, .LBB3_8
.LBB3_10:
	add	w14, w1, w1, lsl #1
	lsl	w14, w14, #5
	mov	w17, w14
.LBB3_11:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w17, sxtw
	subs	x16, x16, #1
	cset	w1, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB3_13
// %bb.12:                              //   in Loop: Header=BB3_11 Depth=1
	add	w17, w17, #32
	tbnz	w1, #0, .LBB3_11
.LBB3_13:
	cmp	w11, #1
	mov	x17, xzr
	mov	w18, w18
	ccmp	w9, #1, #0, eq
	rdvl	x1, #2
	mov	w5, #16                         // =0x10
	ccmp	w13, #1, #0, eq
	ccmp	w15, #1, #0, eq
	cset	w16, eq
	b	.LBB3_15
.LBB3_14:                               //   in Loop: Header=BB3_15 Depth=1
	ldr	x6, [x4, #24]
	cmp	w0, w19
	st1b	{ z6.b }, p1, [x6, x17]
	ldr	x6, [x4, #24]
	st1b	{ z7.b }, p2, [x6, x7]
	ldr	x6, [x4, #16]
	st1b	{ z4.b }, p1, [x6, x17]
	ldr	x6, [x4, #16]
	st1b	{ z5.b }, p2, [x6, x7]
	ldr	x6, [x4, #8]
	st1b	{ z2.b }, p1, [x6, x17]
	ldr	x6, [x4, #8]
	st1b	{ z3.b }, p2, [x6, x7]
	ldr	x6, [x4]
	st1b	{ z0.b }, p1, [x6, x17]
	ldr	x17, [x4]
	st1b	{ z1.b }, p2, [x17, x7]
	mov	x17, x19
	b.le	.LBB3_31
.LBB3_15:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB3_18 Depth 2
	whilelt	p1.b, w17, w0
	ptest	p0, p1.b
	b.eq	.LBB3_31
// %bb.16:                              //   in Loop: Header=BB3_15 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	x7, x17, x18
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x6, xzr
	movi	v1.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	add	x19, x17, x1
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x20, x3
	whilelt	p2.b, w7, w0
	mov	w21, w10
	mov	w22, w12
	mov	w23, w14
	b	.LBB3_18
.LBB3_17:                               //   in Loop: Header=BB3_18 Depth=2
	eor	z0.d, z0.d, z22.d
	eor	z1.d, z1.d, z23.d
	add	x6, x6, #32
	eor	z2.d, z2.d, z24.d
	eor	z3.d, z3.d, z25.d
	cmp	x8, x6
	eor	z4.d, z4.d, z26.d
	eor	z5.d, z5.d, z27.d
	add	w23, w23, #32
	eor	z6.d, z6.d, z16.d
	eor	z7.d, z7.d, z17.d
	add	w22, w22, #32
	add	w21, w21, #32
	b.eq	.LBB3_14
.LBB3_18:                               //   Parent Loop BB3_15 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x24, [x20], #8
	ld1b	{ z16.b }, p1/z, [x24, x17]
	ld1b	{ z17.b }, p2/z, [x24, x7]
	tbz	w16, #0, .LBB3_24
// %bb.19:                              //   in Loop: Header=BB3_18 Depth=2
	movi	v18.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	mov	z22.d, z16.d
	mov	z23.d, z17.d
	cmp	w9, #1
	b.eq	.LBB3_21
.LBB3_20:                               //   in Loop: Header=BB3_18 Depth=2
	sxtw	x24, w6
	add	x25, x2, x24
	ld1b	{ z22.b }, p0/z, [x2, x24]
	ld1b	{ z23.b }, p0/z, [x25, x5]
	tbl	z24.b, { z22.b }, z21.b
	tbl	z26.b, { z22.b }, z19.b
	tbl	z25.b, { z23.b }, z20.b
	tbl	z23.b, { z23.b }, z18.b
	eor	z22.d, z24.d, z25.d
	eor	z23.d, z26.d, z23.d
.LBB3_21:                               //   in Loop: Header=BB3_18 Depth=2
	mov	z24.d, z16.d
	mov	z25.d, z17.d
	cmp	w11, #1
	b.ne	.LBB3_25
// %bb.22:                              //   in Loop: Header=BB3_18 Depth=2
	mov	z26.d, z16.d
	mov	z27.d, z17.d
	cmp	w13, #1
	b.ne	.LBB3_26
.LBB3_23:                               //   in Loop: Header=BB3_18 Depth=2
	cmp	w15, #1
	b.eq	.LBB3_17
	b	.LBB3_27
.LBB3_24:                               //   in Loop: Header=BB3_18 Depth=2
	lsr	z20.b, z16.b, #4
	lsr	z18.b, z17.b, #4
	movprfx	z21, z16
	and	z21.b, z21.b, #0xf
	movprfx	z19, z17
	and	z19.b, z19.b, #0xf
	mov	z22.d, z16.d
	mov	z23.d, z17.d
	cmp	w9, #1
	b.ne	.LBB3_20
	b	.LBB3_21
.LBB3_25:                               //   in Loop: Header=BB3_18 Depth=2
	sxtw	x24, w21
	add	x25, x2, x24
	ld1b	{ z24.b }, p0/z, [x2, x24]
	ld1b	{ z25.b }, p0/z, [x25, x5]
	tbl	z26.b, { z24.b }, z21.b
	tbl	z28.b, { z24.b }, z19.b
	tbl	z27.b, { z25.b }, z20.b
	tbl	z25.b, { z25.b }, z18.b
	eor	z24.d, z26.d, z27.d
	eor	z25.d, z28.d, z25.d
	mov	z26.d, z16.d
	mov	z27.d, z17.d
	cmp	w13, #1
	b.eq	.LBB3_23
.LBB3_26:                               //   in Loop: Header=BB3_18 Depth=2
	sxtw	x24, w22
	add	x25, x2, x24
	ld1b	{ z26.b }, p0/z, [x2, x24]
	ld1b	{ z27.b }, p0/z, [x25, x5]
	tbl	z28.b, { z26.b }, z21.b
	tbl	z30.b, { z26.b }, z19.b
	tbl	z29.b, { z27.b }, z20.b
	tbl	z27.b, { z27.b }, z18.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	cmp	w15, #1
	b.eq	.LBB3_17
.LBB3_27:                               //   in Loop: Header=BB3_18 Depth=2
	sxtw	x24, w23
	add	x25, x2, x24
	ld1b	{ z16.b }, p0/z, [x2, x24]
	ld1b	{ z17.b }, p0/z, [x25, x5]
	tbl	z21.b, { z16.b }, z21.b
	tbl	z19.b, { z16.b }, z19.b
	tbl	z20.b, { z17.b }, z20.b
	tbl	z17.b, { z17.b }, z18.b
	eor	z16.d, z21.d, z20.d
	eor	z17.d, z19.d, z17.d
	b	.LBB3_17
.LBB3_28:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w18
	rdvl	x10, #2
.LBB3_29:                               // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB3_31
// %bb.30:                              //   in Loop: Header=BB3_29 Depth=1
	ldr	x11, [x4, #24]
	add	x12, x9, x8
	whilelt	p2.b, w12, w0
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p1, [x11, x8]
	add	x8, x8, x10
	ldr	x11, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x12, x11]
	b.gt	.LBB3_29
.LBB3_31:
	ldp	x20, x19, [sp, #48]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #32]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #16]             // 16-byte Folded Reload
	ldr	x25, [sp], #64                  // 8-byte Folded Reload
.LBB3_32:
	ret
.Lfunc_end3:
	.size	gf_4vect_dot_prod_sve, .Lfunc_end3-gf_4vect_dot_prod_sve
                                        // -- End function
	.globl	gf_5vect_dot_prod_sve           // -- Begin function gf_5vect_dot_prod_sve
	.p2align	2
	.type	gf_5vect_dot_prod_sve,@function
gf_5vect_dot_prod_sve:                  // @gf_5vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB4_37
// %bb.1:
	str	d10, [sp, #-112]!               // 8-byte Folded Spill
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x5, #1
	stp	d9, d8, [sp, #16]               // 16-byte Folded Spill
	stp	x28, x27, [sp, #32]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #48]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #64]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             // 16-byte Folded Spill
	b.lt	.LBB4_33
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB4_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB4_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x18, x11, #1
	mov	x13, x18
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
	lsl	w12, w1, #6
	mov	x15, x18
	mov	w14, w12
.LBB4_8:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w16, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB4_10
// %bb.9:                               //   in Loop: Header=BB4_8 Depth=1
	add	w14, w14, #32
	tbnz	w16, #0, .LBB4_8
.LBB4_10:
	add	w14, w1, w1, lsl #1
	mov	x17, x18
	lsl	w14, w14, #5
	mov	w16, w14
.LBB4_11:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	subs	x17, x17, #1
	cset	w6, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB4_13
// %bb.12:                              //   in Loop: Header=BB4_11 Depth=1
	add	w16, w16, #32
	tbnz	w6, #0, .LBB4_11
.LBB4_13:
	lsl	w16, w1, #7
	mov	w1, w16
.LBB4_14:                               // =>This Inner Loop Header: Depth=1
	add	x17, x2, w1, sxtw
	subs	x18, x18, #1
	cset	w6, hs
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	b.ne	.LBB4_16
// %bb.15:                              //   in Loop: Header=BB4_14 Depth=1
	add	w1, w1, #32
	tbnz	w6, #0, .LBB4_14
.LBB4_16:
	cmp	w11, #1
	mov	x18, xzr
	mov	w5, w5
	ccmp	w9, #1, #0, eq
	rdvl	x6, #2
	mov	w7, #16                         // =0x10
	ccmp	w13, #1, #0, eq
	ccmp	w15, #1, #0, eq
	ccmp	w17, #1, #0, eq
	cset	w1, eq
	b	.LBB4_18
.LBB4_17:                               //   in Loop: Header=BB4_18 Depth=1
	ldr	x19, [x4, #32]
	cmp	w0, w21
	st1b	{ z16.b }, p1, [x19, x18]
	ldr	x19, [x4, #32]
	st1b	{ z17.b }, p2, [x19, x20]
	ldr	x19, [x4, #24]
	st1b	{ z6.b }, p1, [x19, x18]
	ldr	x19, [x4, #24]
	st1b	{ z7.b }, p2, [x19, x20]
	ldr	x19, [x4, #16]
	st1b	{ z4.b }, p1, [x19, x18]
	ldr	x19, [x4, #16]
	st1b	{ z5.b }, p2, [x19, x20]
	ldr	x19, [x4, #8]
	st1b	{ z2.b }, p1, [x19, x18]
	ldr	x19, [x4, #8]
	st1b	{ z3.b }, p2, [x19, x20]
	ldr	x19, [x4]
	st1b	{ z0.b }, p1, [x19, x18]
	ldr	x18, [x4]
	st1b	{ z1.b }, p2, [x18, x20]
	mov	x18, x21
	b.le	.LBB4_36
.LBB4_18:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB4_21 Depth 2
	whilelt	p1.b, w18, w0
	ptest	p0, p1.b
	b.eq	.LBB4_36
// %bb.19:                              //   in Loop: Header=BB4_18 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	x20, x18, x5
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x19, xzr
	movi	v16.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	add	x21, x18, x6
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	x22, x3
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	w23, w10
	whilelt	p2.b, w20, w0
	mov	w24, w12
	mov	w25, w14
	mov	w26, w16
	b	.LBB4_21
.LBB4_20:                               //   in Loop: Header=BB4_21 Depth=2
	eor	z0.d, z0.d, z24.d
	eor	z1.d, z1.d, z25.d
	add	x19, x19, #32
	eor	z2.d, z2.d, z26.d
	eor	z3.d, z3.d, z27.d
	add	w26, w26, #32
	eor	z4.d, z4.d, z28.d
	eor	z5.d, z5.d, z29.d
	cmp	x8, x19
	eor	z6.d, z6.d, z30.d
	eor	z7.d, z7.d, z31.d
	add	w25, w25, #32
	eor	z16.d, z16.d, z18.d
	eor	z17.d, z17.d, z19.d
	add	w24, w24, #32
	add	w23, w23, #32
	b.eq	.LBB4_17
.LBB4_21:                               //   Parent Loop BB4_18 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x27, [x22], #8
	ld1b	{ z18.b }, p1/z, [x27, x18]
	ld1b	{ z19.b }, p2/z, [x27, x20]
	tbz	w1, #0, .LBB4_28
// %bb.22:                              //   in Loop: Header=BB4_21 Depth=2
	movi	v20.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	mov	z24.d, z18.d
	mov	z25.d, z19.d
	cmp	w9, #1
	b.eq	.LBB4_24
.LBB4_23:                               //   in Loop: Header=BB4_21 Depth=2
	sxtw	x27, w19
	add	x28, x2, x27
	ld1b	{ z24.b }, p0/z, [x2, x27]
	ld1b	{ z25.b }, p0/z, [x28, x7]
	tbl	z26.b, { z24.b }, z23.b
	tbl	z28.b, { z24.b }, z21.b
	tbl	z27.b, { z25.b }, z22.b
	tbl	z25.b, { z25.b }, z20.b
	eor	z24.d, z26.d, z27.d
	eor	z25.d, z28.d, z25.d
.LBB4_24:                               //   in Loop: Header=BB4_21 Depth=2
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w11, #1
	b.ne	.LBB4_29
// %bb.25:                              //   in Loop: Header=BB4_21 Depth=2
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	cmp	w13, #1
	b.ne	.LBB4_30
.LBB4_26:                               //   in Loop: Header=BB4_21 Depth=2
	mov	z30.d, z18.d
	mov	z31.d, z19.d
	cmp	w15, #1
	b.ne	.LBB4_31
.LBB4_27:                               //   in Loop: Header=BB4_21 Depth=2
	cmp	w17, #1
	b.eq	.LBB4_20
	b	.LBB4_32
.LBB4_28:                               //   in Loop: Header=BB4_21 Depth=2
	lsr	z22.b, z18.b, #4
	lsr	z20.b, z19.b, #4
	movprfx	z23, z18
	and	z23.b, z23.b, #0xf
	movprfx	z21, z19
	and	z21.b, z21.b, #0xf
	mov	z24.d, z18.d
	mov	z25.d, z19.d
	cmp	w9, #1
	b.ne	.LBB4_23
	b	.LBB4_24
.LBB4_29:                               //   in Loop: Header=BB4_21 Depth=2
	sxtw	x27, w23
	add	x28, x2, x27
	ld1b	{ z26.b }, p0/z, [x2, x27]
	ld1b	{ z27.b }, p0/z, [x28, x7]
	tbl	z28.b, { z26.b }, z23.b
	tbl	z30.b, { z26.b }, z21.b
	tbl	z29.b, { z27.b }, z22.b
	tbl	z27.b, { z27.b }, z20.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	cmp	w13, #1
	b.eq	.LBB4_26
.LBB4_30:                               //   in Loop: Header=BB4_21 Depth=2
	sxtw	x27, w24
	add	x28, x2, x27
	ld1b	{ z28.b }, p0/z, [x2, x27]
	ld1b	{ z29.b }, p0/z, [x28, x7]
	tbl	z30.b, { z28.b }, z23.b
	tbl	z8.b, { z28.b }, z21.b
	tbl	z31.b, { z29.b }, z22.b
	tbl	z29.b, { z29.b }, z20.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
	mov	z30.d, z18.d
	mov	z31.d, z19.d
	cmp	w15, #1
	b.eq	.LBB4_27
.LBB4_31:                               //   in Loop: Header=BB4_21 Depth=2
	sxtw	x27, w25
	add	x28, x2, x27
	ld1b	{ z30.b }, p0/z, [x2, x27]
	ld1b	{ z31.b }, p0/z, [x28, x7]
	tbl	z8.b, { z30.b }, z23.b
	tbl	z10.b, { z30.b }, z21.b
	tbl	z9.b, { z31.b }, z22.b
	tbl	z31.b, { z31.b }, z20.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	cmp	w17, #1
	b.eq	.LBB4_20
.LBB4_32:                               //   in Loop: Header=BB4_21 Depth=2
	sxtw	x27, w26
	add	x28, x2, x27
	ld1b	{ z18.b }, p0/z, [x2, x27]
	ld1b	{ z19.b }, p0/z, [x28, x7]
	tbl	z23.b, { z18.b }, z23.b
	tbl	z21.b, { z18.b }, z21.b
	tbl	z22.b, { z19.b }, z22.b
	tbl	z19.b, { z19.b }, z20.b
	eor	z18.d, z23.d, z22.d
	eor	z19.d, z21.d, z19.d
	b	.LBB4_20
.LBB4_33:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w5
	rdvl	x10, #2
.LBB4_34:                               // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB4_36
// %bb.35:                              //   in Loop: Header=BB4_34 Depth=1
	ldr	x11, [x4, #32]
	add	x12, x9, x8
	whilelt	p2.b, w12, w0
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p1, [x11, x8]
	add	x8, x8, x10
	ldr	x11, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x12, x11]
	b.gt	.LBB4_34
.LBB4_36:
	ldp	x20, x19, [sp, #96]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #64]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #48]             // 16-byte Folded Reload
	ldp	x28, x27, [sp, #32]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #16]               // 16-byte Folded Reload
	ldr	d10, [sp], #112                 // 8-byte Folded Reload
.LBB4_37:
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
	b.lt	.LBB5_42
// %bb.1:
	str	d14, [sp, #-160]!               // 8-byte Folded Spill
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x7, #1
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             // 16-byte Folded Spill
	stp	x28, x27, [sp, #80]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #96]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #112]            // 16-byte Folded Spill
	stp	x22, x21, [sp, #128]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #144]            // 16-byte Folded Spill
	b.lt	.LBB5_38
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB5_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB5_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x5, x11, #1
	mov	x13, x5
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
	lsl	w12, w1, #6
	mov	x15, x5
	mov	w14, w12
.LBB5_8:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w16, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB5_10
// %bb.9:                               //   in Loop: Header=BB5_8 Depth=1
	add	w14, w14, #32
	tbnz	w16, #0, .LBB5_8
.LBB5_10:
	add	w14, w1, w1, lsl #1
	mov	x17, x5
	lsl	w14, w14, #5
	mov	w16, w14
.LBB5_11:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	subs	x17, x17, #1
	cset	w18, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB5_13
// %bb.12:                              //   in Loop: Header=BB5_11 Depth=1
	add	w16, w16, #32
	tbnz	w18, #0, .LBB5_11
.LBB5_13:
	lsl	w16, w1, #7
	mov	x6, x5
	mov	w18, w16
.LBB5_14:                               // =>This Inner Loop Header: Depth=1
	add	x17, x2, w18, sxtw
	subs	x6, x6, #1
	cset	w19, hs
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	b.ne	.LBB5_16
// %bb.15:                              //   in Loop: Header=BB5_14 Depth=1
	add	w18, w18, #32
	tbnz	w19, #0, .LBB5_14
.LBB5_16:
	add	w18, w1, w1, lsl #2
	lsl	w18, w18, #5
	mov	w6, w18
.LBB5_17:                               // =>This Inner Loop Header: Depth=1
	add	x1, x2, w6, sxtw
	subs	x5, x5, #1
	cset	w19, hs
	ldrb	w1, [x1, #1]
	cmp	w1, #1
	b.ne	.LBB5_19
// %bb.18:                              //   in Loop: Header=BB5_17 Depth=1
	add	w6, w6, #32
	tbnz	w19, #0, .LBB5_17
.LBB5_19:
	cmp	w11, #1
	mov	x5, xzr
	mov	w7, w7
	ccmp	w9, #1, #0, eq
	mov	w20, #16                        // =0x10
	ccmp	w13, #1, #0, eq
	ccmp	w15, #1, #0, eq
	ccmp	w17, #1, #0, eq
	ccmp	w1, #1, #0, eq
	cset	w6, eq
	b	.LBB5_21
.LBB5_20:                               //   in Loop: Header=BB5_21 Depth=1
	ldr	x19, [x4, #40]
	cmp	w0, w23
	st1b	{ z18.b }, p1, [x19, x5]
	ldr	x19, [x4, #40]
	st1b	{ z19.b }, p2, [x19, x22]
	ldr	x19, [x4, #32]
	st1b	{ z16.b }, p1, [x19, x5]
	ldr	x19, [x4, #32]
	st1b	{ z17.b }, p2, [x19, x22]
	ldr	x19, [x4, #24]
	st1b	{ z6.b }, p1, [x19, x5]
	ldr	x19, [x4, #24]
	st1b	{ z7.b }, p2, [x19, x22]
	ldr	x19, [x4, #16]
	st1b	{ z4.b }, p1, [x19, x5]
	ldr	x19, [x4, #16]
	st1b	{ z5.b }, p2, [x19, x22]
	ldr	x19, [x4, #8]
	st1b	{ z2.b }, p1, [x19, x5]
	ldr	x19, [x4, #8]
	st1b	{ z3.b }, p2, [x19, x22]
	ldr	x19, [x4]
	st1b	{ z0.b }, p1, [x19, x5]
	ldr	x5, [x4]
	st1b	{ z1.b }, p2, [x5, x22]
	mov	x5, x23
	b.le	.LBB5_41
.LBB5_21:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB5_24 Depth 2
	whilelt	p1.b, w5, w0
	ptest	p0, p1.b
	b.eq	.LBB5_41
// %bb.22:                              //   in Loop: Header=BB5_21 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	x22, x5, x7
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	rdvl	x19, #2
	movi	v16.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	mov	x21, xzr
	movi	v1.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	add	x23, x5, x19
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x24, x3
	movi	v17.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	w25, w10
	whilelt	p2.b, w22, w0
	mov	w26, w12
	mov	w27, w14
	mov	w28, w16
	mov	w29, w18
	b	.LBB5_24
.LBB5_23:                               //   in Loop: Header=BB5_24 Depth=2
	eor	z0.d, z0.d, z26.d
	eor	z1.d, z1.d, z28.d
	add	x21, x21, #32
	eor	z2.d, z2.d, z27.d
	eor	z3.d, z3.d, z29.d
	add	w29, w29, #32
	eor	z4.d, z4.d, z30.d
	eor	z5.d, z5.d, z31.d
	add	w28, w28, #32
	eor	z6.d, z6.d, z8.d
	eor	z7.d, z7.d, z9.d
	cmp	x8, x21
	eor	z16.d, z16.d, z10.d
	eor	z17.d, z17.d, z11.d
	add	w27, w27, #32
	eor	z18.d, z18.d, z20.d
	eor	z19.d, z19.d, z21.d
	add	w26, w26, #32
	add	w25, w25, #32
	b.eq	.LBB5_20
.LBB5_24:                               //   Parent Loop BB5_21 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x30, [x24], #8
	ld1b	{ z20.b }, p1/z, [x30, x5]
	ld1b	{ z21.b }, p2/z, [x30, x22]
	tbz	w6, #0, .LBB5_32
// %bb.25:                              //   in Loop: Header=BB5_24 Depth=2
	movi	v22.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	mov	z26.d, z20.d
	mov	z28.d, z21.d
	cmp	w9, #1
	b.eq	.LBB5_27
.LBB5_26:                               //   in Loop: Header=BB5_24 Depth=2
	sxtw	x30, w21
	add	x19, x2, x30
	ld1b	{ z26.b }, p0/z, [x2, x30]
	ld1b	{ z27.b }, p0/z, [x19, x20]
	tbl	z28.b, { z26.b }, z25.b
	tbl	z30.b, { z26.b }, z23.b
	tbl	z29.b, { z27.b }, z24.b
	tbl	z27.b, { z27.b }, z22.b
	eor	z26.d, z28.d, z29.d
	eor	z28.d, z30.d, z27.d
.LBB5_27:                               //   in Loop: Header=BB5_24 Depth=2
	mov	z27.d, z20.d
	mov	z29.d, z21.d
	cmp	w11, #1
	b.ne	.LBB5_33
// %bb.28:                              //   in Loop: Header=BB5_24 Depth=2
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w13, #1
	b.ne	.LBB5_34
.LBB5_29:                               //   in Loop: Header=BB5_24 Depth=2
	mov	z8.d, z20.d
	mov	z9.d, z21.d
	cmp	w15, #1
	b.ne	.LBB5_35
.LBB5_30:                               //   in Loop: Header=BB5_24 Depth=2
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	cmp	w17, #1
	b.ne	.LBB5_36
.LBB5_31:                               //   in Loop: Header=BB5_24 Depth=2
	cmp	w1, #1
	b.eq	.LBB5_23
	b	.LBB5_37
.LBB5_32:                               //   in Loop: Header=BB5_24 Depth=2
	lsr	z24.b, z20.b, #4
	lsr	z22.b, z21.b, #4
	movprfx	z25, z20
	and	z25.b, z25.b, #0xf
	movprfx	z23, z21
	and	z23.b, z23.b, #0xf
	mov	z26.d, z20.d
	mov	z28.d, z21.d
	cmp	w9, #1
	b.ne	.LBB5_26
	b	.LBB5_27
.LBB5_33:                               //   in Loop: Header=BB5_24 Depth=2
	sxtw	x19, w25
	add	x30, x2, x19
	ld1b	{ z27.b }, p0/z, [x2, x19]
	ld1b	{ z29.b }, p0/z, [x30, x20]
	tbl	z30.b, { z27.b }, z25.b
	tbl	z8.b, { z27.b }, z23.b
	tbl	z31.b, { z29.b }, z24.b
	tbl	z29.b, { z29.b }, z22.b
	eor	z27.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w13, #1
	b.eq	.LBB5_29
.LBB5_34:                               //   in Loop: Header=BB5_24 Depth=2
	sxtw	x19, w26
	add	x30, x2, x19
	ld1b	{ z30.b }, p0/z, [x2, x19]
	ld1b	{ z31.b }, p0/z, [x30, x20]
	tbl	z8.b, { z30.b }, z25.b
	tbl	z10.b, { z30.b }, z23.b
	tbl	z9.b, { z31.b }, z24.b
	tbl	z31.b, { z31.b }, z22.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	mov	z8.d, z20.d
	mov	z9.d, z21.d
	cmp	w15, #1
	b.eq	.LBB5_30
.LBB5_35:                               //   in Loop: Header=BB5_24 Depth=2
	sxtw	x19, w27
	add	x30, x2, x19
	ld1b	{ z8.b }, p0/z, [x2, x19]
	ld1b	{ z9.b }, p0/z, [x30, x20]
	tbl	z10.b, { z8.b }, z25.b
	tbl	z12.b, { z8.b }, z23.b
	tbl	z11.b, { z9.b }, z24.b
	tbl	z9.b, { z9.b }, z22.b
	eor	z8.d, z10.d, z11.d
	eor	z9.d, z12.d, z9.d
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	cmp	w17, #1
	b.eq	.LBB5_31
.LBB5_36:                               //   in Loop: Header=BB5_24 Depth=2
	sxtw	x19, w28
	add	x30, x2, x19
	ld1b	{ z10.b }, p0/z, [x2, x19]
	ld1b	{ z11.b }, p0/z, [x30, x20]
	tbl	z12.b, { z10.b }, z25.b
	tbl	z14.b, { z10.b }, z23.b
	tbl	z13.b, { z11.b }, z24.b
	tbl	z11.b, { z11.b }, z22.b
	eor	z10.d, z12.d, z13.d
	eor	z11.d, z14.d, z11.d
	cmp	w1, #1
	b.eq	.LBB5_23
.LBB5_37:                               //   in Loop: Header=BB5_24 Depth=2
	sxtw	x19, w29
	add	x30, x2, x19
	ld1b	{ z20.b }, p0/z, [x2, x19]
	ld1b	{ z21.b }, p0/z, [x30, x20]
	tbl	z25.b, { z20.b }, z25.b
	tbl	z23.b, { z20.b }, z23.b
	tbl	z24.b, { z21.b }, z24.b
	tbl	z21.b, { z21.b }, z22.b
	eor	z20.d, z25.d, z24.d
	eor	z21.d, z23.d, z21.d
	b	.LBB5_23
.LBB5_38:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w7
	rdvl	x10, #2
.LBB5_39:                               // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB5_41
// %bb.40:                              //   in Loop: Header=BB5_39 Depth=1
	ldr	x11, [x4, #40]
	add	x12, x9, x8
	whilelt	p2.b, w12, w0
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #40]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p1, [x11, x8]
	add	x8, x8, x10
	ldr	x11, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x12, x11]
	b.gt	.LBB5_39
.LBB5_41:
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
.LBB5_42:
	ret
.Lfunc_end5:
	.size	gf_6vect_dot_prod_sve, .Lfunc_end5-gf_6vect_dot_prod_sve
                                        // -- End function
	.globl	gf_7vect_dot_prod_sve           // -- Begin function gf_7vect_dot_prod_sve
	.p2align	2
	.type	gf_7vect_dot_prod_sve,@function
gf_7vect_dot_prod_sve:                  // @gf_7vect_dot_prod_sve
// %bb.0:
	stp	d15, d14, [sp, #-160]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             // 16-byte Folded Spill
	stp	x28, x27, [sp, #80]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #96]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #112]            // 16-byte Folded Spill
	stp	x22, x21, [sp, #128]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #144]            // 16-byte Folded Spill
	sub	sp, sp, #32
	addvl	sp, sp, #-3
	cmp	w0, #16
	str	x3, [sp, #24]                   // 8-byte Spill
	b.ge	.LBB6_2
.LBB6_1:
	addvl	sp, sp, #3
	add	sp, sp, #32
	ldp	x20, x19, [sp, #144]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #128]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #112]            // 16-byte Folded Reload
	ldp	x26, x25, [sp, #96]             // 16-byte Folded Reload
	ldp	x28, x27, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x30, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #160            // 16-byte Folded Reload
	ret
.LBB6_2:
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x10, #1
	b.lt	.LBB6_44
// %bb.3:
	mov	w11, w1
	mov	x12, xzr
	lsl	x8, x11, #5
	sub	x13, x8, #32
.LBB6_4:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w12, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x13, x12, #4, eq
	add	x12, x12, #32
	b.ne	.LBB6_4
// %bb.5:
	lsl	w12, w1, #5
	sub	x7, x11, #1
	mov	x13, x7
	str	w12, [sp, #20]                  // 4-byte Spill
.LBB6_6:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB6_8
// %bb.7:                               //   in Loop: Header=BB6_6 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB6_6
.LBB6_8:
	lsl	w14, w1, #6
	mov	x15, x7
	str	w14, [sp, #16]                  // 4-byte Spill
.LBB6_9:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w16, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB6_11
// %bb.10:                              //   in Loop: Header=BB6_9 Depth=1
	add	w14, w14, #32
	tbnz	w16, #0, .LBB6_9
.LBB6_11:
	add	w5, w1, w1, lsl #1
	mov	x17, x7
	lsl	w14, w5, #5
	mov	w16, w14
.LBB6_12:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	subs	x17, x17, #1
	cset	w18, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB6_14
// %bb.13:                              //   in Loop: Header=BB6_12 Depth=1
	add	w16, w16, #32
	tbnz	w18, #0, .LBB6_12
.LBB6_14:
	lsl	w16, w1, #7
	mov	x6, x7
	mov	w18, w16
.LBB6_15:                               // =>This Inner Loop Header: Depth=1
	add	x17, x2, w18, sxtw
	subs	x6, x6, #1
	cset	w19, hs
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	b.ne	.LBB6_17
// %bb.16:                              //   in Loop: Header=BB6_15 Depth=1
	add	w18, w18, #32
	tbnz	w19, #0, .LBB6_15
.LBB6_17:
	add	w18, w1, w1, lsl #2
	mov	x19, x7
	lsl	w18, w18, #5
	mov	w6, w18
.LBB6_18:                               // =>This Inner Loop Header: Depth=1
	add	x1, x2, w6, sxtw
	subs	x19, x19, #1
	cset	w20, hs
	ldrb	w1, [x1, #1]
	cmp	w1, #1
	b.ne	.LBB6_20
// %bb.19:                              //   in Loop: Header=BB6_18 Depth=1
	add	w6, w6, #32
	tbnz	w20, #0, .LBB6_18
.LBB6_20:
	lsl	w5, w5, #6
	mov	w19, w5
.LBB6_21:                               // =>This Inner Loop Header: Depth=1
	add	x6, x2, w19, sxtw
	subs	x7, x7, #1
	cset	w20, hs
	ldrb	w6, [x6, #1]
	cmp	w6, #1
	b.ne	.LBB6_23
// %bb.22:                              //   in Loop: Header=BB6_21 Depth=1
	add	w19, w19, #32
	tbnz	w20, #0, .LBB6_21
.LBB6_23:
	cmp	w11, #1
	mov	x7, xzr
	mov	w20, w10
	ccmp	w9, #1, #0, eq
	mov	w22, #16                        // =0x10
	ccmp	w13, #1, #0, eq
	ccmp	w15, #1, #0, eq
	ccmp	w17, #1, #0, eq
	ccmp	w1, #1, #0, eq
	ccmp	w6, #1, #0, eq
	cset	w19, eq
	b	.LBB6_25
.LBB6_24:                               //   in Loop: Header=BB6_25 Depth=1
	ldr	x10, [x4, #48]
	cmp	w0, w25
	st1b	{ z19.b }, p1, [x10, x7]
	ldr	x10, [x4, #48]
	st1b	{ z21.b }, p2, [x10, x23]
	ldr	x10, [x4, #40]
	st1b	{ z17.b }, p1, [x10, x7]
	ldr	x10, [x4, #40]
	st1b	{ z20.b }, p2, [x10, x23]
	ldr	x10, [x4, #32]
	st1b	{ z7.b }, p1, [x10, x7]
	ldr	x10, [x4, #32]
	st1b	{ z18.b }, p2, [x10, x23]
	ldr	x10, [x4, #24]
	st1b	{ z5.b }, p1, [x10, x7]
	ldr	x10, [x4, #24]
	st1b	{ z16.b }, p2, [x10, x23]
	ldr	x10, [x4, #16]
	st1b	{ z3.b }, p1, [x10, x7]
	ldr	x10, [x4, #16]
	st1b	{ z6.b }, p2, [x10, x23]
	ldr	x10, [x4, #8]
	st1b	{ z2.b }, p1, [x10, x7]
	ldr	x10, [x4, #8]
	st1b	{ z4.b }, p2, [x10, x23]
	ldr	x10, [x4]
	st1b	{ z0.b }, p1, [x10, x7]
	mov	x7, x25
	ldr	x10, [x4]
	st1b	{ z1.b }, p2, [x10, x23]
	b.le	.LBB6_1
.LBB6_25:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB6_28 Depth 2
	whilelt	p1.b, w7, w0
	ptest	p0, p1.b
	b.eq	.LBB6_1
// %bb.26:                              //   in Loop: Header=BB6_25 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	x23, x7, x20
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	rdvl	x10, #2
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	ldr	x26, [sp, #24]                  // 8-byte Reload
	movi	v19.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x24, xzr
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	add	x25, x7, x10
	movi	v16.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	mov	w29, w14
	movi	v20.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	mov	w30, w16
	ldp	w28, w27, [sp, #16]             // 8-byte Folded Reload
	whilelt	p2.b, w23, w0
	mov	w21, w18
	mov	w10, w5
	b	.LBB6_28
.LBB6_27:                               //   in Loop: Header=BB6_28 Depth=2
	eor	z0.d, z0.d, z28.d
	eor	z1.d, z1.d, z29.d
	add	x24, x24, #32
	eor	z2.d, z2.d, z30.d
	eor	z4.d, z4.d, z31.d
	add	w10, w10, #32
	eor	z3.d, z3.d, z8.d
	eor	z6.d, z6.d, z9.d
	add	w21, w21, #32
	eor	z5.d, z5.d, z10.d
	eor	z16.d, z16.d, z11.d
	add	w30, w30, #32
	eor	z7.d, z7.d, z12.d
	eor	z18.d, z18.d, z13.d
	cmp	x8, x24
	eor	z17.d, z17.d, z14.d
	eor	z20.d, z20.d, z15.d
	add	w29, w29, #32
	eor	z19.d, z19.d, z22.d
	eor	z21.d, z21.d, z23.d
	add	w28, w28, #32
	add	w27, w27, #32
	b.eq	.LBB6_24
.LBB6_28:                               //   Parent Loop BB6_25 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x3, [x26], #8
	ld1b	{ z22.b }, p1/z, [x3, x7]
	ld1b	{ z23.b }, p2/z, [x3, x23]
	tbz	w19, #0, .LBB6_37
// %bb.29:                              //   in Loop: Header=BB6_28 Depth=2
	movi	v24.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	mov	z28.d, z22.d
	mov	z29.d, z23.d
	cmp	w9, #1
	b.eq	.LBB6_31
.LBB6_30:                               //   in Loop: Header=BB6_28 Depth=2
	sxtw	x3, w24
	add	x12, x2, x3
	ld1b	{ z28.b }, p0/z, [x2, x3]
	ld1b	{ z29.b }, p0/z, [x12, x22]
	tbl	z30.b, { z28.b }, z27.b
	tbl	z8.b, { z28.b }, z25.b
	tbl	z31.b, { z29.b }, z26.b
	tbl	z29.b, { z29.b }, z24.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
.LBB6_31:                               //   in Loop: Header=BB6_28 Depth=2
	mov	z30.d, z22.d
	mov	z31.d, z23.d
	cmp	w11, #1
	b.ne	.LBB6_38
// %bb.32:                              //   in Loop: Header=BB6_28 Depth=2
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	cmp	w13, #1
	b.ne	.LBB6_39
.LBB6_33:                               //   in Loop: Header=BB6_28 Depth=2
	mov	z10.d, z22.d
	mov	z11.d, z23.d
	cmp	w15, #1
	b.ne	.LBB6_40
.LBB6_34:                               //   in Loop: Header=BB6_28 Depth=2
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w17, #1
	b.ne	.LBB6_41
.LBB6_35:                               //   in Loop: Header=BB6_28 Depth=2
	mov	z14.d, z22.d
	mov	z15.d, z23.d
	cmp	w1, #1
	b.ne	.LBB6_42
.LBB6_36:                               //   in Loop: Header=BB6_28 Depth=2
	cmp	w6, #1
	b.eq	.LBB6_27
	b	.LBB6_43
.LBB6_37:                               //   in Loop: Header=BB6_28 Depth=2
	lsr	z26.b, z22.b, #4
	lsr	z24.b, z23.b, #4
	movprfx	z27, z22
	and	z27.b, z27.b, #0xf
	movprfx	z25, z23
	and	z25.b, z25.b, #0xf
	mov	z28.d, z22.d
	mov	z29.d, z23.d
	cmp	w9, #1
	b.ne	.LBB6_30
	b	.LBB6_31
.LBB6_38:                               //   in Loop: Header=BB6_28 Depth=2
	sxtw	x12, w27
	add	x3, x2, x12
	ld1b	{ z30.b }, p0/z, [x2, x12]
	ld1b	{ z31.b }, p0/z, [x3, x22]
	tbl	z8.b, { z30.b }, z27.b
	tbl	z10.b, { z30.b }, z25.b
	tbl	z9.b, { z31.b }, z26.b
	tbl	z31.b, { z31.b }, z24.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	cmp	w13, #1
	b.eq	.LBB6_33
.LBB6_39:                               //   in Loop: Header=BB6_28 Depth=2
	sxtw	x12, w28
	add	x3, x2, x12
	ld1b	{ z8.b }, p0/z, [x2, x12]
	ld1b	{ z9.b }, p0/z, [x3, x22]
	tbl	z10.b, { z8.b }, z27.b
	tbl	z12.b, { z8.b }, z25.b
	tbl	z11.b, { z9.b }, z26.b
	tbl	z9.b, { z9.b }, z24.b
	eor	z8.d, z10.d, z11.d
	eor	z9.d, z12.d, z9.d
	mov	z10.d, z22.d
	mov	z11.d, z23.d
	cmp	w15, #1
	b.eq	.LBB6_34
.LBB6_40:                               //   in Loop: Header=BB6_28 Depth=2
	sxtw	x12, w29
	add	x3, x2, x12
	ld1b	{ z10.b }, p0/z, [x2, x12]
	ld1b	{ z11.b }, p0/z, [x3, x22]
	tbl	z12.b, { z10.b }, z27.b
	tbl	z14.b, { z10.b }, z25.b
	tbl	z13.b, { z11.b }, z26.b
	tbl	z11.b, { z11.b }, z24.b
	eor	z10.d, z12.d, z13.d
	eor	z11.d, z14.d, z11.d
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w17, #1
	b.eq	.LBB6_35
.LBB6_41:                               //   in Loop: Header=BB6_28 Depth=2
	sxtw	x12, w30
	add	x3, x2, x12
	ld1b	{ z12.b }, p0/z, [x2, x12]
	add	x12, sp, #32
	ld1b	{ z13.b }, p0/z, [x3, x22]
	str	z11, [x12, #2, mul vl]          // 16-byte Folded Spill
	mov	z11.d, z10.d
	mov	z10.d, z9.d
	mov	z9.d, z8.d
	mov	z8.d, z18.d
	tbl	z14.b, { z12.b }, z27.b
	mov	z18.d, z17.d
	mov	z17.d, z16.d
	tbl	z15.b, { z13.b }, z26.b
	mov	z16.d, z7.d
	mov	z7.d, z6.d
	mov	z6.d, z5.d
	mov	z5.d, z4.d
	mov	z4.d, z3.d
	mov	z3.d, z2.d
	mov	z2.d, z1.d
	mov	z1.d, z0.d
	mov	z0.d, z31.d
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
	mov	z31.d, z0.d
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
	mov	z18.d, z8.d
	mov	z8.d, z9.d
	mov	z9.d, z10.d
	mov	z10.d, z11.d
	ldr	z11, [x12, #2, mul vl]          // 16-byte Folded Reload
	mov	z14.d, z22.d
	mov	z15.d, z23.d
	cmp	w1, #1
	b.eq	.LBB6_36
.LBB6_42:                               //   in Loop: Header=BB6_28 Depth=2
	sxtw	x12, w21
	str	x8, [sp]                        // 8-byte Spill
	add	x8, sp, #32
	str	z17, [x8]                       // 16-byte Folded Spill
	mov	z17.d, z6.d
	mov	z6.d, z3.d
	add	x3, x2, x12
	mov	z3.d, z1.d
	mov	z1.d, z31.d
	mov	z31.d, z28.d
	ld1b	{ z28.b }, p0/z, [x2, x12]
	ld1b	{ z14.b }, p0/z, [x3, x22]
	str	z10, [x8, #2, mul vl]           // 16-byte Folded Spill
	mov	z10.d, z16.d
	mov	z16.d, z5.d
	str	z18, [x8, #1, mul vl]           // 16-byte Folded Spill
	mov	z18.d, z7.d
	mov	z7.d, z4.d
	mov	z5.d, z2.d
	mov	z2.d, z0.d
	tbl	z15.b, { z28.b }, z27.b
	mov	z0.d, z13.d
	mov	z13.d, z11.d
	mov	z11.d, z29.d
	tbl	z29.b, { z14.b }, z26.b
	tbl	z28.b, { z28.b }, z25.b
	mov	z4.d, z27.d
	mov	z27.d, z26.d
	mov	z26.d, z25.d
	add	x12, sp, #32
	mov	z25.d, z12.d
	mov	z12.d, z21.d
	ldr	x8, [sp]                        // 8-byte Reload
	mov	z21.d, z20.d
	mov	z20.d, z19.d
	mov	z19.d, z9.d
	mov	z9.d, z30.d
	tbl	z30.b, { z14.b }, z24.b
	eor	z14.d, z15.d, z29.d
	mov	z29.d, z11.d
	mov	z11.d, z13.d
	mov	z13.d, z0.d
	mov	z0.d, z2.d
	mov	z2.d, z5.d
	mov	z5.d, z16.d
	mov	z16.d, z10.d
	ldr	z10, [x12, #2, mul vl]          // 16-byte Folded Reload
	eor	z15.d, z28.d, z30.d
	mov	z30.d, z9.d
	mov	z9.d, z19.d
	mov	z19.d, z20.d
	mov	z20.d, z21.d
	mov	z21.d, z12.d
	mov	z12.d, z25.d
	mov	z25.d, z26.d
	mov	z26.d, z27.d
	mov	z27.d, z4.d
	mov	z28.d, z31.d
	mov	z31.d, z1.d
	mov	z1.d, z3.d
	mov	z3.d, z6.d
	mov	z4.d, z7.d
	mov	z6.d, z17.d
	ldr	z17, [x12]                      // 16-byte Folded Reload
	mov	z7.d, z18.d
	ldr	z18, [x12, #1, mul vl]          // 16-byte Folded Reload
	cmp	w6, #1
	b.eq	.LBB6_27
.LBB6_43:                               //   in Loop: Header=BB6_28 Depth=2
	sxtw	x12, w10
	add	x3, x2, x12
	ld1b	{ z22.b }, p0/z, [x2, x12]
	ld1b	{ z23.b }, p0/z, [x3, x22]
	tbl	z27.b, { z22.b }, z27.b
	tbl	z25.b, { z22.b }, z25.b
	tbl	z26.b, { z23.b }, z26.b
	tbl	z23.b, { z23.b }, z24.b
	eor	z22.d, z27.d, z26.d
	eor	z23.d, z25.d, z23.d
	b	.LBB6_27
.LBB6_44:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w10
	rdvl	x10, #2
.LBB6_45:                               // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB6_1
// %bb.46:                              //   in Loop: Header=BB6_45 Depth=1
	ldr	x11, [x4, #48]
	add	x12, x9, x8
	whilelt	p2.b, w12, w0
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #48]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #40]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #40]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #32]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #24]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #16]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p1, [x11, x8]
	ldr	x11, [x4, #8]
	st1b	{ z0.b }, p2, [x12, x11]
	ldr	x11, [x4]
	st1b	{ z0.b }, p1, [x11, x8]
	add	x8, x8, x10
	ldr	x11, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x12, x11]
	b.gt	.LBB6_45
	b	.LBB6_1
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
	rdvl	x14, #1
	ptrue	p0.b, vl16
	cmp	w1, #1
	lsr	x12, x14, #4
	b.lt	.LBB7_13
// %bb.3:
	mov	w8, w1
	mov	x11, xzr
	lsl	x9, x8, #5
	sub	x13, x9, #32
.LBB7_4:                                // =>This Inner Loop Header: Depth=1
	add	x10, x2, w11, sxtw
	ldrb	w10, [x10, #1]
	cmp	w10, #1
	ccmp	x13, x11, #4, eq
	add	x11, x11, #32
	b.ne	.LBB7_4
// %bb.5:
	add	w13, w12, w12, lsl #1
	lsl	w12, w12, #5
	mov	x11, xzr
	mov	w14, w14
	mov	w15, #16                        // =0x10
	lsl	w13, w13, #4
	b	.LBB7_7
.LBB7_6:                                //   in Loop: Header=BB7_7 Depth=1
	st1b	{ z2.b }, p1, [x4, x11]
	incb	x11, all, mul #4
	st1b	{ z1.b }, p2, [x4, x16]
	st1b	{ z3.b }, p4, [x4, x18]
	cmp	w0, w11
	st1b	{ z0.b }, p3, [x4, x17]
	b.le	.LBB7_1
.LBB7_7:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB7_12 Depth 2
                                        //     Child Loop BB7_10 Depth 2
	whilelt	p1.b, w11, w0
	ptest	p0, p1.b
	b.eq	.LBB7_1
// %bb.8:                               //   in Loop: Header=BB7_7 Depth=1
	add	x16, x11, x14
	add	x18, x11, x12
	add	x17, x11, x13
	whilelt	p2.b, w16, w0
	whilelt	p4.b, w18, w0
	whilelt	p3.b, w17, w0
	cmp	w10, #1
	b.eq	.LBB7_11
// %bb.9:                               //   in Loop: Header=BB7_7 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x1, xzr
	movi	v3.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	mov	x5, x3
.LBB7_10:                               //   Parent Loop BB7_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x6, [x5], #8
	sxtw	x7, w1
	add	x1, x1, #32
	ld1b	{ z4.b }, p1/z, [x6, x11]
	ld1b	{ z5.b }, p4/z, [x6, x18]
	ld1b	{ z6.b }, p2/z, [x6, x16]
	ld1b	{ z7.b }, p3/z, [x6, x17]
	add	x6, x2, x7
	ld1b	{ z16.b }, p0/z, [x2, x7]
	ld1b	{ z17.b }, p0/z, [x6, x15]
	cmp	x9, x1
	lsr	z18.b, z4.b, #4
	and	z4.b, z4.b, #0xf
	movprfx	z19, z5
	and	z19.b, z19.b, #0xf
	lsr	z20.b, z6.b, #4
	and	z6.b, z6.b, #0xf
	lsr	z21.b, z7.b, #4
	and	z7.b, z7.b, #0xf
	lsr	z5.b, z5.b, #4
	tbl	z4.b, { z16.b }, z4.b
	tbl	z18.b, { z17.b }, z18.b
	tbl	z19.b, { z16.b }, z19.b
	tbl	z6.b, { z16.b }, z6.b
	tbl	z20.b, { z17.b }, z20.b
	tbl	z5.b, { z17.b }, z5.b
	tbl	z7.b, { z16.b }, z7.b
	tbl	z16.b, { z17.b }, z21.b
	eor3	z2.d, z2.d, z4.d, z18.d
	eor3	z1.d, z1.d, z6.d, z20.d
	eor3	z3.d, z3.d, z19.d, z5.d
	eor3	z0.d, z0.d, z7.d, z16.d
	b.ne	.LBB7_10
	b	.LBB7_6
.LBB7_11:                               //   in Loop: Header=BB7_7 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x1, x8
	movi	v3.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	mov	x5, x3
.LBB7_12:                               //   Parent Loop BB7_7 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x6, [x5], #8
	subs	x1, x1, #1
	ld1b	{ z4.b }, p1/z, [x6, x11]
	ld1b	{ z5.b }, p2/z, [x6, x16]
	ld1b	{ z6.b }, p4/z, [x6, x18]
	ld1b	{ z7.b }, p3/z, [x6, x17]
	eor	z2.d, z2.d, z4.d
	eor	z1.d, z1.d, z5.d
	eor	z3.d, z3.d, z6.d
	eor	z0.d, z0.d, z7.d
	b.ne	.LBB7_12
	b	.LBB7_6
.LBB7_13:
	add	w10, w12, w12, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w12, #5
	mov	w11, w14
	mov	x8, xzr
	lsl	w10, w10, #4
	add	x12, x4, x11
	add	x13, x4, x9
	add	x14, x4, x10
.LBB7_14:                               // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB7_1
// %bb.15:                              //   in Loop: Header=BB7_14 Depth=1
	add	w15, w11, w8
	add	w16, w9, w8
	st1b	{ z0.b }, p1, [x4, x8]
	whilelt	p2.b, w15, w0
	add	w15, w10, w8
	whilelt	p1.b, w16, w0
	whilelt	p3.b, w15, w0
	st1b	{ z0.b }, p2, [x12, x8]
	st1b	{ z0.b }, p1, [x13, x8]
	st1b	{ z0.b }, p3, [x14, x8]
	incb	x8, all, mul #4
	cmp	w0, w8
	b.gt	.LBB7_14
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
	ptrue	p0.b, vl16
	cmp	w1, #1
	lsr	x13, x15, #4
	stp	d11, d10, [sp, #8]              // 16-byte Folded Spill
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
	mov	x12, xzr
	mov	w15, w15
	lsl	w14, w14, #4
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
	ptest	p0, p1.b
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
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB8_20
// %bb.19:                              //   in Loop: Header=BB8_18 Depth=1
	ldr	x12, [x4, #8]
	add	x13, x11, x8
	add	x14, x9, x8
	whilelt	p4.b, w13, w0
	add	x15, x10, x8
	st1b	{ z0.b }, p1, [x12, x8]
	whilelt	p3.b, w14, w0
	ldr	x12, [x4, #8]
	whilelt	p2.b, w15, w0
	st1b	{ z0.b }, p4, [x13, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p3, [x14, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p2, [x15, x12]
	ldr	x12, [x4]
	st1b	{ z0.b }, p1, [x12, x8]
	incb	x8, all, mul #4
	ldr	x12, [x4]
	st1b	{ z0.b }, p4, [x13, x12]
	cmp	w0, w8
	ldr	x12, [x4]
	st1b	{ z0.b }, p3, [x14, x12]
	ldr	x12, [x4]
	st1b	{ z0.b }, p2, [x15, x12]
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
	b.lt	.LBB9_27
// %bb.1:
	str	x21, [sp, #-32]!                // 8-byte Folded Spill
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x16, #1
	stp	x20, x19, [sp, #16]             // 16-byte Folded Spill
	b.lt	.LBB9_23
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB9_3:                                // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB9_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x14, x11, #1
	mov	x13, x14
	mov	w12, w10
.LBB9_5:                                // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w15, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB9_7
// %bb.6:                               //   in Loop: Header=BB9_5 Depth=1
	add	w12, w12, #32
	tbnz	w15, #0, .LBB9_5
.LBB9_7:
	lsl	w12, w1, #6
	mov	w15, w12
.LBB9_8:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w15, sxtw
	subs	x14, x14, #1
	cset	w17, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB9_10
// %bb.9:                               //   in Loop: Header=BB9_8 Depth=1
	add	w15, w15, #32
	tbnz	w17, #0, .LBB9_8
.LBB9_10:
	cmp	w11, #1
	mov	x15, xzr
	mov	w16, w16
	ccmp	w9, #1, #0, eq
	mov	w17, #16                        // =0x10
	ccmp	w13, #1, #0, eq
	cset	w14, eq
	b	.LBB9_12
.LBB9_11:                               //   in Loop: Header=BB9_12 Depth=1
	ldr	x1, [x4, #16]
	cmp	w0, w18
	st1b	{ z4.b }, p1, [x1, x15]
	ldr	x1, [x4, #16]
	st1b	{ z5.b }, p2, [x1, x5]
	ldr	x1, [x4, #8]
	st1b	{ z2.b }, p1, [x1, x15]
	ldr	x1, [x4, #8]
	st1b	{ z3.b }, p2, [x1, x5]
	ldr	x1, [x4]
	st1b	{ z1.b }, p1, [x1, x15]
	ldr	x15, [x4]
	st1b	{ z0.b }, p2, [x15, x5]
	mov	x15, x18
	b.le	.LBB9_26
.LBB9_12:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB9_15 Depth 2
	whilelt	p1.b, w15, w0
	ptest	p0, p1.b
	b.eq	.LBB9_26
// %bb.13:                              //   in Loop: Header=BB9_12 Depth=1
	mov	x18, x15
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	add	x5, x15, x16
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	incb	x18, all, mul #2
	whilelt	p2.b, w5, w0
	mov	x1, xzr
	mov	x6, x3
	mov	w7, w10
	mov	w19, w12
	b	.LBB9_15
.LBB9_14:                               //   in Loop: Header=BB9_15 Depth=2
	eor	z1.d, z1.d, z20.d
	eor	z0.d, z0.d, z21.d
	add	x1, x1, #32
	eor	z2.d, z2.d, z22.d
	eor	z3.d, z3.d, z23.d
	cmp	x8, x1
	eor	z4.d, z4.d, z6.d
	eor	z5.d, z5.d, z7.d
	add	w19, w19, #32
	add	w7, w7, #32
	b.eq	.LBB9_11
.LBB9_15:                               //   Parent Loop BB9_12 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x20, [x6], #8
	ld1b	{ z6.b }, p1/z, [x20, x15]
	ld1b	{ z7.b }, p2/z, [x20, x5]
	tbz	w14, #0, .LBB9_20
// %bb.16:                              //   in Loop: Header=BB9_15 Depth=2
	movi	v16.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	z20.d, z6.d
	mov	z21.d, z7.d
	cmp	w9, #1
	b.eq	.LBB9_18
.LBB9_17:                               //   in Loop: Header=BB9_15 Depth=2
	sxtw	x20, w1
	add	x21, x2, x20
	ld1b	{ z20.b }, p0/z, [x2, x20]
	ld1b	{ z21.b }, p0/z, [x21, x17]
	tbl	z22.b, { z20.b }, z19.b
	tbl	z24.b, { z20.b }, z17.b
	tbl	z23.b, { z21.b }, z18.b
	tbl	z21.b, { z21.b }, z16.b
	eor	z20.d, z22.d, z23.d
	eor	z21.d, z24.d, z21.d
.LBB9_18:                               //   in Loop: Header=BB9_15 Depth=2
	mov	z22.d, z6.d
	mov	z23.d, z7.d
	cmp	w11, #1
	b.ne	.LBB9_21
// %bb.19:                              //   in Loop: Header=BB9_15 Depth=2
	cmp	w13, #1
	b.eq	.LBB9_14
	b	.LBB9_22
.LBB9_20:                               //   in Loop: Header=BB9_15 Depth=2
	lsr	z18.b, z6.b, #4
	lsr	z16.b, z7.b, #4
	movprfx	z19, z6
	and	z19.b, z19.b, #0xf
	movprfx	z17, z7
	and	z17.b, z17.b, #0xf
	mov	z20.d, z6.d
	mov	z21.d, z7.d
	cmp	w9, #1
	b.ne	.LBB9_17
	b	.LBB9_18
.LBB9_21:                               //   in Loop: Header=BB9_15 Depth=2
	sxtw	x20, w7
	add	x21, x2, x20
	ld1b	{ z22.b }, p0/z, [x2, x20]
	ld1b	{ z23.b }, p0/z, [x21, x17]
	tbl	z24.b, { z22.b }, z19.b
	tbl	z26.b, { z22.b }, z17.b
	tbl	z25.b, { z23.b }, z18.b
	tbl	z23.b, { z23.b }, z16.b
	eor	z22.d, z24.d, z25.d
	eor	z23.d, z26.d, z23.d
	cmp	w13, #1
	b.eq	.LBB9_14
.LBB9_22:                               //   in Loop: Header=BB9_15 Depth=2
	sxtw	x20, w19
	add	x21, x2, x20
	ld1b	{ z6.b }, p0/z, [x2, x20]
	ld1b	{ z7.b }, p0/z, [x21, x17]
	tbl	z19.b, { z6.b }, z19.b
	tbl	z17.b, { z6.b }, z17.b
	tbl	z18.b, { z7.b }, z18.b
	tbl	z7.b, { z7.b }, z16.b
	eor	z6.d, z19.d, z18.d
	eor	z7.d, z17.d, z7.d
	b	.LBB9_14
.LBB9_23:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w16
.LBB9_24:                               // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB9_26
// %bb.25:                              //   in Loop: Header=BB9_24 Depth=1
	ldr	x10, [x4, #16]
	add	x11, x9, x8
	whilelt	p2.b, w11, w0
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #16]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4]
	st1b	{ z0.b }, p1, [x10, x8]
	incb	x8, all, mul #2
	ldr	x10, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x11, x10]
	b.gt	.LBB9_24
.LBB9_26:
	ldp	x20, x19, [sp, #16]             // 16-byte Folded Reload
	ldr	x21, [sp], #32                  // 8-byte Folded Reload
.LBB9_27:
	ret
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
	stp	x24, x23, [sp, #-48]!           // 16-byte Folded Spill
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x18, #1
	stp	x22, x21, [sp, #16]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #32]             // 16-byte Folded Spill
	b.lt	.LBB10_28
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB10_3:                               // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB10_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x16, x11, #1
	mov	x13, x16
	mov	w12, w10
.LBB10_5:                               // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB10_7
// %bb.6:                               //   in Loop: Header=BB10_5 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB10_5
.LBB10_7:
	lsl	w12, w1, #6
	mov	x15, x16
	mov	w14, w12
.LBB10_8:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w17, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB10_10
// %bb.9:                               //   in Loop: Header=BB10_8 Depth=1
	add	w14, w14, #32
	tbnz	w17, #0, .LBB10_8
.LBB10_10:
	add	w14, w1, w1, lsl #1
	lsl	w14, w14, #5
	mov	w17, w14
.LBB10_11:                              // =>This Inner Loop Header: Depth=1
	add	x15, x2, w17, sxtw
	subs	x16, x16, #1
	cset	w1, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB10_13
// %bb.12:                              //   in Loop: Header=BB10_11 Depth=1
	add	w17, w17, #32
	tbnz	w1, #0, .LBB10_11
.LBB10_13:
	cmp	w11, #1
	mov	x17, xzr
	mov	w18, w18
	ccmp	w9, #1, #0, eq
	mov	w1, #16                         // =0x10
	ccmp	w13, #1, #0, eq
	ccmp	w15, #1, #0, eq
	cset	w16, eq
	b	.LBB10_15
.LBB10_14:                              //   in Loop: Header=BB10_15 Depth=1
	ldr	x6, [x4, #24]
	cmp	w0, w5
	st1b	{ z6.b }, p1, [x6, x17]
	ldr	x6, [x4, #24]
	st1b	{ z7.b }, p2, [x6, x7]
	ldr	x6, [x4, #16]
	st1b	{ z4.b }, p1, [x6, x17]
	ldr	x6, [x4, #16]
	st1b	{ z5.b }, p2, [x6, x7]
	ldr	x6, [x4, #8]
	st1b	{ z2.b }, p1, [x6, x17]
	ldr	x6, [x4, #8]
	st1b	{ z3.b }, p2, [x6, x7]
	ldr	x6, [x4]
	st1b	{ z0.b }, p1, [x6, x17]
	ldr	x17, [x4]
	st1b	{ z1.b }, p2, [x17, x7]
	mov	x17, x5
	b.le	.LBB10_31
.LBB10_15:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB10_18 Depth 2
	whilelt	p1.b, w17, w0
	ptest	p0, p1.b
	b.eq	.LBB10_31
// %bb.16:                              //   in Loop: Header=BB10_15 Depth=1
	mov	x5, x17
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	add	x7, x17, x18
	movi	v1.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	incb	x5, all, mul #2
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x6, xzr
	whilelt	p2.b, w7, w0
	mov	x19, x3
	mov	w20, w10
	mov	w21, w12
	mov	w22, w14
	b	.LBB10_18
.LBB10_17:                              //   in Loop: Header=BB10_18 Depth=2
	eor	z0.d, z0.d, z22.d
	eor	z1.d, z1.d, z23.d
	add	x6, x6, #32
	eor	z2.d, z2.d, z24.d
	eor	z3.d, z3.d, z25.d
	cmp	x8, x6
	eor	z4.d, z4.d, z26.d
	eor	z5.d, z5.d, z27.d
	add	w22, w22, #32
	eor	z6.d, z6.d, z16.d
	eor	z7.d, z7.d, z17.d
	add	w21, w21, #32
	add	w20, w20, #32
	b.eq	.LBB10_14
.LBB10_18:                              //   Parent Loop BB10_15 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x23, [x19], #8
	ld1b	{ z16.b }, p1/z, [x23, x17]
	ld1b	{ z17.b }, p2/z, [x23, x7]
	tbz	w16, #0, .LBB10_24
// %bb.19:                              //   in Loop: Header=BB10_18 Depth=2
	movi	v18.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	mov	z22.d, z16.d
	mov	z23.d, z17.d
	cmp	w9, #1
	b.eq	.LBB10_21
.LBB10_20:                              //   in Loop: Header=BB10_18 Depth=2
	sxtw	x23, w6
	add	x24, x2, x23
	ld1b	{ z22.b }, p0/z, [x2, x23]
	ld1b	{ z23.b }, p0/z, [x24, x1]
	tbl	z24.b, { z22.b }, z21.b
	tbl	z26.b, { z22.b }, z19.b
	tbl	z25.b, { z23.b }, z20.b
	tbl	z23.b, { z23.b }, z18.b
	eor	z22.d, z24.d, z25.d
	eor	z23.d, z26.d, z23.d
.LBB10_21:                              //   in Loop: Header=BB10_18 Depth=2
	mov	z24.d, z16.d
	mov	z25.d, z17.d
	cmp	w11, #1
	b.ne	.LBB10_25
// %bb.22:                              //   in Loop: Header=BB10_18 Depth=2
	mov	z26.d, z16.d
	mov	z27.d, z17.d
	cmp	w13, #1
	b.ne	.LBB10_26
.LBB10_23:                              //   in Loop: Header=BB10_18 Depth=2
	cmp	w15, #1
	b.eq	.LBB10_17
	b	.LBB10_27
.LBB10_24:                              //   in Loop: Header=BB10_18 Depth=2
	lsr	z20.b, z16.b, #4
	lsr	z18.b, z17.b, #4
	movprfx	z21, z16
	and	z21.b, z21.b, #0xf
	movprfx	z19, z17
	and	z19.b, z19.b, #0xf
	mov	z22.d, z16.d
	mov	z23.d, z17.d
	cmp	w9, #1
	b.ne	.LBB10_20
	b	.LBB10_21
.LBB10_25:                              //   in Loop: Header=BB10_18 Depth=2
	sxtw	x23, w20
	add	x24, x2, x23
	ld1b	{ z24.b }, p0/z, [x2, x23]
	ld1b	{ z25.b }, p0/z, [x24, x1]
	tbl	z26.b, { z24.b }, z21.b
	tbl	z28.b, { z24.b }, z19.b
	tbl	z27.b, { z25.b }, z20.b
	tbl	z25.b, { z25.b }, z18.b
	eor	z24.d, z26.d, z27.d
	eor	z25.d, z28.d, z25.d
	mov	z26.d, z16.d
	mov	z27.d, z17.d
	cmp	w13, #1
	b.eq	.LBB10_23
.LBB10_26:                              //   in Loop: Header=BB10_18 Depth=2
	sxtw	x23, w21
	add	x24, x2, x23
	ld1b	{ z26.b }, p0/z, [x2, x23]
	ld1b	{ z27.b }, p0/z, [x24, x1]
	tbl	z28.b, { z26.b }, z21.b
	tbl	z30.b, { z26.b }, z19.b
	tbl	z29.b, { z27.b }, z20.b
	tbl	z27.b, { z27.b }, z18.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	cmp	w15, #1
	b.eq	.LBB10_17
.LBB10_27:                              //   in Loop: Header=BB10_18 Depth=2
	sxtw	x23, w22
	add	x24, x2, x23
	ld1b	{ z16.b }, p0/z, [x2, x23]
	ld1b	{ z17.b }, p0/z, [x24, x1]
	tbl	z21.b, { z16.b }, z21.b
	tbl	z19.b, { z16.b }, z19.b
	tbl	z20.b, { z17.b }, z20.b
	tbl	z17.b, { z17.b }, z18.b
	eor	z16.d, z21.d, z20.d
	eor	z17.d, z19.d, z17.d
	b	.LBB10_17
.LBB10_28:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w18
.LBB10_29:                              // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB10_31
// %bb.30:                              //   in Loop: Header=BB10_29 Depth=1
	ldr	x10, [x4, #24]
	add	x11, x9, x8
	whilelt	p2.b, w11, w0
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #24]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #16]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #16]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4]
	st1b	{ z0.b }, p1, [x10, x8]
	incb	x8, all, mul #2
	ldr	x10, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x11, x10]
	b.gt	.LBB10_29
.LBB10_31:
	ldp	x20, x19, [sp, #32]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #16]             // 16-byte Folded Reload
	ldp	x24, x23, [sp], #48             // 16-byte Folded Reload
.LBB10_32:
	ret
.Lfunc_end10:
	.size	gf_4vect_dot_prod_sve2, .Lfunc_end10-gf_4vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_5vect_dot_prod_sve2          // -- Begin function gf_5vect_dot_prod_sve2
	.p2align	2
	.type	gf_5vect_dot_prod_sve2,@function
gf_5vect_dot_prod_sve2:                 // @gf_5vect_dot_prod_sve2
// %bb.0:
	cmp	w0, #16
	b.lt	.LBB11_37
// %bb.1:
	str	d10, [sp, #-96]!                // 8-byte Folded Spill
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x5, #1
	stp	d9, d8, [sp, #8]                // 16-byte Folded Spill
	str	x27, [sp, #24]                  // 8-byte Spill
	stp	x26, x25, [sp, #32]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #48]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #64]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #80]             // 16-byte Folded Spill
	b.lt	.LBB11_33
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB11_3:                               // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB11_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x18, x11, #1
	mov	x13, x18
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
	lsl	w12, w1, #6
	mov	x15, x18
	mov	w14, w12
.LBB11_8:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w16, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB11_10
// %bb.9:                               //   in Loop: Header=BB11_8 Depth=1
	add	w14, w14, #32
	tbnz	w16, #0, .LBB11_8
.LBB11_10:
	add	w14, w1, w1, lsl #1
	mov	x17, x18
	lsl	w14, w14, #5
	mov	w16, w14
.LBB11_11:                              // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	subs	x17, x17, #1
	cset	w6, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB11_13
// %bb.12:                              //   in Loop: Header=BB11_11 Depth=1
	add	w16, w16, #32
	tbnz	w6, #0, .LBB11_11
.LBB11_13:
	lsl	w16, w1, #7
	mov	w1, w16
.LBB11_14:                              // =>This Inner Loop Header: Depth=1
	add	x17, x2, w1, sxtw
	subs	x18, x18, #1
	cset	w6, hs
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	b.ne	.LBB11_16
// %bb.15:                              //   in Loop: Header=BB11_14 Depth=1
	add	w1, w1, #32
	tbnz	w6, #0, .LBB11_14
.LBB11_16:
	cmp	w11, #1
	mov	x18, xzr
	mov	w5, w5
	ccmp	w9, #1, #0, eq
	mov	w6, #16                         // =0x10
	ccmp	w13, #1, #0, eq
	ccmp	w15, #1, #0, eq
	ccmp	w17, #1, #0, eq
	cset	w1, eq
	b	.LBB11_18
.LBB11_17:                              //   in Loop: Header=BB11_18 Depth=1
	ldr	x19, [x4, #32]
	cmp	w0, w7
	st1b	{ z16.b }, p1, [x19, x18]
	ldr	x19, [x4, #32]
	st1b	{ z17.b }, p2, [x19, x20]
	ldr	x19, [x4, #24]
	st1b	{ z6.b }, p1, [x19, x18]
	ldr	x19, [x4, #24]
	st1b	{ z7.b }, p2, [x19, x20]
	ldr	x19, [x4, #16]
	st1b	{ z4.b }, p1, [x19, x18]
	ldr	x19, [x4, #16]
	st1b	{ z5.b }, p2, [x19, x20]
	ldr	x19, [x4, #8]
	st1b	{ z2.b }, p1, [x19, x18]
	ldr	x19, [x4, #8]
	st1b	{ z3.b }, p2, [x19, x20]
	ldr	x19, [x4]
	st1b	{ z0.b }, p1, [x19, x18]
	ldr	x18, [x4]
	st1b	{ z1.b }, p2, [x18, x20]
	mov	x18, x7
	b.le	.LBB11_36
.LBB11_18:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB11_21 Depth 2
	whilelt	p1.b, w18, w0
	ptest	p0, p1.b
	b.eq	.LBB11_36
// %bb.19:                              //   in Loop: Header=BB11_18 Depth=1
	mov	x7, x18
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	add	x20, x18, x5
	movi	v16.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	incb	x7, all, mul #2
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	x19, xzr
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	x21, x3
	whilelt	p2.b, w20, w0
	mov	w22, w10
	mov	w23, w12
	mov	w24, w14
	mov	w25, w16
	b	.LBB11_21
.LBB11_20:                              //   in Loop: Header=BB11_21 Depth=2
	eor	z0.d, z0.d, z24.d
	eor	z1.d, z1.d, z25.d
	add	x19, x19, #32
	eor	z2.d, z2.d, z26.d
	eor	z3.d, z3.d, z27.d
	add	w25, w25, #32
	eor	z4.d, z4.d, z28.d
	eor	z5.d, z5.d, z29.d
	cmp	x8, x19
	eor	z6.d, z6.d, z30.d
	eor	z7.d, z7.d, z31.d
	add	w24, w24, #32
	eor	z16.d, z16.d, z18.d
	eor	z17.d, z17.d, z19.d
	add	w23, w23, #32
	add	w22, w22, #32
	b.eq	.LBB11_17
.LBB11_21:                              //   Parent Loop BB11_18 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x26, [x21], #8
	ld1b	{ z18.b }, p1/z, [x26, x18]
	ld1b	{ z19.b }, p2/z, [x26, x20]
	tbz	w1, #0, .LBB11_28
// %bb.22:                              //   in Loop: Header=BB11_21 Depth=2
	movi	v20.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	mov	z24.d, z18.d
	mov	z25.d, z19.d
	cmp	w9, #1
	b.eq	.LBB11_24
.LBB11_23:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x26, w19
	add	x27, x2, x26
	ld1b	{ z24.b }, p0/z, [x2, x26]
	ld1b	{ z25.b }, p0/z, [x27, x6]
	tbl	z26.b, { z24.b }, z23.b
	tbl	z28.b, { z24.b }, z21.b
	tbl	z27.b, { z25.b }, z22.b
	tbl	z25.b, { z25.b }, z20.b
	eor	z24.d, z26.d, z27.d
	eor	z25.d, z28.d, z25.d
.LBB11_24:                              //   in Loop: Header=BB11_21 Depth=2
	mov	z26.d, z18.d
	mov	z27.d, z19.d
	cmp	w11, #1
	b.ne	.LBB11_29
// %bb.25:                              //   in Loop: Header=BB11_21 Depth=2
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	cmp	w13, #1
	b.ne	.LBB11_30
.LBB11_26:                              //   in Loop: Header=BB11_21 Depth=2
	mov	z30.d, z18.d
	mov	z31.d, z19.d
	cmp	w15, #1
	b.ne	.LBB11_31
.LBB11_27:                              //   in Loop: Header=BB11_21 Depth=2
	cmp	w17, #1
	b.eq	.LBB11_20
	b	.LBB11_32
.LBB11_28:                              //   in Loop: Header=BB11_21 Depth=2
	lsr	z22.b, z18.b, #4
	lsr	z20.b, z19.b, #4
	movprfx	z23, z18
	and	z23.b, z23.b, #0xf
	movprfx	z21, z19
	and	z21.b, z21.b, #0xf
	mov	z24.d, z18.d
	mov	z25.d, z19.d
	cmp	w9, #1
	b.ne	.LBB11_23
	b	.LBB11_24
.LBB11_29:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x26, w22
	add	x27, x2, x26
	ld1b	{ z26.b }, p0/z, [x2, x26]
	ld1b	{ z27.b }, p0/z, [x27, x6]
	tbl	z28.b, { z26.b }, z23.b
	tbl	z30.b, { z26.b }, z21.b
	tbl	z29.b, { z27.b }, z22.b
	tbl	z27.b, { z27.b }, z20.b
	eor	z26.d, z28.d, z29.d
	eor	z27.d, z30.d, z27.d
	mov	z28.d, z18.d
	mov	z29.d, z19.d
	cmp	w13, #1
	b.eq	.LBB11_26
.LBB11_30:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x26, w23
	add	x27, x2, x26
	ld1b	{ z28.b }, p0/z, [x2, x26]
	ld1b	{ z29.b }, p0/z, [x27, x6]
	tbl	z30.b, { z28.b }, z23.b
	tbl	z8.b, { z28.b }, z21.b
	tbl	z31.b, { z29.b }, z22.b
	tbl	z29.b, { z29.b }, z20.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
	mov	z30.d, z18.d
	mov	z31.d, z19.d
	cmp	w15, #1
	b.eq	.LBB11_27
.LBB11_31:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x26, w24
	add	x27, x2, x26
	ld1b	{ z30.b }, p0/z, [x2, x26]
	ld1b	{ z31.b }, p0/z, [x27, x6]
	tbl	z8.b, { z30.b }, z23.b
	tbl	z10.b, { z30.b }, z21.b
	tbl	z9.b, { z31.b }, z22.b
	tbl	z31.b, { z31.b }, z20.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	cmp	w17, #1
	b.eq	.LBB11_20
.LBB11_32:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x26, w25
	add	x27, x2, x26
	ld1b	{ z18.b }, p0/z, [x2, x26]
	ld1b	{ z19.b }, p0/z, [x27, x6]
	tbl	z23.b, { z18.b }, z23.b
	tbl	z21.b, { z18.b }, z21.b
	tbl	z22.b, { z19.b }, z22.b
	tbl	z19.b, { z19.b }, z20.b
	eor	z18.d, z23.d, z22.d
	eor	z19.d, z21.d, z19.d
	b	.LBB11_20
.LBB11_33:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w5
.LBB11_34:                              // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB11_36
// %bb.35:                              //   in Loop: Header=BB11_34 Depth=1
	ldr	x10, [x4, #32]
	add	x11, x9, x8
	whilelt	p2.b, w11, w0
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #32]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #24]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #24]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #16]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #16]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4]
	st1b	{ z0.b }, p1, [x10, x8]
	incb	x8, all, mul #2
	ldr	x10, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x11, x10]
	b.gt	.LBB11_34
.LBB11_36:
	ldp	x20, x19, [sp, #80]             // 16-byte Folded Reload
	ldr	x27, [sp, #24]                  // 8-byte Reload
	ldp	x22, x21, [sp, #64]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #48]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #32]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #8]                // 16-byte Folded Reload
	ldr	d10, [sp], #96                  // 8-byte Folded Reload
.LBB11_37:
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
	b.lt	.LBB12_42
// %bb.1:
	str	d14, [sp, #-160]!               // 8-byte Folded Spill
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x7, #1
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             // 16-byte Folded Spill
	stp	x28, x27, [sp, #80]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #96]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #112]            // 16-byte Folded Spill
	stp	x22, x21, [sp, #128]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #144]            // 16-byte Folded Spill
	b.lt	.LBB12_38
// %bb.2:
	mov	w11, w1
	mov	x10, xzr
	lsl	x8, x11, #5
	sub	x12, x8, #32
.LBB12_3:                               // =>This Inner Loop Header: Depth=1
	add	x9, x2, w10, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x12, x10, #4, eq
	add	x10, x10, #32
	b.ne	.LBB12_3
// %bb.4:
	lsl	w10, w1, #5
	sub	x5, x11, #1
	mov	x13, x5
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
	lsl	w12, w1, #6
	mov	x15, x5
	mov	w14, w12
.LBB12_8:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w16, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB12_10
// %bb.9:                               //   in Loop: Header=BB12_8 Depth=1
	add	w14, w14, #32
	tbnz	w16, #0, .LBB12_8
.LBB12_10:
	add	w14, w1, w1, lsl #1
	mov	x17, x5
	lsl	w14, w14, #5
	mov	w16, w14
.LBB12_11:                              // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	subs	x17, x17, #1
	cset	w18, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB12_13
// %bb.12:                              //   in Loop: Header=BB12_11 Depth=1
	add	w16, w16, #32
	tbnz	w18, #0, .LBB12_11
.LBB12_13:
	lsl	w16, w1, #7
	mov	x6, x5
	mov	w18, w16
.LBB12_14:                              // =>This Inner Loop Header: Depth=1
	add	x17, x2, w18, sxtw
	subs	x6, x6, #1
	cset	w19, hs
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	b.ne	.LBB12_16
// %bb.15:                              //   in Loop: Header=BB12_14 Depth=1
	add	w18, w18, #32
	tbnz	w19, #0, .LBB12_14
.LBB12_16:
	add	w18, w1, w1, lsl #2
	lsl	w18, w18, #5
	mov	w6, w18
.LBB12_17:                              // =>This Inner Loop Header: Depth=1
	add	x1, x2, w6, sxtw
	subs	x5, x5, #1
	cset	w19, hs
	ldrb	w1, [x1, #1]
	cmp	w1, #1
	b.ne	.LBB12_19
// %bb.18:                              //   in Loop: Header=BB12_17 Depth=1
	add	w6, w6, #32
	tbnz	w19, #0, .LBB12_17
.LBB12_19:
	cmp	w11, #1
	mov	x5, xzr
	mov	w7, w7
	ccmp	w9, #1, #0, eq
	mov	w19, #16                        // =0x10
	ccmp	w13, #1, #0, eq
	ccmp	w15, #1, #0, eq
	ccmp	w17, #1, #0, eq
	ccmp	w1, #1, #0, eq
	cset	w6, eq
	b	.LBB12_21
.LBB12_20:                              //   in Loop: Header=BB12_21 Depth=1
	ldr	x21, [x4, #40]
	cmp	w0, w20
	st1b	{ z18.b }, p1, [x21, x5]
	ldr	x21, [x4, #40]
	st1b	{ z19.b }, p2, [x21, x22]
	ldr	x21, [x4, #32]
	st1b	{ z16.b }, p1, [x21, x5]
	ldr	x21, [x4, #32]
	st1b	{ z17.b }, p2, [x21, x22]
	ldr	x21, [x4, #24]
	st1b	{ z6.b }, p1, [x21, x5]
	ldr	x21, [x4, #24]
	st1b	{ z7.b }, p2, [x21, x22]
	ldr	x21, [x4, #16]
	st1b	{ z4.b }, p1, [x21, x5]
	ldr	x21, [x4, #16]
	st1b	{ z5.b }, p2, [x21, x22]
	ldr	x21, [x4, #8]
	st1b	{ z2.b }, p1, [x21, x5]
	ldr	x21, [x4, #8]
	st1b	{ z3.b }, p2, [x21, x22]
	ldr	x21, [x4]
	st1b	{ z0.b }, p1, [x21, x5]
	ldr	x5, [x4]
	st1b	{ z1.b }, p2, [x5, x22]
	mov	x5, x20
	b.le	.LBB12_41
.LBB12_21:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB12_24 Depth 2
	whilelt	p1.b, w5, w0
	ptest	p0, p1.b
	b.eq	.LBB12_41
// %bb.22:                              //   in Loop: Header=BB12_21 Depth=1
	mov	x20, x5
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	add	x22, x5, x7
	movi	v16.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	incb	x20, all, mul #2
	movi	v1.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	mov	x21, xzr
	movi	v5.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x23, x3
	movi	v17.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	w24, w10
	whilelt	p2.b, w22, w0
	mov	w25, w12
	mov	w26, w14
	mov	w27, w16
	mov	w28, w18
	b	.LBB12_24
.LBB12_23:                              //   in Loop: Header=BB12_24 Depth=2
	eor	z0.d, z0.d, z26.d
	eor	z1.d, z1.d, z28.d
	add	x21, x21, #32
	eor	z2.d, z2.d, z27.d
	eor	z3.d, z3.d, z29.d
	add	w28, w28, #32
	eor	z4.d, z4.d, z30.d
	eor	z5.d, z5.d, z31.d
	add	w27, w27, #32
	eor	z6.d, z6.d, z8.d
	eor	z7.d, z7.d, z9.d
	cmp	x8, x21
	eor	z16.d, z16.d, z10.d
	eor	z17.d, z17.d, z11.d
	add	w26, w26, #32
	eor	z18.d, z18.d, z20.d
	eor	z19.d, z19.d, z21.d
	add	w25, w25, #32
	add	w24, w24, #32
	b.eq	.LBB12_20
.LBB12_24:                              //   Parent Loop BB12_21 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x29, [x23], #8
	ld1b	{ z20.b }, p1/z, [x29, x5]
	ld1b	{ z21.b }, p2/z, [x29, x22]
	tbz	w6, #0, .LBB12_32
// %bb.25:                              //   in Loop: Header=BB12_24 Depth=2
	movi	v22.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	mov	z26.d, z20.d
	mov	z28.d, z21.d
	cmp	w9, #1
	b.eq	.LBB12_27
.LBB12_26:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x29, w21
	add	x30, x2, x29
	ld1b	{ z26.b }, p0/z, [x2, x29]
	ld1b	{ z27.b }, p0/z, [x30, x19]
	tbl	z28.b, { z26.b }, z25.b
	tbl	z30.b, { z26.b }, z23.b
	tbl	z29.b, { z27.b }, z24.b
	tbl	z27.b, { z27.b }, z22.b
	eor	z26.d, z28.d, z29.d
	eor	z28.d, z30.d, z27.d
.LBB12_27:                              //   in Loop: Header=BB12_24 Depth=2
	mov	z27.d, z20.d
	mov	z29.d, z21.d
	cmp	w11, #1
	b.ne	.LBB12_33
// %bb.28:                              //   in Loop: Header=BB12_24 Depth=2
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w13, #1
	b.ne	.LBB12_34
.LBB12_29:                              //   in Loop: Header=BB12_24 Depth=2
	mov	z8.d, z20.d
	mov	z9.d, z21.d
	cmp	w15, #1
	b.ne	.LBB12_35
.LBB12_30:                              //   in Loop: Header=BB12_24 Depth=2
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	cmp	w17, #1
	b.ne	.LBB12_36
.LBB12_31:                              //   in Loop: Header=BB12_24 Depth=2
	cmp	w1, #1
	b.eq	.LBB12_23
	b	.LBB12_37
.LBB12_32:                              //   in Loop: Header=BB12_24 Depth=2
	lsr	z24.b, z20.b, #4
	lsr	z22.b, z21.b, #4
	movprfx	z25, z20
	and	z25.b, z25.b, #0xf
	movprfx	z23, z21
	and	z23.b, z23.b, #0xf
	mov	z26.d, z20.d
	mov	z28.d, z21.d
	cmp	w9, #1
	b.ne	.LBB12_26
	b	.LBB12_27
.LBB12_33:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x29, w24
	add	x30, x2, x29
	ld1b	{ z27.b }, p0/z, [x2, x29]
	ld1b	{ z29.b }, p0/z, [x30, x19]
	tbl	z30.b, { z27.b }, z25.b
	tbl	z8.b, { z27.b }, z23.b
	tbl	z31.b, { z29.b }, z24.b
	tbl	z29.b, { z29.b }, z22.b
	eor	z27.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
	mov	z30.d, z20.d
	mov	z31.d, z21.d
	cmp	w13, #1
	b.eq	.LBB12_29
.LBB12_34:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x29, w25
	add	x30, x2, x29
	ld1b	{ z30.b }, p0/z, [x2, x29]
	ld1b	{ z31.b }, p0/z, [x30, x19]
	tbl	z8.b, { z30.b }, z25.b
	tbl	z10.b, { z30.b }, z23.b
	tbl	z9.b, { z31.b }, z24.b
	tbl	z31.b, { z31.b }, z22.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	mov	z8.d, z20.d
	mov	z9.d, z21.d
	cmp	w15, #1
	b.eq	.LBB12_30
.LBB12_35:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x29, w26
	add	x30, x2, x29
	ld1b	{ z8.b }, p0/z, [x2, x29]
	ld1b	{ z9.b }, p0/z, [x30, x19]
	tbl	z10.b, { z8.b }, z25.b
	tbl	z12.b, { z8.b }, z23.b
	tbl	z11.b, { z9.b }, z24.b
	tbl	z9.b, { z9.b }, z22.b
	eor	z8.d, z10.d, z11.d
	eor	z9.d, z12.d, z9.d
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	cmp	w17, #1
	b.eq	.LBB12_31
.LBB12_36:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x29, w27
	add	x30, x2, x29
	ld1b	{ z10.b }, p0/z, [x2, x29]
	ld1b	{ z11.b }, p0/z, [x30, x19]
	tbl	z12.b, { z10.b }, z25.b
	tbl	z14.b, { z10.b }, z23.b
	tbl	z13.b, { z11.b }, z24.b
	tbl	z11.b, { z11.b }, z22.b
	eor	z10.d, z12.d, z13.d
	eor	z11.d, z14.d, z11.d
	cmp	w1, #1
	b.eq	.LBB12_23
.LBB12_37:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x29, w28
	add	x30, x2, x29
	ld1b	{ z20.b }, p0/z, [x2, x29]
	ld1b	{ z21.b }, p0/z, [x30, x19]
	tbl	z25.b, { z20.b }, z25.b
	tbl	z23.b, { z20.b }, z23.b
	tbl	z24.b, { z21.b }, z24.b
	tbl	z21.b, { z21.b }, z22.b
	eor	z20.d, z25.d, z24.d
	eor	z21.d, z23.d, z21.d
	b	.LBB12_23
.LBB12_38:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w7
.LBB12_39:                              // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB12_41
// %bb.40:                              //   in Loop: Header=BB12_39 Depth=1
	ldr	x10, [x4, #40]
	add	x11, x9, x8
	whilelt	p2.b, w11, w0
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #40]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #32]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #32]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #24]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #24]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #16]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #16]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4]
	st1b	{ z0.b }, p1, [x10, x8]
	incb	x8, all, mul #2
	ldr	x10, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x11, x10]
	b.gt	.LBB12_39
.LBB12_41:
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
.LBB12_42:
	ret
.Lfunc_end12:
	.size	gf_6vect_dot_prod_sve2, .Lfunc_end12-gf_6vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_7vect_dot_prod_sve2          // -- Begin function gf_7vect_dot_prod_sve2
	.p2align	2
	.type	gf_7vect_dot_prod_sve2,@function
gf_7vect_dot_prod_sve2:                 // @gf_7vect_dot_prod_sve2
// %bb.0:
	stp	d15, d14, [sp, #-160]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x30, [sp, #64]             // 16-byte Folded Spill
	stp	x28, x27, [sp, #80]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #96]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #112]            // 16-byte Folded Spill
	stp	x22, x21, [sp, #128]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #144]            // 16-byte Folded Spill
	sub	sp, sp, #32
	addvl	sp, sp, #-3
	cmp	w0, #16
	str	x3, [sp, #24]                   // 8-byte Spill
	b.ge	.LBB13_2
.LBB13_1:
	addvl	sp, sp, #3
	add	sp, sp, #32
	ldp	x20, x19, [sp, #144]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #128]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #112]            // 16-byte Folded Reload
	ldp	x26, x25, [sp, #96]             // 16-byte Folded Reload
	ldp	x28, x27, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x30, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #160            // 16-byte Folded Reload
	ret
.LBB13_2:
	ptrue	p0.b, vl16
	cmp	w1, #1
	rdvl	x10, #1
	b.lt	.LBB13_44
// %bb.3:
	mov	w11, w1
	mov	x12, xzr
	lsl	x8, x11, #5
	sub	x13, x8, #32
.LBB13_4:                               // =>This Inner Loop Header: Depth=1
	add	x9, x2, w12, sxtw
	ldrb	w9, [x9, #1]
	cmp	w9, #1
	ccmp	x13, x12, #4, eq
	add	x12, x12, #32
	b.ne	.LBB13_4
// %bb.5:
	lsl	w12, w1, #5
	sub	x7, x11, #1
	mov	x13, x7
	str	w12, [sp, #20]                  // 4-byte Spill
.LBB13_6:                               // =>This Inner Loop Header: Depth=1
	add	x11, x2, w12, sxtw
	subs	x13, x13, #1
	cset	w14, hs
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	b.ne	.LBB13_8
// %bb.7:                               //   in Loop: Header=BB13_6 Depth=1
	add	w12, w12, #32
	tbnz	w14, #0, .LBB13_6
.LBB13_8:
	lsl	w14, w1, #6
	mov	x15, x7
	str	w14, [sp, #16]                  // 4-byte Spill
.LBB13_9:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	subs	x15, x15, #1
	cset	w16, hs
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	b.ne	.LBB13_11
// %bb.10:                              //   in Loop: Header=BB13_9 Depth=1
	add	w14, w14, #32
	tbnz	w16, #0, .LBB13_9
.LBB13_11:
	add	w5, w1, w1, lsl #1
	mov	x17, x7
	lsl	w14, w5, #5
	mov	w16, w14
.LBB13_12:                              // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	subs	x17, x17, #1
	cset	w18, hs
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	b.ne	.LBB13_14
// %bb.13:                              //   in Loop: Header=BB13_12 Depth=1
	add	w16, w16, #32
	tbnz	w18, #0, .LBB13_12
.LBB13_14:
	lsl	w16, w1, #7
	mov	x6, x7
	mov	w18, w16
.LBB13_15:                              // =>This Inner Loop Header: Depth=1
	add	x17, x2, w18, sxtw
	subs	x6, x6, #1
	cset	w19, hs
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	b.ne	.LBB13_17
// %bb.16:                              //   in Loop: Header=BB13_15 Depth=1
	add	w18, w18, #32
	tbnz	w19, #0, .LBB13_15
.LBB13_17:
	add	w18, w1, w1, lsl #2
	mov	x19, x7
	lsl	w18, w18, #5
	mov	w6, w18
.LBB13_18:                              // =>This Inner Loop Header: Depth=1
	add	x1, x2, w6, sxtw
	subs	x19, x19, #1
	cset	w20, hs
	ldrb	w1, [x1, #1]
	cmp	w1, #1
	b.ne	.LBB13_20
// %bb.19:                              //   in Loop: Header=BB13_18 Depth=1
	add	w6, w6, #32
	tbnz	w20, #0, .LBB13_18
.LBB13_20:
	lsl	w5, w5, #6
	mov	w19, w5
.LBB13_21:                              // =>This Inner Loop Header: Depth=1
	add	x6, x2, w19, sxtw
	subs	x7, x7, #1
	cset	w20, hs
	ldrb	w6, [x6, #1]
	cmp	w6, #1
	b.ne	.LBB13_23
// %bb.22:                              //   in Loop: Header=BB13_21 Depth=1
	add	w19, w19, #32
	tbnz	w20, #0, .LBB13_21
.LBB13_23:
	cmp	w11, #1
	mov	x7, xzr
	mov	w20, w10
	ccmp	w9, #1, #0, eq
	mov	w21, #16                        // =0x10
	ccmp	w13, #1, #0, eq
	ccmp	w15, #1, #0, eq
	ccmp	w17, #1, #0, eq
	ccmp	w1, #1, #0, eq
	ccmp	w6, #1, #0, eq
	cset	w19, eq
	b	.LBB13_25
.LBB13_24:                              //   in Loop: Header=BB13_25 Depth=1
	ldr	x10, [x4, #48]
	cmp	w0, w23
	st1b	{ z19.b }, p1, [x10, x7]
	ldr	x10, [x4, #48]
	st1b	{ z21.b }, p2, [x10, x22]
	ldr	x10, [x4, #40]
	st1b	{ z17.b }, p1, [x10, x7]
	ldr	x10, [x4, #40]
	st1b	{ z20.b }, p2, [x10, x22]
	ldr	x10, [x4, #32]
	st1b	{ z7.b }, p1, [x10, x7]
	ldr	x10, [x4, #32]
	st1b	{ z18.b }, p2, [x10, x22]
	ldr	x10, [x4, #24]
	st1b	{ z5.b }, p1, [x10, x7]
	ldr	x10, [x4, #24]
	st1b	{ z16.b }, p2, [x10, x22]
	ldr	x10, [x4, #16]
	st1b	{ z3.b }, p1, [x10, x7]
	ldr	x10, [x4, #16]
	st1b	{ z6.b }, p2, [x10, x22]
	ldr	x10, [x4, #8]
	st1b	{ z2.b }, p1, [x10, x7]
	ldr	x10, [x4, #8]
	st1b	{ z4.b }, p2, [x10, x22]
	ldr	x10, [x4]
	st1b	{ z0.b }, p1, [x10, x7]
	mov	x7, x23
	ldr	x10, [x4]
	st1b	{ z1.b }, p2, [x10, x22]
	b.le	.LBB13_1
.LBB13_25:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB13_28 Depth 2
	whilelt	p1.b, w7, w0
	ptest	p0, p1.b
	b.eq	.LBB13_1
// %bb.26:                              //   in Loop: Header=BB13_25 Depth=1
	mov	x23, x7
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	add	x22, x7, x20
	movi	v7.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	incb	x23, all, mul #2
	movi	v19.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	ldr	x25, [sp, #24]                  // 8-byte Reload
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x24, xzr
	movi	v16.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	mov	w28, w14
	movi	v20.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	mov	w29, w16
	ldp	w27, w26, [sp, #16]             // 8-byte Folded Reload
	whilelt	p2.b, w22, w0
	mov	w30, w18
	mov	w10, w5
	b	.LBB13_28
.LBB13_27:                              //   in Loop: Header=BB13_28 Depth=2
	eor	z0.d, z0.d, z28.d
	eor	z1.d, z1.d, z29.d
	add	x24, x24, #32
	eor	z2.d, z2.d, z30.d
	eor	z4.d, z4.d, z31.d
	add	w10, w10, #32
	eor	z3.d, z3.d, z8.d
	eor	z6.d, z6.d, z9.d
	add	w30, w30, #32
	eor	z5.d, z5.d, z10.d
	eor	z16.d, z16.d, z11.d
	add	w29, w29, #32
	eor	z7.d, z7.d, z12.d
	eor	z18.d, z18.d, z13.d
	cmp	x8, x24
	eor	z17.d, z17.d, z14.d
	eor	z20.d, z20.d, z15.d
	add	w28, w28, #32
	eor	z19.d, z19.d, z22.d
	eor	z21.d, z21.d, z23.d
	add	w27, w27, #32
	add	w26, w26, #32
	b.eq	.LBB13_24
.LBB13_28:                              //   Parent Loop BB13_25 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x3, [x25], #8
	ld1b	{ z22.b }, p1/z, [x3, x7]
	ld1b	{ z23.b }, p2/z, [x3, x22]
	tbz	w19, #0, .LBB13_37
// %bb.29:                              //   in Loop: Header=BB13_28 Depth=2
	movi	v24.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	mov	z28.d, z22.d
	mov	z29.d, z23.d
	cmp	w9, #1
	b.eq	.LBB13_31
.LBB13_30:                              //   in Loop: Header=BB13_28 Depth=2
	sxtw	x3, w24
	add	x12, x2, x3
	ld1b	{ z28.b }, p0/z, [x2, x3]
	ld1b	{ z29.b }, p0/z, [x12, x21]
	tbl	z30.b, { z28.b }, z27.b
	tbl	z8.b, { z28.b }, z25.b
	tbl	z31.b, { z29.b }, z26.b
	tbl	z29.b, { z29.b }, z24.b
	eor	z28.d, z30.d, z31.d
	eor	z29.d, z8.d, z29.d
.LBB13_31:                              //   in Loop: Header=BB13_28 Depth=2
	mov	z30.d, z22.d
	mov	z31.d, z23.d
	cmp	w11, #1
	b.ne	.LBB13_38
// %bb.32:                              //   in Loop: Header=BB13_28 Depth=2
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	cmp	w13, #1
	b.ne	.LBB13_39
.LBB13_33:                              //   in Loop: Header=BB13_28 Depth=2
	mov	z10.d, z22.d
	mov	z11.d, z23.d
	cmp	w15, #1
	b.ne	.LBB13_40
.LBB13_34:                              //   in Loop: Header=BB13_28 Depth=2
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w17, #1
	b.ne	.LBB13_41
.LBB13_35:                              //   in Loop: Header=BB13_28 Depth=2
	mov	z14.d, z22.d
	mov	z15.d, z23.d
	cmp	w1, #1
	b.ne	.LBB13_42
.LBB13_36:                              //   in Loop: Header=BB13_28 Depth=2
	cmp	w6, #1
	b.eq	.LBB13_27
	b	.LBB13_43
.LBB13_37:                              //   in Loop: Header=BB13_28 Depth=2
	lsr	z26.b, z22.b, #4
	lsr	z24.b, z23.b, #4
	movprfx	z27, z22
	and	z27.b, z27.b, #0xf
	movprfx	z25, z23
	and	z25.b, z25.b, #0xf
	mov	z28.d, z22.d
	mov	z29.d, z23.d
	cmp	w9, #1
	b.ne	.LBB13_30
	b	.LBB13_31
.LBB13_38:                              //   in Loop: Header=BB13_28 Depth=2
	sxtw	x12, w26
	add	x3, x2, x12
	ld1b	{ z30.b }, p0/z, [x2, x12]
	ld1b	{ z31.b }, p0/z, [x3, x21]
	tbl	z8.b, { z30.b }, z27.b
	tbl	z10.b, { z30.b }, z25.b
	tbl	z9.b, { z31.b }, z26.b
	tbl	z31.b, { z31.b }, z24.b
	eor	z30.d, z8.d, z9.d
	eor	z31.d, z10.d, z31.d
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	cmp	w13, #1
	b.eq	.LBB13_33
.LBB13_39:                              //   in Loop: Header=BB13_28 Depth=2
	sxtw	x12, w27
	add	x3, x2, x12
	ld1b	{ z8.b }, p0/z, [x2, x12]
	ld1b	{ z9.b }, p0/z, [x3, x21]
	tbl	z10.b, { z8.b }, z27.b
	tbl	z12.b, { z8.b }, z25.b
	tbl	z11.b, { z9.b }, z26.b
	tbl	z9.b, { z9.b }, z24.b
	eor	z8.d, z10.d, z11.d
	eor	z9.d, z12.d, z9.d
	mov	z10.d, z22.d
	mov	z11.d, z23.d
	cmp	w15, #1
	b.eq	.LBB13_34
.LBB13_40:                              //   in Loop: Header=BB13_28 Depth=2
	sxtw	x12, w28
	add	x3, x2, x12
	ld1b	{ z10.b }, p0/z, [x2, x12]
	ld1b	{ z11.b }, p0/z, [x3, x21]
	tbl	z12.b, { z10.b }, z27.b
	tbl	z14.b, { z10.b }, z25.b
	tbl	z13.b, { z11.b }, z26.b
	tbl	z11.b, { z11.b }, z24.b
	eor	z10.d, z12.d, z13.d
	eor	z11.d, z14.d, z11.d
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w17, #1
	b.eq	.LBB13_35
.LBB13_41:                              //   in Loop: Header=BB13_28 Depth=2
	sxtw	x12, w29
	add	x3, x2, x12
	ld1b	{ z12.b }, p0/z, [x2, x12]
	add	x12, sp, #32
	ld1b	{ z13.b }, p0/z, [x3, x21]
	str	z11, [x12, #2, mul vl]          // 16-byte Folded Spill
	mov	z11.d, z10.d
	mov	z10.d, z9.d
	mov	z9.d, z8.d
	mov	z8.d, z18.d
	tbl	z14.b, { z12.b }, z27.b
	mov	z18.d, z17.d
	mov	z17.d, z16.d
	tbl	z15.b, { z13.b }, z26.b
	mov	z16.d, z7.d
	mov	z7.d, z6.d
	mov	z6.d, z5.d
	mov	z5.d, z4.d
	mov	z4.d, z3.d
	mov	z3.d, z2.d
	mov	z2.d, z1.d
	mov	z1.d, z0.d
	mov	z0.d, z31.d
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
	mov	z31.d, z0.d
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
	mov	z18.d, z8.d
	mov	z8.d, z9.d
	mov	z9.d, z10.d
	mov	z10.d, z11.d
	ldr	z11, [x12, #2, mul vl]          // 16-byte Folded Reload
	mov	z14.d, z22.d
	mov	z15.d, z23.d
	cmp	w1, #1
	b.eq	.LBB13_36
.LBB13_42:                              //   in Loop: Header=BB13_28 Depth=2
	sxtw	x12, w30
	str	x8, [sp]                        // 8-byte Spill
	add	x8, sp, #32
	str	z17, [x8]                       // 16-byte Folded Spill
	mov	z17.d, z6.d
	mov	z6.d, z3.d
	add	x3, x2, x12
	mov	z3.d, z1.d
	mov	z1.d, z31.d
	mov	z31.d, z28.d
	ld1b	{ z28.b }, p0/z, [x2, x12]
	ld1b	{ z14.b }, p0/z, [x3, x21]
	str	z10, [x8, #2, mul vl]           // 16-byte Folded Spill
	mov	z10.d, z16.d
	mov	z16.d, z5.d
	str	z18, [x8, #1, mul vl]           // 16-byte Folded Spill
	mov	z18.d, z7.d
	mov	z7.d, z4.d
	mov	z5.d, z2.d
	mov	z2.d, z0.d
	tbl	z15.b, { z28.b }, z27.b
	mov	z0.d, z13.d
	mov	z13.d, z11.d
	mov	z11.d, z29.d
	tbl	z29.b, { z14.b }, z26.b
	tbl	z28.b, { z28.b }, z25.b
	mov	z4.d, z27.d
	mov	z27.d, z26.d
	mov	z26.d, z25.d
	add	x12, sp, #32
	mov	z25.d, z12.d
	mov	z12.d, z21.d
	ldr	x8, [sp]                        // 8-byte Reload
	mov	z21.d, z20.d
	mov	z20.d, z19.d
	mov	z19.d, z9.d
	mov	z9.d, z30.d
	tbl	z30.b, { z14.b }, z24.b
	eor	z14.d, z15.d, z29.d
	mov	z29.d, z11.d
	mov	z11.d, z13.d
	mov	z13.d, z0.d
	mov	z0.d, z2.d
	mov	z2.d, z5.d
	mov	z5.d, z16.d
	mov	z16.d, z10.d
	ldr	z10, [x12, #2, mul vl]          // 16-byte Folded Reload
	eor	z15.d, z28.d, z30.d
	mov	z30.d, z9.d
	mov	z9.d, z19.d
	mov	z19.d, z20.d
	mov	z20.d, z21.d
	mov	z21.d, z12.d
	mov	z12.d, z25.d
	mov	z25.d, z26.d
	mov	z26.d, z27.d
	mov	z27.d, z4.d
	mov	z28.d, z31.d
	mov	z31.d, z1.d
	mov	z1.d, z3.d
	mov	z3.d, z6.d
	mov	z4.d, z7.d
	mov	z6.d, z17.d
	ldr	z17, [x12]                      // 16-byte Folded Reload
	mov	z7.d, z18.d
	ldr	z18, [x12, #1, mul vl]          // 16-byte Folded Reload
	cmp	w6, #1
	b.eq	.LBB13_27
.LBB13_43:                              //   in Loop: Header=BB13_28 Depth=2
	sxtw	x12, w10
	add	x3, x2, x12
	ld1b	{ z22.b }, p0/z, [x2, x12]
	ld1b	{ z23.b }, p0/z, [x3, x21]
	tbl	z27.b, { z22.b }, z27.b
	tbl	z25.b, { z22.b }, z25.b
	tbl	z26.b, { z23.b }, z26.b
	tbl	z23.b, { z23.b }, z24.b
	eor	z22.d, z27.d, z26.d
	eor	z23.d, z25.d, z23.d
	b	.LBB13_27
.LBB13_44:
	movi	v0.2d, #0000000000000000
	mov	x8, xzr
	mov	w9, w10
.LBB13_45:                              // =>This Inner Loop Header: Depth=1
	whilelt	p1.b, w8, w0
	ptest	p0, p1.b
	b.eq	.LBB13_1
// %bb.46:                              //   in Loop: Header=BB13_45 Depth=1
	ldr	x10, [x4, #48]
	add	x11, x9, x8
	whilelt	p2.b, w11, w0
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #48]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #40]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #40]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #32]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #32]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #24]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #24]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #16]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #16]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p1, [x10, x8]
	ldr	x10, [x4, #8]
	st1b	{ z0.b }, p2, [x11, x10]
	ldr	x10, [x4]
	st1b	{ z0.b }, p1, [x10, x8]
	incb	x8, all, mul #2
	ldr	x10, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x11, x10]
	b.gt	.LBB13_45
	b	.LBB13_1
.Lfunc_end13:
	.size	gf_7vect_dot_prod_sve2, .Lfunc_end13-gf_7vect_dot_prod_sve2
                                        // -- End function
	.ident	"clang version 23.1.3 (https://github.com/llvm/llvm-project 0d261d1ca552c95a8f007e061c787ac7132fbcbc)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
