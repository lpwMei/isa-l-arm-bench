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
	ptrue	p0.b
	mov	x11, xzr
	mov	w14, w14
	mov	w15, #16                        // =0x10
	lsl	w13, w13, #4
	rdvl	x16, #4
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
	whilelt	p0.b, w8, w0
	b.eq	.LBB0_1
// %bb.16:                              //   in Loop: Header=BB0_15 Depth=1
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
	b.lt	.LBB2_25
// %bb.1:
	stp	d15, d14, [sp, #-128]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x25, [sp, #64]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #80]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            // 16-byte Folded Spill
	addvl	sp, sp, #-5
	rdvl	x17, #1
	cmp	w1, #1
	lsr	x15, x17, #4
	b.lt	.LBB2_21
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
	add	w12, w12, #32
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	ccmp	x13, #0, #4, eq
	sub	x13, x13, #1
	b.ne	.LBB2_5
// %bb.6:
	lsl	w12, w1, #6
	mov	w16, w12
.LBB2_7:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w16, sxtw
	add	w16, w16, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	ccmp	x14, #0, #4, eq
	sub	x14, x14, #1
	b.ne	.LBB2_7
// %bb.8:
	add	w16, w15, w15, lsl #1
	cmp	w9, #1
	lsl	w15, w15, #5
	ccmp	w11, #1, #0, eq
	ptrue	p0.b
	mov	x14, xzr
	lsl	w16, w16, #4
	ccmp	w13, #1, #0, eq
	mov	w17, w17
	cset	w18, ne
	mov	w1, #16                         // =0x10
	rdvl	x5, #4
	b	.LBB2_10
.LBB2_9:                                //   in Loop: Header=BB2_10 Depth=1
	ldr	x19, [x4, #16]
	st1b	{ z16.b }, p1, [x19, x14]
	ldr	x19, [x4, #16]
	st1b	{ z17.b }, p2, [x19, x6]
	ldr	x19, [x4, #16]
	st1b	{ z18.b }, p4, [x19, x7]
	ldr	x19, [x4, #16]
	st1b	{ z19.b }, p3, [x19, x20]
	ldr	x19, [x4, #8]
	st1b	{ z2.b }, p1, [x19, x14]
	ldr	x19, [x4, #8]
	st1b	{ z25.b }, p2, [x19, x6]
	ldr	x19, [x4, #8]
	st1b	{ z26.b }, p4, [x19, x7]
	ldr	x19, [x4, #8]
	st1b	{ z27.b }, p3, [x19, x20]
	ldr	x19, [x4]
	st1b	{ z5.b }, p1, [x19, x14]
	add	x14, x14, x5
	ldr	x19, [x4]
	cmp	w0, w14
	st1b	{ z6.b }, p2, [x19, x6]
	ldr	x6, [x4]
	st1b	{ z7.b }, p4, [x6, x7]
	ldr	x6, [x4]
	st1b	{ z1.b }, p3, [x6, x20]
	b.le	.LBB2_24
.LBB2_10:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB2_14 Depth 2
	whilelt	p1.b, w14, w0
	b.eq	.LBB2_24
// %bb.11:                              //   in Loop: Header=BB2_10 Depth=1
	movi	v5.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	x6, x14, x17
	movi	v16.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	add	x7, x14, x15
	movi	v25.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	add	x20, x14, x16
	movi	v7.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	mov	x19, xzr
	movi	v18.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x21, x3
	movi	v27.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	w22, w10
	whilelt	p2.b, w6, w0
	mov	w23, w12
	whilelt	p4.b, w7, w0
	whilelt	p3.b, w20, w0
	b	.LBB2_14
.LBB2_12:                               //   in Loop: Header=BB2_14 Depth=2
	eor	z5.d, z5.d, z22.d
	eor	z6.d, z6.d, z23.d
	eor	z7.d, z7.d, z20.d
	eor	z1.d, z1.d, z21.d
	eor	z2.d, z2.d, z22.d
	eor	z25.d, z25.d, z23.d
	eor	z26.d, z26.d, z20.d
	eor	z27.d, z27.d, z21.d
.LBB2_13:                               //   in Loop: Header=BB2_14 Depth=2
	eor	z16.d, z16.d, z22.d
	eor	z17.d, z17.d, z23.d
	add	x19, x19, #32
	eor	z18.d, z18.d, z20.d
	eor	z19.d, z19.d, z21.d
	cmp	x8, x19
	add	w23, w23, #32
	add	w22, w22, #32
	b.eq	.LBB2_9
.LBB2_14:                               //   Parent Loop BB2_10 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x24, [x21], #8
	ld1b	{ z22.b }, p1/z, [x24, x14]
	ld1b	{ z23.b }, p2/z, [x24, x6]
	ld1b	{ z20.b }, p4/z, [x24, x7]
	ld1b	{ z21.b }, p3/z, [x24, x20]
	tbz	w18, #0, .LBB2_12
// %bb.15:                              //   in Loop: Header=BB2_14 Depth=2
	lsr	z28.b, z22.b, #4
	lsr	z3.b, z23.b, #4
	cmp	w9, #1
	lsr	z4.b, z20.b, #4
	lsr	z0.b, z21.b, #4
	movprfx	z24, z22
	and	z24.b, z24.b, #0xf
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	movprfx	z29, z23
	and	z29.b, z29.b, #0xf
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	movprfx	z30, z20
	and	z30.b, z30.b, #0xf
	movprfx	z31, z21
	and	z31.b, z31.b, #0xf
	str	z0, [sp, #4, mul vl]            // 16-byte Folded Spill
	b.eq	.LBB2_17
// %bb.16:                              //   in Loop: Header=BB2_14 Depth=2
	sxtw	x24, w19
	ldr	z0, [sp, #4, mul vl]            // 16-byte Folded Reload
	add	x25, x2, x24
	ld1b	{ z8.b }, p0/z, [x2, x24]
	ld1b	{ z9.b }, p0/z, [x25, x1]
	tbl	z10.b, { z8.b }, z24.b
	tbl	z11.b, { z8.b }, z29.b
	tbl	z12.b, { z8.b }, z30.b
	tbl	z13.b, { z8.b }, z31.b
	tbl	z8.b, { z9.b }, z28.b
	tbl	z14.b, { z9.b }, z3.b
	tbl	z15.b, { z9.b }, z4.b
	tbl	z0.b, { z9.b }, z0.b
	eor	z8.d, z10.d, z8.d
	eor	z9.d, z11.d, z14.d
	eor	z10.d, z12.d, z15.d
	eor	z11.d, z13.d, z0.d
.LBB2_17:                               //   in Loop: Header=BB2_14 Depth=2
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w11, #1
	mov	z14.d, z20.d
	mov	z15.d, z21.d
	b.eq	.LBB2_19
// %bb.18:                              //   in Loop: Header=BB2_14 Depth=2
	sxtw	x24, w22
	str	z29, [sp, #3, mul vl]           // 16-byte Folded Spill
	str	z30, [sp, #2, mul vl]           // 16-byte Folded Spill
	ld1b	{ z0.b }, p0/z, [x2, x24]
	add	x25, x2, x24
	str	z31, [sp, #1, mul vl]           // 16-byte Folded Spill
	ld1b	{ z12.b }, p0/z, [x25, x1]
	tbl	z13.b, { z0.b }, z24.b
	tbl	z14.b, { z0.b }, z29.b
	tbl	z15.b, { z0.b }, z30.b
	tbl	z0.b, { z0.b }, z31.b
	mov	z29.d, z28.d
	mov	z30.d, z3.d
	mov	z31.d, z4.d
	str	z13, [sp]                       // 16-byte Folded Spill
	mov	z13.d, z24.d
	mov	z24.d, z7.d
	mov	z7.d, z6.d
	mov	z6.d, z5.d
	mov	z5.d, z1.d
	tbl	z1.b, { z12.b }, z28.b
	mov	z28.d, z27.d
	mov	z27.d, z26.d
	mov	z26.d, z25.d
	mov	z25.d, z2.d
	tbl	z2.b, { z12.b }, z3.b
	tbl	z3.b, { z12.b }, z4.b
	ldr	z4, [sp, #4, mul vl]            // 16-byte Folded Reload
	tbl	z4.b, { z12.b }, z4.b
	ldr	z12, [sp]                       // 16-byte Folded Reload
	eor	z12.d, z12.d, z1.d
	mov	z1.d, z5.d
	mov	z5.d, z6.d
	mov	z6.d, z7.d
	mov	z7.d, z24.d
	mov	z24.d, z13.d
	eor	z13.d, z14.d, z2.d
	mov	z2.d, z25.d
	mov	z25.d, z26.d
	mov	z26.d, z27.d
	mov	z27.d, z28.d
	mov	z28.d, z29.d
	ldr	z29, [sp, #3, mul vl]           // 16-byte Folded Reload
	eor	z14.d, z15.d, z3.d
	mov	z3.d, z30.d
	ldr	z30, [sp, #2, mul vl]           // 16-byte Folded Reload
	eor	z15.d, z0.d, z4.d
	mov	z4.d, z31.d
	ldr	z31, [sp, #1, mul vl]           // 16-byte Folded Reload
.LBB2_19:                               //   in Loop: Header=BB2_14 Depth=2
	eor	z5.d, z5.d, z8.d
	eor	z6.d, z6.d, z9.d
	cmp	w13, #1
	eor	z7.d, z7.d, z10.d
	eor	z1.d, z1.d, z11.d
	eor	z2.d, z2.d, z12.d
	eor	z25.d, z25.d, z13.d
	eor	z26.d, z26.d, z14.d
	eor	z27.d, z27.d, z15.d
	b.eq	.LBB2_13
// %bb.20:                              //   in Loop: Header=BB2_14 Depth=2
	sxtw	x24, w23
	mov	z8.d, z1.d
	mov	z22.d, z4.d
	mov	z23.d, z2.d
	mov	z21.d, z3.d
	add	x25, x2, x24
	ld1b	{ z0.b }, p0/z, [x2, x24]
	ld1b	{ z1.b }, p0/z, [x25, x1]
	tbl	z2.b, { z0.b }, z24.b
	tbl	z3.b, { z0.b }, z29.b
	tbl	z4.b, { z0.b }, z30.b
	tbl	z24.b, { z1.b }, z22.b
	ldr	z22, [sp, #4, mul vl]           // 16-byte Folded Reload
	tbl	z0.b, { z0.b }, z31.b
	tbl	z20.b, { z1.b }, z28.b
	tbl	z21.b, { z1.b }, z21.b
	tbl	z1.b, { z1.b }, z22.b
	eor	z22.d, z2.d, z20.d
	mov	z2.d, z23.d
	eor	z23.d, z3.d, z21.d
	eor	z20.d, z4.d, z24.d
	eor	z21.d, z0.d, z1.d
	mov	z1.d, z8.d
	b	.LBB2_13
.LBB2_21:
	add	w10, w15, w15, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w15, #5
	mov	x8, xzr
	mov	w11, w17
	rdvl	x12, #4
	lsl	w10, w10, #4
.LBB2_22:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB2_24
// %bb.23:                              //   in Loop: Header=BB2_22 Depth=1
	ldr	x13, [x4, #16]
	add	x14, x11, x8
	add	x15, x9, x8
	whilelt	p2.b, w14, w0
	add	x16, x10, x8
	st1b	{ z0.b }, p0, [x13, x8]
	whilelt	p3.b, w15, w0
	ldr	x13, [x4, #16]
	whilelt	p1.b, w16, w0
	st1b	{ z0.b }, p2, [x14, x13]
	ldr	x13, [x4, #16]
	st1b	{ z0.b }, p3, [x15, x13]
	ldr	x13, [x4, #16]
	st1b	{ z0.b }, p1, [x16, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p0, [x13, x8]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p2, [x14, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p3, [x15, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p1, [x16, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p0, [x13, x8]
	add	x8, x8, x12
	ldr	x13, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x14, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p3, [x15, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p1, [x16, x13]
	b.gt	.LBB2_22
.LBB2_24:
	addvl	sp, sp, #5
	ldp	x20, x19, [sp, #112]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #96]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x25, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #128            // 16-byte Folded Reload
.LBB2_25:
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
	b.lt	.LBB3_29
// %bb.1:
	stp	d15, d14, [sp, #-160]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	str	x29, [sp, #64]                  // 8-byte Spill
	stp	x28, x27, [sp, #80]             // 16-byte Folded Spill
	stp	x26, x25, [sp, #96]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #112]            // 16-byte Folded Spill
	stp	x22, x21, [sp, #128]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #144]            // 16-byte Folded Spill
	addvl	sp, sp, #-13
	rdvl	x5, #1
	cmp	w1, #1
	lsr	x17, x5, #4
	b.lt	.LBB3_25
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
	add	w12, w12, #32
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	ccmp	x13, #0, #4, eq
	sub	x13, x13, #1
	b.ne	.LBB3_5
// %bb.6:
	lsl	w12, w1, #6
	mov	x15, x16
	mov	w14, w12
.LBB3_7:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	add	w14, w14, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	ccmp	x15, #0, #4, eq
	sub	x15, x15, #1
	b.ne	.LBB3_7
// %bb.8:
	add	w14, w1, w1, lsl #1
	lsl	w14, w14, #5
	mov	w18, w14
.LBB3_9:                                // =>This Inner Loop Header: Depth=1
	add	x15, x2, w18, sxtw
	add	w18, w18, #32
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	ccmp	x16, #0, #4, eq
	sub	x16, x16, #1
	b.ne	.LBB3_9
// %bb.10:
	cmp	w9, #1
	add	w18, w17, w17, lsl #1
	lsl	w17, w17, #5
	ccmp	w11, #1, #0, eq
	ptrue	p0.b
	mov	x16, xzr
	ccmp	w13, #1, #0, eq
	lsl	w18, w18, #4
	mov	w1, w5
	ccmp	w15, #1, #0, eq
	mov	w6, #16                         // =0x10
	rdvl	x7, #4
	cset	w5, ne
	b	.LBB3_12
.LBB3_11:                               //   in Loop: Header=BB3_12 Depth=1
	ldr	x21, [x4, #24]
	ldr	z0, [sp, #11, mul vl]           // 16-byte Folded Reload
	st1b	{ z20.b }, p1, [x21, x16]
	ldr	x21, [x4, #24]
	st1b	{ z21.b }, p2, [x21, x19]
	ldr	x21, [x4, #24]
	st1b	{ z22.b }, p4, [x21, x20]
	ldr	x21, [x4, #24]
	st1b	{ z23.b }, p3, [x21, x22]
	ldr	x21, [x4, #16]
	st1b	{ z9.b }, p1, [x21, x16]
	ldr	x21, [x4, #16]
	st1b	{ z18.b }, p2, [x21, x19]
	ldr	x21, [x4, #16]
	st1b	{ z11.b }, p4, [x21, x20]
	ldr	x21, [x4, #16]
	st1b	{ z12.b }, p3, [x21, x22]
	ldr	x21, [x4, #8]
	st1b	{ z29.b }, p1, [x21, x16]
	ldr	x21, [x4, #8]
	st1b	{ z0.b }, p2, [x21, x19]
	ldr	z0, [sp, #12, mul vl]           // 16-byte Folded Reload
	ldr	x21, [x4, #8]
	st1b	{ z31.b }, p4, [x21, x20]
	ldr	x21, [x4, #8]
	st1b	{ z8.b }, p3, [x21, x22]
	ldr	x21, [x4]
	st1b	{ z17.b }, p1, [x21, x16]
	add	x16, x16, x7
	ldr	x21, [x4]
	cmp	w0, w16
	st1b	{ z19.b }, p2, [x21, x19]
	ldr	x19, [x4]
	st1b	{ z28.b }, p4, [x19, x20]
	ldr	x19, [x4]
	st1b	{ z0.b }, p3, [x19, x22]
	b.le	.LBB3_28
.LBB3_12:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB3_16 Depth 2
	whilelt	p1.b, w16, w0
	b.eq	.LBB3_28
// %bb.13:                              //   in Loop: Header=BB3_12 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	add	x19, x16, x1
	movi	v29.2d, #0000000000000000
	movi	v9.2d, #0000000000000000
	add	x20, x16, x17
	movi	v20.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	add	x22, x16, x18
	movi	v18.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	mov	x21, xzr
	str	z0, [sp, #11, mul vl]           // 16-byte Folded Spill
	movi	v28.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	movi	v11.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	mov	x23, x3
	movi	v0.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	mov	w24, w10
	movi	v12.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	mov	w25, w12
	whilelt	p2.b, w19, w0
	mov	w26, w14
	whilelt	p4.b, w20, w0
	whilelt	p3.b, w22, w0
	str	z0, [sp, #12, mul vl]           // 16-byte Folded Spill
	b	.LBB3_16
.LBB3_14:                               //   in Loop: Header=BB3_16 Depth=2
	ldr	z0, [sp, #12, mul vl]           // 16-byte Folded Reload
	eor	z17.d, z17.d, z26.d
	eor	z19.d, z19.d, z27.d
	eor	z28.d, z28.d, z14.d
	eor	z29.d, z29.d, z26.d
	eor	z31.d, z31.d, z14.d
	eor	z8.d, z8.d, z15.d
	eor	z9.d, z9.d, z26.d
	eor	z18.d, z18.d, z27.d
	eor	z0.d, z0.d, z15.d
	eor	z11.d, z11.d, z14.d
	eor	z12.d, z12.d, z15.d
	str	z0, [sp, #12, mul vl]           // 16-byte Folded Spill
	ldr	z0, [sp, #11, mul vl]           // 16-byte Folded Reload
	eor	z0.d, z0.d, z27.d
	str	z0, [sp, #11, mul vl]           // 16-byte Folded Spill
.LBB3_15:                               //   in Loop: Header=BB3_16 Depth=2
	eor	z20.d, z20.d, z26.d
	eor	z21.d, z21.d, z27.d
	add	x21, x21, #32
	eor	z22.d, z22.d, z14.d
	eor	z23.d, z23.d, z15.d
	cmp	x8, x21
	add	w26, w26, #32
	add	w25, w25, #32
	add	w24, w24, #32
	b.eq	.LBB3_11
.LBB3_16:                               //   Parent Loop BB3_12 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x27, [x23], #8
	ld1b	{ z26.b }, p1/z, [x27, x16]
	ld1b	{ z27.b }, p2/z, [x27, x19]
	ld1b	{ z14.b }, p4/z, [x27, x20]
	ld1b	{ z15.b }, p3/z, [x27, x22]
	tbz	w5, #0, .LBB3_14
// %bb.17:                              //   in Loop: Header=BB3_16 Depth=2
	movprfx	z0, z26
	and	z0.b, z0.b, #0xf
	lsr	z7.b, z26.b, #4
	lsr	z10.b, z27.b, #4
	lsr	z30.b, z14.b, #4
	lsr	z13.b, z15.b, #4
	cmp	w9, #1
	mov	z2.d, z26.d
	mov	z3.d, z27.d
	mov	z4.d, z14.d
	str	z0, [sp, #10, mul vl]           // 16-byte Folded Spill
	movprfx	z0, z27
	and	z0.b, z0.b, #0xf
	str	z0, [sp, #9, mul vl]            // 16-byte Folded Spill
	movprfx	z0, z14
	and	z0.b, z0.b, #0xf
	str	z0, [sp, #8, mul vl]            // 16-byte Folded Spill
	movprfx	z0, z15
	and	z0.b, z0.b, #0xf
	str	z0, [sp, #7, mul vl]            // 16-byte Folded Spill
	mov	z0.d, z15.d
	b.eq	.LBB3_19
// %bb.18:                              //   in Loop: Header=BB3_16 Depth=2
	sxtw	x27, w21
	ldr	z2, [sp, #10, mul vl]           // 16-byte Folded Reload
	ldr	z3, [sp, #9, mul vl]            // 16-byte Folded Reload
	ldr	z4, [sp, #8, mul vl]            // 16-byte Folded Reload
	ldr	z5, [sp, #7, mul vl]            // 16-byte Folded Reload
	mov	z16.d, z7.d
	add	x28, x2, x27
	ld1b	{ z0.b }, p0/z, [x2, x27]
	ld1b	{ z1.b }, p0/z, [x28, x6]
	tbl	z2.b, { z0.b }, z2.b
	tbl	z3.b, { z0.b }, z3.b
	tbl	z4.b, { z0.b }, z4.b
	tbl	z0.b, { z0.b }, z5.b
	tbl	z5.b, { z1.b }, z7.b
	tbl	z6.b, { z1.b }, z10.b
	tbl	z7.b, { z1.b }, z30.b
	tbl	z1.b, { z1.b }, z13.b
	eor	z2.d, z2.d, z5.d
	eor	z3.d, z3.d, z6.d
	eor	z4.d, z4.d, z7.d
	mov	z7.d, z16.d
	eor	z0.d, z0.d, z1.d
.LBB3_19:                               //   in Loop: Header=BB3_16 Depth=2
	str	z0, [sp, #1, mul vl]            // 16-byte Folded Spill
	mov	z0.d, z26.d
	mov	z1.d, z27.d
	str	z3, [sp, #3, mul vl]            // 16-byte Folded Spill
	mov	z3.d, z15.d
	cmp	w11, #1
	str	z2, [sp, #4, mul vl]            // 16-byte Folded Spill
	mov	z2.d, z14.d
	str	z4, [sp, #2, mul vl]            // 16-byte Folded Spill
	b.eq	.LBB3_21
// %bb.20:                              //   in Loop: Header=BB3_16 Depth=2
	sxtw	x27, w24
	ldr	z2, [sp, #10, mul vl]           // 16-byte Folded Reload
	ldr	z3, [sp, #9, mul vl]            // 16-byte Folded Reload
	ldr	z4, [sp, #8, mul vl]            // 16-byte Folded Reload
	ldr	z5, [sp, #7, mul vl]            // 16-byte Folded Reload
	add	x28, x2, x27
	ld1b	{ z0.b }, p0/z, [x2, x27]
	ld1b	{ z1.b }, p0/z, [x28, x6]
	tbl	z2.b, { z0.b }, z2.b
	tbl	z3.b, { z0.b }, z3.b
	tbl	z4.b, { z0.b }, z4.b
	tbl	z5.b, { z0.b }, z5.b
	tbl	z0.b, { z1.b }, z7.b
	tbl	z24.b, { z1.b }, z10.b
	tbl	z25.b, { z1.b }, z30.b
	tbl	z16.b, { z1.b }, z13.b
	eor	z0.d, z2.d, z0.d
	eor	z1.d, z3.d, z24.d
	eor	z2.d, z4.d, z25.d
	eor	z3.d, z5.d, z16.d
.LBB3_21:                               //   in Loop: Header=BB3_16 Depth=2
	mov	z4.d, z26.d
	mov	z5.d, z27.d
	cmp	w13, #1
	mov	z24.d, z14.d
	mov	z25.d, z15.d
	str	z13, [sp, #5, mul vl]           // 16-byte Folded Spill
	str	z30, [sp, #6, mul vl]           // 16-byte Folded Spill
	b.eq	.LBB3_23
// %bb.22:                              //   in Loop: Header=BB3_16 Depth=2
	sxtw	x27, w25
	ldr	z6, [sp, #10, mul vl]           // 16-byte Folded Reload
	ldr	z16, [sp, #6, mul vl]           // 16-byte Folded Reload
	str	z9, [sp]                        // 16-byte Folded Spill
	mov	z13.d, z29.d
	mov	z9.d, z17.d
	ld1b	{ z4.b }, p0/z, [x2, x27]
	add	x28, x2, x27
	mov	z29.d, z10.d
	ld1b	{ z5.b }, p0/z, [x28, x6]
	tbl	z30.b, { z4.b }, z6.b
	ldr	z6, [sp, #9, mul vl]            // 16-byte Folded Reload
	tbl	z24.b, { z4.b }, z6.b
	ldr	z6, [sp, #8, mul vl]            // 16-byte Folded Reload
	tbl	z25.b, { z4.b }, z6.b
	ldr	z6, [sp, #7, mul vl]            // 16-byte Folded Reload
	tbl	z17.b, { z4.b }, z6.b
	tbl	z4.b, { z5.b }, z7.b
	mov	z6.d, z18.d
	tbl	z18.b, { z5.b }, z10.b
	mov	z10.d, z7.d
	mov	z7.d, z11.d
	mov	z11.d, z31.d
	mov	z31.d, z19.d
	tbl	z19.b, { z5.b }, z16.b
	mov	z16.d, z8.d
	mov	z8.d, z28.d
	ldr	z28, [sp, #5, mul vl]           // 16-byte Folded Reload
	eor	z4.d, z30.d, z4.d
	tbl	z28.b, { z5.b }, z28.b
	eor	z5.d, z24.d, z18.d
	mov	z18.d, z6.d
	eor	z24.d, z25.d, z19.d
	mov	z19.d, z31.d
	mov	z31.d, z11.d
	mov	z11.d, z7.d
	mov	z7.d, z10.d
	mov	z10.d, z29.d
	mov	z29.d, z13.d
	eor	z25.d, z17.d, z28.d
	mov	z28.d, z8.d
	mov	z8.d, z16.d
	mov	z17.d, z9.d
	ldr	z9, [sp]                        // 16-byte Folded Reload
.LBB3_23:                               //   in Loop: Header=BB3_16 Depth=2
	ldr	z6, [sp, #4, mul vl]            // 16-byte Folded Reload
	ldr	z16, [sp, #1, mul vl]           // 16-byte Folded Reload
	eor	z29.d, z29.d, z0.d
	ldr	z0, [sp, #11, mul vl]           // 16-byte Folded Reload
	eor	z31.d, z31.d, z2.d
	eor	z8.d, z8.d, z3.d
	eor	z9.d, z9.d, z4.d
	eor	z18.d, z18.d, z5.d
	eor	z11.d, z11.d, z24.d
	eor	z17.d, z17.d, z6.d
	ldr	z6, [sp, #3, mul vl]            // 16-byte Folded Reload
	eor	z12.d, z12.d, z25.d
	eor	z0.d, z0.d, z1.d
	cmp	w15, #1
	eor	z19.d, z19.d, z6.d
	ldr	z6, [sp, #2, mul vl]            // 16-byte Folded Reload
	str	z0, [sp, #11, mul vl]           // 16-byte Folded Spill
	eor	z28.d, z28.d, z6.d
	ldr	z6, [sp, #12, mul vl]           // 16-byte Folded Reload
	eor	z6.d, z6.d, z16.d
	str	z6, [sp, #12, mul vl]           // 16-byte Folded Spill
	b.eq	.LBB3_15
// %bb.24:                              //   in Loop: Header=BB3_16 Depth=2
	sxtw	x27, w26
	ldr	z2, [sp, #10, mul vl]           // 16-byte Folded Reload
	ldr	z3, [sp, #9, mul vl]            // 16-byte Folded Reload
	ldr	z4, [sp, #8, mul vl]            // 16-byte Folded Reload
	ldr	z5, [sp, #7, mul vl]            // 16-byte Folded Reload
	ldr	z16, [sp, #5, mul vl]           // 16-byte Folded Reload
	add	x28, x2, x27
	ld1b	{ z0.b }, p0/z, [x2, x27]
	ld1b	{ z1.b }, p0/z, [x28, x6]
	tbl	z2.b, { z0.b }, z2.b
	tbl	z3.b, { z0.b }, z3.b
	tbl	z4.b, { z0.b }, z4.b
	tbl	z0.b, { z0.b }, z5.b
	tbl	z5.b, { z1.b }, z7.b
	ldr	z7, [sp, #6, mul vl]            // 16-byte Folded Reload
	tbl	z6.b, { z1.b }, z10.b
	tbl	z7.b, { z1.b }, z7.b
	tbl	z1.b, { z1.b }, z16.b
	eor	z26.d, z2.d, z5.d
	eor	z27.d, z3.d, z6.d
	eor	z14.d, z4.d, z7.d
	eor	z15.d, z0.d, z1.d
	b	.LBB3_15
.LBB3_25:
	add	w10, w17, w17, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w17, #5
	mov	x8, xzr
	mov	w11, w5
	rdvl	x12, #4
	lsl	w10, w10, #4
.LBB3_26:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB3_28
// %bb.27:                              //   in Loop: Header=BB3_26 Depth=1
	ldr	x13, [x4, #24]
	add	x14, x11, x8
	add	x15, x9, x8
	whilelt	p2.b, w14, w0
	add	x16, x10, x8
	st1b	{ z0.b }, p0, [x13, x8]
	whilelt	p3.b, w15, w0
	ldr	x13, [x4, #24]
	whilelt	p1.b, w16, w0
	st1b	{ z0.b }, p2, [x14, x13]
	ldr	x13, [x4, #24]
	st1b	{ z0.b }, p3, [x15, x13]
	ldr	x13, [x4, #24]
	st1b	{ z0.b }, p1, [x16, x13]
	ldr	x13, [x4, #16]
	st1b	{ z0.b }, p0, [x13, x8]
	ldr	x13, [x4, #16]
	st1b	{ z0.b }, p2, [x14, x13]
	ldr	x13, [x4, #16]
	st1b	{ z0.b }, p3, [x15, x13]
	ldr	x13, [x4, #16]
	st1b	{ z0.b }, p1, [x16, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p0, [x13, x8]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p2, [x14, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p3, [x15, x13]
	ldr	x13, [x4, #8]
	st1b	{ z0.b }, p1, [x16, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p0, [x13, x8]
	add	x8, x8, x12
	ldr	x13, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x14, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p3, [x15, x13]
	ldr	x13, [x4]
	st1b	{ z0.b }, p1, [x16, x13]
	b.gt	.LBB3_26
.LBB3_28:
	addvl	sp, sp, #13
	ldp	x20, x19, [sp, #144]            // 16-byte Folded Reload
	ldr	x29, [sp, #64]                  // 8-byte Reload
	ldp	x22, x21, [sp, #128]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #112]            // 16-byte Folded Reload
	ldp	x26, x25, [sp, #96]             // 16-byte Folded Reload
	ldp	x28, x27, [sp, #80]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #160            // 16-byte Folded Reload
.LBB3_29:
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
	b.lt	.LBB4_33
// %bb.1:
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
	sub	sp, sp, #16
	addvl	sp, sp, #-21
	rdvl	x5, #1
	mov	w13, w1
	lsl	w8, w1, #5
	lsr	x18, x5, #4
	lsl	x9, x13, #5
	lsl	w10, w1, #6
	add	w7, w1, w1, lsl #1
	lsl	w11, w1, #7
	cmp	w1, #1
	str	w8, [sp, #12]                   // 4-byte Spill
	b.lt	.LBB4_12
// %bb.2:
	mov	x15, xzr
	sub	x14, x9, #32
.LBB4_3:                                // =>This Inner Loop Header: Depth=1
	add	x12, x2, w15, sxtw
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	cset	w12, ne
	ccmp	x14, x15, #4, eq
	add	x15, x15, #32
	b.ne	.LBB4_3
// %bb.4:
	sub	x17, x13, #1
	ldr	w14, [sp, #12]                  // 4-byte Reload
	mov	x15, x17
.LBB4_5:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	add	w14, w14, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	cset	w13, ne
	ccmp	x15, #0, #4, eq
	sub	x15, x15, #1
	b.ne	.LBB4_5
// %bb.6:
	mov	w15, w10
	mov	x16, x17
.LBB4_7:                                // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	add	w15, w15, #32
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	cset	w14, ne
	ccmp	x16, #0, #4, eq
	sub	x16, x16, #1
	b.ne	.LBB4_7
// %bb.8:
	lsl	w16, w7, #5
	mov	x6, x17
.LBB4_9:                                // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	add	w16, w16, #32
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	cset	w15, ne
	ccmp	x6, #0, #4, eq
	sub	x6, x6, #1
	b.ne	.LBB4_9
// %bb.10:
	mov	w6, w11
.LBB4_11:                               // =>This Inner Loop Header: Depth=1
	add	x16, x2, w6, sxtw
	add	w6, w6, #32
	ldrb	w16, [x16, #1]
	cmp	w16, #1
	cset	w16, ne
	ccmp	x17, #0, #4, eq
	sub	x17, x17, #1
	b.ne	.LBB4_11
	b	.LBB4_13
.LBB4_12:
	mov	w13, wzr
	mov	w14, wzr
	mov	w15, wzr
	mov	w16, wzr
	mov	w12, wzr
.LBB4_13:
	add	w6, w18, w18, lsl #1
	orr	w19, w12, w13
	orr	w20, w14, w15
	lsl	w18, w18, #5
	orr	w19, w19, w20
	lsl	w7, w7, #5
	lsl	w6, w6, #4
	ptrue	p0.b
	mov	x17, xzr
	mov	w5, w5
	orr	w19, w19, w16
	mov	w20, #16                        // =0x10
	b	.LBB4_16
.LBB4_14:                               //   in Loop: Header=BB4_16 Depth=1
	movi	v24.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v14.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	movi	v15.2d, #0000000000000000
	movi	v11.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v12.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	movi	v13.2d, #0000000000000000
	movi	v9.2d, #0000000000000000
.LBB4_15:                               //   in Loop: Header=BB4_16 Depth=1
	ldr	x8, [x4, #32]
	st1b	{ z27.b }, p1, [x8, x17]
	ldr	x8, [x4, #32]
	st1b	{ z26.b }, p3, [x8, x23]
	ldr	x8, [x4, #32]
	st1b	{ z25.b }, p4, [x8, x24]
	ldr	x8, [x4, #32]
	st1b	{ z24.b }, p2, [x8, x22]
	ldr	x8, [x4, #24]
	st1b	{ z4.b }, p1, [x8, x17]
	ldr	x8, [x4, #24]
	st1b	{ z20.b }, p3, [x8, x23]
	ldr	x8, [x4, #24]
	st1b	{ z19.b }, p4, [x8, x24]
	ldr	x8, [x4, #24]
	st1b	{ z18.b }, p2, [x8, x22]
	ldr	x8, [x4, #16]
	st1b	{ z1.b }, p1, [x8, x17]
	ldr	x8, [x4, #16]
	st1b	{ z16.b }, p3, [x8, x23]
	ldr	x8, [x4, #16]
	st1b	{ z15.b }, p4, [x8, x24]
	ldr	x8, [x4, #16]
	st1b	{ z14.b }, p2, [x8, x22]
	ldr	x8, [x4, #8]
	st1b	{ z13.b }, p1, [x8, x17]
	ldr	x8, [x4, #8]
	st1b	{ z12.b }, p3, [x8, x23]
	ldr	x8, [x4, #8]
	st1b	{ z11.b }, p4, [x8, x24]
	ldr	x8, [x4, #8]
	st1b	{ z10.b }, p2, [x8, x22]
	ldr	x8, [x4]
	st1b	{ z9.b }, p1, [x8, x17]
	rdvl	x8, #4
	add	x17, x17, x8
	ldr	x8, [x4]
	cmp	w0, w17
	st1b	{ z8.b }, p3, [x8, x23]
	ldr	x8, [x4]
	st1b	{ z23.b }, p4, [x8, x24]
	ldr	x8, [x4]
	st1b	{ z22.b }, p2, [x8, x22]
	b.le	.LBB4_32
.LBB4_16:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB4_21 Depth 2
	whilelt	p1.b, w17, w0
	b.eq	.LBB4_32
// %bb.17:                              //   in Loop: Header=BB4_16 Depth=1
	add	x23, x17, x5
	add	x24, x17, x18
	add	x22, x17, x6
	whilelt	p3.b, w23, w0
	whilelt	p4.b, w24, w0
	whilelt	p2.b, w22, w0
	cmp	w1, #1
	b.lt	.LBB4_14
// %bb.18:                              //   in Loop: Header=BB4_16 Depth=1
	movi	v9.2d, #0000000000000000
	movi	v13.2d, #0000000000000000
	ldr	w27, [sp, #12]                  // 4-byte Reload
	movi	v1.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	x25, xzr
	movi	v27.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	mov	x26, x3
	movi	v12.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	mov	w28, w10
	movi	v20.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	mov	w29, w7
	movi	v23.2d, #0000000000000000
	movi	v11.2d, #0000000000000000
	mov	w30, w11
	movi	v15.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	movi	v14.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	b	.LBB4_21
.LBB4_19:                               //   in Loop: Header=BB4_21 Depth=2
	eor	z9.d, z9.d, z30.d
	eor	z8.d, z8.d, z31.d
	eor	z23.d, z23.d, z2.d
	eor	z22.d, z22.d, z3.d
	eor	z13.d, z13.d, z30.d
	eor	z12.d, z12.d, z31.d
	eor	z11.d, z11.d, z2.d
	eor	z10.d, z10.d, z3.d
	eor	z1.d, z1.d, z30.d
	eor	z16.d, z16.d, z31.d
	eor	z15.d, z15.d, z2.d
	eor	z14.d, z14.d, z3.d
	eor	z4.d, z4.d, z30.d
	eor	z20.d, z20.d, z31.d
	eor	z19.d, z19.d, z2.d
	eor	z18.d, z18.d, z3.d
.LBB4_20:                               //   in Loop: Header=BB4_21 Depth=2
	eor	z27.d, z27.d, z30.d
	eor	z26.d, z26.d, z31.d
	add	x25, x25, #32
	eor	z25.d, z25.d, z2.d
	eor	z24.d, z24.d, z3.d
	add	w30, w30, #32
	cmp	x9, x25
	add	w29, w29, #32
	add	w28, w28, #32
	add	w27, w27, #32
	b.eq	.LBB4_15
.LBB4_21:                               //   Parent Loop BB4_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x21, [x26], #8
	ld1b	{ z30.b }, p1/z, [x21, x17]
	ld1b	{ z31.b }, p3/z, [x21, x23]
	ld1b	{ z2.b }, p4/z, [x21, x24]
	ld1b	{ z3.b }, p2/z, [x21, x22]
	tbz	w19, #0, .LBB4_19
// %bb.22:                              //   in Loop: Header=BB4_21 Depth=2
	lsr	z0.b, z30.b, #4
	add	x8, sp, #16
	movprfx	z6, z30
	and	z6.b, z6.b, #0xf
	str	z4, [x8, #8, mul vl]            // 16-byte Folded Spill
	movprfx	z7, z31
	and	z7.b, z7.b, #0xf
	mov	z4.d, z30.d
	str	z16, [x8, #12, mul vl]          // 16-byte Folded Spill
	mov	z5.d, z31.d
	mov	z16.d, z3.d
	str	z0, [x8, #20, mul vl]           // 16-byte Folded Spill
	lsr	z0.b, z31.b, #4
	str	z20, [x8, #9, mul vl]           // 16-byte Folded Spill
	str	z19, [x8, #10, mul vl]          // 16-byte Folded Spill
	str	z0, [x8, #19, mul vl]           // 16-byte Folded Spill
	movprfx	z0, z2
	and	z0.b, z0.b, #0xf
	str	z18, [x8, #11, mul vl]          // 16-byte Folded Spill
	str	z6, [x8, #14, mul vl]           // 16-byte Folded Spill
	str	z0, [x8, #16, mul vl]           // 16-byte Folded Spill
	lsr	z0.b, z2.b, #4
	str	z7, [x8, #13, mul vl]           // 16-byte Folded Spill
	str	z0, [x8, #18, mul vl]           // 16-byte Folded Spill
	movprfx	z0, z3
	and	z0.b, z0.b, #0xf
	str	z0, [x8, #15, mul vl]           // 16-byte Folded Spill
	lsr	z0.b, z3.b, #4
	str	z0, [x8, #17, mul vl]           // 16-byte Folded Spill
	mov	z0.d, z2.d
	cbz	w12, .LBB4_24
// %bb.23:                              //   in Loop: Header=BB4_21 Depth=2
	sxtw	x21, w25
	mov	z19.d, z1.d
	ld1b	{ z0.b }, p0/z, [x2, x21]
	add	x8, x2, x21
	ld1b	{ z1.b }, p0/z, [x8, x20]
	add	x8, sp, #16
	ldr	z16, [x8, #19, mul vl]          // 16-byte Folded Reload
	ldr	z17, [x8, #18, mul vl]          // 16-byte Folded Reload
	ldr	z18, [x8, #17, mul vl]          // 16-byte Folded Reload
	tbl	z4.b, { z0.b }, z6.b
	tbl	z5.b, { z0.b }, z7.b
	ldr	z6, [x8, #16, mul vl]           // 16-byte Folded Reload
	ldr	z7, [x8, #15, mul vl]           // 16-byte Folded Reload
	tbl	z16.b, { z1.b }, z16.b
	tbl	z17.b, { z1.b }, z17.b
	tbl	z18.b, { z1.b }, z18.b
	tbl	z6.b, { z0.b }, z6.b
	tbl	z7.b, { z0.b }, z7.b
	ldr	z0, [x8, #20, mul vl]           // 16-byte Folded Reload
	eor	z5.d, z5.d, z16.d
	tbl	z0.b, { z1.b }, z0.b
	mov	z1.d, z19.d
	eor	z16.d, z7.d, z18.d
	ldr	z7, [x8, #13, mul vl]           // 16-byte Folded Reload
	eor	z4.d, z4.d, z0.d
	eor	z0.d, z6.d, z17.d
	ldr	z6, [x8, #14, mul vl]           // 16-byte Folded Reload
.LBB4_24:                               //   in Loop: Header=BB4_21 Depth=2
	str	z16, [x8, #6, mul vl]           // 16-byte Folded Spill
	mov	z18.d, z31.d
	mov	z16.d, z2.d
	str	z0, [x8, #7, mul vl]            // 16-byte Folded Spill
	mov	z0.d, z30.d
	mov	z17.d, z3.d
	cbz	w13, .LBB4_26
// %bb.25:                              //   in Loop: Header=BB4_21 Depth=2
	sxtw	x8, w27
	mov	z21.d, z4.d
	mov	z28.d, z5.d
	add	x21, x2, x8
	ld1b	{ z4.b }, p0/z, [x2, x8]
	add	x8, sp, #16
	ldr	z0, [x8, #14, mul vl]           // 16-byte Folded Reload
	ld1b	{ z5.b }, p0/z, [x21, x20]
	tbl	z6.b, { z4.b }, z0.b
	ldr	z0, [x8, #13, mul vl]           // 16-byte Folded Reload
	tbl	z7.b, { z4.b }, z0.b
	ldr	z0, [x8, #16, mul vl]           // 16-byte Folded Reload
	tbl	z16.b, { z4.b }, z0.b
	ldr	z0, [x8, #15, mul vl]           // 16-byte Folded Reload
	tbl	z17.b, { z4.b }, z0.b
	ldr	z0, [x8, #20, mul vl]           // 16-byte Folded Reload
	tbl	z4.b, { z5.b }, z0.b
	ldr	z0, [x8, #19, mul vl]           // 16-byte Folded Reload
	tbl	z18.b, { z5.b }, z0.b
	ldr	z0, [x8, #18, mul vl]           // 16-byte Folded Reload
	tbl	z19.b, { z5.b }, z0.b
	ldr	z0, [x8, #17, mul vl]           // 16-byte Folded Reload
	eor	z18.d, z7.d, z18.d
	ldr	z7, [x8, #13, mul vl]           // 16-byte Folded Reload
	tbl	z20.b, { z5.b }, z0.b
	mov	z5.d, z28.d
	eor	z0.d, z6.d, z4.d
	mov	z4.d, z21.d
	ldr	z6, [x8, #14, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z16.d, z19.d
	eor	z17.d, z17.d, z20.d
.LBB4_26:                               //   in Loop: Header=BB4_21 Depth=2
	str	z17, [x8, #2, mul vl]           // 16-byte Folded Spill
	mov	z17.d, z31.d
	mov	z19.d, z3.d
	str	z16, [x8, #3, mul vl]           // 16-byte Folded Spill
	mov	z16.d, z30.d
	str	z18, [x8, #4, mul vl]           // 16-byte Folded Spill
	mov	z18.d, z2.d
	str	z0, [x8, #5, mul vl]            // 16-byte Folded Spill
	cbz	w14, .LBB4_28
// %bb.27:                              //   in Loop: Header=BB4_21 Depth=2
	sxtw	x8, w28
	add	x21, x2, x8
	ld1b	{ z16.b }, p0/z, [x2, x8]
	add	x8, sp, #16
	ldr	z0, [x8, #16, mul vl]           // 16-byte Folded Reload
	ld1b	{ z17.b }, p0/z, [x21, x20]
	tbl	z18.b, { z16.b }, z6.b
	tbl	z19.b, { z16.b }, z7.b
	tbl	z20.b, { z16.b }, z0.b
	ldr	z0, [x8, #15, mul vl]           // 16-byte Folded Reload
	tbl	z21.b, { z16.b }, z0.b
	ldr	z0, [x8, #20, mul vl]           // 16-byte Folded Reload
	tbl	z16.b, { z17.b }, z0.b
	ldr	z0, [x8, #19, mul vl]           // 16-byte Folded Reload
	tbl	z28.b, { z17.b }, z0.b
	ldr	z0, [x8, #18, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z18.d, z16.d
	tbl	z29.b, { z17.b }, z0.b
	ldr	z0, [x8, #17, mul vl]           // 16-byte Folded Reload
	tbl	z0.b, { z17.b }, z0.b
	eor	z17.d, z19.d, z28.d
	eor	z18.d, z20.d, z29.d
	eor	z19.d, z21.d, z0.d
.LBB4_28:                               //   in Loop: Header=BB4_21 Depth=2
	mov	z20.d, z30.d
	mov	z21.d, z31.d
	mov	z28.d, z2.d
	mov	z29.d, z3.d
	cbz	w15, .LBB4_30
// %bb.29:                              //   in Loop: Header=BB4_21 Depth=2
	sxtw	x8, w29
	add	x21, x2, x8
	ld1b	{ z0.b }, p0/z, [x2, x8]
	add	x8, sp, #16
	str	z4, [x8, #1, mul vl]            // 16-byte Folded Spill
	ldr	z4, [x8, #16, mul vl]           // 16-byte Folded Reload
	ld1b	{ z20.b }, p0/z, [x21, x20]
	str	z24, [x8]                       // 16-byte Folded Spill
	mov	z24.d, z5.d
	ldr	z5, [x8, #18, mul vl]           // 16-byte Folded Reload
	tbl	z21.b, { z0.b }, z6.b
	tbl	z28.b, { z0.b }, z7.b
	mov	z7.d, z1.d
	tbl	z29.b, { z0.b }, z4.b
	ldr	z4, [x8, #15, mul vl]           // 16-byte Folded Reload
	ldr	z1, [x8, #20, mul vl]           // 16-byte Folded Reload
	mov	z6.d, z15.d
	mov	z15.d, z12.d
	mov	z12.d, z9.d
	mov	z9.d, z22.d
	tbl	z0.b, { z0.b }, z4.b
	ldr	z4, [x8, #19, mul vl]           // 16-byte Folded Reload
	tbl	z1.b, { z20.b }, z1.b
	tbl	z22.b, { z20.b }, z4.b
	mov	z4.d, z13.d
	mov	z13.d, z10.d
	mov	z10.d, z23.d
	tbl	z23.b, { z20.b }, z5.b
	mov	z5.d, z11.d
	mov	z11.d, z8.d
	ldr	z8, [x8, #17, mul vl]           // 16-byte Folded Reload
	tbl	z8.b, { z20.b }, z8.b
	eor	z20.d, z21.d, z1.d
	mov	z1.d, z7.d
	ldr	z7, [x8, #13, mul vl]           // 16-byte Folded Reload
	eor	z21.d, z28.d, z22.d
	mov	z22.d, z9.d
	mov	z9.d, z12.d
	mov	z12.d, z15.d
	mov	z15.d, z6.d
	ldr	z6, [x8, #14, mul vl]           // 16-byte Folded Reload
	eor	z28.d, z29.d, z23.d
	mov	z23.d, z10.d
	mov	z10.d, z13.d
	mov	z13.d, z4.d
	ldr	z4, [x8, #1, mul vl]            // 16-byte Folded Reload
	eor	z29.d, z0.d, z8.d
	mov	z8.d, z11.d
	mov	z11.d, z5.d
	mov	z5.d, z24.d
	ldr	z24, [x8]                       // 16-byte Folded Reload
.LBB4_30:                               //   in Loop: Header=BB4_21 Depth=2
	ldr	z0, [x8, #7, mul vl]            // 16-byte Folded Reload
	eor	z9.d, z9.d, z4.d
	ldr	z4, [x8, #8, mul vl]            // 16-byte Folded Reload
	eor	z1.d, z1.d, z16.d
	ldr	z16, [x8, #12, mul vl]          // 16-byte Folded Reload
	eor	z15.d, z15.d, z18.d
	eor	z14.d, z14.d, z19.d
	ldr	z19, [x8, #10, mul vl]          // 16-byte Folded Reload
	ldr	z18, [x8, #11, mul vl]          // 16-byte Folded Reload
	eor	z23.d, z23.d, z0.d
	ldr	z0, [x8, #6, mul vl]            // 16-byte Folded Reload
	eor	z4.d, z4.d, z20.d
	ldr	z20, [x8, #9, mul vl]           // 16-byte Folded Reload
	eor	z8.d, z8.d, z5.d
	eor	z16.d, z16.d, z17.d
	eor	z19.d, z19.d, z28.d
	eor	z18.d, z18.d, z29.d
	eor	z22.d, z22.d, z0.d
	ldr	z0, [x8, #5, mul vl]            // 16-byte Folded Reload
	eor	z20.d, z20.d, z21.d
	eor	z13.d, z13.d, z0.d
	ldr	z0, [x8, #4, mul vl]            // 16-byte Folded Reload
	eor	z12.d, z12.d, z0.d
	ldr	z0, [x8, #3, mul vl]            // 16-byte Folded Reload
	eor	z11.d, z11.d, z0.d
	ldr	z0, [x8, #2, mul vl]            // 16-byte Folded Reload
	eor	z10.d, z10.d, z0.d
	cbz	w16, .LBB4_20
// %bb.31:                              //   in Loop: Header=BB4_21 Depth=2
	sxtw	x8, w30
	mov	z21.d, z4.d
	mov	z17.d, z1.d
	add	x21, x2, x8
	ld1b	{ z0.b }, p0/z, [x2, x8]
	add	x8, sp, #16
	ldr	z4, [x8, #16, mul vl]           // 16-byte Folded Reload
	ldr	z5, [x8, #15, mul vl]           // 16-byte Folded Reload
	ld1b	{ z1.b }, p0/z, [x21, x20]
	ldr	z28, [x8, #17, mul vl]          // 16-byte Folded Reload
	tbl	z2.b, { z0.b }, z6.b
	tbl	z3.b, { z0.b }, z7.b
	ldr	z6, [x8, #19, mul vl]           // 16-byte Folded Reload
	tbl	z4.b, { z0.b }, z4.b
	tbl	z0.b, { z0.b }, z5.b
	ldr	z5, [x8, #20, mul vl]           // 16-byte Folded Reload
	ldr	z7, [x8, #18, mul vl]           // 16-byte Folded Reload
	tbl	z6.b, { z1.b }, z6.b
	tbl	z5.b, { z1.b }, z5.b
	tbl	z7.b, { z1.b }, z7.b
	tbl	z1.b, { z1.b }, z28.b
	eor	z31.d, z3.d, z6.d
	eor	z30.d, z2.d, z5.d
	eor	z2.d, z4.d, z7.d
	eor	z3.d, z0.d, z1.d
	mov	z1.d, z17.d
	mov	z4.d, z21.d
	b	.LBB4_20
.LBB4_32:
	addvl	sp, sp, #21
	add	sp, sp, #16
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
.LBB4_33:
	ret
.Lfunc_end4:
	.size	gf_5vect_dot_prod_sve, .Lfunc_end4-gf_5vect_dot_prod_sve
                                        // -- End function
	.globl	gf_6vect_dot_prod_sve           // -- Begin function gf_6vect_dot_prod_sve
	.p2align	2
	.type	gf_6vect_dot_prod_sve,@function
gf_6vect_dot_prod_sve:                  // @gf_6vect_dot_prod_sve
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
	addvl	sp, sp, #-29
	cmp	w0, #16
	str	x3, [sp, #24]                   // 8-byte Spill
	b.ge	.LBB5_2
.LBB5_1:
	addvl	sp, sp, #29
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
.LBB5_2:
	lsl	w11, w1, #5
	lsl	w10, w1, #6
	rdvl	x8, #1
	mov	w13, w1
	lsr	x5, x8, #4
	add	w19, w1, w1, lsl #2
	lsl	x9, x13, #5
	stp	w10, w11, [sp, #16]             // 8-byte Folded Spill
	add	w10, w1, w1, lsl #1
	lsl	w11, w1, #7
	cmp	w1, #1
	str	w11, [sp, #12]                  // 4-byte Spill
	b.lt	.LBB5_15
// %bb.3:
	mov	x15, xzr
	sub	x14, x9, #32
.LBB5_4:                                // =>This Inner Loop Header: Depth=1
	add	x12, x2, w15, sxtw
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	cset	w12, ne
	ccmp	x14, x15, #4, eq
	add	x15, x15, #32
	b.ne	.LBB5_4
// %bb.5:
	sub	x18, x13, #1
	ldr	w14, [sp, #20]                  // 4-byte Reload
	mov	x15, x18
.LBB5_6:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	add	w14, w14, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	cset	w13, ne
	ccmp	x15, #0, #4, eq
	sub	x15, x15, #1
	b.ne	.LBB5_6
// %bb.7:
	ldr	w15, [sp, #16]                  // 4-byte Reload
	mov	x16, x18
.LBB5_8:                                // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	add	w15, w15, #32
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	cset	w14, ne
	ccmp	x16, #0, #4, eq
	sub	x16, x16, #1
	b.ne	.LBB5_8
// %bb.9:
	lsl	w16, w10, #5
	mov	x17, x18
.LBB5_10:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	add	w16, w16, #32
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	cset	w15, ne
	ccmp	x17, #0, #4, eq
	sub	x17, x17, #1
	b.ne	.LBB5_10
// %bb.11:
	ldr	w17, [sp, #12]                  // 4-byte Reload
	mov	x6, x18
.LBB5_12:                               // =>This Inner Loop Header: Depth=1
	add	x16, x2, w17, sxtw
	add	w17, w17, #32
	ldrb	w16, [x16, #1]
	cmp	w16, #1
	cset	w16, ne
	ccmp	x6, #0, #4, eq
	sub	x6, x6, #1
	b.ne	.LBB5_12
// %bb.13:
	lsl	w6, w19, #5
.LBB5_14:                               // =>This Inner Loop Header: Depth=1
	add	x17, x2, w6, sxtw
	add	w6, w6, #32
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	cset	w17, ne
	ccmp	x18, #0, #4, eq
	sub	x18, x18, #1
	b.ne	.LBB5_14
	b	.LBB5_16
.LBB5_15:
	mov	w13, wzr
	mov	w14, wzr
	mov	w15, wzr
	mov	w16, wzr
	mov	w17, wzr
	mov	w12, wzr
.LBB5_16:
	add	w7, w5, w5, lsl #1
	orr	w6, w12, w13
	orr	w20, w14, w15
	orr	w20, w6, w20
	lsl	w5, w5, #5
	mov	w6, w8
	lsl	w7, w7, #4
	orr	w8, w20, w16
	lsl	w3, w19, #5
	lsl	w20, w10, #5
	ptrue	p0.b
	mov	x18, xzr
	orr	w21, w8, w17
	mov	w22, #16                        // =0x10
	b	.LBB5_19
.LBB5_17:                               //   in Loop: Header=BB5_19 Depth=1
	movi	v0.2d, #0000000000000000
	add	x8, sp, #32
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	str	z0, [x8, #24, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	str	z1, [x8, #28, mul vl]           // 16-byte Folded Spill
	movi	v22.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	str	z2, [x8, #27, mul vl]           // 16-byte Folded Spill
	movi	v17.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	str	z3, [x8, #26, mul vl]           // 16-byte Folded Spill
	movi	v4.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	str	z0, [x8, #23, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	str	z7, [x8, #25, mul vl]           // 16-byte Folded Spill
	movi	v6.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	str	z0, [x8, #22, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #21, mul vl]           // 16-byte Folded Spill
.LBB5_18:                               //   in Loop: Header=BB5_19 Depth=1
	ldr	x8, [x4, #40]
	add	x10, sp, #32
	ldr	z0, [x10, #21, mul vl]          // 16-byte Folded Reload
	st1b	{ z31.b }, p1, [x8, x18]
	ldr	x8, [x4, #40]
	st1b	{ z30.b }, p3, [x8, x25]
	ldr	x8, [x4, #40]
	st1b	{ z29.b }, p4, [x8, x26]
	ldr	x8, [x4, #40]
	st1b	{ z28.b }, p2, [x8, x24]
	ldr	x8, [x4, #32]
	st1b	{ z18.b }, p1, [x8, x18]
	ldr	x8, [x4, #32]
	st1b	{ z17.b }, p3, [x8, x25]
	ldr	x8, [x4, #32]
	st1b	{ z27.b }, p4, [x8, x26]
	ldr	x8, [x4, #32]
	st1b	{ z26.b }, p2, [x8, x24]
	ldr	x8, [x4, #24]
	st1b	{ z6.b }, p1, [x8, x18]
	ldr	x8, [x4, #24]
	st1b	{ z25.b }, p3, [x8, x25]
	ldr	x8, [x4, #24]
	st1b	{ z24.b }, p4, [x8, x26]
	ldr	x8, [x4, #24]
	st1b	{ z23.b }, p2, [x8, x24]
	ldr	x8, [x4, #16]
	st1b	{ z5.b }, p1, [x8, x18]
	ldr	x8, [x4, #16]
	st1b	{ z4.b }, p3, [x8, x25]
	ldr	x8, [x4, #16]
	st1b	{ z22.b }, p4, [x8, x26]
	ldr	x8, [x4, #16]
	st1b	{ z21.b }, p2, [x8, x24]
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p1, [x8, x18]
	ldr	z0, [x10, #22, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p3, [x8, x25]
	ldr	z0, [x10, #23, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p4, [x8, x26]
	ldr	z0, [x10, #24, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p2, [x8, x24]
	ldr	z0, [x10, #25, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4]
	st1b	{ z0.b }, p1, [x8, x18]
	rdvl	x8, #4
	ldr	z0, [x10, #26, mul vl]          // 16-byte Folded Reload
	add	x18, x18, x8
	ldr	x8, [x4]
	cmp	w0, w18
	st1b	{ z0.b }, p3, [x8, x25]
	ldr	z0, [x10, #27, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4]
	st1b	{ z0.b }, p4, [x8, x26]
	ldr	z0, [x10, #28, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4]
	st1b	{ z0.b }, p2, [x8, x24]
	b.le	.LBB5_1
.LBB5_19:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB5_24 Depth 2
	whilelt	p1.b, w18, w0
	b.eq	.LBB5_1
// %bb.20:                              //   in Loop: Header=BB5_19 Depth=1
	add	x25, x18, x6
	add	x26, x18, x5
	add	x24, x18, x7
	whilelt	p3.b, w25, w0
	whilelt	p4.b, w26, w0
	whilelt	p2.b, w24, w0
	cmp	w1, #1
	b.lt	.LBB5_17
// %bb.21:                              //   in Loop: Header=BB5_19 Depth=1
	movi	v0.2d, #0000000000000000
	add	x8, sp, #32
	movi	v5.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	ldr	x28, [sp, #24]                  // 8-byte Reload
	movi	v31.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	x27, xzr
	movi	v25.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	w23, w20
	str	z0, [x8, #25, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	mov	w10, w3
	movi	v27.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	str	z0, [x8, #21, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	ldp	w30, w29, [sp, #16]             // 8-byte Folded Reload
	str	z0, [x8, #26, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #22, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #27, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #23, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #28, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #24, mul vl]           // 16-byte Folded Spill
	ldr	w8, [sp, #12]                   // 4-byte Reload
	b	.LBB5_24
.LBB5_22:                               //   in Loop: Header=BB5_24 Depth=2
	ldr	z16, [x11, #25, mul vl]         // 16-byte Folded Reload
	ldr	z0, [x11, #21, mul vl]          // 16-byte Folded Reload
	eor	z5.d, z5.d, z10.d
	eor	z4.d, z4.d, z11.d
	eor	z22.d, z22.d, z8.d
	eor	z21.d, z21.d, z7.d
	eor	z6.d, z6.d, z10.d
	eor	z25.d, z25.d, z11.d
	eor	z24.d, z24.d, z8.d
	eor	z16.d, z16.d, z10.d
	eor	z0.d, z0.d, z10.d
	eor	z23.d, z23.d, z7.d
	eor	z18.d, z18.d, z10.d
	eor	z17.d, z17.d, z11.d
	eor	z27.d, z27.d, z8.d
	eor	z26.d, z26.d, z7.d
	str	z16, [x11, #25, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #26, mul vl]         // 16-byte Folded Reload
	str	z0, [x11, #21, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #22, mul vl]          // 16-byte Folded Reload
	eor	z16.d, z16.d, z11.d
	eor	z0.d, z0.d, z11.d
	str	z16, [x11, #26, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #27, mul vl]         // 16-byte Folded Reload
	str	z0, [x11, #22, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #23, mul vl]          // 16-byte Folded Reload
	eor	z16.d, z16.d, z8.d
	eor	z0.d, z0.d, z8.d
	str	z16, [x11, #27, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #28, mul vl]         // 16-byte Folded Reload
	str	z0, [x11, #23, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #24, mul vl]          // 16-byte Folded Reload
	eor	z16.d, z16.d, z7.d
	eor	z0.d, z0.d, z7.d
	str	z16, [x11, #28, mul vl]         // 16-byte Folded Spill
	str	z0, [x11, #24, mul vl]          // 16-byte Folded Spill
.LBB5_23:                               //   in Loop: Header=BB5_24 Depth=2
	eor	z31.d, z31.d, z10.d
	eor	z30.d, z30.d, z11.d
	add	x27, x27, #32
	eor	z29.d, z29.d, z8.d
	eor	z28.d, z28.d, z7.d
	add	w10, w10, #32
	add	w8, w8, #32
	cmp	x9, x27
	add	w23, w23, #32
	add	w30, w30, #32
	add	w29, w29, #32
	b.eq	.LBB5_18
.LBB5_24:                               //   Parent Loop BB5_19 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x11, [x28], #8
	ld1b	{ z10.b }, p1/z, [x11, x18]
	ld1b	{ z11.b }, p3/z, [x11, x25]
	ld1b	{ z8.b }, p4/z, [x11, x26]
	ld1b	{ z7.b }, p2/z, [x11, x24]
	add	x11, sp, #32
	tbz	w21, #0, .LBB5_22
// %bb.25:                              //   in Loop: Header=BB5_24 Depth=2
	str	z4, [x11, #20, mul vl]          // 16-byte Folded Spill
	lsr	z4.b, z11.b, #4
	lsr	z9.b, z10.b, #4
	mov	z0.d, z10.d
	mov	z1.d, z11.d
	str	z6, [x11, #18, mul vl]          // 16-byte Folded Spill
	mov	z2.d, z8.d
	mov	z3.d, z7.d
	str	z5, [x11, #19, mul vl]          // 16-byte Folded Spill
	str	z4, [x11, #17, mul vl]          // 16-byte Folded Spill
	lsr	z4.b, z8.b, #4
	movprfx	z12, z10
	and	z12.b, z12.b, #0xf
	movprfx	z13, z11
	and	z13.b, z13.b, #0xf
	movprfx	z19, z8
	and	z19.b, z19.b, #0xf
	movprfx	z14, z7
	and	z14.b, z14.b, #0xf
	str	z17, [x11, #14, mul vl]         // 16-byte Folded Spill
	str	z4, [x11, #16, mul vl]          // 16-byte Folded Spill
	lsr	z4.b, z7.b, #4
	str	z18, [x11, #13, mul vl]         // 16-byte Folded Spill
	str	z4, [x11, #15, mul vl]          // 16-byte Folded Spill
	cbz	w12, .LBB5_27
// %bb.26:                              //   in Loop: Header=BB5_24 Depth=2
	sxtw	x11, w27
	mov	z15.d, z19.d
	mov	z0.d, z14.d
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x19, x2, x11
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x19, x22]
	ldr	z20, [x11, #16, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z4.b }, z12.b
	tbl	z16.b, { z4.b }, z13.b
	tbl	z17.b, { z4.b }, z19.b
	tbl	z4.b, { z4.b }, z14.b
	ldr	z19, [x11, #17, mul vl]         // 16-byte Folded Reload
	mov	z14.d, z13.d
	mov	z13.d, z12.d
	ldr	z12, [x11, #15, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z5.b }, z9.b
	tbl	z20.b, { z5.b }, z20.b
	tbl	z19.b, { z5.b }, z19.b
	tbl	z5.b, { z5.b }, z12.b
	mov	z12.d, z13.d
	mov	z13.d, z14.d
	mov	z14.d, z0.d
	eor	z0.d, z6.d, z18.d
	ldr	z18, [x11, #13, mul vl]         // 16-byte Folded Reload
	eor	z2.d, z17.d, z20.d
	ldr	z17, [x11, #14, mul vl]         // 16-byte Folded Reload
	eor	z1.d, z16.d, z19.d
	mov	z19.d, z15.d
	eor	z3.d, z4.d, z5.d
.LBB5_27:                               //   in Loop: Header=BB5_24 Depth=2
	mov	z15.d, z10.d
	mov	z6.d, z11.d
	str	z24, [x11, #8, mul vl]          // 16-byte Folded Spill
	mov	z16.d, z8.d
	mov	z4.d, z7.d
	str	z23, [x11, #9, mul vl]          // 16-byte Folded Spill
	str	z22, [x11, #10, mul vl]         // 16-byte Folded Spill
	str	z21, [x11, #11, mul vl]         // 16-byte Folded Spill
	cbz	w13, .LBB5_29
// %bb.28:                              //   in Loop: Header=BB5_24 Depth=2
	sxtw	x11, w29
	mov	z22.d, z19.d
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x19, x2, x11
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x19, x22]
	ldr	z20, [x11, #16, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x11, #15, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z4.b }, z19.b
	ldr	z19, [x11, #17, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z4.b }, z12.b
	tbl	z17.b, { z4.b }, z13.b
	tbl	z4.b, { z4.b }, z14.b
	tbl	z16.b, { z5.b }, z9.b
	tbl	z20.b, { z5.b }, z20.b
	tbl	z19.b, { z5.b }, z19.b
	tbl	z5.b, { z5.b }, z21.b
	eor	z15.d, z6.d, z16.d
	eor	z16.d, z18.d, z20.d
	ldr	z18, [x11, #13, mul vl]         // 16-byte Folded Reload
	eor	z6.d, z17.d, z19.d
	mov	z19.d, z22.d
	ldr	z17, [x11, #14, mul vl]         // 16-byte Folded Reload
	eor	z4.d, z4.d, z5.d
.LBB5_29:                               //   in Loop: Header=BB5_24 Depth=2
	str	z6, [x11, #4, mul vl]           // 16-byte Folded Spill
	mov	z6.d, z10.d
	mov	z20.d, z11.d
	mov	z21.d, z8.d
	mov	z23.d, z7.d
	str	z4, [x11, #2, mul vl]           // 16-byte Folded Spill
	str	z16, [x11, #3, mul vl]          // 16-byte Folded Spill
	str	z27, [x11, #5, mul vl]          // 16-byte Folded Spill
	str	z26, [x11, #6, mul vl]          // 16-byte Folded Spill
	str	z25, [x11, #7, mul vl]          // 16-byte Folded Spill
	cbz	w14, .LBB5_31
// %bb.30:                              //   in Loop: Header=BB5_24 Depth=2
	sxtw	x11, w30
	add	x19, x2, x11
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x19, x22]
	ldr	z16, [x11, #17, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z4.b }, z12.b
	tbl	z21.b, { z4.b }, z13.b
	tbl	z22.b, { z4.b }, z19.b
	tbl	z23.b, { z5.b }, z16.b
	ldr	z16, [x11, #16, mul vl]         // 16-byte Folded Reload
	tbl	z4.b, { z4.b }, z14.b
	tbl	z20.b, { z5.b }, z9.b
	tbl	z24.b, { z5.b }, z16.b
	ldr	z16, [x11, #15, mul vl]         // 16-byte Folded Reload
	eor	z6.d, z6.d, z20.d
	eor	z20.d, z21.d, z23.d
	tbl	z5.b, { z5.b }, z16.b
	eor	z21.d, z22.d, z24.d
	eor	z23.d, z4.d, z5.d
.LBB5_31:                               //   in Loop: Header=BB5_24 Depth=2
	mov	z24.d, z10.d
	mov	z25.d, z11.d
	str	z6, [x11, #1, mul vl]           // 16-byte Folded Spill
	mov	z26.d, z8.d
	mov	z27.d, z7.d
	str	z9, [x11, #12, mul vl]          // 16-byte Folded Spill
	cbz	w15, .LBB5_33
// %bb.32:                              //   in Loop: Header=BB5_24 Depth=2
	sxtw	x11, w23
	add	x19, x2, x11
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x19, x22]
	ldr	z16, [x11, #12, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z4.b }, z12.b
	tbl	z25.b, { z4.b }, z13.b
	tbl	z26.b, { z4.b }, z19.b
	tbl	z24.b, { z5.b }, z16.b
	ldr	z16, [x11, #17, mul vl]         // 16-byte Folded Reload
	tbl	z4.b, { z4.b }, z14.b
	tbl	z27.b, { z5.b }, z16.b
	ldr	z16, [x11, #16, mul vl]         // 16-byte Folded Reload
	eor	z24.d, z6.d, z24.d
	tbl	z9.b, { z5.b }, z16.b
	ldr	z16, [x11, #15, mul vl]         // 16-byte Folded Reload
	eor	z25.d, z25.d, z27.d
	tbl	z5.b, { z5.b }, z16.b
	eor	z26.d, z26.d, z9.d
	eor	z27.d, z4.d, z5.d
.LBB5_33:                               //   in Loop: Header=BB5_24 Depth=2
	mov	z4.d, z10.d
	mov	z5.d, z11.d
	mov	z6.d, z8.d
	mov	z9.d, z7.d
	cbz	w16, .LBB5_35
// %bb.34:                              //   in Loop: Header=BB5_24 Depth=2
	sxtw	x11, w8
	mov	z22.d, z20.d
	mov	z20.d, z3.d
	mov	z3.d, z2.d
	mov	z2.d, z1.d
	mov	z1.d, z0.d
	add	x19, x2, x11
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x19, x22]
	ldr	z18, [x11, #17, mul vl]         // 16-byte Folded Reload
	mov	z0.d, z14.d
	str	z31, [x11]                      // 16-byte Folded Spill
	mov	z31.d, z30.d
	mov	z30.d, z29.d
	tbl	z6.b, { z4.b }, z12.b
	tbl	z17.b, { z4.b }, z14.b
	mov	z14.d, z12.d
	tbl	z12.b, { z5.b }, z18.b
	ldr	z18, [x11, #16, mul vl]         // 16-byte Folded Reload
	tbl	z9.b, { z4.b }, z13.b
	tbl	z16.b, { z4.b }, z19.b
	ldr	z4, [x11, #12, mul vl]          // 16-byte Folded Reload
	mov	z29.d, z28.d
	mov	z28.d, z23.d
	mov	z23.d, z21.d
	mov	z21.d, z15.d
	mov	z15.d, z13.d
	tbl	z13.b, { z5.b }, z18.b
	ldr	z18, [x11, #15, mul vl]         // 16-byte Folded Reload
	tbl	z4.b, { z5.b }, z4.b
	tbl	z18.b, { z5.b }, z18.b
	eor	z5.d, z9.d, z12.d
	mov	z12.d, z14.d
	mov	z14.d, z0.d
	mov	z0.d, z1.d
	mov	z1.d, z2.d
	eor	z4.d, z6.d, z4.d
	mov	z2.d, z3.d
	mov	z3.d, z20.d
	mov	z20.d, z22.d
	eor	z6.d, z16.d, z13.d
	mov	z13.d, z15.d
	mov	z15.d, z21.d
	mov	z21.d, z23.d
	mov	z23.d, z28.d
	mov	z28.d, z29.d
	mov	z29.d, z30.d
	mov	z30.d, z31.d
	ldr	z31, [x11]                      // 16-byte Folded Reload
	eor	z9.d, z17.d, z18.d
	ldr	z18, [x11, #13, mul vl]         // 16-byte Folded Reload
	ldr	z17, [x11, #14, mul vl]         // 16-byte Folded Reload
.LBB5_35:                               //   in Loop: Header=BB5_24 Depth=2
	ldr	z16, [x11, #25, mul vl]         // 16-byte Folded Reload
	eor	z18.d, z18.d, z4.d
	eor	z17.d, z17.d, z5.d
	eor	z16.d, z16.d, z0.d
	ldr	z0, [x11, #21, mul vl]          // 16-byte Folded Reload
	str	z16, [x11, #25, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #26, mul vl]         // 16-byte Folded Reload
	eor	z0.d, z0.d, z15.d
	eor	z16.d, z16.d, z1.d
	str	z0, [x11, #21, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #22, mul vl]          // 16-byte Folded Reload
	ldr	z1, [x11, #4, mul vl]           // 16-byte Folded Reload
	str	z16, [x11, #26, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #27, mul vl]         // 16-byte Folded Reload
	eor	z0.d, z0.d, z1.d
	ldr	z1, [x11, #3, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z16.d, z2.d
	str	z0, [x11, #22, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #23, mul vl]          // 16-byte Folded Reload
	str	z16, [x11, #27, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #28, mul vl]         // 16-byte Folded Reload
	eor	z0.d, z0.d, z1.d
	ldr	z1, [x11, #2, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z16.d, z3.d
	str	z0, [x11, #23, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #24, mul vl]          // 16-byte Folded Reload
	str	z16, [x11, #28, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #19, mul vl]         // 16-byte Folded Reload
	eor	z0.d, z0.d, z1.d
	str	z0, [x11, #24, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #1, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z16.d, z0.d
	str	z16, [x11, #19, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #20, mul vl]         // 16-byte Folded Reload
	eor	z16.d, z16.d, z20.d
	str	z16, [x11, #20, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #10, mul vl]         // 16-byte Folded Reload
	eor	z22.d, z16.d, z21.d
	ldr	z21, [x11, #11, mul vl]         // 16-byte Folded Reload
	ldr	z16, [x11, #18, mul vl]         // 16-byte Folded Reload
	eor	z21.d, z21.d, z23.d
	eor	z16.d, z16.d, z24.d
	ldr	z24, [x11, #8, mul vl]          // 16-byte Folded Reload
	ldr	z23, [x11, #9, mul vl]          // 16-byte Folded Reload
	str	z16, [x11, #18, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #7, mul vl]          // 16-byte Folded Reload
	eor	z24.d, z24.d, z26.d
	eor	z23.d, z23.d, z27.d
	ldr	z27, [x11, #5, mul vl]          // 16-byte Folded Reload
	ldr	z26, [x11, #6, mul vl]          // 16-byte Folded Reload
	eor	z25.d, z16.d, z25.d
	eor	z27.d, z27.d, z6.d
	eor	z26.d, z26.d, z9.d
	cbz	w17, .LBB5_37
// %bb.36:                              //   in Loop: Header=BB5_24 Depth=2
	sxtw	x11, w10
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x19, x2, x11
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x19, x22]
	ldr	z6, [x11, #17, mul vl]          // 16-byte Folded Reload
	ldr	z7, [x11, #16, mul vl]          // 16-byte Folded Reload
	ldr	z8, [x11, #15, mul vl]          // 16-byte Folded Reload
	tbl	z0.b, { z4.b }, z12.b
	tbl	z1.b, { z4.b }, z13.b
	tbl	z2.b, { z4.b }, z19.b
	tbl	z3.b, { z4.b }, z14.b
	ldr	z4, [x11, #12, mul vl]          // 16-byte Folded Reload
	tbl	z6.b, { z5.b }, z6.b
	tbl	z7.b, { z5.b }, z7.b
	tbl	z4.b, { z5.b }, z4.b
	tbl	z5.b, { z5.b }, z8.b
	eor	z11.d, z1.d, z6.d
	eor	z8.d, z2.d, z7.d
	eor	z10.d, z0.d, z4.d
	eor	z7.d, z3.d, z5.d
.LBB5_37:                               //   in Loop: Header=BB5_24 Depth=2
	ldr	z4, [x11, #20, mul vl]          // 16-byte Folded Reload
	ldr	z5, [x11, #19, mul vl]          // 16-byte Folded Reload
	ldr	z6, [x11, #18, mul vl]          // 16-byte Folded Reload
	b	.LBB5_23
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
	sub	sp, sp, #48
	addvl	sp, sp, #-32
	addvl	sp, sp, #-6
	cmp	w0, #16
	str	x3, [sp, #40]                   // 8-byte Spill
	b.ge	.LBB6_2
.LBB6_1:
	addvl	sp, sp, #31
	addvl	sp, sp, #7
	add	sp, sp, #48
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
	lsl	w11, w1, #5
	lsl	w10, w1, #6
	rdvl	x8, #1
	mov	w13, w1
	lsr	x3, x8, #4
	cmp	w1, #1
	stp	w10, w11, [sp, #32]             // 8-byte Folded Spill
	lsl	w11, w1, #7
	lsl	x9, x13, #5
	add	w10, w1, w1, lsl #1
	str	w11, [sp, #28]                  // 4-byte Spill
	add	w11, w1, w1, lsl #2
	b.lt	.LBB6_17
// %bb.3:
	mov	x15, xzr
	sub	x14, x9, #32
.LBB6_4:                                // =>This Inner Loop Header: Depth=1
	add	x12, x2, w15, sxtw
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	cset	w12, ne
	ccmp	x14, x15, #4, eq
	add	x15, x15, #32
	b.ne	.LBB6_4
// %bb.5:
	sub	x5, x13, #1
	ldr	w14, [sp, #36]                  // 4-byte Reload
	mov	x15, x5
.LBB6_6:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	add	w14, w14, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	cset	w13, ne
	ccmp	x15, #0, #4, eq
	sub	x15, x15, #1
	b.ne	.LBB6_6
// %bb.7:
	ldr	w15, [sp, #32]                  // 4-byte Reload
	mov	x16, x5
.LBB6_8:                                // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	add	w15, w15, #32
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	cset	w14, ne
	ccmp	x16, #0, #4, eq
	sub	x16, x16, #1
	b.ne	.LBB6_8
// %bb.9:
	lsl	w16, w10, #5
	mov	x17, x5
.LBB6_10:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	add	w16, w16, #32
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	cset	w15, ne
	ccmp	x17, #0, #4, eq
	sub	x17, x17, #1
	b.ne	.LBB6_10
// %bb.11:
	ldr	w17, [sp, #28]                  // 4-byte Reload
	mov	x18, x5
.LBB6_12:                               // =>This Inner Loop Header: Depth=1
	add	x16, x2, w17, sxtw
	add	w17, w17, #32
	ldrb	w16, [x16, #1]
	cmp	w16, #1
	cset	w16, ne
	ccmp	x18, #0, #4, eq
	sub	x18, x18, #1
	b.ne	.LBB6_12
// %bb.13:
	lsl	w18, w11, #5
	mov	x6, x5
.LBB6_14:                               // =>This Inner Loop Header: Depth=1
	add	x17, x2, w18, sxtw
	add	w18, w18, #32
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	cset	w17, ne
	ccmp	x6, #0, #4, eq
	sub	x6, x6, #1
	b.ne	.LBB6_14
// %bb.15:
	lsl	w6, w10, #6
.LBB6_16:                               // =>This Inner Loop Header: Depth=1
	add	x18, x2, w6, sxtw
	add	w6, w6, #32
	ldrb	w18, [x18, #1]
	cmp	w18, #1
	cset	w18, ne
	ccmp	x5, #0, #4, eq
	sub	x5, x5, #1
	b.ne	.LBB6_16
	b	.LBB6_18
.LBB6_17:
	mov	w12, wzr
	mov	w13, wzr
	mov	w14, wzr
	mov	w15, wzr
	mov	w16, wzr
	mov	w17, wzr
	mov	w18, wzr
.LBB6_18:
	lsl	w6, w3, #5
	add	w3, w3, w3, lsl #1
	orr	w19, w12, w13
	orr	w20, w14, w15
	mov	w7, w8
	lsl	w11, w11, #5
	orr	w8, w19, w20
	orr	w20, w16, w17
	lsl	w19, w3, #4
	orr	w8, w8, w20
	lsl	w3, w10, #6
	lsl	w10, w10, #5
	ptrue	p0.b
	mov	x5, xzr
	orr	w23, w8, w18
	mov	w24, #16                        // =0x10
	stp	w11, w3, [sp, #20]              // 8-byte Folded Spill
	str	w10, [sp, #16]                  // 4-byte Spill
	b	.LBB6_21
.LBB6_19:                               //   in Loop: Header=BB6_21 Depth=1
	movi	v0.2d, #0000000000000000
	add	x8, sp, #48
	movi	v8.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	str	z0, [x8, #25, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	str	z0, [x8, #28, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #32, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #24, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #27, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #31, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #23, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #37, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #30, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #34, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #22, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #26, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #29, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #33, mul vl]           // 16-byte Folded Spill
.LBB6_20:                               //   in Loop: Header=BB6_21 Depth=1
	ldr	x8, [x4, #48]
	add	x10, sp, #48
	ldr	z0, [x10, #22, mul vl]          // 16-byte Folded Reload
	st1b	{ z29.b }, p1, [x8, x5]
	ldr	x8, [x4, #48]
	st1b	{ z7.b }, p3, [x8, x27]
	ldr	x8, [x4, #48]
	st1b	{ z30.b }, p4, [x8, x28]
	ldr	x8, [x4, #48]
	st1b	{ z8.b }, p2, [x8, x26]
	ldr	x8, [x4, #40]
	st1b	{ z0.b }, p1, [x8, x5]
	ldr	z0, [x10, #23, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #40]
	st1b	{ z0.b }, p3, [x8, x27]
	ldr	z0, [x10, #24, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #40]
	st1b	{ z0.b }, p4, [x8, x28]
	ldr	z0, [x10, #25, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #40]
	st1b	{ z0.b }, p2, [x8, x26]
	ldr	z0, [x10, #26, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #32]
	st1b	{ z0.b }, p1, [x8, x5]
	ldr	z0, [x10, #37, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #32]
	st1b	{ z4.b }, p3, [x8, x27]
	ldr	x8, [x4, #32]
	st1b	{ z6.b }, p4, [x8, x28]
	ldr	x8, [x4, #32]
	st1b	{ z5.b }, p2, [x8, x26]
	ldr	x8, [x4, #24]
	st1b	{ z25.b }, p1, [x8, x5]
	ldr	x8, [x4, #24]
	st1b	{ z0.b }, p3, [x8, x27]
	ldr	z0, [x10, #27, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #24]
	st1b	{ z0.b }, p4, [x8, x28]
	ldr	z0, [x10, #28, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #24]
	st1b	{ z0.b }, p2, [x8, x26]
	ldr	z0, [x10, #29, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #16]
	st1b	{ z0.b }, p1, [x8, x5]
	ldr	z0, [x10, #30, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #16]
	st1b	{ z0.b }, p3, [x8, x27]
	ldr	z0, [x10, #31, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #16]
	st1b	{ z0.b }, p4, [x8, x28]
	ldr	z0, [x10, #32, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #16]
	st1b	{ z0.b }, p2, [x8, x26]
	ldr	z0, [x10, #33, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p1, [x8, x5]
	ldr	z0, [x10, #34, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z27.b }, p3, [x8, x27]
	ldr	x8, [x4, #8]
	st1b	{ z2.b }, p4, [x8, x28]
	ldr	x8, [x4, #8]
	st1b	{ z1.b }, p2, [x8, x26]
	ldr	x8, [x4]
	st1b	{ z26.b }, p1, [x8, x5]
	rdvl	x8, #4
	add	x5, x5, x8
	ldr	x8, [x4]
	cmp	w0, w5
	st1b	{ z0.b }, p3, [x8, x27]
	ldr	x8, [x4]
	st1b	{ z3.b }, p4, [x8, x28]
	ldr	x8, [x4]
	st1b	{ z24.b }, p2, [x8, x26]
	b.le	.LBB6_1
.LBB6_21:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB6_26 Depth 2
	whilelt	p1.b, w5, w0
	b.eq	.LBB6_1
// %bb.22:                              //   in Loop: Header=BB6_21 Depth=1
	add	x27, x5, x7
	add	x28, x5, x6
	add	x26, x5, x19
	whilelt	p3.b, w27, w0
	whilelt	p4.b, w28, w0
	whilelt	p2.b, w26, w0
	cmp	w1, #1
	b.lt	.LBB6_19
// %bb.23:                              //   in Loop: Header=BB6_21 Depth=1
	movi	v0.2d, #0000000000000000
	add	x8, sp, #48
	movi	v26.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	ldr	x30, [sp, #40]                  // 8-byte Reload
	movi	v27.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	x29, xzr
	movi	v7.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	str	z0, [x8, #33, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	ldp	w10, w20, [sp, #16]             // 8-byte Folded Reload
	movi	v5.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	str	z0, [x8, #29, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	ldp	w3, w11, [sp, #24]              // 8-byte Folded Reload
	str	z0, [x8, #26, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #22, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #34, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #30, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #37, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #23, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #31, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #27, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #24, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #32, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #28, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #25, mul vl]           // 16-byte Folded Spill
	ldp	w8, w25, [sp, #32]              // 8-byte Folded Reload
	b	.LBB6_26
.LBB6_24:                               //   in Loop: Header=BB6_26 Depth=2
	add	x21, sp, #48
	eor	z26.d, z26.d, z13.d
	eor	z3.d, z3.d, z12.d
	ldr	z0, [x21, #34, mul vl]          // 16-byte Folded Reload
	eor	z24.d, z24.d, z14.d
	eor	z27.d, z27.d, z15.d
	eor	z2.d, z2.d, z12.d
	eor	z1.d, z1.d, z14.d
	eor	z25.d, z25.d, z13.d
	eor	z4.d, z4.d, z15.d
	eor	z6.d, z6.d, z12.d
	eor	z5.d, z5.d, z14.d
	eor	z0.d, z0.d, z15.d
	str	z0, [x21, #34, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #33, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z13.d
	str	z0, [x21, #33, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #29, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z13.d
	str	z0, [x21, #29, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #30, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z15.d
	str	z0, [x21, #30, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #31, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z12.d
	str	z0, [x21, #31, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #32, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z14.d
	str	z0, [x21, #32, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #37, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z15.d
	str	z0, [x21, #37, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #27, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z12.d
	str	z0, [x21, #27, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #28, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z14.d
	str	z0, [x21, #28, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #26, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z13.d
	str	z0, [x21, #26, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #22, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z13.d
	str	z0, [x21, #22, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #23, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z15.d
	str	z0, [x21, #23, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #24, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z12.d
	str	z0, [x21, #24, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #25, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z14.d
	str	z0, [x21, #25, mul vl]          // 16-byte Folded Spill
.LBB6_25:                               //   in Loop: Header=BB6_26 Depth=2
	eor	z29.d, z29.d, z13.d
	eor	z7.d, z7.d, z15.d
	add	x29, x29, #32
	eor	z30.d, z30.d, z12.d
	eor	z8.d, z8.d, z14.d
	add	w3, w3, #32
	add	w20, w20, #32
	add	w11, w11, #32
	cmp	x9, x29
	add	w10, w10, #32
	add	w8, w8, #32
	add	w25, w25, #32
	b.eq	.LBB6_20
.LBB6_26:                               //   Parent Loop BB6_21 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x21, [x30], #8
	ld1b	{ z13.b }, p1/z, [x21, x5]
	ld1b	{ z15.b }, p3/z, [x21, x27]
	ld1b	{ z12.b }, p4/z, [x21, x28]
	ld1b	{ z14.b }, p2/z, [x21, x26]
	tbz	w23, #0, .LBB6_24
// %bb.27:                              //   in Loop: Header=BB6_26 Depth=2
	movprfx	z16, z12
	and	z16.b, z16.b, #0xf
	add	x21, sp, #48
	lsr	z9.b, z13.b, #4
	lsr	z10.b, z15.b, #4
	lsr	z28.b, z12.b, #4
	lsr	z11.b, z14.b, #4
	mov	z18.d, z13.d
	mov	z19.d, z15.d
	movprfx	z0, z13
	and	z0.b, z0.b, #0xf
	str	z16, [x21, #36, mul vl]         // 16-byte Folded Spill
	movprfx	z16, z14
	and	z16.b, z16.b, #0xf
	mov	z20.d, z12.d
	movprfx	z31, z15
	and	z31.b, z31.b, #0xf
	str	z16, [x21, #35, mul vl]         // 16-byte Folded Spill
	mov	z16.d, z14.d
	cbz	w12, .LBB6_29
// %bb.28:                              //   in Loop: Header=BB6_26 Depth=2
	sxtw	x21, w29
	add	x22, x2, x21
	ld1b	{ z16.b }, p0/z, [x2, x21]
	add	x21, sp, #48
	ld1b	{ z17.b }, p0/z, [x22, x24]
	ldr	z20, [x21, #36, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x21, #35, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z16.b }, z0.b
	tbl	z19.b, { z16.b }, z31.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z21.b, { z17.b }, z9.b
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z17.b, { z17.b }, z11.b
	eor	z18.d, z18.d, z21.d
	eor	z19.d, z19.d, z22.d
	eor	z20.d, z20.d, z23.d
	eor	z16.d, z16.d, z17.d
.LBB6_29:                               //   in Loop: Header=BB6_26 Depth=2
	str	z16, [x21, #14, mul vl]         // 16-byte Folded Spill
	mov	z16.d, z14.d
	str	z20, [x21, #15, mul vl]         // 16-byte Folded Spill
	mov	z20.d, z12.d
	str	z19, [x21, #16, mul vl]         // 16-byte Folded Spill
	mov	z19.d, z15.d
	str	z18, [x21, #17, mul vl]         // 16-byte Folded Spill
	mov	z18.d, z13.d
	cbz	w13, .LBB6_31
// %bb.30:                              //   in Loop: Header=BB6_26 Depth=2
	sxtw	x21, w25
	add	x22, x2, x21
	ld1b	{ z16.b }, p0/z, [x2, x21]
	add	x21, sp, #48
	ld1b	{ z17.b }, p0/z, [x22, x24]
	ldr	z20, [x21, #36, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x21, #35, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z16.b }, z0.b
	tbl	z19.b, { z16.b }, z31.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z21.b, { z17.b }, z9.b
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z17.b, { z17.b }, z11.b
	eor	z18.d, z18.d, z21.d
	eor	z19.d, z19.d, z22.d
	eor	z20.d, z20.d, z23.d
	eor	z16.d, z16.d, z17.d
.LBB6_31:                               //   in Loop: Header=BB6_26 Depth=2
	str	z16, [x21, #10, mul vl]         // 16-byte Folded Spill
	mov	z16.d, z14.d
	str	z20, [x21, #11, mul vl]         // 16-byte Folded Spill
	mov	z20.d, z12.d
	str	z19, [x21, #12, mul vl]         // 16-byte Folded Spill
	mov	z19.d, z15.d
	str	z18, [x21, #13, mul vl]         // 16-byte Folded Spill
	mov	z18.d, z13.d
	cbz	w14, .LBB6_33
// %bb.32:                              //   in Loop: Header=BB6_26 Depth=2
	sxtw	x21, w8
	add	x22, x2, x21
	ld1b	{ z16.b }, p0/z, [x2, x21]
	add	x21, sp, #48
	ld1b	{ z17.b }, p0/z, [x22, x24]
	ldr	z20, [x21, #36, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x21, #35, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z16.b }, z0.b
	tbl	z19.b, { z16.b }, z31.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z21.b, { z17.b }, z9.b
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z17.b, { z17.b }, z11.b
	eor	z18.d, z18.d, z21.d
	eor	z19.d, z19.d, z22.d
	eor	z20.d, z20.d, z23.d
	eor	z16.d, z16.d, z17.d
.LBB6_33:                               //   in Loop: Header=BB6_26 Depth=2
	str	z16, [x21, #6, mul vl]          // 16-byte Folded Spill
	mov	z16.d, z14.d
	str	z20, [x21, #7, mul vl]          // 16-byte Folded Spill
	mov	z20.d, z12.d
	str	z19, [x21, #8, mul vl]          // 16-byte Folded Spill
	mov	z19.d, z15.d
	str	z18, [x21, #9, mul vl]          // 16-byte Folded Spill
	mov	z18.d, z13.d
	cbz	w15, .LBB6_35
// %bb.34:                              //   in Loop: Header=BB6_26 Depth=2
	sxtw	x21, w10
	add	x22, x2, x21
	ld1b	{ z16.b }, p0/z, [x2, x21]
	add	x21, sp, #48
	ld1b	{ z17.b }, p0/z, [x22, x24]
	ldr	z20, [x21, #36, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x21, #35, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z16.b }, z0.b
	tbl	z19.b, { z16.b }, z31.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z21.b, { z17.b }, z9.b
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z17.b, { z17.b }, z11.b
	eor	z18.d, z18.d, z21.d
	eor	z19.d, z19.d, z22.d
	eor	z20.d, z20.d, z23.d
	eor	z16.d, z16.d, z17.d
.LBB6_35:                               //   in Loop: Header=BB6_26 Depth=2
	str	z19, [x21, #4, mul vl]          // 16-byte Folded Spill
	mov	z17.d, z15.d
	mov	z19.d, z14.d
	str	z18, [x21, #5, mul vl]          // 16-byte Folded Spill
	mov	z18.d, z12.d
	str	z31, [x21, #21, mul vl]         // 16-byte Folded Spill
	mov	z31.d, z13.d
	str	z16, [x21, #2, mul vl]          // 16-byte Folded Spill
	str	z20, [x21, #3, mul vl]          // 16-byte Folded Spill
	str	z0, [x21, #18, mul vl]          // 16-byte Folded Spill
	cbz	w16, .LBB6_37
// %bb.36:                              //   in Loop: Header=BB6_26 Depth=2
	sxtw	x21, w11
	ld1b	{ z16.b }, p0/z, [x2, x21]
	add	x22, x2, x21
	add	x21, sp, #48
	ld1b	{ z17.b }, p0/z, [x22, x24]
	tbl	z18.b, { z16.b }, z0.b
	ldr	z0, [x21, #21, mul vl]          // 16-byte Folded Reload
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z19.b, { z16.b }, z0.b
	ldr	z0, [x21, #36, mul vl]          // 16-byte Folded Reload
	tbl	z20.b, { z16.b }, z0.b
	ldr	z0, [x21, #35, mul vl]          // 16-byte Folded Reload
	tbl	z21.b, { z16.b }, z0.b
	tbl	z16.b, { z17.b }, z9.b
	tbl	z0.b, { z17.b }, z11.b
	eor	z17.d, z19.d, z22.d
	eor	z31.d, z18.d, z16.d
	eor	z18.d, z20.d, z23.d
	eor	z19.d, z21.d, z0.d
.LBB6_37:                               //   in Loop: Header=BB6_26 Depth=2
	mov	z20.d, z13.d
	mov	z21.d, z15.d
	str	z11, [x21, #19, mul vl]         // 16-byte Folded Spill
	mov	z22.d, z12.d
	mov	z23.d, z14.d
	str	z28, [x21, #20, mul vl]         // 16-byte Folded Spill
	cbz	w17, .LBB6_39
// %bb.38:                              //   in Loop: Header=BB6_26 Depth=2
	sxtw	x21, w20
	mov	z28.d, z10.d
	add	x22, x2, x21
	ld1b	{ z0.b }, p0/z, [x2, x21]
	add	x21, sp, #48
	ldr	z16, [x21, #18, mul vl]         // 16-byte Folded Reload
	ld1b	{ z20.b }, p0/z, [x22, x24]
	str	z25, [x21, #1, mul vl]          // 16-byte Folded Spill
	ldr	z25, [x21, #37, mul vl]         // 16-byte Folded Reload
	str	z30, [x21]                      // 16-byte Folded Spill
	mov	z30.d, z8.d
	mov	z8.d, z4.d
	mov	z4.d, z6.d
	mov	z6.d, z1.d
	tbl	z21.b, { z0.b }, z16.b
	ldr	z16, [x21, #21, mul vl]         // 16-byte Folded Reload
	tbl	z1.b, { z20.b }, z10.b
	mov	z10.d, z29.d
	mov	z29.d, z7.d
	mov	z7.d, z2.d
	ldr	z2, [x21, #20, mul vl]          // 16-byte Folded Reload
	str	z25, [x21, #37, mul vl]         // 16-byte Folded Spill
	ldr	z25, [x21, #19, mul vl]         // 16-byte Folded Reload
	tbl	z22.b, { z0.b }, z16.b
	ldr	z16, [x21, #36, mul vl]         // 16-byte Folded Reload
	tbl	z2.b, { z20.b }, z2.b
	tbl	z25.b, { z20.b }, z25.b
	tbl	z23.b, { z0.b }, z16.b
	ldr	z16, [x21, #35, mul vl]         // 16-byte Folded Reload
	tbl	z0.b, { z0.b }, z16.b
	mov	z16.d, z5.d
	mov	z5.d, z26.d
	mov	z26.d, z3.d
	mov	z3.d, z24.d
	tbl	z24.b, { z20.b }, z9.b
	eor	z20.d, z21.d, z24.d
	mov	z24.d, z3.d
	mov	z3.d, z26.d
	mov	z26.d, z5.d
	mov	z5.d, z16.d
	eor	z21.d, z22.d, z1.d
	mov	z1.d, z6.d
	mov	z6.d, z4.d
	mov	z4.d, z8.d
	mov	z8.d, z30.d
	ldr	z30, [x21]                      // 16-byte Folded Reload
	eor	z22.d, z23.d, z2.d
	mov	z2.d, z7.d
	mov	z7.d, z29.d
	mov	z29.d, z10.d
	mov	z10.d, z28.d
	eor	z23.d, z0.d, z25.d
	ldr	z25, [x21, #1, mul vl]          // 16-byte Folded Reload
.LBB6_39:                               //   in Loop: Header=BB6_26 Depth=2
	ldr	z0, [x21, #17, mul vl]          // 16-byte Folded Reload
	ldr	z16, [x21, #16, mul vl]         // 16-byte Folded Reload
	eor	z4.d, z4.d, z17.d
	eor	z6.d, z6.d, z18.d
	eor	z5.d, z5.d, z19.d
	eor	z26.d, z26.d, z0.d
	ldr	z0, [x21, #34, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x21, #13, mul vl]         // 16-byte Folded Reload
	str	z0, [x21, #34, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #15, mul vl]          // 16-byte Folded Reload
	eor	z3.d, z3.d, z0.d
	ldr	z0, [x21, #14, mul vl]          // 16-byte Folded Reload
	eor	z24.d, z24.d, z0.d
	ldr	z0, [x21, #33, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x21, #9, mul vl]          // 16-byte Folded Reload
	str	z0, [x21, #33, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #12, mul vl]          // 16-byte Folded Reload
	eor	z27.d, z27.d, z0.d
	ldr	z0, [x21, #11, mul vl]          // 16-byte Folded Reload
	eor	z2.d, z2.d, z0.d
	ldr	z0, [x21, #10, mul vl]          // 16-byte Folded Reload
	eor	z1.d, z1.d, z0.d
	ldr	z0, [x21, #29, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x21, #8, mul vl]          // 16-byte Folded Reload
	str	z0, [x21, #29, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #30, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x21, #7, mul vl]          // 16-byte Folded Reload
	str	z0, [x21, #30, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #31, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x21, #6, mul vl]          // 16-byte Folded Reload
	str	z0, [x21, #31, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #32, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x21, #4, mul vl]          // 16-byte Folded Reload
	str	z0, [x21, #32, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #5, mul vl]           // 16-byte Folded Reload
	eor	z25.d, z25.d, z0.d
	ldr	z0, [x21, #37, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x21, #3, mul vl]          // 16-byte Folded Reload
	str	z0, [x21, #37, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #27, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x21, #2, mul vl]          // 16-byte Folded Reload
	str	z0, [x21, #27, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #28, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	str	z0, [x21, #28, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #26, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z31.d
	str	z0, [x21, #26, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #22, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z20.d
	str	z0, [x21, #22, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #23, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z21.d
	str	z0, [x21, #23, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #24, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z22.d
	str	z0, [x21, #24, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x21, #25, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z23.d
	str	z0, [x21, #25, mul vl]          // 16-byte Folded Spill
	cbz	w18, .LBB6_25
// %bb.40:                              //   in Loop: Header=BB6_26 Depth=2
	sxtw	x21, w3
	mov	z18.d, z2.d
	mov	z22.d, z4.d
	mov	z20.d, z5.d
	mov	z17.d, z1.d
	mov	z19.d, z27.d
	add	x22, x2, x21
	ld1b	{ z0.b }, p0/z, [x2, x21]
	add	x21, sp, #48
	ldr	z2, [x21, #18, mul vl]          // 16-byte Folded Reload
	ldr	z4, [x21, #21, mul vl]          // 16-byte Folded Reload
	ldr	z5, [x21, #36, mul vl]          // 16-byte Folded Reload
	ldr	z16, [x21, #35, mul vl]         // 16-byte Folded Reload
	ld1b	{ z1.b }, p0/z, [x22, x24]
	ldr	z27, [x21, #19, mul vl]         // 16-byte Folded Reload
	mov	z21.d, z6.d
	mov	z23.d, z7.d
	tbl	z2.b, { z0.b }, z2.b
	tbl	z4.b, { z0.b }, z4.b
	tbl	z5.b, { z0.b }, z5.b
	tbl	z0.b, { z0.b }, z16.b
	ldr	z16, [x21, #20, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z1.b }, z9.b
	tbl	z7.b, { z1.b }, z10.b
	tbl	z16.b, { z1.b }, z16.b
	tbl	z1.b, { z1.b }, z27.b
	mov	z27.d, z19.d
	eor	z13.d, z2.d, z6.d
	mov	z6.d, z21.d
	mov	z2.d, z18.d
	eor	z15.d, z4.d, z7.d
	mov	z7.d, z23.d
	mov	z4.d, z22.d
	eor	z12.d, z5.d, z16.d
	mov	z5.d, z20.d
	eor	z14.d, z0.d, z1.d
	mov	z1.d, z17.d
	b	.LBB6_25
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
	ptrue	p0.b
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
	whilelt	p0.b, w8, w0
	b.eq	.LBB7_1
// %bb.15:                              //   in Loop: Header=BB7_14 Depth=1
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
	b.lt	.LBB9_25
// %bb.1:
	stp	d15, d14, [sp, #-128]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	str	x29, [sp, #64]                  // 8-byte Spill
	stp	x24, x23, [sp, #80]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            // 16-byte Folded Spill
	addvl	sp, sp, #-5
	rdvl	x17, #1
	cmp	w1, #1
	lsr	x15, x17, #4
	b.lt	.LBB9_21
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
	add	w12, w12, #32
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	ccmp	x13, #0, #4, eq
	sub	x13, x13, #1
	b.ne	.LBB9_5
// %bb.6:
	lsl	w12, w1, #6
	mov	w16, w12
.LBB9_7:                                // =>This Inner Loop Header: Depth=1
	add	x13, x2, w16, sxtw
	add	w16, w16, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	ccmp	x14, #0, #4, eq
	sub	x14, x14, #1
	b.ne	.LBB9_7
// %bb.8:
	cmp	w9, #1
	add	w16, w15, w15, lsl #1
	lsl	w15, w15, #5
	ccmp	w11, #1, #0, eq
	ptrue	p0.b
	mov	x14, xzr
	lsl	w16, w16, #4
	ccmp	w13, #1, #0, eq
	mov	w17, w17
	cset	w18, ne
	mov	w1, #16                         // =0x10
	b	.LBB9_10
.LBB9_9:                                //   in Loop: Header=BB9_10 Depth=1
	ldr	x7, [x4, #16]
	st1b	{ z16.b }, p1, [x7, x14]
	ldr	x7, [x4, #16]
	st1b	{ z17.b }, p2, [x7, x6]
	ldr	x7, [x4, #16]
	st1b	{ z18.b }, p4, [x7, x5]
	ldr	x7, [x4, #16]
	st1b	{ z19.b }, p3, [x7, x19]
	ldr	x7, [x4, #8]
	st1b	{ z2.b }, p1, [x7, x14]
	ldr	x7, [x4, #8]
	st1b	{ z25.b }, p2, [x7, x6]
	ldr	x7, [x4, #8]
	st1b	{ z26.b }, p4, [x7, x5]
	ldr	x7, [x4, #8]
	st1b	{ z27.b }, p3, [x7, x19]
	ldr	x7, [x4]
	st1b	{ z6.b }, p1, [x7, x14]
	incb	x14, all, mul #4
	ldr	x7, [x4]
	st1b	{ z7.b }, p2, [x7, x6]
	cmp	w0, w14
	ldr	x6, [x4]
	st1b	{ z5.b }, p4, [x6, x5]
	ldr	x5, [x4]
	st1b	{ z1.b }, p3, [x5, x19]
	b.le	.LBB9_24
.LBB9_10:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB9_14 Depth 2
	whilelt	p1.b, w14, w0
	b.eq	.LBB9_24
// %bb.11:                              //   in Loop: Header=BB9_10 Depth=1
	movi	v6.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	x6, x14, x17
	movi	v16.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	add	x5, x14, x15
	movi	v25.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	add	x19, x14, x16
	movi	v5.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	mov	x7, xzr
	movi	v18.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x20, x3
	movi	v27.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	w21, w10
	whilelt	p2.b, w6, w0
	mov	w22, w12
	whilelt	p4.b, w5, w0
	whilelt	p3.b, w19, w0
	b	.LBB9_14
.LBB9_12:                               //   in Loop: Header=BB9_14 Depth=2
	eor	z6.d, z6.d, z22.d
	eor	z7.d, z7.d, z23.d
	eor	z5.d, z5.d, z20.d
	eor	z1.d, z1.d, z21.d
	eor	z2.d, z2.d, z22.d
	eor	z25.d, z25.d, z23.d
	eor	z26.d, z26.d, z20.d
	eor	z27.d, z27.d, z21.d
.LBB9_13:                               //   in Loop: Header=BB9_14 Depth=2
	eor	z16.d, z16.d, z22.d
	eor	z17.d, z17.d, z23.d
	add	x7, x7, #32
	eor	z18.d, z18.d, z20.d
	eor	z19.d, z19.d, z21.d
	cmp	x8, x7
	add	w22, w22, #32
	add	w21, w21, #32
	b.eq	.LBB9_9
.LBB9_14:                               //   Parent Loop BB9_10 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x23, [x20], #8
	ld1b	{ z22.b }, p1/z, [x23, x14]
	ld1b	{ z23.b }, p2/z, [x23, x6]
	ld1b	{ z20.b }, p4/z, [x23, x5]
	ld1b	{ z21.b }, p3/z, [x23, x19]
	tbz	w18, #0, .LBB9_12
// %bb.15:                              //   in Loop: Header=BB9_14 Depth=2
	lsr	z28.b, z22.b, #4
	lsr	z3.b, z23.b, #4
	cmp	w9, #1
	lsr	z4.b, z20.b, #4
	lsr	z0.b, z21.b, #4
	movprfx	z24, z22
	and	z24.b, z24.b, #0xf
	mov	z8.d, z22.d
	mov	z9.d, z23.d
	movprfx	z29, z23
	and	z29.b, z29.b, #0xf
	mov	z10.d, z20.d
	mov	z11.d, z21.d
	movprfx	z30, z20
	and	z30.b, z30.b, #0xf
	movprfx	z31, z21
	and	z31.b, z31.b, #0xf
	str	z0, [sp, #4, mul vl]            // 16-byte Folded Spill
	b.eq	.LBB9_17
// %bb.16:                              //   in Loop: Header=BB9_14 Depth=2
	sxtw	x23, w7
	ldr	z0, [sp, #4, mul vl]            // 16-byte Folded Reload
	add	x24, x2, x23
	ld1b	{ z8.b }, p0/z, [x2, x23]
	ld1b	{ z9.b }, p0/z, [x24, x1]
	tbl	z10.b, { z8.b }, z24.b
	tbl	z11.b, { z8.b }, z29.b
	tbl	z12.b, { z8.b }, z30.b
	tbl	z13.b, { z8.b }, z31.b
	tbl	z8.b, { z9.b }, z28.b
	tbl	z14.b, { z9.b }, z3.b
	tbl	z15.b, { z9.b }, z4.b
	tbl	z0.b, { z9.b }, z0.b
	eor	z8.d, z10.d, z8.d
	eor	z9.d, z11.d, z14.d
	eor	z10.d, z12.d, z15.d
	eor	z11.d, z13.d, z0.d
.LBB9_17:                               //   in Loop: Header=BB9_14 Depth=2
	mov	z12.d, z22.d
	mov	z13.d, z23.d
	cmp	w11, #1
	mov	z14.d, z20.d
	mov	z15.d, z21.d
	b.eq	.LBB9_19
// %bb.18:                              //   in Loop: Header=BB9_14 Depth=2
	sxtw	x23, w21
	str	z29, [sp, #3, mul vl]           // 16-byte Folded Spill
	str	z30, [sp, #2, mul vl]           // 16-byte Folded Spill
	ld1b	{ z0.b }, p0/z, [x2, x23]
	add	x24, x2, x23
	str	z31, [sp, #1, mul vl]           // 16-byte Folded Spill
	ld1b	{ z12.b }, p0/z, [x24, x1]
	tbl	z13.b, { z0.b }, z24.b
	tbl	z14.b, { z0.b }, z29.b
	tbl	z15.b, { z0.b }, z30.b
	tbl	z0.b, { z0.b }, z31.b
	mov	z29.d, z28.d
	mov	z30.d, z3.d
	mov	z31.d, z4.d
	str	z13, [sp]                       // 16-byte Folded Spill
	mov	z13.d, z24.d
	mov	z24.d, z7.d
	mov	z7.d, z6.d
	mov	z6.d, z5.d
	mov	z5.d, z1.d
	tbl	z1.b, { z12.b }, z28.b
	mov	z28.d, z27.d
	mov	z27.d, z26.d
	mov	z26.d, z25.d
	mov	z25.d, z2.d
	tbl	z2.b, { z12.b }, z3.b
	tbl	z3.b, { z12.b }, z4.b
	ldr	z4, [sp, #4, mul vl]            // 16-byte Folded Reload
	tbl	z4.b, { z12.b }, z4.b
	ldr	z12, [sp]                       // 16-byte Folded Reload
	eor	z12.d, z12.d, z1.d
	mov	z1.d, z5.d
	mov	z5.d, z6.d
	mov	z6.d, z7.d
	mov	z7.d, z24.d
	mov	z24.d, z13.d
	eor	z13.d, z14.d, z2.d
	mov	z2.d, z25.d
	mov	z25.d, z26.d
	mov	z26.d, z27.d
	mov	z27.d, z28.d
	mov	z28.d, z29.d
	ldr	z29, [sp, #3, mul vl]           // 16-byte Folded Reload
	eor	z14.d, z15.d, z3.d
	mov	z3.d, z30.d
	ldr	z30, [sp, #2, mul vl]           // 16-byte Folded Reload
	eor	z15.d, z0.d, z4.d
	mov	z4.d, z31.d
	ldr	z31, [sp, #1, mul vl]           // 16-byte Folded Reload
.LBB9_19:                               //   in Loop: Header=BB9_14 Depth=2
	eor	z6.d, z6.d, z8.d
	eor	z7.d, z7.d, z9.d
	cmp	w13, #1
	eor	z5.d, z5.d, z10.d
	eor	z1.d, z1.d, z11.d
	eor	z2.d, z2.d, z12.d
	eor	z25.d, z25.d, z13.d
	eor	z26.d, z26.d, z14.d
	eor	z27.d, z27.d, z15.d
	b.eq	.LBB9_13
// %bb.20:                              //   in Loop: Header=BB9_14 Depth=2
	sxtw	x23, w22
	mov	z8.d, z1.d
	mov	z22.d, z4.d
	mov	z23.d, z2.d
	mov	z21.d, z3.d
	add	x24, x2, x23
	ld1b	{ z0.b }, p0/z, [x2, x23]
	ld1b	{ z1.b }, p0/z, [x24, x1]
	tbl	z2.b, { z0.b }, z24.b
	tbl	z3.b, { z0.b }, z29.b
	tbl	z4.b, { z0.b }, z30.b
	tbl	z24.b, { z1.b }, z22.b
	ldr	z22, [sp, #4, mul vl]           // 16-byte Folded Reload
	tbl	z0.b, { z0.b }, z31.b
	tbl	z20.b, { z1.b }, z28.b
	tbl	z21.b, { z1.b }, z21.b
	tbl	z1.b, { z1.b }, z22.b
	eor	z22.d, z2.d, z20.d
	mov	z2.d, z23.d
	eor	z23.d, z3.d, z21.d
	eor	z20.d, z4.d, z24.d
	eor	z21.d, z0.d, z1.d
	mov	z1.d, z8.d
	b	.LBB9_13
.LBB9_21:
	add	w10, w15, w15, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w15, #5
	mov	x8, xzr
	mov	w11, w17
	lsl	w10, w10, #4
.LBB9_22:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB9_24
// %bb.23:                              //   in Loop: Header=BB9_22 Depth=1
	ldr	x12, [x4, #16]
	add	x13, x11, x8
	add	x14, x9, x8
	whilelt	p3.b, w13, w0
	add	x15, x10, x8
	st1b	{ z0.b }, p0, [x12, x8]
	whilelt	p2.b, w14, w0
	ldr	x12, [x4, #16]
	whilelt	p1.b, w15, w0
	st1b	{ z0.b }, p3, [x13, x12]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p2, [x14, x12]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p1, [x15, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #8]
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
	b.gt	.LBB9_22
.LBB9_24:
	addvl	sp, sp, #5
	ldp	x20, x19, [sp, #112]            // 16-byte Folded Reload
	ldr	x29, [sp, #64]                  // 8-byte Reload
	ldp	x22, x21, [sp, #96]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #128            // 16-byte Folded Reload
.LBB9_25:
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
	b.lt	.LBB10_29
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
	addvl	sp, sp, #-13
	rdvl	x5, #1
	cmp	w1, #1
	lsr	x17, x5, #4
	b.lt	.LBB10_25
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
	add	w12, w12, #32
	ldrb	w11, [x11, #1]
	cmp	w11, #1
	ccmp	x13, #0, #4, eq
	sub	x13, x13, #1
	b.ne	.LBB10_5
// %bb.6:
	lsl	w12, w1, #6
	mov	x15, x16
	mov	w14, w12
.LBB10_7:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	add	w14, w14, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	ccmp	x15, #0, #4, eq
	sub	x15, x15, #1
	b.ne	.LBB10_7
// %bb.8:
	add	w14, w1, w1, lsl #1
	lsl	w14, w14, #5
	mov	w18, w14
.LBB10_9:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w18, sxtw
	add	w18, w18, #32
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	ccmp	x16, #0, #4, eq
	sub	x16, x16, #1
	b.ne	.LBB10_9
// %bb.10:
	cmp	w9, #1
	add	w18, w17, w17, lsl #1
	lsl	w17, w17, #5
	ccmp	w11, #1, #0, eq
	ptrue	p0.b
	mov	x16, xzr
	ccmp	w13, #1, #0, eq
	lsl	w18, w18, #4
	mov	w1, w5
	ccmp	w15, #1, #0, eq
	mov	w6, #16                         // =0x10
	cset	w5, ne
	b	.LBB10_12
.LBB10_11:                              //   in Loop: Header=BB10_12 Depth=1
	ldr	x21, [x4, #24]
	ldr	z0, [sp, #11, mul vl]           // 16-byte Folded Reload
	st1b	{ z20.b }, p1, [x21, x16]
	ldr	x21, [x4, #24]
	st1b	{ z21.b }, p2, [x21, x7]
	ldr	x21, [x4, #24]
	st1b	{ z22.b }, p4, [x21, x19]
	ldr	x21, [x4, #24]
	st1b	{ z23.b }, p3, [x21, x20]
	ldr	x21, [x4, #16]
	st1b	{ z9.b }, p1, [x21, x16]
	ldr	x21, [x4, #16]
	st1b	{ z18.b }, p2, [x21, x7]
	ldr	x21, [x4, #16]
	st1b	{ z11.b }, p4, [x21, x19]
	ldr	x21, [x4, #16]
	st1b	{ z12.b }, p3, [x21, x20]
	ldr	x21, [x4, #8]
	st1b	{ z29.b }, p1, [x21, x16]
	ldr	x21, [x4, #8]
	st1b	{ z0.b }, p2, [x21, x7]
	ldr	z0, [sp, #12, mul vl]           // 16-byte Folded Reload
	ldr	x21, [x4, #8]
	st1b	{ z31.b }, p4, [x21, x19]
	ldr	x21, [x4, #8]
	st1b	{ z8.b }, p3, [x21, x20]
	ldr	x21, [x4]
	st1b	{ z0.b }, p1, [x21, x16]
	incb	x16, all, mul #4
	ldr	x21, [x4]
	st1b	{ z28.b }, p2, [x21, x7]
	cmp	w0, w16
	ldr	x7, [x4]
	st1b	{ z19.b }, p4, [x7, x19]
	ldr	x7, [x4]
	st1b	{ z17.b }, p3, [x7, x20]
	b.le	.LBB10_28
.LBB10_12:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB10_16 Depth 2
	whilelt	p1.b, w16, w0
	b.eq	.LBB10_28
// %bb.13:                              //   in Loop: Header=BB10_12 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	add	x7, x16, x1
	movi	v9.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	add	x19, x16, x17
	movi	v28.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	add	x20, x16, x18
	movi	v21.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	x21, xzr
	str	z0, [sp, #12, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	movi	v11.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	mov	x22, x3
	movi	v17.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	mov	w23, w10
	movi	v12.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	mov	w24, w12
	whilelt	p2.b, w7, w0
	mov	w25, w14
	str	z0, [sp, #11, mul vl]           // 16-byte Folded Spill
	whilelt	p4.b, w19, w0
	whilelt	p3.b, w20, w0
	b	.LBB10_16
.LBB10_14:                              //   in Loop: Header=BB10_16 Depth=2
	ldr	z0, [sp, #12, mul vl]           // 16-byte Folded Reload
	eor	z28.d, z28.d, z27.d
	eor	z19.d, z19.d, z14.d
	eor	z17.d, z17.d, z15.d
	eor	z29.d, z29.d, z26.d
	eor	z31.d, z31.d, z14.d
	eor	z8.d, z8.d, z15.d
	eor	z9.d, z9.d, z26.d
	eor	z18.d, z18.d, z27.d
	eor	z0.d, z0.d, z26.d
	eor	z11.d, z11.d, z14.d
	eor	z12.d, z12.d, z15.d
	str	z0, [sp, #12, mul vl]           // 16-byte Folded Spill
	ldr	z0, [sp, #11, mul vl]           // 16-byte Folded Reload
	eor	z0.d, z0.d, z27.d
	str	z0, [sp, #11, mul vl]           // 16-byte Folded Spill
.LBB10_15:                              //   in Loop: Header=BB10_16 Depth=2
	eor	z20.d, z20.d, z26.d
	eor	z21.d, z21.d, z27.d
	add	x21, x21, #32
	eor	z22.d, z22.d, z14.d
	eor	z23.d, z23.d, z15.d
	cmp	x8, x21
	add	w25, w25, #32
	add	w24, w24, #32
	add	w23, w23, #32
	b.eq	.LBB10_11
.LBB10_16:                              //   Parent Loop BB10_12 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x26, [x22], #8
	ld1b	{ z26.b }, p1/z, [x26, x16]
	ld1b	{ z27.b }, p2/z, [x26, x7]
	ld1b	{ z14.b }, p4/z, [x26, x19]
	ld1b	{ z15.b }, p3/z, [x26, x20]
	tbz	w5, #0, .LBB10_14
// %bb.17:                              //   in Loop: Header=BB10_16 Depth=2
	movprfx	z0, z26
	and	z0.b, z0.b, #0xf
	lsr	z7.b, z26.b, #4
	lsr	z10.b, z27.b, #4
	lsr	z30.b, z14.b, #4
	lsr	z13.b, z15.b, #4
	cmp	w9, #1
	mov	z2.d, z26.d
	mov	z3.d, z27.d
	mov	z4.d, z14.d
	str	z0, [sp, #10, mul vl]           // 16-byte Folded Spill
	movprfx	z0, z27
	and	z0.b, z0.b, #0xf
	str	z0, [sp, #9, mul vl]            // 16-byte Folded Spill
	movprfx	z0, z14
	and	z0.b, z0.b, #0xf
	str	z0, [sp, #8, mul vl]            // 16-byte Folded Spill
	movprfx	z0, z15
	and	z0.b, z0.b, #0xf
	str	z0, [sp, #7, mul vl]            // 16-byte Folded Spill
	mov	z0.d, z15.d
	b.eq	.LBB10_19
// %bb.18:                              //   in Loop: Header=BB10_16 Depth=2
	sxtw	x26, w21
	ldr	z2, [sp, #10, mul vl]           // 16-byte Folded Reload
	ldr	z3, [sp, #9, mul vl]            // 16-byte Folded Reload
	ldr	z4, [sp, #8, mul vl]            // 16-byte Folded Reload
	ldr	z5, [sp, #7, mul vl]            // 16-byte Folded Reload
	mov	z16.d, z7.d
	add	x27, x2, x26
	ld1b	{ z0.b }, p0/z, [x2, x26]
	ld1b	{ z1.b }, p0/z, [x27, x6]
	tbl	z2.b, { z0.b }, z2.b
	tbl	z3.b, { z0.b }, z3.b
	tbl	z4.b, { z0.b }, z4.b
	tbl	z0.b, { z0.b }, z5.b
	tbl	z5.b, { z1.b }, z7.b
	tbl	z6.b, { z1.b }, z10.b
	tbl	z7.b, { z1.b }, z30.b
	tbl	z1.b, { z1.b }, z13.b
	eor	z2.d, z2.d, z5.d
	eor	z3.d, z3.d, z6.d
	eor	z4.d, z4.d, z7.d
	mov	z7.d, z16.d
	eor	z0.d, z0.d, z1.d
.LBB10_19:                              //   in Loop: Header=BB10_16 Depth=2
	str	z0, [sp, #1, mul vl]            // 16-byte Folded Spill
	mov	z0.d, z26.d
	mov	z1.d, z27.d
	str	z3, [sp, #3, mul vl]            // 16-byte Folded Spill
	mov	z3.d, z15.d
	cmp	w11, #1
	str	z2, [sp, #4, mul vl]            // 16-byte Folded Spill
	mov	z2.d, z14.d
	str	z4, [sp, #2, mul vl]            // 16-byte Folded Spill
	b.eq	.LBB10_21
// %bb.20:                              //   in Loop: Header=BB10_16 Depth=2
	sxtw	x26, w23
	ldr	z2, [sp, #10, mul vl]           // 16-byte Folded Reload
	ldr	z3, [sp, #9, mul vl]            // 16-byte Folded Reload
	ldr	z4, [sp, #8, mul vl]            // 16-byte Folded Reload
	ldr	z5, [sp, #7, mul vl]            // 16-byte Folded Reload
	add	x27, x2, x26
	ld1b	{ z0.b }, p0/z, [x2, x26]
	ld1b	{ z1.b }, p0/z, [x27, x6]
	tbl	z2.b, { z0.b }, z2.b
	tbl	z3.b, { z0.b }, z3.b
	tbl	z4.b, { z0.b }, z4.b
	tbl	z5.b, { z0.b }, z5.b
	tbl	z0.b, { z1.b }, z7.b
	tbl	z24.b, { z1.b }, z10.b
	tbl	z25.b, { z1.b }, z30.b
	tbl	z16.b, { z1.b }, z13.b
	eor	z0.d, z2.d, z0.d
	eor	z1.d, z3.d, z24.d
	eor	z2.d, z4.d, z25.d
	eor	z3.d, z5.d, z16.d
.LBB10_21:                              //   in Loop: Header=BB10_16 Depth=2
	mov	z4.d, z26.d
	mov	z5.d, z27.d
	cmp	w13, #1
	mov	z24.d, z14.d
	mov	z25.d, z15.d
	str	z13, [sp, #5, mul vl]           // 16-byte Folded Spill
	str	z30, [sp, #6, mul vl]           // 16-byte Folded Spill
	b.eq	.LBB10_23
// %bb.22:                              //   in Loop: Header=BB10_16 Depth=2
	sxtw	x26, w24
	ldr	z6, [sp, #10, mul vl]           // 16-byte Folded Reload
	ldr	z16, [sp, #6, mul vl]           // 16-byte Folded Reload
	str	z9, [sp]                        // 16-byte Folded Spill
	mov	z13.d, z29.d
	mov	z9.d, z17.d
	ld1b	{ z4.b }, p0/z, [x2, x26]
	add	x27, x2, x26
	mov	z29.d, z10.d
	ld1b	{ z5.b }, p0/z, [x27, x6]
	tbl	z30.b, { z4.b }, z6.b
	ldr	z6, [sp, #9, mul vl]            // 16-byte Folded Reload
	tbl	z24.b, { z4.b }, z6.b
	ldr	z6, [sp, #8, mul vl]            // 16-byte Folded Reload
	tbl	z25.b, { z4.b }, z6.b
	ldr	z6, [sp, #7, mul vl]            // 16-byte Folded Reload
	tbl	z17.b, { z4.b }, z6.b
	tbl	z4.b, { z5.b }, z7.b
	mov	z6.d, z18.d
	tbl	z18.b, { z5.b }, z10.b
	mov	z10.d, z7.d
	mov	z7.d, z11.d
	mov	z11.d, z31.d
	mov	z31.d, z19.d
	tbl	z19.b, { z5.b }, z16.b
	mov	z16.d, z8.d
	mov	z8.d, z28.d
	ldr	z28, [sp, #5, mul vl]           // 16-byte Folded Reload
	eor	z4.d, z30.d, z4.d
	tbl	z28.b, { z5.b }, z28.b
	eor	z5.d, z24.d, z18.d
	mov	z18.d, z6.d
	eor	z24.d, z25.d, z19.d
	mov	z19.d, z31.d
	mov	z31.d, z11.d
	mov	z11.d, z7.d
	mov	z7.d, z10.d
	mov	z10.d, z29.d
	mov	z29.d, z13.d
	eor	z25.d, z17.d, z28.d
	mov	z28.d, z8.d
	mov	z8.d, z16.d
	mov	z17.d, z9.d
	ldr	z9, [sp]                        // 16-byte Folded Reload
.LBB10_23:                              //   in Loop: Header=BB10_16 Depth=2
	ldr	z6, [sp, #12, mul vl]           // 16-byte Folded Reload
	ldr	z16, [sp, #4, mul vl]           // 16-byte Folded Reload
	eor	z29.d, z29.d, z0.d
	ldr	z0, [sp, #11, mul vl]           // 16-byte Folded Reload
	eor	z31.d, z31.d, z2.d
	eor	z8.d, z8.d, z3.d
	eor	z9.d, z9.d, z4.d
	eor	z18.d, z18.d, z5.d
	eor	z11.d, z11.d, z24.d
	eor	z6.d, z6.d, z16.d
	eor	z12.d, z12.d, z25.d
	cmp	w15, #1
	eor	z0.d, z0.d, z1.d
	str	z6, [sp, #12, mul vl]           // 16-byte Folded Spill
	ldr	z6, [sp, #3, mul vl]            // 16-byte Folded Reload
	str	z0, [sp, #11, mul vl]           // 16-byte Folded Spill
	eor	z28.d, z28.d, z6.d
	ldr	z6, [sp, #2, mul vl]            // 16-byte Folded Reload
	eor	z19.d, z19.d, z6.d
	ldr	z6, [sp, #1, mul vl]            // 16-byte Folded Reload
	eor	z17.d, z17.d, z6.d
	b.eq	.LBB10_15
// %bb.24:                              //   in Loop: Header=BB10_16 Depth=2
	sxtw	x26, w25
	ldr	z2, [sp, #10, mul vl]           // 16-byte Folded Reload
	ldr	z3, [sp, #9, mul vl]            // 16-byte Folded Reload
	ldr	z4, [sp, #8, mul vl]            // 16-byte Folded Reload
	ldr	z5, [sp, #7, mul vl]            // 16-byte Folded Reload
	ldr	z16, [sp, #5, mul vl]           // 16-byte Folded Reload
	add	x27, x2, x26
	ld1b	{ z0.b }, p0/z, [x2, x26]
	ld1b	{ z1.b }, p0/z, [x27, x6]
	tbl	z2.b, { z0.b }, z2.b
	tbl	z3.b, { z0.b }, z3.b
	tbl	z4.b, { z0.b }, z4.b
	tbl	z0.b, { z0.b }, z5.b
	tbl	z5.b, { z1.b }, z7.b
	ldr	z7, [sp, #6, mul vl]            // 16-byte Folded Reload
	tbl	z6.b, { z1.b }, z10.b
	tbl	z7.b, { z1.b }, z7.b
	tbl	z1.b, { z1.b }, z16.b
	eor	z26.d, z2.d, z5.d
	eor	z27.d, z3.d, z6.d
	eor	z14.d, z4.d, z7.d
	eor	z15.d, z0.d, z1.d
	b	.LBB10_15
.LBB10_25:
	add	w10, w17, w17, lsl #1
	movi	v0.2d, #0000000000000000
	lsl	w9, w17, #5
	mov	x8, xzr
	mov	w11, w5
	lsl	w10, w10, #4
.LBB10_26:                              // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB10_28
// %bb.27:                              //   in Loop: Header=BB10_26 Depth=1
	ldr	x12, [x4, #24]
	add	x13, x11, x8
	add	x14, x9, x8
	whilelt	p3.b, w13, w0
	add	x15, x10, x8
	st1b	{ z0.b }, p0, [x12, x8]
	whilelt	p2.b, w14, w0
	ldr	x12, [x4, #24]
	whilelt	p1.b, w15, w0
	st1b	{ z0.b }, p3, [x13, x12]
	ldr	x12, [x4, #24]
	st1b	{ z0.b }, p2, [x14, x12]
	ldr	x12, [x4, #24]
	st1b	{ z0.b }, p1, [x15, x12]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p3, [x13, x12]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p2, [x14, x12]
	ldr	x12, [x4, #16]
	st1b	{ z0.b }, p1, [x15, x12]
	ldr	x12, [x4, #8]
	st1b	{ z0.b }, p0, [x12, x8]
	ldr	x12, [x4, #8]
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
	b.gt	.LBB10_26
.LBB10_28:
	addvl	sp, sp, #13
	ldp	x20, x19, [sp, #128]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x27, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #144            // 16-byte Folded Reload
.LBB10_29:
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
	b.lt	.LBB11_33
// %bb.1:
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
	sub	sp, sp, #16
	addvl	sp, sp, #-21
	rdvl	x7, #1
	mov	w13, w1
	lsl	w8, w1, #5
	lsr	x18, x7, #4
	lsl	x9, x13, #5
	lsl	w10, w1, #6
	add	w6, w1, w1, lsl #1
	lsl	w11, w1, #7
	cmp	w1, #1
	str	w8, [sp, #12]                   // 4-byte Spill
	b.lt	.LBB11_12
// %bb.2:
	mov	x15, xzr
	sub	x14, x9, #32
.LBB11_3:                               // =>This Inner Loop Header: Depth=1
	add	x12, x2, w15, sxtw
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	cset	w12, ne
	ccmp	x14, x15, #4, eq
	add	x15, x15, #32
	b.ne	.LBB11_3
// %bb.4:
	sub	x17, x13, #1
	ldr	w14, [sp, #12]                  // 4-byte Reload
	mov	x15, x17
.LBB11_5:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	add	w14, w14, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	cset	w13, ne
	ccmp	x15, #0, #4, eq
	sub	x15, x15, #1
	b.ne	.LBB11_5
// %bb.6:
	mov	w15, w10
	mov	x16, x17
.LBB11_7:                               // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	add	w15, w15, #32
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	cset	w14, ne
	ccmp	x16, #0, #4, eq
	sub	x16, x16, #1
	b.ne	.LBB11_7
// %bb.8:
	lsl	w16, w6, #5
	mov	x5, x17
.LBB11_9:                               // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	add	w16, w16, #32
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	cset	w15, ne
	ccmp	x5, #0, #4, eq
	sub	x5, x5, #1
	b.ne	.LBB11_9
// %bb.10:
	mov	w5, w11
.LBB11_11:                              // =>This Inner Loop Header: Depth=1
	add	x16, x2, w5, sxtw
	add	w5, w5, #32
	ldrb	w16, [x16, #1]
	cmp	w16, #1
	cset	w16, ne
	ccmp	x17, #0, #4, eq
	sub	x17, x17, #1
	b.ne	.LBB11_11
	b	.LBB11_13
.LBB11_12:
	mov	w13, wzr
	mov	w14, wzr
	mov	w15, wzr
	mov	w16, wzr
	mov	w12, wzr
.LBB11_13:
	add	w5, w18, w18, lsl #1
	orr	w19, w12, w13
	orr	w20, w14, w15
	lsl	w18, w18, #5
	orr	w19, w19, w20
	lsl	w6, w6, #5
	lsl	w5, w5, #4
	ptrue	p0.b
	mov	x17, xzr
	mov	w7, w7
	orr	w19, w19, w16
	mov	w20, #16                        // =0x10
	b	.LBB11_16
.LBB11_14:                              //   in Loop: Header=BB11_16 Depth=1
	movi	v24.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v14.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	movi	v15.2d, #0000000000000000
	movi	v11.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v12.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	movi	v13.2d, #0000000000000000
	movi	v9.2d, #0000000000000000
.LBB11_15:                              //   in Loop: Header=BB11_16 Depth=1
	ldr	x8, [x4, #32]
	st1b	{ z27.b }, p1, [x8, x17]
	ldr	x8, [x4, #32]
	st1b	{ z26.b }, p4, [x8, x23]
	ldr	x8, [x4, #32]
	st1b	{ z25.b }, p3, [x8, x22]
	ldr	x8, [x4, #32]
	st1b	{ z24.b }, p2, [x8, x21]
	ldr	x8, [x4, #24]
	st1b	{ z4.b }, p1, [x8, x17]
	ldr	x8, [x4, #24]
	st1b	{ z20.b }, p4, [x8, x23]
	ldr	x8, [x4, #24]
	st1b	{ z19.b }, p3, [x8, x22]
	ldr	x8, [x4, #24]
	st1b	{ z18.b }, p2, [x8, x21]
	ldr	x8, [x4, #16]
	st1b	{ z1.b }, p1, [x8, x17]
	ldr	x8, [x4, #16]
	st1b	{ z16.b }, p4, [x8, x23]
	ldr	x8, [x4, #16]
	st1b	{ z15.b }, p3, [x8, x22]
	ldr	x8, [x4, #16]
	st1b	{ z14.b }, p2, [x8, x21]
	ldr	x8, [x4, #8]
	st1b	{ z13.b }, p1, [x8, x17]
	ldr	x8, [x4, #8]
	st1b	{ z12.b }, p4, [x8, x23]
	ldr	x8, [x4, #8]
	st1b	{ z11.b }, p3, [x8, x22]
	ldr	x8, [x4, #8]
	st1b	{ z10.b }, p2, [x8, x21]
	ldr	x8, [x4]
	st1b	{ z9.b }, p1, [x8, x17]
	incb	x17, all, mul #4
	ldr	x8, [x4]
	st1b	{ z8.b }, p4, [x8, x23]
	cmp	w0, w17
	ldr	x8, [x4]
	st1b	{ z23.b }, p3, [x8, x22]
	ldr	x8, [x4]
	st1b	{ z22.b }, p2, [x8, x21]
	b.le	.LBB11_32
.LBB11_16:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB11_21 Depth 2
	whilelt	p1.b, w17, w0
	b.eq	.LBB11_32
// %bb.17:                              //   in Loop: Header=BB11_16 Depth=1
	add	x23, x17, x7
	add	x22, x17, x18
	add	x21, x17, x5
	whilelt	p4.b, w23, w0
	whilelt	p3.b, w22, w0
	whilelt	p2.b, w21, w0
	cmp	w1, #1
	b.lt	.LBB11_14
// %bb.18:                              //   in Loop: Header=BB11_16 Depth=1
	movi	v9.2d, #0000000000000000
	movi	v13.2d, #0000000000000000
	ldr	w26, [sp, #12]                  // 4-byte Reload
	movi	v1.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	x24, xzr
	movi	v27.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	mov	x25, x3
	movi	v12.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	mov	w27, w10
	movi	v20.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	mov	w28, w6
	movi	v23.2d, #0000000000000000
	movi	v11.2d, #0000000000000000
	mov	w29, w11
	movi	v15.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	movi	v14.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	b	.LBB11_21
.LBB11_19:                              //   in Loop: Header=BB11_21 Depth=2
	eor	z9.d, z9.d, z30.d
	eor	z8.d, z8.d, z31.d
	eor	z23.d, z23.d, z2.d
	eor	z22.d, z22.d, z3.d
	eor	z13.d, z13.d, z30.d
	eor	z12.d, z12.d, z31.d
	eor	z11.d, z11.d, z2.d
	eor	z10.d, z10.d, z3.d
	eor	z1.d, z1.d, z30.d
	eor	z16.d, z16.d, z31.d
	eor	z15.d, z15.d, z2.d
	eor	z14.d, z14.d, z3.d
	eor	z4.d, z4.d, z30.d
	eor	z20.d, z20.d, z31.d
	eor	z19.d, z19.d, z2.d
	eor	z18.d, z18.d, z3.d
.LBB11_20:                              //   in Loop: Header=BB11_21 Depth=2
	eor	z27.d, z27.d, z30.d
	eor	z26.d, z26.d, z31.d
	add	x24, x24, #32
	eor	z25.d, z25.d, z2.d
	eor	z24.d, z24.d, z3.d
	add	w29, w29, #32
	cmp	x9, x24
	add	w28, w28, #32
	add	w27, w27, #32
	add	w26, w26, #32
	b.eq	.LBB11_15
.LBB11_21:                              //   Parent Loop BB11_16 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x30, [x25], #8
	ld1b	{ z30.b }, p1/z, [x30, x17]
	ld1b	{ z31.b }, p4/z, [x30, x23]
	ld1b	{ z2.b }, p3/z, [x30, x22]
	ld1b	{ z3.b }, p2/z, [x30, x21]
	tbz	w19, #0, .LBB11_19
// %bb.22:                              //   in Loop: Header=BB11_21 Depth=2
	lsr	z0.b, z30.b, #4
	add	x8, sp, #16
	movprfx	z6, z30
	and	z6.b, z6.b, #0xf
	str	z4, [x8, #8, mul vl]            // 16-byte Folded Spill
	movprfx	z7, z31
	and	z7.b, z7.b, #0xf
	mov	z4.d, z30.d
	str	z16, [x8, #12, mul vl]          // 16-byte Folded Spill
	mov	z5.d, z31.d
	mov	z16.d, z3.d
	str	z0, [x8, #20, mul vl]           // 16-byte Folded Spill
	lsr	z0.b, z31.b, #4
	str	z20, [x8, #9, mul vl]           // 16-byte Folded Spill
	str	z19, [x8, #10, mul vl]          // 16-byte Folded Spill
	str	z0, [x8, #19, mul vl]           // 16-byte Folded Spill
	movprfx	z0, z2
	and	z0.b, z0.b, #0xf
	str	z18, [x8, #11, mul vl]          // 16-byte Folded Spill
	str	z6, [x8, #14, mul vl]           // 16-byte Folded Spill
	str	z0, [x8, #16, mul vl]           // 16-byte Folded Spill
	lsr	z0.b, z2.b, #4
	str	z7, [x8, #13, mul vl]           // 16-byte Folded Spill
	str	z0, [x8, #18, mul vl]           // 16-byte Folded Spill
	movprfx	z0, z3
	and	z0.b, z0.b, #0xf
	str	z0, [x8, #15, mul vl]           // 16-byte Folded Spill
	lsr	z0.b, z3.b, #4
	str	z0, [x8, #17, mul vl]           // 16-byte Folded Spill
	mov	z0.d, z2.d
	cbz	w12, .LBB11_24
// %bb.23:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x30, w24
	mov	z19.d, z1.d
	ld1b	{ z0.b }, p0/z, [x2, x30]
	add	x8, x2, x30
	ld1b	{ z1.b }, p0/z, [x8, x20]
	add	x8, sp, #16
	ldr	z16, [x8, #19, mul vl]          // 16-byte Folded Reload
	ldr	z17, [x8, #18, mul vl]          // 16-byte Folded Reload
	ldr	z18, [x8, #17, mul vl]          // 16-byte Folded Reload
	tbl	z4.b, { z0.b }, z6.b
	tbl	z5.b, { z0.b }, z7.b
	ldr	z6, [x8, #16, mul vl]           // 16-byte Folded Reload
	ldr	z7, [x8, #15, mul vl]           // 16-byte Folded Reload
	tbl	z16.b, { z1.b }, z16.b
	tbl	z17.b, { z1.b }, z17.b
	tbl	z18.b, { z1.b }, z18.b
	tbl	z6.b, { z0.b }, z6.b
	tbl	z7.b, { z0.b }, z7.b
	ldr	z0, [x8, #20, mul vl]           // 16-byte Folded Reload
	eor	z5.d, z5.d, z16.d
	tbl	z0.b, { z1.b }, z0.b
	mov	z1.d, z19.d
	eor	z16.d, z7.d, z18.d
	ldr	z7, [x8, #13, mul vl]           // 16-byte Folded Reload
	eor	z4.d, z4.d, z0.d
	eor	z0.d, z6.d, z17.d
	ldr	z6, [x8, #14, mul vl]           // 16-byte Folded Reload
.LBB11_24:                              //   in Loop: Header=BB11_21 Depth=2
	str	z16, [x8, #6, mul vl]           // 16-byte Folded Spill
	mov	z18.d, z31.d
	mov	z16.d, z2.d
	str	z0, [x8, #7, mul vl]            // 16-byte Folded Spill
	mov	z0.d, z30.d
	mov	z17.d, z3.d
	cbz	w13, .LBB11_26
// %bb.25:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x8, w26
	mov	z21.d, z4.d
	mov	z28.d, z5.d
	add	x30, x2, x8
	ld1b	{ z4.b }, p0/z, [x2, x8]
	add	x8, sp, #16
	ldr	z0, [x8, #14, mul vl]           // 16-byte Folded Reload
	ld1b	{ z5.b }, p0/z, [x30, x20]
	tbl	z6.b, { z4.b }, z0.b
	ldr	z0, [x8, #13, mul vl]           // 16-byte Folded Reload
	tbl	z7.b, { z4.b }, z0.b
	ldr	z0, [x8, #16, mul vl]           // 16-byte Folded Reload
	tbl	z16.b, { z4.b }, z0.b
	ldr	z0, [x8, #15, mul vl]           // 16-byte Folded Reload
	tbl	z17.b, { z4.b }, z0.b
	ldr	z0, [x8, #20, mul vl]           // 16-byte Folded Reload
	tbl	z4.b, { z5.b }, z0.b
	ldr	z0, [x8, #19, mul vl]           // 16-byte Folded Reload
	tbl	z18.b, { z5.b }, z0.b
	ldr	z0, [x8, #18, mul vl]           // 16-byte Folded Reload
	tbl	z19.b, { z5.b }, z0.b
	ldr	z0, [x8, #17, mul vl]           // 16-byte Folded Reload
	eor	z18.d, z7.d, z18.d
	ldr	z7, [x8, #13, mul vl]           // 16-byte Folded Reload
	tbl	z20.b, { z5.b }, z0.b
	mov	z5.d, z28.d
	eor	z0.d, z6.d, z4.d
	mov	z4.d, z21.d
	ldr	z6, [x8, #14, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z16.d, z19.d
	eor	z17.d, z17.d, z20.d
.LBB11_26:                              //   in Loop: Header=BB11_21 Depth=2
	str	z17, [x8, #2, mul vl]           // 16-byte Folded Spill
	mov	z17.d, z31.d
	mov	z19.d, z3.d
	str	z16, [x8, #3, mul vl]           // 16-byte Folded Spill
	mov	z16.d, z30.d
	str	z18, [x8, #4, mul vl]           // 16-byte Folded Spill
	mov	z18.d, z2.d
	str	z0, [x8, #5, mul vl]            // 16-byte Folded Spill
	cbz	w14, .LBB11_28
// %bb.27:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x8, w27
	add	x30, x2, x8
	ld1b	{ z16.b }, p0/z, [x2, x8]
	add	x8, sp, #16
	ldr	z0, [x8, #16, mul vl]           // 16-byte Folded Reload
	ld1b	{ z17.b }, p0/z, [x30, x20]
	tbl	z18.b, { z16.b }, z6.b
	tbl	z19.b, { z16.b }, z7.b
	tbl	z20.b, { z16.b }, z0.b
	ldr	z0, [x8, #15, mul vl]           // 16-byte Folded Reload
	tbl	z21.b, { z16.b }, z0.b
	ldr	z0, [x8, #20, mul vl]           // 16-byte Folded Reload
	tbl	z16.b, { z17.b }, z0.b
	ldr	z0, [x8, #19, mul vl]           // 16-byte Folded Reload
	tbl	z28.b, { z17.b }, z0.b
	ldr	z0, [x8, #18, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z18.d, z16.d
	tbl	z29.b, { z17.b }, z0.b
	ldr	z0, [x8, #17, mul vl]           // 16-byte Folded Reload
	tbl	z0.b, { z17.b }, z0.b
	eor	z17.d, z19.d, z28.d
	eor	z18.d, z20.d, z29.d
	eor	z19.d, z21.d, z0.d
.LBB11_28:                              //   in Loop: Header=BB11_21 Depth=2
	mov	z20.d, z30.d
	mov	z21.d, z31.d
	mov	z28.d, z2.d
	mov	z29.d, z3.d
	cbz	w15, .LBB11_30
// %bb.29:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x8, w28
	add	x30, x2, x8
	ld1b	{ z0.b }, p0/z, [x2, x8]
	add	x8, sp, #16
	str	z4, [x8, #1, mul vl]            // 16-byte Folded Spill
	ldr	z4, [x8, #16, mul vl]           // 16-byte Folded Reload
	ld1b	{ z20.b }, p0/z, [x30, x20]
	str	z24, [x8]                       // 16-byte Folded Spill
	mov	z24.d, z5.d
	ldr	z5, [x8, #18, mul vl]           // 16-byte Folded Reload
	tbl	z21.b, { z0.b }, z6.b
	tbl	z28.b, { z0.b }, z7.b
	mov	z7.d, z1.d
	tbl	z29.b, { z0.b }, z4.b
	ldr	z4, [x8, #15, mul vl]           // 16-byte Folded Reload
	ldr	z1, [x8, #20, mul vl]           // 16-byte Folded Reload
	mov	z6.d, z15.d
	mov	z15.d, z12.d
	mov	z12.d, z9.d
	mov	z9.d, z22.d
	tbl	z0.b, { z0.b }, z4.b
	ldr	z4, [x8, #19, mul vl]           // 16-byte Folded Reload
	tbl	z1.b, { z20.b }, z1.b
	tbl	z22.b, { z20.b }, z4.b
	mov	z4.d, z13.d
	mov	z13.d, z10.d
	mov	z10.d, z23.d
	tbl	z23.b, { z20.b }, z5.b
	mov	z5.d, z11.d
	mov	z11.d, z8.d
	ldr	z8, [x8, #17, mul vl]           // 16-byte Folded Reload
	tbl	z8.b, { z20.b }, z8.b
	eor	z20.d, z21.d, z1.d
	mov	z1.d, z7.d
	ldr	z7, [x8, #13, mul vl]           // 16-byte Folded Reload
	eor	z21.d, z28.d, z22.d
	mov	z22.d, z9.d
	mov	z9.d, z12.d
	mov	z12.d, z15.d
	mov	z15.d, z6.d
	ldr	z6, [x8, #14, mul vl]           // 16-byte Folded Reload
	eor	z28.d, z29.d, z23.d
	mov	z23.d, z10.d
	mov	z10.d, z13.d
	mov	z13.d, z4.d
	ldr	z4, [x8, #1, mul vl]            // 16-byte Folded Reload
	eor	z29.d, z0.d, z8.d
	mov	z8.d, z11.d
	mov	z11.d, z5.d
	mov	z5.d, z24.d
	ldr	z24, [x8]                       // 16-byte Folded Reload
.LBB11_30:                              //   in Loop: Header=BB11_21 Depth=2
	ldr	z0, [x8, #7, mul vl]            // 16-byte Folded Reload
	eor	z9.d, z9.d, z4.d
	ldr	z4, [x8, #8, mul vl]            // 16-byte Folded Reload
	eor	z1.d, z1.d, z16.d
	ldr	z16, [x8, #12, mul vl]          // 16-byte Folded Reload
	eor	z15.d, z15.d, z18.d
	eor	z14.d, z14.d, z19.d
	ldr	z19, [x8, #10, mul vl]          // 16-byte Folded Reload
	ldr	z18, [x8, #11, mul vl]          // 16-byte Folded Reload
	eor	z23.d, z23.d, z0.d
	ldr	z0, [x8, #6, mul vl]            // 16-byte Folded Reload
	eor	z4.d, z4.d, z20.d
	ldr	z20, [x8, #9, mul vl]           // 16-byte Folded Reload
	eor	z8.d, z8.d, z5.d
	eor	z16.d, z16.d, z17.d
	eor	z19.d, z19.d, z28.d
	eor	z18.d, z18.d, z29.d
	eor	z22.d, z22.d, z0.d
	ldr	z0, [x8, #5, mul vl]            // 16-byte Folded Reload
	eor	z20.d, z20.d, z21.d
	eor	z13.d, z13.d, z0.d
	ldr	z0, [x8, #4, mul vl]            // 16-byte Folded Reload
	eor	z12.d, z12.d, z0.d
	ldr	z0, [x8, #3, mul vl]            // 16-byte Folded Reload
	eor	z11.d, z11.d, z0.d
	ldr	z0, [x8, #2, mul vl]            // 16-byte Folded Reload
	eor	z10.d, z10.d, z0.d
	cbz	w16, .LBB11_20
// %bb.31:                              //   in Loop: Header=BB11_21 Depth=2
	sxtw	x8, w29
	mov	z21.d, z4.d
	mov	z17.d, z1.d
	add	x30, x2, x8
	ld1b	{ z0.b }, p0/z, [x2, x8]
	add	x8, sp, #16
	ldr	z4, [x8, #16, mul vl]           // 16-byte Folded Reload
	ldr	z5, [x8, #15, mul vl]           // 16-byte Folded Reload
	ld1b	{ z1.b }, p0/z, [x30, x20]
	ldr	z28, [x8, #17, mul vl]          // 16-byte Folded Reload
	tbl	z2.b, { z0.b }, z6.b
	tbl	z3.b, { z0.b }, z7.b
	ldr	z6, [x8, #19, mul vl]           // 16-byte Folded Reload
	tbl	z4.b, { z0.b }, z4.b
	tbl	z0.b, { z0.b }, z5.b
	ldr	z5, [x8, #20, mul vl]           // 16-byte Folded Reload
	ldr	z7, [x8, #18, mul vl]           // 16-byte Folded Reload
	tbl	z6.b, { z1.b }, z6.b
	tbl	z5.b, { z1.b }, z5.b
	tbl	z7.b, { z1.b }, z7.b
	tbl	z1.b, { z1.b }, z28.b
	eor	z31.d, z3.d, z6.d
	eor	z30.d, z2.d, z5.d
	eor	z2.d, z4.d, z7.d
	eor	z3.d, z0.d, z1.d
	mov	z1.d, z17.d
	mov	z4.d, z21.d
	b	.LBB11_20
.LBB11_32:
	addvl	sp, sp, #21
	add	sp, sp, #16
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
.LBB11_33:
	ret
.Lfunc_end11:
	.size	gf_5vect_dot_prod_sve2, .Lfunc_end11-gf_5vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_6vect_dot_prod_sve2          // -- Begin function gf_6vect_dot_prod_sve2
	.p2align	2
	.type	gf_6vect_dot_prod_sve2,@function
gf_6vect_dot_prod_sve2:                 // @gf_6vect_dot_prod_sve2
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
	addvl	sp, sp, #-29
	cmp	w0, #16
	str	x3, [sp, #24]                   // 8-byte Spill
	b.ge	.LBB12_2
.LBB12_1:
	addvl	sp, sp, #29
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
.LBB12_2:
	lsl	w11, w1, #5
	lsl	w10, w1, #6
	rdvl	x8, #1
	mov	w13, w1
	lsr	x5, x8, #4
	add	w7, w1, w1, lsl #2
	lsl	x9, x13, #5
	stp	w10, w11, [sp, #16]             // 8-byte Folded Spill
	add	w10, w1, w1, lsl #1
	lsl	w11, w1, #7
	cmp	w1, #1
	str	w11, [sp, #12]                  // 4-byte Spill
	b.lt	.LBB12_15
// %bb.3:
	mov	x15, xzr
	sub	x14, x9, #32
.LBB12_4:                               // =>This Inner Loop Header: Depth=1
	add	x12, x2, w15, sxtw
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	cset	w12, ne
	ccmp	x14, x15, #4, eq
	add	x15, x15, #32
	b.ne	.LBB12_4
// %bb.5:
	sub	x18, x13, #1
	ldr	w14, [sp, #20]                  // 4-byte Reload
	mov	x15, x18
.LBB12_6:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	add	w14, w14, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	cset	w13, ne
	ccmp	x15, #0, #4, eq
	sub	x15, x15, #1
	b.ne	.LBB12_6
// %bb.7:
	ldr	w15, [sp, #16]                  // 4-byte Reload
	mov	x16, x18
.LBB12_8:                               // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	add	w15, w15, #32
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	cset	w14, ne
	ccmp	x16, #0, #4, eq
	sub	x16, x16, #1
	b.ne	.LBB12_8
// %bb.9:
	lsl	w16, w10, #5
	mov	x17, x18
.LBB12_10:                              // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	add	w16, w16, #32
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	cset	w15, ne
	ccmp	x17, #0, #4, eq
	sub	x17, x17, #1
	b.ne	.LBB12_10
// %bb.11:
	ldr	w17, [sp, #12]                  // 4-byte Reload
	mov	x6, x18
.LBB12_12:                              // =>This Inner Loop Header: Depth=1
	add	x16, x2, w17, sxtw
	add	w17, w17, #32
	ldrb	w16, [x16, #1]
	cmp	w16, #1
	cset	w16, ne
	ccmp	x6, #0, #4, eq
	sub	x6, x6, #1
	b.ne	.LBB12_12
// %bb.13:
	lsl	w6, w7, #5
.LBB12_14:                              // =>This Inner Loop Header: Depth=1
	add	x17, x2, w6, sxtw
	add	w6, w6, #32
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	cset	w17, ne
	ccmp	x18, #0, #4, eq
	sub	x18, x18, #1
	b.ne	.LBB12_14
	b	.LBB12_16
.LBB12_15:
	mov	w13, wzr
	mov	w14, wzr
	mov	w15, wzr
	mov	w16, wzr
	mov	w17, wzr
	mov	w12, wzr
.LBB12_16:
	add	w6, w5, w5, lsl #1
	orr	w19, w12, w13
	orr	w20, w14, w15
	orr	w19, w19, w20
	lsl	w5, w5, #5
	lsl	w3, w7, #5
	lsl	w6, w6, #4
	orr	w21, w19, w16
	lsl	w19, w10, #5
	ptrue	p0.b
	mov	x18, xzr
	mov	w20, w8
	orr	w21, w21, w17
	mov	w22, #16                        // =0x10
	b	.LBB12_19
.LBB12_17:                              //   in Loop: Header=BB12_19 Depth=1
	movi	v0.2d, #0000000000000000
	add	x8, sp, #32
	movi	v1.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	str	z0, [x8, #24, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	str	z1, [x8, #28, mul vl]           // 16-byte Folded Spill
	movi	v22.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	str	z2, [x8, #27, mul vl]           // 16-byte Folded Spill
	movi	v17.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	str	z3, [x8, #26, mul vl]           // 16-byte Folded Spill
	movi	v4.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	str	z0, [x8, #23, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	str	z7, [x8, #25, mul vl]           // 16-byte Folded Spill
	movi	v6.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	str	z0, [x8, #22, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #21, mul vl]           // 16-byte Folded Spill
.LBB12_18:                              //   in Loop: Header=BB12_19 Depth=1
	ldr	x8, [x4, #40]
	add	x10, sp, #32
	ldr	z0, [x10, #21, mul vl]          // 16-byte Folded Reload
	st1b	{ z31.b }, p1, [x8, x18]
	ldr	x8, [x4, #40]
	st1b	{ z30.b }, p4, [x8, x25]
	ldr	x8, [x4, #40]
	st1b	{ z29.b }, p3, [x8, x24]
	ldr	x8, [x4, #40]
	st1b	{ z28.b }, p2, [x8, x23]
	ldr	x8, [x4, #32]
	st1b	{ z18.b }, p1, [x8, x18]
	ldr	x8, [x4, #32]
	st1b	{ z17.b }, p4, [x8, x25]
	ldr	x8, [x4, #32]
	st1b	{ z27.b }, p3, [x8, x24]
	ldr	x8, [x4, #32]
	st1b	{ z26.b }, p2, [x8, x23]
	ldr	x8, [x4, #24]
	st1b	{ z6.b }, p1, [x8, x18]
	ldr	x8, [x4, #24]
	st1b	{ z25.b }, p4, [x8, x25]
	ldr	x8, [x4, #24]
	st1b	{ z24.b }, p3, [x8, x24]
	ldr	x8, [x4, #24]
	st1b	{ z23.b }, p2, [x8, x23]
	ldr	x8, [x4, #16]
	st1b	{ z5.b }, p1, [x8, x18]
	ldr	x8, [x4, #16]
	st1b	{ z4.b }, p4, [x8, x25]
	ldr	x8, [x4, #16]
	st1b	{ z22.b }, p3, [x8, x24]
	ldr	x8, [x4, #16]
	st1b	{ z21.b }, p2, [x8, x23]
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p1, [x8, x18]
	ldr	z0, [x10, #22, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p4, [x8, x25]
	ldr	z0, [x10, #23, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p3, [x8, x24]
	ldr	z0, [x10, #24, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p2, [x8, x23]
	ldr	z0, [x10, #25, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4]
	st1b	{ z0.b }, p1, [x8, x18]
	ldr	z0, [x10, #26, mul vl]          // 16-byte Folded Reload
	incb	x18, all, mul #4
	ldr	x8, [x4]
	st1b	{ z0.b }, p4, [x8, x25]
	ldr	z0, [x10, #27, mul vl]          // 16-byte Folded Reload
	cmp	w0, w18
	ldr	x8, [x4]
	st1b	{ z0.b }, p3, [x8, x24]
	ldr	z0, [x10, #28, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4]
	st1b	{ z0.b }, p2, [x8, x23]
	b.le	.LBB12_1
.LBB12_19:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB12_24 Depth 2
	whilelt	p1.b, w18, w0
	b.eq	.LBB12_1
// %bb.20:                              //   in Loop: Header=BB12_19 Depth=1
	add	x25, x18, x20
	add	x24, x18, x5
	add	x23, x18, x6
	whilelt	p4.b, w25, w0
	whilelt	p3.b, w24, w0
	whilelt	p2.b, w23, w0
	cmp	w1, #1
	b.lt	.LBB12_17
// %bb.21:                              //   in Loop: Header=BB12_19 Depth=1
	movi	v0.2d, #0000000000000000
	add	x8, sp, #32
	movi	v5.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	ldr	x27, [sp, #24]                  // 8-byte Reload
	movi	v31.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	x26, xzr
	movi	v25.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	w30, w19
	str	z0, [x8, #25, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	mov	w10, w3
	movi	v27.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	str	z0, [x8, #21, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	ldp	w29, w28, [sp, #16]             // 8-byte Folded Reload
	str	z0, [x8, #26, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #22, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #27, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #23, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #28, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #24, mul vl]           // 16-byte Folded Spill
	ldr	w8, [sp, #12]                   // 4-byte Reload
	b	.LBB12_24
.LBB12_22:                              //   in Loop: Header=BB12_24 Depth=2
	ldr	z16, [x11, #25, mul vl]         // 16-byte Folded Reload
	ldr	z0, [x11, #21, mul vl]          // 16-byte Folded Reload
	eor	z5.d, z5.d, z10.d
	eor	z4.d, z4.d, z11.d
	eor	z22.d, z22.d, z8.d
	eor	z21.d, z21.d, z7.d
	eor	z6.d, z6.d, z10.d
	eor	z25.d, z25.d, z11.d
	eor	z24.d, z24.d, z8.d
	eor	z16.d, z16.d, z10.d
	eor	z0.d, z0.d, z10.d
	eor	z23.d, z23.d, z7.d
	eor	z18.d, z18.d, z10.d
	eor	z17.d, z17.d, z11.d
	eor	z27.d, z27.d, z8.d
	eor	z26.d, z26.d, z7.d
	str	z16, [x11, #25, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #26, mul vl]         // 16-byte Folded Reload
	str	z0, [x11, #21, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #22, mul vl]          // 16-byte Folded Reload
	eor	z16.d, z16.d, z11.d
	eor	z0.d, z0.d, z11.d
	str	z16, [x11, #26, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #27, mul vl]         // 16-byte Folded Reload
	str	z0, [x11, #22, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #23, mul vl]          // 16-byte Folded Reload
	eor	z16.d, z16.d, z8.d
	eor	z0.d, z0.d, z8.d
	str	z16, [x11, #27, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #28, mul vl]         // 16-byte Folded Reload
	str	z0, [x11, #23, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #24, mul vl]          // 16-byte Folded Reload
	eor	z16.d, z16.d, z7.d
	eor	z0.d, z0.d, z7.d
	str	z16, [x11, #28, mul vl]         // 16-byte Folded Spill
	str	z0, [x11, #24, mul vl]          // 16-byte Folded Spill
.LBB12_23:                              //   in Loop: Header=BB12_24 Depth=2
	eor	z31.d, z31.d, z10.d
	eor	z30.d, z30.d, z11.d
	add	x26, x26, #32
	eor	z29.d, z29.d, z8.d
	eor	z28.d, z28.d, z7.d
	add	w10, w10, #32
	add	w8, w8, #32
	cmp	x9, x26
	add	w30, w30, #32
	add	w29, w29, #32
	add	w28, w28, #32
	b.eq	.LBB12_18
.LBB12_24:                              //   Parent Loop BB12_19 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x11, [x27], #8
	ld1b	{ z10.b }, p1/z, [x11, x18]
	ld1b	{ z11.b }, p4/z, [x11, x25]
	ld1b	{ z8.b }, p3/z, [x11, x24]
	ld1b	{ z7.b }, p2/z, [x11, x23]
	add	x11, sp, #32
	tbz	w21, #0, .LBB12_22
// %bb.25:                              //   in Loop: Header=BB12_24 Depth=2
	str	z4, [x11, #20, mul vl]          // 16-byte Folded Spill
	lsr	z4.b, z11.b, #4
	lsr	z9.b, z10.b, #4
	mov	z0.d, z10.d
	mov	z1.d, z11.d
	str	z6, [x11, #18, mul vl]          // 16-byte Folded Spill
	mov	z2.d, z8.d
	mov	z3.d, z7.d
	str	z5, [x11, #19, mul vl]          // 16-byte Folded Spill
	str	z4, [x11, #17, mul vl]          // 16-byte Folded Spill
	lsr	z4.b, z8.b, #4
	movprfx	z12, z10
	and	z12.b, z12.b, #0xf
	movprfx	z13, z11
	and	z13.b, z13.b, #0xf
	movprfx	z19, z8
	and	z19.b, z19.b, #0xf
	movprfx	z14, z7
	and	z14.b, z14.b, #0xf
	str	z17, [x11, #14, mul vl]         // 16-byte Folded Spill
	str	z4, [x11, #16, mul vl]          // 16-byte Folded Spill
	lsr	z4.b, z7.b, #4
	str	z18, [x11, #13, mul vl]         // 16-byte Folded Spill
	str	z4, [x11, #15, mul vl]          // 16-byte Folded Spill
	cbz	w12, .LBB12_27
// %bb.26:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x11, w26
	mov	z15.d, z19.d
	mov	z0.d, z14.d
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x7, x2, x11
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x7, x22]
	ldr	z20, [x11, #16, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z4.b }, z12.b
	tbl	z16.b, { z4.b }, z13.b
	tbl	z17.b, { z4.b }, z19.b
	tbl	z4.b, { z4.b }, z14.b
	ldr	z19, [x11, #17, mul vl]         // 16-byte Folded Reload
	mov	z14.d, z13.d
	mov	z13.d, z12.d
	ldr	z12, [x11, #15, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z5.b }, z9.b
	tbl	z20.b, { z5.b }, z20.b
	tbl	z19.b, { z5.b }, z19.b
	tbl	z5.b, { z5.b }, z12.b
	mov	z12.d, z13.d
	mov	z13.d, z14.d
	mov	z14.d, z0.d
	eor	z0.d, z6.d, z18.d
	ldr	z18, [x11, #13, mul vl]         // 16-byte Folded Reload
	eor	z2.d, z17.d, z20.d
	ldr	z17, [x11, #14, mul vl]         // 16-byte Folded Reload
	eor	z1.d, z16.d, z19.d
	mov	z19.d, z15.d
	eor	z3.d, z4.d, z5.d
.LBB12_27:                              //   in Loop: Header=BB12_24 Depth=2
	mov	z15.d, z10.d
	mov	z6.d, z11.d
	str	z24, [x11, #8, mul vl]          // 16-byte Folded Spill
	mov	z16.d, z8.d
	mov	z4.d, z7.d
	str	z23, [x11, #9, mul vl]          // 16-byte Folded Spill
	str	z22, [x11, #10, mul vl]         // 16-byte Folded Spill
	str	z21, [x11, #11, mul vl]         // 16-byte Folded Spill
	cbz	w13, .LBB12_29
// %bb.28:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x11, w28
	mov	z22.d, z19.d
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x7, x2, x11
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x7, x22]
	ldr	z20, [x11, #16, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x11, #15, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z4.b }, z19.b
	ldr	z19, [x11, #17, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z4.b }, z12.b
	tbl	z17.b, { z4.b }, z13.b
	tbl	z4.b, { z4.b }, z14.b
	tbl	z16.b, { z5.b }, z9.b
	tbl	z20.b, { z5.b }, z20.b
	tbl	z19.b, { z5.b }, z19.b
	tbl	z5.b, { z5.b }, z21.b
	eor	z15.d, z6.d, z16.d
	eor	z16.d, z18.d, z20.d
	ldr	z18, [x11, #13, mul vl]         // 16-byte Folded Reload
	eor	z6.d, z17.d, z19.d
	mov	z19.d, z22.d
	ldr	z17, [x11, #14, mul vl]         // 16-byte Folded Reload
	eor	z4.d, z4.d, z5.d
.LBB12_29:                              //   in Loop: Header=BB12_24 Depth=2
	str	z6, [x11, #4, mul vl]           // 16-byte Folded Spill
	mov	z6.d, z10.d
	mov	z20.d, z11.d
	mov	z21.d, z8.d
	mov	z23.d, z7.d
	str	z4, [x11, #2, mul vl]           // 16-byte Folded Spill
	str	z16, [x11, #3, mul vl]          // 16-byte Folded Spill
	str	z27, [x11, #5, mul vl]          // 16-byte Folded Spill
	str	z26, [x11, #6, mul vl]          // 16-byte Folded Spill
	str	z25, [x11, #7, mul vl]          // 16-byte Folded Spill
	cbz	w14, .LBB12_31
// %bb.30:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x11, w29
	add	x7, x2, x11
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x7, x22]
	ldr	z16, [x11, #17, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z4.b }, z12.b
	tbl	z21.b, { z4.b }, z13.b
	tbl	z22.b, { z4.b }, z19.b
	tbl	z23.b, { z5.b }, z16.b
	ldr	z16, [x11, #16, mul vl]         // 16-byte Folded Reload
	tbl	z4.b, { z4.b }, z14.b
	tbl	z20.b, { z5.b }, z9.b
	tbl	z24.b, { z5.b }, z16.b
	ldr	z16, [x11, #15, mul vl]         // 16-byte Folded Reload
	eor	z6.d, z6.d, z20.d
	eor	z20.d, z21.d, z23.d
	tbl	z5.b, { z5.b }, z16.b
	eor	z21.d, z22.d, z24.d
	eor	z23.d, z4.d, z5.d
.LBB12_31:                              //   in Loop: Header=BB12_24 Depth=2
	mov	z24.d, z10.d
	mov	z25.d, z11.d
	str	z6, [x11, #1, mul vl]           // 16-byte Folded Spill
	mov	z26.d, z8.d
	mov	z27.d, z7.d
	str	z9, [x11, #12, mul vl]          // 16-byte Folded Spill
	cbz	w15, .LBB12_33
// %bb.32:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x11, w30
	add	x7, x2, x11
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x7, x22]
	ldr	z16, [x11, #12, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z4.b }, z12.b
	tbl	z25.b, { z4.b }, z13.b
	tbl	z26.b, { z4.b }, z19.b
	tbl	z24.b, { z5.b }, z16.b
	ldr	z16, [x11, #17, mul vl]         // 16-byte Folded Reload
	tbl	z4.b, { z4.b }, z14.b
	tbl	z27.b, { z5.b }, z16.b
	ldr	z16, [x11, #16, mul vl]         // 16-byte Folded Reload
	eor	z24.d, z6.d, z24.d
	tbl	z9.b, { z5.b }, z16.b
	ldr	z16, [x11, #15, mul vl]         // 16-byte Folded Reload
	eor	z25.d, z25.d, z27.d
	tbl	z5.b, { z5.b }, z16.b
	eor	z26.d, z26.d, z9.d
	eor	z27.d, z4.d, z5.d
.LBB12_33:                              //   in Loop: Header=BB12_24 Depth=2
	mov	z4.d, z10.d
	mov	z5.d, z11.d
	mov	z6.d, z8.d
	mov	z9.d, z7.d
	cbz	w16, .LBB12_35
// %bb.34:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x11, w8
	mov	z22.d, z20.d
	mov	z20.d, z3.d
	mov	z3.d, z2.d
	mov	z2.d, z1.d
	mov	z1.d, z0.d
	add	x7, x2, x11
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x7, x22]
	ldr	z18, [x11, #17, mul vl]         // 16-byte Folded Reload
	mov	z0.d, z14.d
	str	z31, [x11]                      // 16-byte Folded Spill
	mov	z31.d, z30.d
	mov	z30.d, z29.d
	tbl	z6.b, { z4.b }, z12.b
	tbl	z17.b, { z4.b }, z14.b
	mov	z14.d, z12.d
	tbl	z12.b, { z5.b }, z18.b
	ldr	z18, [x11, #16, mul vl]         // 16-byte Folded Reload
	tbl	z9.b, { z4.b }, z13.b
	tbl	z16.b, { z4.b }, z19.b
	ldr	z4, [x11, #12, mul vl]          // 16-byte Folded Reload
	mov	z29.d, z28.d
	mov	z28.d, z23.d
	mov	z23.d, z21.d
	mov	z21.d, z15.d
	mov	z15.d, z13.d
	tbl	z13.b, { z5.b }, z18.b
	ldr	z18, [x11, #15, mul vl]         // 16-byte Folded Reload
	tbl	z4.b, { z5.b }, z4.b
	tbl	z18.b, { z5.b }, z18.b
	eor	z5.d, z9.d, z12.d
	mov	z12.d, z14.d
	mov	z14.d, z0.d
	mov	z0.d, z1.d
	mov	z1.d, z2.d
	eor	z4.d, z6.d, z4.d
	mov	z2.d, z3.d
	mov	z3.d, z20.d
	mov	z20.d, z22.d
	eor	z6.d, z16.d, z13.d
	mov	z13.d, z15.d
	mov	z15.d, z21.d
	mov	z21.d, z23.d
	mov	z23.d, z28.d
	mov	z28.d, z29.d
	mov	z29.d, z30.d
	mov	z30.d, z31.d
	ldr	z31, [x11]                      // 16-byte Folded Reload
	eor	z9.d, z17.d, z18.d
	ldr	z18, [x11, #13, mul vl]         // 16-byte Folded Reload
	ldr	z17, [x11, #14, mul vl]         // 16-byte Folded Reload
.LBB12_35:                              //   in Loop: Header=BB12_24 Depth=2
	ldr	z16, [x11, #25, mul vl]         // 16-byte Folded Reload
	eor	z18.d, z18.d, z4.d
	eor	z17.d, z17.d, z5.d
	eor	z16.d, z16.d, z0.d
	ldr	z0, [x11, #21, mul vl]          // 16-byte Folded Reload
	str	z16, [x11, #25, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #26, mul vl]         // 16-byte Folded Reload
	eor	z0.d, z0.d, z15.d
	eor	z16.d, z16.d, z1.d
	str	z0, [x11, #21, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #22, mul vl]          // 16-byte Folded Reload
	ldr	z1, [x11, #4, mul vl]           // 16-byte Folded Reload
	str	z16, [x11, #26, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #27, mul vl]         // 16-byte Folded Reload
	eor	z0.d, z0.d, z1.d
	ldr	z1, [x11, #3, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z16.d, z2.d
	str	z0, [x11, #22, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #23, mul vl]          // 16-byte Folded Reload
	str	z16, [x11, #27, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #28, mul vl]         // 16-byte Folded Reload
	eor	z0.d, z0.d, z1.d
	ldr	z1, [x11, #2, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z16.d, z3.d
	str	z0, [x11, #23, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #24, mul vl]          // 16-byte Folded Reload
	str	z16, [x11, #28, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #19, mul vl]         // 16-byte Folded Reload
	eor	z0.d, z0.d, z1.d
	str	z0, [x11, #24, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x11, #1, mul vl]           // 16-byte Folded Reload
	eor	z16.d, z16.d, z0.d
	str	z16, [x11, #19, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #20, mul vl]         // 16-byte Folded Reload
	eor	z16.d, z16.d, z20.d
	str	z16, [x11, #20, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #10, mul vl]         // 16-byte Folded Reload
	eor	z22.d, z16.d, z21.d
	ldr	z21, [x11, #11, mul vl]         // 16-byte Folded Reload
	ldr	z16, [x11, #18, mul vl]         // 16-byte Folded Reload
	eor	z21.d, z21.d, z23.d
	eor	z16.d, z16.d, z24.d
	ldr	z24, [x11, #8, mul vl]          // 16-byte Folded Reload
	ldr	z23, [x11, #9, mul vl]          // 16-byte Folded Reload
	str	z16, [x11, #18, mul vl]         // 16-byte Folded Spill
	ldr	z16, [x11, #7, mul vl]          // 16-byte Folded Reload
	eor	z24.d, z24.d, z26.d
	eor	z23.d, z23.d, z27.d
	ldr	z27, [x11, #5, mul vl]          // 16-byte Folded Reload
	ldr	z26, [x11, #6, mul vl]          // 16-byte Folded Reload
	eor	z25.d, z16.d, z25.d
	eor	z27.d, z27.d, z6.d
	eor	z26.d, z26.d, z9.d
	cbz	w17, .LBB12_37
// %bb.36:                              //   in Loop: Header=BB12_24 Depth=2
	sxtw	x11, w10
	ld1b	{ z4.b }, p0/z, [x2, x11]
	add	x7, x2, x11
	add	x11, sp, #32
	ld1b	{ z5.b }, p0/z, [x7, x22]
	ldr	z6, [x11, #17, mul vl]          // 16-byte Folded Reload
	ldr	z7, [x11, #16, mul vl]          // 16-byte Folded Reload
	ldr	z8, [x11, #15, mul vl]          // 16-byte Folded Reload
	tbl	z0.b, { z4.b }, z12.b
	tbl	z1.b, { z4.b }, z13.b
	tbl	z2.b, { z4.b }, z19.b
	tbl	z3.b, { z4.b }, z14.b
	ldr	z4, [x11, #12, mul vl]          // 16-byte Folded Reload
	tbl	z6.b, { z5.b }, z6.b
	tbl	z7.b, { z5.b }, z7.b
	tbl	z4.b, { z5.b }, z4.b
	tbl	z5.b, { z5.b }, z8.b
	eor	z11.d, z1.d, z6.d
	eor	z8.d, z2.d, z7.d
	eor	z10.d, z0.d, z4.d
	eor	z7.d, z3.d, z5.d
.LBB12_37:                              //   in Loop: Header=BB12_24 Depth=2
	ldr	z4, [x11, #20, mul vl]          // 16-byte Folded Reload
	ldr	z5, [x11, #19, mul vl]          // 16-byte Folded Reload
	ldr	z6, [x11, #18, mul vl]          // 16-byte Folded Reload
	b	.LBB12_23
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
	sub	sp, sp, #48
	addvl	sp, sp, #-32
	addvl	sp, sp, #-6
	cmp	w0, #16
	str	x3, [sp, #40]                   // 8-byte Spill
	b.ge	.LBB13_2
.LBB13_1:
	addvl	sp, sp, #31
	addvl	sp, sp, #7
	add	sp, sp, #48
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
	lsl	w11, w1, #5
	lsl	w10, w1, #6
	rdvl	x8, #1
	mov	w13, w1
	lsr	x3, x8, #4
	cmp	w1, #1
	stp	w10, w11, [sp, #32]             // 8-byte Folded Spill
	lsl	w11, w1, #7
	lsl	x9, x13, #5
	add	w10, w1, w1, lsl #1
	str	w11, [sp, #28]                  // 4-byte Spill
	add	w11, w1, w1, lsl #2
	b.lt	.LBB13_17
// %bb.3:
	mov	x15, xzr
	sub	x14, x9, #32
.LBB13_4:                               // =>This Inner Loop Header: Depth=1
	add	x12, x2, w15, sxtw
	ldrb	w12, [x12, #1]
	cmp	w12, #1
	cset	w12, ne
	ccmp	x14, x15, #4, eq
	add	x15, x15, #32
	b.ne	.LBB13_4
// %bb.5:
	sub	x5, x13, #1
	ldr	w14, [sp, #36]                  // 4-byte Reload
	mov	x15, x5
.LBB13_6:                               // =>This Inner Loop Header: Depth=1
	add	x13, x2, w14, sxtw
	add	w14, w14, #32
	ldrb	w13, [x13, #1]
	cmp	w13, #1
	cset	w13, ne
	ccmp	x15, #0, #4, eq
	sub	x15, x15, #1
	b.ne	.LBB13_6
// %bb.7:
	ldr	w15, [sp, #32]                  // 4-byte Reload
	mov	x16, x5
.LBB13_8:                               // =>This Inner Loop Header: Depth=1
	add	x14, x2, w15, sxtw
	add	w15, w15, #32
	ldrb	w14, [x14, #1]
	cmp	w14, #1
	cset	w14, ne
	ccmp	x16, #0, #4, eq
	sub	x16, x16, #1
	b.ne	.LBB13_8
// %bb.9:
	lsl	w16, w10, #5
	mov	x17, x5
.LBB13_10:                              // =>This Inner Loop Header: Depth=1
	add	x15, x2, w16, sxtw
	add	w16, w16, #32
	ldrb	w15, [x15, #1]
	cmp	w15, #1
	cset	w15, ne
	ccmp	x17, #0, #4, eq
	sub	x17, x17, #1
	b.ne	.LBB13_10
// %bb.11:
	ldr	w17, [sp, #28]                  // 4-byte Reload
	mov	x18, x5
.LBB13_12:                              // =>This Inner Loop Header: Depth=1
	add	x16, x2, w17, sxtw
	add	w17, w17, #32
	ldrb	w16, [x16, #1]
	cmp	w16, #1
	cset	w16, ne
	ccmp	x18, #0, #4, eq
	sub	x18, x18, #1
	b.ne	.LBB13_12
// %bb.13:
	lsl	w18, w11, #5
	mov	x6, x5
.LBB13_14:                              // =>This Inner Loop Header: Depth=1
	add	x17, x2, w18, sxtw
	add	w18, w18, #32
	ldrb	w17, [x17, #1]
	cmp	w17, #1
	cset	w17, ne
	ccmp	x6, #0, #4, eq
	sub	x6, x6, #1
	b.ne	.LBB13_14
// %bb.15:
	lsl	w6, w10, #6
.LBB13_16:                              // =>This Inner Loop Header: Depth=1
	add	x18, x2, w6, sxtw
	add	w6, w6, #32
	ldrb	w18, [x18, #1]
	cmp	w18, #1
	cset	w18, ne
	ccmp	x5, #0, #4, eq
	sub	x5, x5, #1
	b.ne	.LBB13_16
	b	.LBB13_18
.LBB13_17:
	mov	w12, wzr
	mov	w13, wzr
	mov	w14, wzr
	mov	w15, wzr
	mov	w16, wzr
	mov	w17, wzr
	mov	w18, wzr
.LBB13_18:
	add	w7, w3, w3, lsl #1
	orr	w19, w12, w13
	orr	w20, w14, w15
	lsl	w6, w3, #5
	orr	w3, w19, w20
	orr	w19, w16, w17
	lsl	w7, w7, #4
	orr	w3, w3, w19
	lsl	w19, w10, #6
	lsl	w11, w11, #5
	lsl	w10, w10, #5
	ptrue	p0.b
	mov	x5, xzr
	mov	w22, w8
	orr	w23, w3, w18
	mov	w24, #16                        // =0x10
	stp	w11, w19, [sp, #20]             // 8-byte Folded Spill
	str	w10, [sp, #16]                  // 4-byte Spill
	b	.LBB13_21
.LBB13_19:                              //   in Loop: Header=BB13_21 Depth=1
	movi	v0.2d, #0000000000000000
	add	x8, sp, #48
	movi	v8.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	str	z0, [x8, #25, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	str	z0, [x8, #28, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #32, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #24, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #27, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #31, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #23, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #37, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #30, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #34, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #22, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #26, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #29, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #33, mul vl]           // 16-byte Folded Spill
.LBB13_20:                              //   in Loop: Header=BB13_21 Depth=1
	ldr	x8, [x4, #48]
	add	x10, sp, #48
	ldr	z0, [x10, #22, mul vl]          // 16-byte Folded Reload
	st1b	{ z29.b }, p1, [x8, x5]
	ldr	x8, [x4, #48]
	st1b	{ z7.b }, p4, [x8, x27]
	ldr	x8, [x4, #48]
	st1b	{ z30.b }, p3, [x8, x26]
	ldr	x8, [x4, #48]
	st1b	{ z8.b }, p2, [x8, x25]
	ldr	x8, [x4, #40]
	st1b	{ z0.b }, p1, [x8, x5]
	ldr	z0, [x10, #23, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #40]
	st1b	{ z0.b }, p4, [x8, x27]
	ldr	z0, [x10, #24, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #40]
	st1b	{ z0.b }, p3, [x8, x26]
	ldr	z0, [x10, #25, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #40]
	st1b	{ z0.b }, p2, [x8, x25]
	ldr	z0, [x10, #26, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #32]
	st1b	{ z0.b }, p1, [x8, x5]
	ldr	z0, [x10, #37, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #32]
	st1b	{ z4.b }, p4, [x8, x27]
	ldr	x8, [x4, #32]
	st1b	{ z6.b }, p3, [x8, x26]
	ldr	x8, [x4, #32]
	st1b	{ z5.b }, p2, [x8, x25]
	ldr	x8, [x4, #24]
	st1b	{ z25.b }, p1, [x8, x5]
	ldr	x8, [x4, #24]
	st1b	{ z0.b }, p4, [x8, x27]
	ldr	z0, [x10, #27, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #24]
	st1b	{ z0.b }, p3, [x8, x26]
	ldr	z0, [x10, #28, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #24]
	st1b	{ z0.b }, p2, [x8, x25]
	ldr	z0, [x10, #29, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #16]
	st1b	{ z0.b }, p1, [x8, x5]
	ldr	z0, [x10, #30, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #16]
	st1b	{ z0.b }, p4, [x8, x27]
	ldr	z0, [x10, #31, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #16]
	st1b	{ z0.b }, p3, [x8, x26]
	ldr	z0, [x10, #32, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #16]
	st1b	{ z0.b }, p2, [x8, x25]
	ldr	z0, [x10, #33, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z0.b }, p1, [x8, x5]
	ldr	z0, [x10, #34, mul vl]          // 16-byte Folded Reload
	ldr	x8, [x4, #8]
	st1b	{ z27.b }, p4, [x8, x27]
	ldr	x8, [x4, #8]
	st1b	{ z2.b }, p3, [x8, x26]
	ldr	x8, [x4, #8]
	st1b	{ z1.b }, p2, [x8, x25]
	ldr	x8, [x4]
	st1b	{ z26.b }, p1, [x8, x5]
	incb	x5, all, mul #4
	ldr	x8, [x4]
	st1b	{ z0.b }, p4, [x8, x27]
	cmp	w0, w5
	ldr	x8, [x4]
	st1b	{ z3.b }, p3, [x8, x26]
	ldr	x8, [x4]
	st1b	{ z24.b }, p2, [x8, x25]
	b.le	.LBB13_1
.LBB13_21:                              // =>This Loop Header: Depth=1
                                        //     Child Loop BB13_26 Depth 2
	whilelt	p1.b, w5, w0
	b.eq	.LBB13_1
// %bb.22:                              //   in Loop: Header=BB13_21 Depth=1
	add	x27, x5, x22
	add	x26, x5, x6
	add	x25, x5, x7
	whilelt	p4.b, w27, w0
	whilelt	p3.b, w26, w0
	whilelt	p2.b, w25, w0
	cmp	w1, #1
	b.lt	.LBB13_19
// %bb.23:                              //   in Loop: Header=BB13_21 Depth=1
	movi	v0.2d, #0000000000000000
	add	x8, sp, #48
	movi	v26.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	ldr	x29, [sp, #40]                  // 8-byte Reload
	movi	v27.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	x28, xzr
	movi	v7.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	str	z0, [x8, #33, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	ldp	w10, w19, [sp, #16]             // 8-byte Folded Reload
	movi	v5.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	str	z0, [x8, #29, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	ldp	w3, w11, [sp, #24]              // 8-byte Folded Reload
	str	z0, [x8, #26, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #22, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #34, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #30, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #37, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #23, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #31, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #27, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #24, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #32, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #28, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x8, #25, mul vl]           // 16-byte Folded Spill
	ldp	w8, w30, [sp, #32]              // 8-byte Folded Reload
	b	.LBB13_26
.LBB13_24:                              //   in Loop: Header=BB13_26 Depth=2
	add	x20, sp, #48
	eor	z26.d, z26.d, z13.d
	eor	z3.d, z3.d, z12.d
	ldr	z0, [x20, #34, mul vl]          // 16-byte Folded Reload
	eor	z24.d, z24.d, z14.d
	eor	z27.d, z27.d, z15.d
	eor	z2.d, z2.d, z12.d
	eor	z1.d, z1.d, z14.d
	eor	z25.d, z25.d, z13.d
	eor	z4.d, z4.d, z15.d
	eor	z6.d, z6.d, z12.d
	eor	z5.d, z5.d, z14.d
	eor	z0.d, z0.d, z15.d
	str	z0, [x20, #34, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #33, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z13.d
	str	z0, [x20, #33, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #29, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z13.d
	str	z0, [x20, #29, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #30, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z15.d
	str	z0, [x20, #30, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #31, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z12.d
	str	z0, [x20, #31, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #32, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z14.d
	str	z0, [x20, #32, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #37, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z15.d
	str	z0, [x20, #37, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #27, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z12.d
	str	z0, [x20, #27, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #28, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z14.d
	str	z0, [x20, #28, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #26, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z13.d
	str	z0, [x20, #26, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #22, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z13.d
	str	z0, [x20, #22, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #23, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z15.d
	str	z0, [x20, #23, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #24, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z12.d
	str	z0, [x20, #24, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #25, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z14.d
	str	z0, [x20, #25, mul vl]          // 16-byte Folded Spill
.LBB13_25:                              //   in Loop: Header=BB13_26 Depth=2
	eor	z29.d, z29.d, z13.d
	eor	z7.d, z7.d, z15.d
	add	x28, x28, #32
	eor	z30.d, z30.d, z12.d
	eor	z8.d, z8.d, z14.d
	add	w3, w3, #32
	add	w19, w19, #32
	add	w11, w11, #32
	cmp	x9, x28
	add	w10, w10, #32
	add	w8, w8, #32
	add	w30, w30, #32
	b.eq	.LBB13_20
.LBB13_26:                              //   Parent Loop BB13_21 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x20, [x29], #8
	ld1b	{ z13.b }, p1/z, [x20, x5]
	ld1b	{ z15.b }, p4/z, [x20, x27]
	ld1b	{ z12.b }, p3/z, [x20, x26]
	ld1b	{ z14.b }, p2/z, [x20, x25]
	tbz	w23, #0, .LBB13_24
// %bb.27:                              //   in Loop: Header=BB13_26 Depth=2
	movprfx	z16, z12
	and	z16.b, z16.b, #0xf
	add	x20, sp, #48
	lsr	z9.b, z13.b, #4
	lsr	z10.b, z15.b, #4
	lsr	z28.b, z12.b, #4
	lsr	z11.b, z14.b, #4
	mov	z18.d, z13.d
	mov	z19.d, z15.d
	movprfx	z0, z13
	and	z0.b, z0.b, #0xf
	str	z16, [x20, #36, mul vl]         // 16-byte Folded Spill
	movprfx	z16, z14
	and	z16.b, z16.b, #0xf
	mov	z20.d, z12.d
	movprfx	z31, z15
	and	z31.b, z31.b, #0xf
	str	z16, [x20, #35, mul vl]         // 16-byte Folded Spill
	mov	z16.d, z14.d
	cbz	w12, .LBB13_29
// %bb.28:                              //   in Loop: Header=BB13_26 Depth=2
	sxtw	x20, w28
	add	x21, x2, x20
	ld1b	{ z16.b }, p0/z, [x2, x20]
	add	x20, sp, #48
	ld1b	{ z17.b }, p0/z, [x21, x24]
	ldr	z20, [x20, #36, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x20, #35, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z16.b }, z0.b
	tbl	z19.b, { z16.b }, z31.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z21.b, { z17.b }, z9.b
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z17.b, { z17.b }, z11.b
	eor	z18.d, z18.d, z21.d
	eor	z19.d, z19.d, z22.d
	eor	z20.d, z20.d, z23.d
	eor	z16.d, z16.d, z17.d
.LBB13_29:                              //   in Loop: Header=BB13_26 Depth=2
	str	z16, [x20, #14, mul vl]         // 16-byte Folded Spill
	mov	z16.d, z14.d
	str	z20, [x20, #15, mul vl]         // 16-byte Folded Spill
	mov	z20.d, z12.d
	str	z19, [x20, #16, mul vl]         // 16-byte Folded Spill
	mov	z19.d, z15.d
	str	z18, [x20, #17, mul vl]         // 16-byte Folded Spill
	mov	z18.d, z13.d
	cbz	w13, .LBB13_31
// %bb.30:                              //   in Loop: Header=BB13_26 Depth=2
	sxtw	x20, w30
	add	x21, x2, x20
	ld1b	{ z16.b }, p0/z, [x2, x20]
	add	x20, sp, #48
	ld1b	{ z17.b }, p0/z, [x21, x24]
	ldr	z20, [x20, #36, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x20, #35, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z16.b }, z0.b
	tbl	z19.b, { z16.b }, z31.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z21.b, { z17.b }, z9.b
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z17.b, { z17.b }, z11.b
	eor	z18.d, z18.d, z21.d
	eor	z19.d, z19.d, z22.d
	eor	z20.d, z20.d, z23.d
	eor	z16.d, z16.d, z17.d
.LBB13_31:                              //   in Loop: Header=BB13_26 Depth=2
	str	z16, [x20, #10, mul vl]         // 16-byte Folded Spill
	mov	z16.d, z14.d
	str	z20, [x20, #11, mul vl]         // 16-byte Folded Spill
	mov	z20.d, z12.d
	str	z19, [x20, #12, mul vl]         // 16-byte Folded Spill
	mov	z19.d, z15.d
	str	z18, [x20, #13, mul vl]         // 16-byte Folded Spill
	mov	z18.d, z13.d
	cbz	w14, .LBB13_33
// %bb.32:                              //   in Loop: Header=BB13_26 Depth=2
	sxtw	x20, w8
	add	x21, x2, x20
	ld1b	{ z16.b }, p0/z, [x2, x20]
	add	x20, sp, #48
	ld1b	{ z17.b }, p0/z, [x21, x24]
	ldr	z20, [x20, #36, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x20, #35, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z16.b }, z0.b
	tbl	z19.b, { z16.b }, z31.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z21.b, { z17.b }, z9.b
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z17.b, { z17.b }, z11.b
	eor	z18.d, z18.d, z21.d
	eor	z19.d, z19.d, z22.d
	eor	z20.d, z20.d, z23.d
	eor	z16.d, z16.d, z17.d
.LBB13_33:                              //   in Loop: Header=BB13_26 Depth=2
	str	z16, [x20, #6, mul vl]          // 16-byte Folded Spill
	mov	z16.d, z14.d
	str	z20, [x20, #7, mul vl]          // 16-byte Folded Spill
	mov	z20.d, z12.d
	str	z19, [x20, #8, mul vl]          // 16-byte Folded Spill
	mov	z19.d, z15.d
	str	z18, [x20, #9, mul vl]          // 16-byte Folded Spill
	mov	z18.d, z13.d
	cbz	w15, .LBB13_35
// %bb.34:                              //   in Loop: Header=BB13_26 Depth=2
	sxtw	x20, w10
	add	x21, x2, x20
	ld1b	{ z16.b }, p0/z, [x2, x20]
	add	x20, sp, #48
	ld1b	{ z17.b }, p0/z, [x21, x24]
	ldr	z20, [x20, #36, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x20, #35, mul vl]         // 16-byte Folded Reload
	tbl	z18.b, { z16.b }, z0.b
	tbl	z19.b, { z16.b }, z31.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z21.b, { z17.b }, z9.b
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z17.b, { z17.b }, z11.b
	eor	z18.d, z18.d, z21.d
	eor	z19.d, z19.d, z22.d
	eor	z20.d, z20.d, z23.d
	eor	z16.d, z16.d, z17.d
.LBB13_35:                              //   in Loop: Header=BB13_26 Depth=2
	str	z19, [x20, #4, mul vl]          // 16-byte Folded Spill
	mov	z17.d, z15.d
	mov	z19.d, z14.d
	str	z18, [x20, #5, mul vl]          // 16-byte Folded Spill
	mov	z18.d, z12.d
	str	z31, [x20, #21, mul vl]         // 16-byte Folded Spill
	mov	z31.d, z13.d
	str	z16, [x20, #2, mul vl]          // 16-byte Folded Spill
	str	z20, [x20, #3, mul vl]          // 16-byte Folded Spill
	str	z0, [x20, #18, mul vl]          // 16-byte Folded Spill
	cbz	w16, .LBB13_37
// %bb.36:                              //   in Loop: Header=BB13_26 Depth=2
	sxtw	x20, w11
	ld1b	{ z16.b }, p0/z, [x2, x20]
	add	x21, x2, x20
	add	x20, sp, #48
	ld1b	{ z17.b }, p0/z, [x21, x24]
	tbl	z18.b, { z16.b }, z0.b
	ldr	z0, [x20, #21, mul vl]          // 16-byte Folded Reload
	tbl	z22.b, { z17.b }, z10.b
	tbl	z23.b, { z17.b }, z28.b
	tbl	z19.b, { z16.b }, z0.b
	ldr	z0, [x20, #36, mul vl]          // 16-byte Folded Reload
	tbl	z20.b, { z16.b }, z0.b
	ldr	z0, [x20, #35, mul vl]          // 16-byte Folded Reload
	tbl	z21.b, { z16.b }, z0.b
	tbl	z16.b, { z17.b }, z9.b
	tbl	z0.b, { z17.b }, z11.b
	eor	z17.d, z19.d, z22.d
	eor	z31.d, z18.d, z16.d
	eor	z18.d, z20.d, z23.d
	eor	z19.d, z21.d, z0.d
.LBB13_37:                              //   in Loop: Header=BB13_26 Depth=2
	mov	z20.d, z13.d
	mov	z21.d, z15.d
	str	z11, [x20, #19, mul vl]         // 16-byte Folded Spill
	mov	z22.d, z12.d
	mov	z23.d, z14.d
	str	z28, [x20, #20, mul vl]         // 16-byte Folded Spill
	cbz	w17, .LBB13_39
// %bb.38:                              //   in Loop: Header=BB13_26 Depth=2
	sxtw	x20, w19
	mov	z28.d, z10.d
	add	x21, x2, x20
	ld1b	{ z0.b }, p0/z, [x2, x20]
	add	x20, sp, #48
	ldr	z16, [x20, #18, mul vl]         // 16-byte Folded Reload
	ld1b	{ z20.b }, p0/z, [x21, x24]
	str	z25, [x20, #1, mul vl]          // 16-byte Folded Spill
	ldr	z25, [x20, #37, mul vl]         // 16-byte Folded Reload
	str	z30, [x20]                      // 16-byte Folded Spill
	mov	z30.d, z8.d
	mov	z8.d, z4.d
	mov	z4.d, z6.d
	mov	z6.d, z1.d
	tbl	z21.b, { z0.b }, z16.b
	ldr	z16, [x20, #21, mul vl]         // 16-byte Folded Reload
	tbl	z1.b, { z20.b }, z10.b
	mov	z10.d, z29.d
	mov	z29.d, z7.d
	mov	z7.d, z2.d
	ldr	z2, [x20, #20, mul vl]          // 16-byte Folded Reload
	str	z25, [x20, #37, mul vl]         // 16-byte Folded Spill
	ldr	z25, [x20, #19, mul vl]         // 16-byte Folded Reload
	tbl	z22.b, { z0.b }, z16.b
	ldr	z16, [x20, #36, mul vl]         // 16-byte Folded Reload
	tbl	z2.b, { z20.b }, z2.b
	tbl	z25.b, { z20.b }, z25.b
	tbl	z23.b, { z0.b }, z16.b
	ldr	z16, [x20, #35, mul vl]         // 16-byte Folded Reload
	tbl	z0.b, { z0.b }, z16.b
	mov	z16.d, z5.d
	mov	z5.d, z26.d
	mov	z26.d, z3.d
	mov	z3.d, z24.d
	tbl	z24.b, { z20.b }, z9.b
	eor	z20.d, z21.d, z24.d
	mov	z24.d, z3.d
	mov	z3.d, z26.d
	mov	z26.d, z5.d
	mov	z5.d, z16.d
	eor	z21.d, z22.d, z1.d
	mov	z1.d, z6.d
	mov	z6.d, z4.d
	mov	z4.d, z8.d
	mov	z8.d, z30.d
	ldr	z30, [x20]                      // 16-byte Folded Reload
	eor	z22.d, z23.d, z2.d
	mov	z2.d, z7.d
	mov	z7.d, z29.d
	mov	z29.d, z10.d
	mov	z10.d, z28.d
	eor	z23.d, z0.d, z25.d
	ldr	z25, [x20, #1, mul vl]          // 16-byte Folded Reload
.LBB13_39:                              //   in Loop: Header=BB13_26 Depth=2
	ldr	z0, [x20, #17, mul vl]          // 16-byte Folded Reload
	ldr	z16, [x20, #16, mul vl]         // 16-byte Folded Reload
	eor	z4.d, z4.d, z17.d
	eor	z6.d, z6.d, z18.d
	eor	z5.d, z5.d, z19.d
	eor	z26.d, z26.d, z0.d
	ldr	z0, [x20, #34, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x20, #13, mul vl]         // 16-byte Folded Reload
	str	z0, [x20, #34, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #15, mul vl]          // 16-byte Folded Reload
	eor	z3.d, z3.d, z0.d
	ldr	z0, [x20, #14, mul vl]          // 16-byte Folded Reload
	eor	z24.d, z24.d, z0.d
	ldr	z0, [x20, #33, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x20, #9, mul vl]          // 16-byte Folded Reload
	str	z0, [x20, #33, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #12, mul vl]          // 16-byte Folded Reload
	eor	z27.d, z27.d, z0.d
	ldr	z0, [x20, #11, mul vl]          // 16-byte Folded Reload
	eor	z2.d, z2.d, z0.d
	ldr	z0, [x20, #10, mul vl]          // 16-byte Folded Reload
	eor	z1.d, z1.d, z0.d
	ldr	z0, [x20, #29, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x20, #8, mul vl]          // 16-byte Folded Reload
	str	z0, [x20, #29, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #30, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x20, #7, mul vl]          // 16-byte Folded Reload
	str	z0, [x20, #30, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #31, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x20, #6, mul vl]          // 16-byte Folded Reload
	str	z0, [x20, #31, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #32, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x20, #4, mul vl]          // 16-byte Folded Reload
	str	z0, [x20, #32, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #5, mul vl]           // 16-byte Folded Reload
	eor	z25.d, z25.d, z0.d
	ldr	z0, [x20, #37, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x20, #3, mul vl]          // 16-byte Folded Reload
	str	z0, [x20, #37, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #27, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	ldr	z16, [x20, #2, mul vl]          // 16-byte Folded Reload
	str	z0, [x20, #27, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #28, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z16.d
	str	z0, [x20, #28, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #26, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z31.d
	str	z0, [x20, #26, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #22, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z20.d
	str	z0, [x20, #22, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #23, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z21.d
	str	z0, [x20, #23, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #24, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z22.d
	str	z0, [x20, #24, mul vl]          // 16-byte Folded Spill
	ldr	z0, [x20, #25, mul vl]          // 16-byte Folded Reload
	eor	z0.d, z0.d, z23.d
	str	z0, [x20, #25, mul vl]          // 16-byte Folded Spill
	cbz	w18, .LBB13_25
// %bb.40:                              //   in Loop: Header=BB13_26 Depth=2
	sxtw	x20, w3
	mov	z18.d, z2.d
	mov	z22.d, z4.d
	mov	z20.d, z5.d
	mov	z17.d, z1.d
	mov	z19.d, z27.d
	add	x21, x2, x20
	ld1b	{ z0.b }, p0/z, [x2, x20]
	add	x20, sp, #48
	ldr	z2, [x20, #18, mul vl]          // 16-byte Folded Reload
	ldr	z4, [x20, #21, mul vl]          // 16-byte Folded Reload
	ldr	z5, [x20, #36, mul vl]          // 16-byte Folded Reload
	ldr	z16, [x20, #35, mul vl]         // 16-byte Folded Reload
	ld1b	{ z1.b }, p0/z, [x21, x24]
	ldr	z27, [x20, #19, mul vl]         // 16-byte Folded Reload
	mov	z21.d, z6.d
	mov	z23.d, z7.d
	tbl	z2.b, { z0.b }, z2.b
	tbl	z4.b, { z0.b }, z4.b
	tbl	z5.b, { z0.b }, z5.b
	tbl	z0.b, { z0.b }, z16.b
	ldr	z16, [x20, #20, mul vl]         // 16-byte Folded Reload
	tbl	z6.b, { z1.b }, z9.b
	tbl	z7.b, { z1.b }, z10.b
	tbl	z16.b, { z1.b }, z16.b
	tbl	z1.b, { z1.b }, z27.b
	mov	z27.d, z19.d
	eor	z13.d, z2.d, z6.d
	mov	z6.d, z21.d
	mov	z2.d, z18.d
	eor	z15.d, z4.d, z7.d
	mov	z7.d, z23.d
	mov	z4.d, z22.d
	eor	z12.d, z5.d, z16.d
	mov	z5.d, z20.d
	eor	z14.d, z0.d, z1.d
	mov	z1.d, z17.d
	b	.LBB13_25
.Lfunc_end13:
	.size	gf_7vect_dot_prod_sve2, .Lfunc_end13-gf_7vect_dot_prod_sve2
                                        // -- End function
	.ident	"clang version 23.1.3 (https://github.com/llvm/llvm-project 0d261d1ca552c95a8f007e061c787ac7132fbcbc)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
