	.file	"gf_nvect_dot_prod_sve.c"
	.text
	.globl	gf_vect_dot_prod_sve            // -- Begin function gf_vect_dot_prod_sve
	.p2align	2
	.type	gf_vect_dot_prod_sve,@function
gf_vect_dot_prod_sve:                   // @gf_vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB0_10
// %bb.1:
	cmp	w1, #0
	rdvl	x10, #1
	rdvl	x8, #2
	rdvl	x12, #3
	mov	x9, xzr
	b.le	.LBB0_7
// %bb.2:
	ubfiz	x11, x1, #5, #32
	ptrue	p0.b
	mov	w10, w10
	mov	w12, w12
	mov	w13, #16                        // =0x10
	rdvl	x14, #4
.LBB0_3:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB0_5 Depth 2
	whilelt	p1.b, w9, w0
	b.eq	.LBB0_10
// %bb.4:                               //   in Loop: Header=BB0_3 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	add	x15, x9, x10
	movi	v3.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	add	x16, x9, x8
	add	x18, x9, x12
	whilelt	p3.b, w15, w0
	mov	x17, xzr
	whilelt	p4.b, w16, w0
	mov	x1, x3
	whilelt	p2.b, w18, w0
.LBB0_5:                                //   Parent Loop BB0_3 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x5, [x1], #8
	sxtw	x6, w17
	add	x17, x17, #32
	ld1b	{ z4.b }, p1/z, [x5, x9]
	ld1b	{ z5.b }, p3/z, [x5, x15]
	ld1b	{ z6.b }, p4/z, [x5, x16]
	ld1b	{ z7.b }, p2/z, [x5, x18]
	add	x5, x2, x6
	ld1b	{ z16.b }, p0/z, [x2, x6]
	ld1b	{ z17.b }, p0/z, [x5, x13]
	cmp	x11, x17
	movprfx	z18, z4
	and	z18.b, z18.b, #0xf
	lsr	z4.b, z4.b, #4
	movprfx	z19, z5
	and	z19.b, z19.b, #0xf
	lsr	z5.b, z5.b, #4
	movprfx	z20, z6
	and	z20.b, z20.b, #0xf
	lsr	z6.b, z6.b, #4
	movprfx	z21, z7
	and	z21.b, z21.b, #0xf
	lsr	z7.b, z7.b, #4
	tbl	z18.b, { z16.b }, z18.b
	tbl	z4.b, { z17.b }, z4.b
	tbl	z19.b, { z16.b }, z19.b
	tbl	z5.b, { z17.b }, z5.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z6.b, { z17.b }, z6.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z7.b, { z17.b }, z7.b
	eor	z4.d, z18.d, z4.d
	eor	z5.d, z19.d, z5.d
	eor	z6.d, z20.d, z6.d
	eor	z7.d, z16.d, z7.d
	eor	z2.d, z2.d, z4.d
	eor	z1.d, z1.d, z5.d
	eor	z3.d, z3.d, z6.d
	eor	z0.d, z0.d, z7.d
	b.ne	.LBB0_5
// %bb.6:                               //   in Loop: Header=BB0_3 Depth=1
	st1b	{ z2.b }, p1, [x4, x9]
	add	x9, x9, x14
	cmp	w0, w9
	st1b	{ z1.b }, p3, [x4, x15]
	st1b	{ z3.b }, p4, [x4, x16]
	st1b	{ z0.b }, p2, [x4, x18]
	b.gt	.LBB0_3
	b	.LBB0_10
.LBB0_7:
	movi	v0.2d, #0000000000000000
	mov	w10, w10
	mov	w11, w12
	add	x12, x4, x10
	add	x13, x4, x8
	add	x14, x4, x11
	rdvl	x15, #4
.LBB0_8:                                // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w9, w0
	b.eq	.LBB0_10
// %bb.9:                               //   in Loop: Header=BB0_8 Depth=1
	add	w16, w10, w9
	add	w17, w8, w9
	st1b	{ z0.b }, p0, [x4, x9]
	whilelt	p1.b, w16, w0
	add	w16, w11, w9
	whilelt	p0.b, w17, w0
	whilelt	p2.b, w16, w0
	st1b	{ z0.b }, p1, [x12, x9]
	st1b	{ z0.b }, p0, [x13, x9]
	st1b	{ z0.b }, p2, [x14, x9]
	add	x9, x9, x15
	cmp	w0, w9
	b.gt	.LBB0_8
.LBB0_10:
	ret
.Lfunc_end0:
	.size	gf_vect_dot_prod_sve, .Lfunc_end0-gf_vect_dot_prod_sve
                                        // -- End function
	.globl	gf_2vect_dot_prod_sve           // -- Begin function gf_2vect_dot_prod_sve
	.p2align	2
	.type	gf_2vect_dot_prod_sve,@function
gf_2vect_dot_prod_sve:                  // @gf_2vect_dot_prod_sve
// %bb.0:
	cmp	w0, #16
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB1_11
// %bb.1:
	stp	d9, d8, [sp, #-32]!             // 16-byte Folded Spill
	cmp	w1, #0
	rdvl	x11, #1
	rdvl	x10, #2
	rdvl	x13, #3
	mov	x8, xzr
	str	x19, [sp, #16]                  // 8-byte Spill
	b.le	.LBB1_7
// %bb.2:
	mov	w9, w11
	lsl	w11, w1, #5
	ubfiz	x12, x1, #5, #32
	ptrue	p0.b
	mov	w10, w10
	mov	w13, w13
	mov	w14, #16                        // =0x10
	rdvl	x15, #4
.LBB1_3:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB1_5 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB1_10
// %bb.4:                               //   in Loop: Header=BB1_3 Depth=1
	movi	v1.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	add	x16, x8, x9
	movi	v2.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	add	x17, x8, x10
	movi	v3.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	add	x1, x8, x13
	movi	v0.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x18, xzr
	whilelt	p2.b, w16, w0
	mov	x5, x3
	mov	w6, w11
	whilelt	p4.b, w17, w0
	whilelt	p3.b, w1, w0
.LBB1_5:                                //   Parent Loop BB1_3 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x7, [x5], #8
	sxtw	x19, w18
	add	x18, x18, #32
	ld1b	{ z16.b }, p1/z, [x7, x8]
	ld1b	{ z17.b }, p3/z, [x7, x1]
	ld1b	{ z18.b }, p2/z, [x7, x16]
	ld1b	{ z19.b }, p4/z, [x7, x17]
	ld1b	{ z21.b }, p0/z, [x2, x19]
	add	x7, x2, x19
	sxtw	x19, w6
	ld1b	{ z25.b }, p0/z, [x7, x14]
	cmp	x12, x18
	movprfx	z20, z16
	and	z20.b, z20.b, #0xf
	lsr	z16.b, z16.b, #4
	movprfx	z22, z17
	and	z22.b, z22.b, #0xf
	add	x7, x2, x19
	movprfx	z23, z18
	and	z23.b, z23.b, #0xf
	movprfx	z24, z19
	and	z24.b, z24.b, #0xf
	lsr	z19.b, z19.b, #4
	lsr	z18.b, z18.b, #4
	lsr	z17.b, z17.b, #4
	ld1b	{ z28.b }, p0/z, [x2, x19]
	ld1b	{ z31.b }, p0/z, [x7, x14]
	tbl	z26.b, { z21.b }, z22.b
	tbl	z27.b, { z21.b }, z24.b
	tbl	z30.b, { z21.b }, z23.b
	tbl	z21.b, { z21.b }, z20.b
	tbl	z29.b, { z25.b }, z19.b
	tbl	z8.b, { z25.b }, z18.b
	tbl	z9.b, { z25.b }, z16.b
	tbl	z22.b, { z28.b }, z22.b
	tbl	z24.b, { z28.b }, z24.b
	tbl	z23.b, { z28.b }, z23.b
	tbl	z20.b, { z28.b }, z20.b
	tbl	z25.b, { z25.b }, z17.b
	tbl	z16.b, { z31.b }, z16.b
	tbl	z17.b, { z31.b }, z17.b
	tbl	z19.b, { z31.b }, z19.b
	tbl	z18.b, { z31.b }, z18.b
	eor	z27.d, z27.d, z29.d
	eor	z28.d, z30.d, z8.d
	eor	z21.d, z21.d, z9.d
	add	w6, w6, #32
	eor	z25.d, z26.d, z25.d
	eor	z16.d, z20.d, z16.d
	eor	z17.d, z22.d, z17.d
	eor	z19.d, z24.d, z19.d
	eor	z18.d, z23.d, z18.d
	eor	z1.d, z1.d, z21.d
	eor	z2.d, z2.d, z28.d
	eor	z3.d, z3.d, z27.d
	eor	z0.d, z0.d, z25.d
	eor	z4.d, z4.d, z16.d
	eor	z5.d, z5.d, z18.d
	eor	z6.d, z6.d, z19.d
	eor	z7.d, z7.d, z17.d
	b.ne	.LBB1_5
// %bb.6:                               //   in Loop: Header=BB1_3 Depth=1
	ldr	x18, [x4, #8]
	st1b	{ z4.b }, p1, [x18, x8]
	ldr	x18, [x4, #8]
	st1b	{ z5.b }, p2, [x18, x16]
	ldr	x18, [x4, #8]
	st1b	{ z6.b }, p4, [x18, x17]
	ldr	x18, [x4, #8]
	st1b	{ z7.b }, p3, [x18, x1]
	ldr	x18, [x4]
	st1b	{ z1.b }, p1, [x18, x8]
	add	x8, x8, x15
	ldr	x18, [x4]
	cmp	w0, w8
	st1b	{ z2.b }, p2, [x18, x16]
	ldr	x16, [x4]
	st1b	{ z3.b }, p4, [x16, x17]
	ldr	x16, [x4]
	st1b	{ z0.b }, p3, [x16, x1]
	b.gt	.LBB1_3
	b	.LBB1_10
.LBB1_7:
	movi	v0.2d, #0000000000000000
	mov	w9, w13
	mov	w10, w10
	mov	w11, w11
	rdvl	x12, #4
.LBB1_8:                                // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB1_10
// %bb.9:                               //   in Loop: Header=BB1_8 Depth=1
	ldr	x13, [x4, #8]
	add	x14, x11, x8
	add	x15, x10, x8
	whilelt	p1.b, w14, w0
	add	x16, x9, x8
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
	b.gt	.LBB1_8
.LBB1_10:
	ldr	x19, [sp, #16]                  // 8-byte Reload
	ldp	d9, d8, [sp], #32               // 16-byte Folded Reload
.LBB1_11:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB2_11
// %bb.1:
	stp	d15, d14, [sp, #-96]!           // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x21, [sp, #64]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #80]             // 16-byte Folded Spill
	addvl	sp, sp, #-1
	cmp	w1, #0
	rdvl	x11, #1
	rdvl	x10, #2
	rdvl	x14, #3
	mov	x8, xzr
	b.le	.LBB2_7
// %bb.2:
	mov	w9, w11
	lsl	w11, w1, #6
	lsl	w12, w1, #5
	ubfiz	x13, x1, #5, #32
	ptrue	p0.b
	mov	w10, w10
	mov	w14, w14
	mov	w15, #16                        // =0x10
	rdvl	x16, #4
.LBB2_3:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB2_5 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB2_10
// %bb.4:                               //   in Loop: Header=BB2_3 Depth=1
	movi	v1.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	add	x17, x8, x9
	movi	v16.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	add	x18, x8, x10
	movi	v5.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	add	x5, x8, x14
	movi	v3.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x1, xzr
	movi	v18.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	mov	x6, x3
	movi	v7.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	w7, w12
	whilelt	p2.b, w17, w0
	mov	w19, w11
	whilelt	p4.b, w18, w0
	whilelt	p3.b, w5, w0
.LBB2_5:                                //   Parent Loop BB2_3 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x20, [x6], #8
	sxtw	x21, w1
	str	z31, [sp]                       // 16-byte Folded Spill
	add	x1, x1, #32
	ld1b	{ z21.b }, p4/z, [x20, x18]
	ld1b	{ z20.b }, p3/z, [x20, x5]
	ld1b	{ z22.b }, p1/z, [x20, x8]
	ld1b	{ z28.b }, p2/z, [x20, x17]
	add	x20, x2, x21
	ld1b	{ z29.b }, p0/z, [x2, x21]
	ld1b	{ z30.b }, p0/z, [x20, x15]
	sxtw	x20, w7
	sxtw	x21, w19
	movprfx	z23, z21
	and	z23.b, z23.b, #0xf
	movprfx	z26, z20
	and	z26.b, z26.b, #0xf
	lsr	z20.b, z20.b, #4
	movprfx	z24, z22
	and	z24.b, z24.b, #0xf
	movprfx	z27, z28
	and	z27.b, z27.b, #0xf
	lsr	z21.b, z21.b, #4
	lsr	z25.b, z22.b, #4
	lsr	z22.b, z28.b, #4
	ld1b	{ z11.b }, p0/z, [x2, x20]
	tbl	z28.b, { z29.b }, z26.b
	tbl	z31.b, { z30.b }, z20.b
	tbl	z8.b, { z29.b }, z23.b
	tbl	z9.b, { z30.b }, z21.b
	tbl	z10.b, { z29.b }, z27.b
	add	x20, x2, x20
	tbl	z12.b, { z30.b }, z22.b
	tbl	z29.b, { z29.b }, z24.b
	tbl	z30.b, { z30.b }, z25.b
	ld1b	{ z15.b }, p0/z, [x20, x15]
	add	x20, x2, x21
	tbl	z13.b, { z11.b }, z26.b
	eor	z28.d, z28.d, z31.d
	tbl	z14.b, { z11.b }, z23.b
	cmp	x13, x1
	eor	z31.d, z8.d, z9.d
	ld1b	{ z8.b }, p0/z, [x2, x21]
	add	w19, w19, #32
	eor	z9.d, z10.d, z12.d
	ld1b	{ z12.b }, p0/z, [x20, x15]
	eor	z29.d, z29.d, z30.d
	tbl	z30.b, { z11.b }, z27.b
	tbl	z10.b, { z15.b }, z22.b
	tbl	z11.b, { z11.b }, z24.b
	tbl	z0.b, { z15.b }, z25.b
	tbl	z26.b, { z8.b }, z26.b
	tbl	z23.b, { z8.b }, z23.b
	tbl	z27.b, { z8.b }, z27.b
	tbl	z24.b, { z8.b }, z24.b
	tbl	z8.b, { z15.b }, z20.b
	tbl	z15.b, { z15.b }, z21.b
	tbl	z25.b, { z12.b }, z25.b
	tbl	z20.b, { z12.b }, z20.b
	tbl	z21.b, { z12.b }, z21.b
	tbl	z22.b, { z12.b }, z22.b
	eor	z3.d, z3.d, z31.d
	ldr	z31, [sp]                       // 16-byte Folded Reload
	eor	z1.d, z1.d, z29.d
	eor	z0.d, z11.d, z0.d
	eor	z29.d, z13.d, z8.d
	eor	z2.d, z2.d, z9.d
	add	w7, w7, #32
	eor	z24.d, z24.d, z25.d
	eor	z20.d, z26.d, z20.d
	eor	z31.d, z31.d, z28.d
	eor	z28.d, z30.d, z10.d
	eor	z30.d, z14.d, z15.d
	eor	z21.d, z23.d, z21.d
	eor	z22.d, z27.d, z22.d
	eor	z4.d, z4.d, z0.d
	eor	z7.d, z7.d, z29.d
	eor	z16.d, z16.d, z24.d
	eor	z19.d, z19.d, z20.d
	eor	z5.d, z5.d, z28.d
	eor	z6.d, z6.d, z30.d
	eor	z17.d, z17.d, z22.d
	eor	z18.d, z18.d, z21.d
	b.ne	.LBB2_5
// %bb.6:                               //   in Loop: Header=BB2_3 Depth=1
	ldr	x1, [x4, #16]
	st1b	{ z16.b }, p1, [x1, x8]
	ldr	x1, [x4, #16]
	st1b	{ z17.b }, p2, [x1, x17]
	ldr	x1, [x4, #16]
	st1b	{ z18.b }, p4, [x1, x18]
	ldr	x1, [x4, #16]
	st1b	{ z19.b }, p3, [x1, x5]
	ldr	x1, [x4, #8]
	st1b	{ z4.b }, p1, [x1, x8]
	ldr	x1, [x4, #8]
	st1b	{ z5.b }, p2, [x1, x17]
	ldr	x1, [x4, #8]
	st1b	{ z6.b }, p4, [x1, x18]
	ldr	x1, [x4, #8]
	st1b	{ z7.b }, p3, [x1, x5]
	ldr	x1, [x4]
	st1b	{ z1.b }, p1, [x1, x8]
	add	x8, x8, x16
	ldr	x1, [x4]
	cmp	w0, w8
	st1b	{ z2.b }, p2, [x1, x17]
	ldr	x17, [x4]
	st1b	{ z3.b }, p4, [x17, x18]
	ldr	x17, [x4]
	st1b	{ z31.b }, p3, [x17, x5]
	b.gt	.LBB2_3
	b	.LBB2_10
.LBB2_7:
	movi	v0.2d, #0000000000000000
	mov	w9, w14
	mov	w10, w10
	mov	w11, w11
	rdvl	x12, #4
.LBB2_8:                                // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB2_10
// %bb.9:                               //   in Loop: Header=BB2_8 Depth=1
	ldr	x13, [x4, #16]
	add	x14, x11, x8
	add	x15, x10, x8
	whilelt	p2.b, w14, w0
	add	x16, x9, x8
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
	b.gt	.LBB2_8
.LBB2_10:
	addvl	sp, sp, #1
	ldp	x20, x19, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x21, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #96             // 16-byte Folded Reload
.LBB2_11:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB3_11
// %bb.1:
	stp	d15, d14, [sp, #-112]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x23, [sp, #64]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #80]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             // 16-byte Folded Spill
	addvl	sp, sp, #-6
	cmp	w1, #0
	rdvl	x11, #1
	rdvl	x10, #2
	rdvl	x15, #3
	mov	x8, xzr
	b.le	.LBB3_7
// %bb.2:
	add	w12, w1, w1, lsl #1
	mov	w9, w11
	lsl	w11, w1, #6
	lsl	w13, w1, #5
	ubfiz	x14, x1, #5, #32
	ptrue	p0.b
	lsl	w12, w12, #5
	mov	w10, w10
	mov	w15, w15
	mov	w16, #16                        // =0x10
	rdvl	x17, #4
.LBB3_3:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB3_5 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB3_10
// %bb.4:                               //   in Loop: Header=BB3_3 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v9.2d, #0000000000000000
	add	x18, x8, x9
	movi	v16.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	add	x1, x8, x10
	movi	v10.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	add	x6, x8, x15
	movi	v21.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x5, xzr
	str	z0, [sp, #5, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x7, x3
	movi	v19.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	mov	w19, w13
	whilelt	p2.b, w18, w0
	mov	w20, w11
	mov	w21, w12
	str	z0, [sp, #3, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	whilelt	p4.b, w1, w0
	whilelt	p3.b, w6, w0
	str	z0, [sp, #2, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #4, mul vl]            // 16-byte Folded Spill
.LBB3_5:                                //   Parent Loop BB3_3 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x22, [x7], #8
	sxtw	x23, w5
	str	z9, [sp, #1, mul vl]            // 16-byte Folded Spill
	add	x5, x5, #32
	ld1b	{ z24.b }, p3/z, [x22, x6]
	ld1b	{ z25.b }, p1/z, [x22, x8]
	ld1b	{ z31.b }, p4/z, [x22, x1]
	ld1b	{ z26.b }, p2/z, [x22, x18]
	add	x22, x2, x23
	ld1b	{ z8.b }, p0/z, [x2, x23]
	ld1b	{ z9.b }, p0/z, [x22, x16]
	str	z10, [sp]                       // 16-byte Folded Spill
	sxtw	x22, w19
	movprfx	z28, z24
	and	z28.b, z28.b, #0xf
	lsr	z29.b, z24.b, #4
	movprfx	z24, z25
	and	z24.b, z24.b, #0xf
	lsr	z25.b, z25.b, #4
	movprfx	z30, z31
	and	z30.b, z30.b, #0xf
	movprfx	z27, z26
	and	z27.b, z27.b, #0xf
	lsr	z26.b, z26.b, #4
	lsr	z31.b, z31.b, #4
	add	x23, x2, x22
	tbl	z13.b, { z8.b }, z24.b
	tbl	z10.b, { z8.b }, z28.b
	tbl	z11.b, { z9.b }, z29.b
	tbl	z14.b, { z9.b }, z25.b
	tbl	z12.b, { z8.b }, z30.b
	tbl	z8.b, { z8.b }, z27.b
	tbl	z1.b, { z9.b }, z31.b
	tbl	z9.b, { z9.b }, z26.b
	ld1b	{ z15.b }, p0/z, [x2, x22]
	ld1b	{ z0.b }, p0/z, [x23, x16]
	sxtw	x22, w20
	cmp	x14, x5
	eor	z10.d, z10.d, z11.d
	add	w20, w20, #32
	add	w19, w19, #32
	eor	z13.d, z13.d, z14.d
	ldr	z14, [sp, #5, mul vl]           // 16-byte Folded Reload
	tbl	z2.b, { z15.b }, z28.b
	eor	z8.d, z8.d, z9.d
	eor	z1.d, z12.d, z1.d
	tbl	z3.b, { z0.b }, z29.b
	tbl	z4.b, { z15.b }, z30.b
	tbl	z5.b, { z0.b }, z31.b
	tbl	z9.b, { z15.b }, z27.b
	eor	z14.d, z14.d, z13.d
	ldr	z13, [sp, #3, mul vl]           // 16-byte Folded Reload
	tbl	z11.b, { z0.b }, z26.b
	add	x23, x2, x22
	tbl	z12.b, { z15.b }, z24.b
	tbl	z0.b, { z0.b }, z25.b
	eor	z2.d, z2.d, z3.d
	eor	z13.d, z13.d, z8.d
	ldr	z8, [sp, #2, mul vl]            // 16-byte Folded Reload
	eor	z3.d, z4.d, z5.d
	ld1b	{ z4.b }, p0/z, [x23, x16]
	eor	z5.d, z9.d, z11.d
	str	z14, [sp, #5, mul vl]           // 16-byte Folded Spill
	eor	z0.d, z12.d, z0.d
	eor	z7.d, z7.d, z2.d
	eor	z8.d, z8.d, z1.d
	ldr	z1, [sp, #4, mul vl]            // 16-byte Folded Reload
	str	z13, [sp, #3, mul vl]           // 16-byte Folded Spill
	tbl	z11.b, { z4.b }, z29.b
	tbl	z13.b, { z4.b }, z31.b
	tbl	z15.b, { z4.b }, z26.b
	tbl	z4.b, { z4.b }, z25.b
	eor	z6.d, z6.d, z3.d
	eor	z1.d, z1.d, z10.d
	str	z8, [sp, #2, mul vl]            // 16-byte Folded Spill
	str	z1, [sp, #4, mul vl]            // 16-byte Folded Spill
	ld1b	{ z1.b }, p0/z, [x2, x22]
	sxtw	x22, w21
	add	w21, w21, #32
	add	x23, x2, x22
	ld1b	{ z9.b }, p0/z, [x2, x22]
	ld1b	{ z10.b }, p0/z, [x23, x16]
	tbl	z8.b, { z1.b }, z28.b
	tbl	z12.b, { z1.b }, z30.b
	tbl	z14.b, { z1.b }, z27.b
	tbl	z1.b, { z1.b }, z24.b
	tbl	z28.b, { z9.b }, z28.b
	tbl	z30.b, { z9.b }, z30.b
	tbl	z24.b, { z9.b }, z24.b
	tbl	z29.b, { z10.b }, z29.b
	tbl	z25.b, { z10.b }, z25.b
	tbl	z27.b, { z9.b }, z27.b
	tbl	z31.b, { z10.b }, z31.b
	tbl	z26.b, { z10.b }, z26.b
	ldr	z9, [sp, #1, mul vl]            // 16-byte Folded Reload
	ldr	z10, [sp]                       // 16-byte Folded Reload
	eor	z3.d, z14.d, z15.d
	eor	z1.d, z1.d, z4.d
	eor	z4.d, z12.d, z13.d
	eor	z9.d, z9.d, z0.d
	eor	z0.d, z8.d, z11.d
	eor	z24.d, z24.d, z25.d
	eor	z10.d, z10.d, z5.d
	eor	z5.d, z28.d, z29.d
	eor	z25.d, z30.d, z31.d
	eor	z26.d, z27.d, z26.d
	eor	z16.d, z16.d, z1.d
	eor	z17.d, z17.d, z3.d
	eor	z18.d, z18.d, z4.d
	eor	z19.d, z19.d, z0.d
	eor	z20.d, z20.d, z24.d
	eor	z22.d, z22.d, z25.d
	eor	z23.d, z23.d, z5.d
	eor	z21.d, z21.d, z26.d
	b.ne	.LBB3_5
// %bb.6:                               //   in Loop: Header=BB3_3 Depth=1
	ldr	x5, [x4, #24]
	ldr	z0, [sp, #5, mul vl]            // 16-byte Folded Reload
	st1b	{ z20.b }, p1, [x5, x8]
	ldr	x5, [x4, #24]
	st1b	{ z21.b }, p2, [x5, x18]
	ldr	x5, [x4, #24]
	st1b	{ z22.b }, p4, [x5, x1]
	ldr	x5, [x4, #24]
	st1b	{ z23.b }, p3, [x5, x6]
	ldr	x5, [x4, #16]
	st1b	{ z16.b }, p1, [x5, x8]
	ldr	x5, [x4, #16]
	st1b	{ z17.b }, p2, [x5, x18]
	ldr	x5, [x4, #16]
	st1b	{ z18.b }, p4, [x5, x1]
	ldr	x5, [x4, #16]
	st1b	{ z19.b }, p3, [x5, x6]
	ldr	x5, [x4, #8]
	st1b	{ z9.b }, p1, [x5, x8]
	ldr	x5, [x4, #8]
	st1b	{ z10.b }, p2, [x5, x18]
	ldr	x5, [x4, #8]
	st1b	{ z6.b }, p4, [x5, x1]
	ldr	x5, [x4, #8]
	st1b	{ z7.b }, p3, [x5, x6]
	ldr	x5, [x4]
	st1b	{ z0.b }, p1, [x5, x8]
	ldr	z0, [sp, #3, mul vl]            // 16-byte Folded Reload
	add	x8, x8, x17
	ldr	x5, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p2, [x5, x18]
	ldr	z0, [sp, #2, mul vl]            // 16-byte Folded Reload
	ldr	x18, [x4]
	st1b	{ z0.b }, p4, [x18, x1]
	ldr	z0, [sp, #4, mul vl]            // 16-byte Folded Reload
	ldr	x18, [x4]
	st1b	{ z0.b }, p3, [x18, x6]
	b.gt	.LBB3_3
	b	.LBB3_10
.LBB3_7:
	movi	v0.2d, #0000000000000000
	mov	w9, w15
	mov	w10, w10
	mov	w11, w11
	rdvl	x12, #4
.LBB3_8:                                // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB3_10
// %bb.9:                               //   in Loop: Header=BB3_8 Depth=1
	ldr	x13, [x4, #24]
	add	x14, x11, x8
	add	x15, x10, x8
	whilelt	p2.b, w14, w0
	add	x16, x9, x8
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
	b.gt	.LBB3_8
.LBB3_10:
	addvl	sp, sp, #6
	ldp	x20, x19, [sp, #96]             // 16-byte Folded Reload
	ldp	x22, x21, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x23, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #112            // 16-byte Folded Reload
.LBB3_11:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB4_9
// %bb.1:
	stp	d15, d14, [sp, #-144]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	str	x29, [sp, #64]                  // 8-byte Spill
	stp	x26, x25, [sp, #80]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #96]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #112]            // 16-byte Folded Spill
	stp	x20, x19, [sp, #128]            // 16-byte Folded Spill
	addvl	sp, sp, #-10
	add	w13, w1, w1, lsl #1
	lsl	w11, w1, #6
	lsl	w12, w1, #7
	lsl	w14, w1, #5
	ubfiz	x15, x1, #5, #32
	ptrue	p0.b
	lsl	w13, w13, #5
	mov	x8, xzr
	rdvl	x9, #1
	rdvl	x10, #2
	rdvl	x16, #3
	mov	w17, #16                        // =0x10
	rdvl	x18, #4
	b	.LBB4_4
.LBB4_2:                                //   in Loop: Header=BB4_4 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	str	z0, [sp, #5, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	str	z0, [sp, #9, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #4, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #8, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #3, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #7, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #2, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #6, mul vl]            // 16-byte Folded Spill
.LBB4_3:                                //   in Loop: Header=BB4_4 Depth=1
	ldr	x19, [x4, #32]
	ldr	z0, [sp, #2, mul vl]            // 16-byte Folded Reload
	st1b	{ z27.b }, p1, [x19, x8]
	ldr	x19, [x4, #32]
	st1b	{ z26.b }, p3, [x19, x6]
	ldr	x19, [x4, #32]
	st1b	{ z25.b }, p4, [x19, x7]
	ldr	x19, [x4, #32]
	st1b	{ z24.b }, p2, [x19, x5]
	ldr	x19, [x4, #24]
	st1b	{ z23.b }, p1, [x19, x8]
	ldr	x19, [x4, #24]
	st1b	{ z22.b }, p3, [x19, x6]
	ldr	x19, [x4, #24]
	st1b	{ z21.b }, p4, [x19, x7]
	ldr	x19, [x4, #24]
	st1b	{ z20.b }, p2, [x19, x5]
	ldr	x19, [x4, #16]
	st1b	{ z19.b }, p1, [x19, x8]
	ldr	x19, [x4, #16]
	st1b	{ z18.b }, p3, [x19, x6]
	ldr	x19, [x4, #16]
	st1b	{ z10.b }, p4, [x19, x7]
	ldr	x19, [x4, #16]
	st1b	{ z17.b }, p2, [x19, x5]
	ldr	x19, [x4, #8]
	st1b	{ z0.b }, p1, [x19, x8]
	ldr	z0, [sp, #3, mul vl]            // 16-byte Folded Reload
	ldr	x19, [x4, #8]
	st1b	{ z0.b }, p3, [x19, x6]
	ldr	z0, [sp, #4, mul vl]            // 16-byte Folded Reload
	ldr	x19, [x4, #8]
	st1b	{ z0.b }, p4, [x19, x7]
	ldr	z0, [sp, #5, mul vl]            // 16-byte Folded Reload
	ldr	x19, [x4, #8]
	st1b	{ z0.b }, p2, [x19, x5]
	ldr	z0, [sp, #6, mul vl]            // 16-byte Folded Reload
	ldr	x19, [x4]
	st1b	{ z0.b }, p1, [x19, x8]
	ldr	z0, [sp, #7, mul vl]            // 16-byte Folded Reload
	add	x8, x8, x18
	ldr	x19, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p3, [x19, x6]
	ldr	z0, [sp, #8, mul vl]            // 16-byte Folded Reload
	ldr	x6, [x4]
	st1b	{ z0.b }, p4, [x6, x7]
	ldr	z0, [sp, #9, mul vl]            // 16-byte Folded Reload
	ldr	x6, [x4]
	st1b	{ z0.b }, p2, [x6, x5]
	b.le	.LBB4_8
.LBB4_4:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB4_7 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB4_8
// %bb.5:                               //   in Loop: Header=BB4_4 Depth=1
	add	x6, x8, x9
	add	x7, x8, x10
	add	x5, x8, x16
	whilelt	p3.b, w6, w0
	whilelt	p4.b, w7, w0
	whilelt	p2.b, w5, w0
	cmp	w1, #1
	b.lt	.LBB4_2
// %bb.6:                               //   in Loop: Header=BB4_4 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	x19, xzr
	movi	v23.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	mov	x20, x3
	movi	v18.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	mov	w21, w14
	movi	v26.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	mov	w22, w11
	str	z0, [sp, #6, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	w23, w13
	movi	v20.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	mov	w24, w12
	str	z0, [sp, #2, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #7, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #3, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #8, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #4, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #9, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #5, mul vl]            // 16-byte Folded Spill
.LBB4_7:                                //   Parent Loop BB4_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x25, [x20], #8
	sxtw	x26, w19
	str	z10, [sp]                       // 16-byte Folded Spill
	add	x19, x19, #32
	ld1b	{ z30.b }, p1/z, [x25, x8]
	ld1b	{ z31.b }, p3/z, [x25, x6]
	ld1b	{ z10.b }, p4/z, [x25, x7]
	ld1b	{ z12.b }, p2/z, [x25, x5]
	add	x25, x2, x26
	ld1b	{ z13.b }, p0/z, [x2, x26]
	ld1b	{ z14.b }, p0/z, [x25, x17]
	sxtw	x25, w21
	str	z17, [sp, #1, mul vl]           // 16-byte Folded Spill
	movprfx	z28, z30
	and	z28.b, z28.b, #0xf
	movprfx	z29, z31
	and	z29.b, z29.b, #0xf
	lsr	z30.b, z30.b, #4
	lsr	z9.b, z31.b, #4
	add	x26, x2, x25
	ld1b	{ z0.b }, p0/z, [x2, x25]
	ld1b	{ z3.b }, p0/z, [x26, x17]
	movprfx	z8, z10
	and	z8.b, z8.b, #0xf
	lsr	z31.b, z10.b, #4
	movprfx	z11, z12
	and	z11.b, z11.b, #0xf
	lsr	z10.b, z12.b, #4
	tbl	z12.b, { z13.b }, z29.b
	tbl	z15.b, { z14.b }, z9.b
	tbl	z1.b, { z13.b }, z28.b
	tbl	z2.b, { z14.b }, z30.b
	tbl	z16.b, { z0.b }, z28.b
	tbl	z17.b, { z3.b }, z30.b
	sxtw	x25, w22
	tbl	z4.b, { z13.b }, z11.b
	tbl	z5.b, { z14.b }, z10.b
	tbl	z13.b, { z13.b }, z8.b
	tbl	z14.b, { z14.b }, z31.b
	tbl	z6.b, { z0.b }, z11.b
	tbl	z7.b, { z3.b }, z10.b
	eor	z12.d, z12.d, z15.d
	tbl	z15.b, { z0.b }, z8.b
	eor	z1.d, z1.d, z2.d
	tbl	z2.b, { z3.b }, z31.b
	tbl	z0.b, { z0.b }, z29.b
	tbl	z3.b, { z3.b }, z9.b
	eor	z16.d, z16.d, z17.d
	ldr	z17, [sp, #6, mul vl]           // 16-byte Folded Reload
	eor	z4.d, z4.d, z5.d
	eor	z5.d, z13.d, z14.d
	ldr	z13, [sp, #3, mul vl]           // 16-byte Folded Reload
	add	x26, x2, x25
	cmp	x15, x19
	add	w22, w22, #32
	add	w21, w21, #32
	eor	z17.d, z17.d, z1.d
	ldr	z1, [sp, #7, mul vl]            // 16-byte Folded Reload
	eor	z0.d, z0.d, z3.d
	eor	z2.d, z15.d, z2.d
	ldr	z3, [sp, #2, mul vl]            // 16-byte Folded Reload
	eor	z1.d, z1.d, z12.d
	ldr	z12, [sp, #8, mul vl]           // 16-byte Folded Reload
	eor	z13.d, z13.d, z0.d
	str	z17, [sp, #6, mul vl]           // 16-byte Folded Spill
	ld1b	{ z17.b }, p0/z, [x26, x17]
	eor	z3.d, z3.d, z16.d
	eor	z12.d, z12.d, z5.d
	ldr	z5, [sp, #9, mul vl]            // 16-byte Folded Reload
	str	z13, [sp, #3, mul vl]           // 16-byte Folded Spill
	ldr	z13, [sp, #4, mul vl]           // 16-byte Folded Reload
	str	z1, [sp, #7, mul vl]            // 16-byte Folded Spill
	ld1b	{ z1.b }, p0/z, [x2, x25]
	sxtw	x25, w23
	str	z3, [sp, #2, mul vl]            // 16-byte Folded Spill
	add	w23, w23, #32
	eor	z5.d, z5.d, z4.d
	eor	z4.d, z6.d, z7.d
	str	z12, [sp, #8, mul vl]           // 16-byte Folded Spill
	eor	z13.d, z13.d, z2.d
	ldr	z2, [sp, #5, mul vl]            // 16-byte Folded Reload
	tbl	z3.b, { z1.b }, z11.b
	tbl	z6.b, { z1.b }, z8.b
	tbl	z7.b, { z17.b }, z31.b
	tbl	z16.b, { z1.b }, z29.b
	str	z5, [sp, #9, mul vl]            // 16-byte Folded Spill
	tbl	z5.b, { z17.b }, z10.b
	tbl	z12.b, { z17.b }, z9.b
	eor	z2.d, z2.d, z4.d
	tbl	z1.b, { z1.b }, z28.b
	tbl	z17.b, { z17.b }, z30.b
	add	x26, x2, x25
	ld1b	{ z0.b }, p0/z, [x2, x25]
	sxtw	x25, w24
	str	z13, [sp, #4, mul vl]           // 16-byte Folded Spill
	eor	z4.d, z6.d, z7.d
	add	w24, w24, #32
	str	z2, [sp, #5, mul vl]            // 16-byte Folded Spill
	ld1b	{ z2.b }, p0/z, [x26, x17]
	add	x26, x2, x25
	eor	z3.d, z3.d, z5.d
	eor	z5.d, z16.d, z12.d
	eor	z1.d, z1.d, z17.d
	ld1b	{ z16.b }, p0/z, [x2, x25]
	tbl	z17.b, { z0.b }, z8.b
	ld1b	{ z13.b }, p0/z, [x26, x17]
	tbl	z12.b, { z2.b }, z31.b
	tbl	z6.b, { z0.b }, z11.b
	tbl	z7.b, { z2.b }, z10.b
	tbl	z14.b, { z0.b }, z29.b
	tbl	z15.b, { z2.b }, z9.b
	tbl	z0.b, { z0.b }, z28.b
	tbl	z2.b, { z2.b }, z30.b
	tbl	z11.b, { z16.b }, z11.b
	tbl	z29.b, { z16.b }, z29.b
	tbl	z9.b, { z13.b }, z9.b
	tbl	z28.b, { z16.b }, z28.b
	tbl	z30.b, { z13.b }, z30.b
	tbl	z16.b, { z16.b }, z8.b
	tbl	z8.b, { z13.b }, z10.b
	tbl	z31.b, { z13.b }, z31.b
	ldr	z10, [sp]                       // 16-byte Folded Reload
	eor	z19.d, z19.d, z1.d
	eor	z1.d, z17.d, z12.d
	ldr	z17, [sp, #1, mul vl]           // 16-byte Folded Reload
	eor	z18.d, z18.d, z5.d
	eor	z0.d, z0.d, z2.d
	eor	z2.d, z6.d, z7.d
	eor	z5.d, z29.d, z9.d
	eor	z6.d, z28.d, z30.d
	eor	z10.d, z10.d, z4.d
	eor	z4.d, z14.d, z15.d
	eor	z7.d, z16.d, z31.d
	eor	z17.d, z17.d, z3.d
	eor	z3.d, z11.d, z8.d
	eor	z23.d, z23.d, z0.d
	eor	z21.d, z21.d, z1.d
	eor	z20.d, z20.d, z2.d
	eor	z27.d, z27.d, z6.d
	eor	z22.d, z22.d, z4.d
	eor	z26.d, z26.d, z5.d
	eor	z25.d, z25.d, z7.d
	eor	z24.d, z24.d, z3.d
	b.ne	.LBB4_7
	b	.LBB4_3
.LBB4_8:
	addvl	sp, sp, #10
	ldp	x20, x19, [sp, #128]            // 16-byte Folded Reload
	ldr	x29, [sp, #64]                  // 8-byte Reload
	ldp	x22, x21, [sp, #112]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #144            // 16-byte Folded Reload
.LBB4_9:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB5_9
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
	addvl	sp, sp, #-17
	add	w13, w1, w1, lsl #2
	add	w14, w1, w1, lsl #1
	lsl	w11, w1, #6
	lsl	w12, w1, #7
	lsl	w15, w1, #5
	ubfiz	x16, x1, #5, #32
	lsl	w13, w13, #5
	lsl	w14, w14, #5
	ptrue	p0.b
	mov	x8, xzr
	rdvl	x9, #1
	rdvl	x10, #2
	rdvl	x17, #3
	mov	w18, #16                        // =0x10
	rdvl	x5, #4
	b	.LBB5_4
.LBB5_2:                                //   in Loop: Header=BB5_4 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	str	z0, [sp, #9, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v13.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	str	z0, [sp, #13, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #12, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #11, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #8, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #10, mul vl]           // 16-byte Folded Spill
.LBB5_3:                                //   in Loop: Header=BB5_4 Depth=1
	ldr	x20, [x4, #40]
	ldr	z0, [sp, #8, mul vl]            // 16-byte Folded Reload
	st1b	{ z6.b }, p1, [x20, x8]
	ldr	x20, [x4, #40]
	st1b	{ z5.b }, p3, [x20, x7]
	ldr	x20, [x4, #40]
	st1b	{ z3.b }, p4, [x20, x19]
	ldr	x20, [x4, #40]
	st1b	{ z1.b }, p2, [x20, x6]
	ldr	x20, [x4, #32]
	st1b	{ z18.b }, p1, [x20, x8]
	ldr	x20, [x4, #32]
	st1b	{ z16.b }, p3, [x20, x7]
	ldr	x20, [x4, #32]
	st1b	{ z4.b }, p4, [x20, x19]
	ldr	x20, [x4, #32]
	st1b	{ z2.b }, p2, [x20, x6]
	ldr	x20, [x4, #24]
	st1b	{ z13.b }, p1, [x20, x8]
	ldr	x20, [x4, #24]
	st1b	{ z31.b }, p3, [x20, x7]
	ldr	x20, [x4, #24]
	st1b	{ z22.b }, p4, [x20, x19]
	ldr	x20, [x4, #24]
	st1b	{ z17.b }, p2, [x20, x6]
	ldr	x20, [x4, #16]
	st1b	{ z30.b }, p1, [x20, x8]
	ldr	x20, [x4, #16]
	st1b	{ z29.b }, p3, [x20, x7]
	ldr	x20, [x4, #16]
	st1b	{ z28.b }, p4, [x20, x19]
	ldr	x20, [x4, #16]
	st1b	{ z27.b }, p2, [x20, x6]
	ldr	x20, [x4, #8]
	st1b	{ z0.b }, p1, [x20, x8]
	ldr	z0, [sp, #9, mul vl]            // 16-byte Folded Reload
	ldr	x20, [x4, #8]
	st1b	{ z25.b }, p3, [x20, x7]
	ldr	x20, [x4, #8]
	st1b	{ z24.b }, p4, [x20, x19]
	ldr	x20, [x4, #8]
	st1b	{ z0.b }, p2, [x20, x6]
	ldr	z0, [sp, #10, mul vl]           // 16-byte Folded Reload
	ldr	x20, [x4]
	st1b	{ z0.b }, p1, [x20, x8]
	ldr	z0, [sp, #11, mul vl]           // 16-byte Folded Reload
	add	x8, x8, x5
	ldr	x20, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p3, [x20, x7]
	ldr	z0, [sp, #12, mul vl]           // 16-byte Folded Reload
	ldr	x7, [x4]
	st1b	{ z0.b }, p4, [x7, x19]
	ldr	z0, [sp, #13, mul vl]           // 16-byte Folded Reload
	ldr	x7, [x4]
	st1b	{ z0.b }, p2, [x7, x6]
	b.le	.LBB5_8
.LBB5_4:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB5_7 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB5_8
// %bb.5:                               //   in Loop: Header=BB5_4 Depth=1
	add	x7, x8, x9
	add	x19, x8, x10
	add	x6, x8, x17
	whilelt	p3.b, w7, w0
	whilelt	p4.b, w19, w0
	whilelt	p2.b, w6, w0
	cmp	w1, #1
	b.lt	.LBB5_2
// %bb.6:                               //   in Loop: Header=BB5_4 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x20, xzr
	movi	v30.2d, #0000000000000000
	movi	v13.2d, #0000000000000000
	mov	x21, x3
	movi	v18.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	w22, w15
	movi	v25.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	mov	w23, w11
	str	z0, [sp, #10, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	w24, w14
	movi	v24.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	mov	w25, w12
	movi	v22.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	w26, w13
	str	z0, [sp, #8, mul vl]            // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	str	z0, [sp, #11, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #12, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #13, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #9, mul vl]            // 16-byte Folded Spill
.LBB5_7:                                //   Parent Loop BB5_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x27, [x21], #8
	sxtw	x28, w20
	str	z13, [sp, #6, mul vl]           // 16-byte Folded Spill
	ldr	z26, [sp, #8, mul vl]           // 16-byte Folded Reload
	add	x20, x20, #32
	ld1b	{ z11.b }, p3/z, [x27, x7]
	ld1b	{ z9.b }, p1/z, [x27, x8]
	ld1b	{ z15.b }, p2/z, [x27, x6]
	ld1b	{ z13.b }, p4/z, [x27, x19]
	add	x27, x2, x28
	str	z1, [sp, #16, mul vl]           // 16-byte Folded Spill
	ld1b	{ z0.b }, p0/z, [x2, x28]
	ld1b	{ z1.b }, p0/z, [x27, x18]
	sxtw	x28, w22
	movprfx	z10, z11
	and	z10.b, z10.b, #0xf
	lsr	z11.b, z11.b, #4
	str	z5, [sp, #15, mul vl]           // 16-byte Folded Spill
	str	z4, [sp, #4, mul vl]            // 16-byte Folded Spill
	movprfx	z23, z9
	and	z23.b, z23.b, #0xf
	movprfx	z12, z15
	and	z12.b, z12.b, #0xf
	movprfx	z14, z13
	and	z14.b, z14.b, #0xf
	lsr	z13.b, z13.b, #4
	str	z22, [sp]                       // 16-byte Folded Spill
	tbl	z4.b, { z0.b }, z10.b
	tbl	z5.b, { z1.b }, z11.b
	str	z18, [sp, #2, mul vl]           // 16-byte Folded Spill
	str	z2, [sp, #5, mul vl]            // 16-byte Folded Spill
	lsr	z15.b, z15.b, #4
	tbl	z2.b, { z0.b }, z12.b
	tbl	z18.b, { z0.b }, z23.b
	tbl	z0.b, { z0.b }, z14.b
	tbl	z22.b, { z1.b }, z13.b
	str	z16, [sp, #3, mul vl]           // 16-byte Folded Spill
	lsr	z9.b, z9.b, #4
	ldr	z16, [sp, #11, mul vl]          // 16-byte Folded Reload
	eor	z4.d, z4.d, z5.d
	tbl	z7.b, { z1.b }, z15.b
	str	z17, [sp, #7, mul vl]           // 16-byte Folded Spill
	add	x27, x2, x28
	str	z6, [sp, #14, mul vl]           // 16-byte Folded Spill
	cmp	x16, x20
	tbl	z17.b, { z1.b }, z9.b
	eor	z0.d, z0.d, z22.d
	str	z3, [sp, #1, mul vl]            // 16-byte Folded Spill
	eor	z16.d, z16.d, z4.d
	ldr	z4, [sp, #12, mul vl]           // 16-byte Folded Reload
	ld1b	{ z3.b }, p0/z, [x2, x28]
	ld1b	{ z6.b }, p0/z, [x27, x18]
	sxtw	x27, w23
	eor	z2.d, z2.d, z7.d
	ldr	z22, [sp, #10, mul vl]          // 16-byte Folded Reload
	add	w23, w23, #32
	add	w22, w22, #32
	eor	z4.d, z4.d, z0.d
	ldr	z0, [sp, #13, mul vl]           // 16-byte Folded Reload
	eor	z1.d, z18.d, z17.d
	add	x28, x2, x27
	tbl	z8.b, { z3.b }, z12.b
	tbl	z19.b, { z6.b }, z15.b
	tbl	z20.b, { z3.b }, z14.b
	tbl	z21.b, { z6.b }, z13.b
	tbl	z5.b, { z3.b }, z10.b
	tbl	z17.b, { z6.b }, z11.b
	tbl	z18.b, { z3.b }, z23.b
	tbl	z3.b, { z6.b }, z9.b
	ld1b	{ z6.b }, p0/z, [x2, x27]
	ld1b	{ z7.b }, p0/z, [x28, x18]
	eor	z0.d, z0.d, z2.d
	eor	z22.d, z22.d, z1.d
	str	z16, [sp, #11, mul vl]          // 16-byte Folded Spill
	sxtw	x27, w24
	str	z4, [sp, #12, mul vl]           // 16-byte Folded Spill
	eor	z2.d, z20.d, z21.d
	add	w24, w24, #32
	tbl	z4.b, { z6.b }, z23.b
	tbl	z16.b, { z7.b }, z9.b
	str	z0, [sp, #13, mul vl]           // 16-byte Folded Spill
	eor	z0.d, z8.d, z19.d
	eor	z5.d, z5.d, z17.d
	eor	z1.d, z18.d, z3.d
	tbl	z3.b, { z6.b }, z12.b
	tbl	z17.b, { z7.b }, z15.b
	tbl	z18.b, { z6.b }, z14.b
	tbl	z19.b, { z7.b }, z13.b
	tbl	z6.b, { z6.b }, z10.b
	tbl	z7.b, { z7.b }, z11.b
	str	z22, [sp, #10, mul vl]          // 16-byte Folded Spill
	ldr	z22, [sp, #9, mul vl]           // 16-byte Folded Reload
	add	x28, x2, x27
	eor	z26.d, z26.d, z1.d
	eor	z1.d, z4.d, z16.d
	eor	z25.d, z25.d, z5.d
	ld1b	{ z4.b }, p0/z, [x2, x27]
	ld1b	{ z5.b }, p0/z, [x28, x18]
	sxtw	x27, w25
	eor	z22.d, z22.d, z0.d
	eor	z0.d, z3.d, z17.d
	eor	z3.d, z6.d, z7.d
	eor	z24.d, z24.d, z2.d
	eor	z2.d, z18.d, z19.d
	eor	z30.d, z30.d, z1.d
	tbl	z1.b, { z4.b }, z12.b
	tbl	z6.b, { z5.b }, z15.b
	tbl	z7.b, { z4.b }, z14.b
	tbl	z16.b, { z5.b }, z13.b
	tbl	z17.b, { z4.b }, z10.b
	tbl	z18.b, { z5.b }, z11.b
	tbl	z4.b, { z4.b }, z23.b
	tbl	z5.b, { z5.b }, z9.b
	add	x28, x2, x27
	eor	z29.d, z29.d, z3.d
	ld1b	{ z3.b }, p0/z, [x2, x27]
	eor	z27.d, z27.d, z0.d
	ld1b	{ z0.b }, p0/z, [x28, x18]
	sxtw	x27, w26
	eor	z28.d, z28.d, z2.d
	eor	z1.d, z1.d, z6.d
	eor	z2.d, z7.d, z16.d
	eor	z6.d, z17.d, z18.d
	add	x28, x2, x27
	eor	z4.d, z4.d, z5.d
	tbl	z5.b, { z3.b }, z12.b
	tbl	z7.b, { z0.b }, z15.b
	ld1b	{ z16.b }, p0/z, [x2, x27]
	tbl	z17.b, { z3.b }, z14.b
	tbl	z18.b, { z0.b }, z13.b
	ld1b	{ z19.b }, p0/z, [x28, x18]
	tbl	z20.b, { z3.b }, z10.b
	tbl	z21.b, { z0.b }, z11.b
	tbl	z3.b, { z3.b }, z23.b
	tbl	z0.b, { z0.b }, z9.b
	str	z22, [sp, #9, mul vl]           // 16-byte Folded Spill
	ldr	z22, [sp]                       // 16-byte Folded Reload
	tbl	z8.b, { z16.b }, z23.b
	tbl	z9.b, { z19.b }, z9.b
	eor	z31.d, z31.d, z6.d
	tbl	z10.b, { z16.b }, z10.b
	tbl	z11.b, { z19.b }, z11.b
	tbl	z12.b, { z16.b }, z12.b
	tbl	z16.b, { z16.b }, z14.b
	eor	z22.d, z22.d, z2.d
	eor	z2.d, z17.d, z18.d
	ldr	z18, [sp, #2, mul vl]           // 16-byte Folded Reload
	eor	z0.d, z3.d, z0.d
	tbl	z14.b, { z19.b }, z15.b
	tbl	z19.b, { z19.b }, z13.b
	eor	z6.d, z8.d, z9.d
	ldr	z13, [sp, #6, mul vl]           // 16-byte Folded Reload
	eor	z3.d, z5.d, z7.d
	eor	z5.d, z10.d, z11.d
	ldr	z17, [sp, #7, mul vl]           // 16-byte Folded Reload
	add	w26, w26, #32
	eor	z18.d, z18.d, z0.d
	ldr	z0, [sp, #14, mul vl]           // 16-byte Folded Reload
	add	w25, w25, #32
	eor	z13.d, z13.d, z4.d
	eor	z4.d, z20.d, z21.d
	eor	z7.d, z16.d, z19.d
	ldr	z16, [sp, #3, mul vl]           // 16-byte Folded Reload
	eor	z17.d, z17.d, z1.d
	eor	z1.d, z12.d, z14.d
	eor	z0.d, z0.d, z6.d
	str	z26, [sp, #8, mul vl]           // 16-byte Folded Spill
	eor	z16.d, z16.d, z4.d
	ldr	z4, [sp, #4, mul vl]            // 16-byte Folded Reload
	str	z0, [sp, #14, mul vl]           // 16-byte Folded Spill
	ldr	z0, [sp, #15, mul vl]           // 16-byte Folded Reload
	ldr	z6, [sp, #14, mul vl]           // 16-byte Folded Reload
	eor	z4.d, z4.d, z2.d
	ldr	z2, [sp, #5, mul vl]            // 16-byte Folded Reload
	eor	z0.d, z0.d, z5.d
	eor	z2.d, z2.d, z3.d
	ldr	z3, [sp, #1, mul vl]            // 16-byte Folded Reload
	str	z0, [sp, #15, mul vl]           // 16-byte Folded Spill
	ldr	z0, [sp, #16, mul vl]           // 16-byte Folded Reload
	ldr	z5, [sp, #15, mul vl]           // 16-byte Folded Reload
	eor	z3.d, z3.d, z7.d
	eor	z0.d, z0.d, z1.d
	str	z0, [sp, #16, mul vl]           // 16-byte Folded Spill
	ldr	z1, [sp, #16, mul vl]           // 16-byte Folded Reload
	b.ne	.LBB5_7
	b	.LBB5_3
.LBB5_8:
	addvl	sp, sp, #17
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
.LBB5_9:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB6_9
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
	addvl	sp, sp, #-19
	add	w15, w1, w1, lsl #1
	add	w14, w1, w1, lsl #2
	lsl	w11, w1, #6
	lsl	w12, w1, #7
	lsl	w16, w1, #5
	ubfiz	x17, x1, #5, #32
	lsl	w13, w15, #6
	lsl	w14, w14, #5
	lsl	w15, w15, #5
	ptrue	p0.b
	mov	x8, xzr
	rdvl	x9, #1
	rdvl	x10, #2
	rdvl	x18, #3
	mov	w5, #16                         // =0x10
	rdvl	x6, #4
	b	.LBB6_4
.LBB6_2:                                //   in Loop: Header=BB6_4 Depth=1
	movi	v0.2d, #0000000000000000
	add	x21, sp, #16
	movi	v16.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	str	z0, [x21, #11, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	movi	v9.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	str	z0, [x21, #15, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x21, #10, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x21, #14, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x21, #9, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x21, #13, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x21, #8, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x21, #12, mul vl]          // 16-byte Folded Spill
.LBB6_3:                                //   in Loop: Header=BB6_4 Depth=1
	ldr	x21, [x4, #48]
	add	x22, sp, #16
	ldr	z0, [x22, #8, mul vl]           // 16-byte Folded Reload
	st1b	{ z17.b }, p1, [x21, x8]
	ldr	x21, [x4, #48]
	st1b	{ z6.b }, p3, [x21, x19]
	ldr	x21, [x4, #48]
	st1b	{ z5.b }, p4, [x21, x20]
	ldr	x21, [x4, #48]
	st1b	{ z1.b }, p2, [x21, x7]
	ldr	x21, [x4, #40]
	st1b	{ z21.b }, p1, [x21, x8]
	ldr	x21, [x4, #40]
	st1b	{ z7.b }, p3, [x21, x19]
	ldr	x21, [x4, #40]
	st1b	{ z4.b }, p4, [x21, x20]
	ldr	x21, [x4, #40]
	st1b	{ z3.b }, p2, [x21, x7]
	ldr	x21, [x4, #32]
	st1b	{ z10.b }, p1, [x21, x8]
	ldr	x21, [x4, #32]
	st1b	{ z20.b }, p3, [x21, x19]
	ldr	x21, [x4, #32]
	st1b	{ z18.b }, p4, [x21, x20]
	ldr	x21, [x4, #32]
	st1b	{ z16.b }, p2, [x21, x7]
	ldr	x21, [x4, #24]
	st1b	{ z9.b }, p1, [x21, x8]
	ldr	x21, [x4, #24]
	st1b	{ z8.b }, p3, [x21, x19]
	ldr	x21, [x4, #24]
	st1b	{ z31.b }, p4, [x21, x20]
	ldr	x21, [x4, #24]
	st1b	{ z30.b }, p2, [x21, x7]
	ldr	x21, [x4, #16]
	st1b	{ z29.b }, p1, [x21, x8]
	ldr	x21, [x4, #16]
	st1b	{ z28.b }, p3, [x21, x19]
	ldr	x21, [x4, #16]
	st1b	{ z27.b }, p4, [x21, x20]
	ldr	x21, [x4, #16]
	st1b	{ z26.b }, p2, [x21, x7]
	ldr	x21, [x4, #8]
	st1b	{ z0.b }, p1, [x21, x8]
	ldr	z0, [x22, #9, mul vl]           // 16-byte Folded Reload
	ldr	x21, [x4, #8]
	st1b	{ z0.b }, p3, [x21, x19]
	ldr	z0, [x22, #10, mul vl]          // 16-byte Folded Reload
	ldr	x21, [x4, #8]
	st1b	{ z0.b }, p4, [x21, x20]
	ldr	z0, [x22, #11, mul vl]          // 16-byte Folded Reload
	ldr	x21, [x4, #8]
	st1b	{ z0.b }, p2, [x21, x7]
	ldr	z0, [x22, #12, mul vl]          // 16-byte Folded Reload
	ldr	x21, [x4]
	st1b	{ z0.b }, p1, [x21, x8]
	ldr	z0, [x22, #13, mul vl]          // 16-byte Folded Reload
	add	x8, x8, x6
	ldr	x21, [x4]
	cmp	w0, w8
	st1b	{ z0.b }, p3, [x21, x19]
	add	x21, sp, #16
	ldr	z0, [x21, #14, mul vl]          // 16-byte Folded Reload
	ldr	x19, [x4]
	st1b	{ z0.b }, p4, [x19, x20]
	add	x20, sp, #16
	ldr	z0, [x20, #15, mul vl]          // 16-byte Folded Reload
	ldr	x19, [x4]
	st1b	{ z0.b }, p2, [x19, x7]
	b.le	.LBB6_8
.LBB6_4:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB6_7 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB6_8
// %bb.5:                               //   in Loop: Header=BB6_4 Depth=1
	add	x19, x8, x9
	add	x20, x8, x10
	add	x7, x8, x18
	whilelt	p3.b, w19, w0
	whilelt	p4.b, w20, w0
	whilelt	p2.b, w7, w0
	cmp	w1, #1
	b.lt	.LBB6_2
// %bb.6:                               //   in Loop: Header=BB6_4 Depth=1
	movi	v0.2d, #0000000000000000
	add	x22, sp, #16
	movi	v1.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	mov	x21, xzr
	movi	v9.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	mov	w23, w16
	movi	v21.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	w24, w11
	str	z0, [x22, #12, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	mov	w25, w15
	movi	v7.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	w26, w12
	movi	v27.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	mov	w27, w14
	str	z0, [x22, #8, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	w28, w13
	movi	v26.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	str	z0, [x22, #13, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x22, #9, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x22, #14, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x22, #10, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x22, #15, mul vl]          // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [x22, #11, mul vl]          // 16-byte Folded Spill
	mov	x22, x3
.LBB6_7:                                //   Parent Loop BB6_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	add	x29, sp, #16
	sxtw	x30, w21
	str	x8, [sp]                        // 8-byte Spill
	str	z17, [x29, #16, mul vl]         // 16-byte Folded Spill
	add	x21, x21, #32
	str	z6, [x29]                       // 16-byte Folded Spill
	cmp	x17, x21
	str	z5, [x29, #1, mul vl]           // 16-byte Folded Spill
	str	z1, [x29, #2, mul vl]           // 16-byte Folded Spill
	str	z21, [x29, #3, mul vl]          // 16-byte Folded Spill
	str	z7, [x29, #17, mul vl]          // 16-byte Folded Spill
	str	z4, [x29, #4, mul vl]           // 16-byte Folded Spill
	ld1b	{ z4.b }, p0/z, [x2, x30]
	str	z3, [x29, #5, mul vl]           // 16-byte Folded Spill
	str	z16, [x29, #18, mul vl]         // 16-byte Folded Spill
	str	z20, [x29, #6, mul vl]          // 16-byte Folded Spill
	str	z18, [x29, #7, mul vl]          // 16-byte Folded Spill
	ldr	x29, [x22], #8
	ld1b	{ z0.b }, p1/z, [x29, x8]
	ld1b	{ z1.b }, p3/z, [x29, x19]
	ld1b	{ z2.b }, p4/z, [x29, x20]
	ld1b	{ z3.b }, p2/z, [x29, x7]
	add	x29, x2, x30
	add	x8, sp, #16
	ld1b	{ z5.b }, p0/z, [x29, x5]
	sxtw	x29, w23
	add	w23, w23, #32
	movprfx	z12, z0
	and	z12.b, z12.b, #0xf
	movprfx	z13, z1
	and	z13.b, z13.b, #0xf
	lsr	z14.b, z0.b, #4
	lsr	z15.b, z1.b, #4
	movprfx	z11, z2
	and	z11.b, z11.b, #0xf
	lsr	z1.b, z2.b, #4
	movprfx	z2, z3
	and	z2.b, z2.b, #0xf
	lsr	z3.b, z3.b, #4
	add	x30, x2, x29
	tbl	z6.b, { z4.b }, z13.b
	tbl	z17.b, { z4.b }, z12.b
	tbl	z18.b, { z5.b }, z14.b
	tbl	z7.b, { z5.b }, z15.b
	ld1b	{ z16.b }, p0/z, [x2, x29]
	sxtw	x29, w24
	tbl	z20.b, { z4.b }, z2.b
	tbl	z21.b, { z5.b }, z3.b
	tbl	z4.b, { z4.b }, z11.b
	tbl	z5.b, { z5.b }, z1.b
	ld1b	{ z19.b }, p0/z, [x30, x5]
	add	x30, x2, x29
	eor	z17.d, z17.d, z18.d
	tbl	z24.b, { z16.b }, z11.b
	tbl	z22.b, { z16.b }, z2.b
	eor	z6.d, z6.d, z7.d
	tbl	z7.b, { z16.b }, z13.b
	tbl	z16.b, { z16.b }, z12.b
	eor	z20.d, z20.d, z21.d
	tbl	z25.b, { z19.b }, z1.b
	tbl	z23.b, { z19.b }, z3.b
	eor	z4.d, z4.d, z5.d
	ldr	z5, [x8, #12, mul vl]           // 16-byte Folded Reload
	tbl	z18.b, { z19.b }, z15.b
	tbl	z19.b, { z19.b }, z14.b
	mov	z0.d, z10.d
	mov	z10.d, z9.d
	mov	z9.d, z8.d
	mov	z8.d, z31.d
	mov	z31.d, z30.d
	eor	z5.d, z5.d, z17.d
	mov	z30.d, z29.d
	mov	z29.d, z28.d
	mov	z28.d, z27.d
	mov	z27.d, z26.d
	eor	z7.d, z7.d, z18.d
	eor	z16.d, z16.d, z19.d
	add	w24, w24, #32
	str	z5, [x8, #12, mul vl]           // 16-byte Folded Spill
	ldr	z5, [x8, #13, mul vl]           // 16-byte Folded Reload
	eor	z5.d, z5.d, z6.d
	ld1b	{ z6.b }, p0/z, [x30, x5]
	str	z5, [x8, #13, mul vl]           // 16-byte Folded Spill
	ld1b	{ z5.b }, p0/z, [x2, x29]
	add	x29, sp, #16
	ldr	z17, [x29, #14, mul vl]         // 16-byte Folded Reload
	tbl	z19.b, { z6.b }, z3.b
	tbl	z21.b, { z6.b }, z1.b
	ldr	x8, [sp]                        // 8-byte Reload
	tbl	z18.b, { z5.b }, z2.b
	eor	z17.d, z17.d, z4.d
	ldr	z4, [x29, #15, mul vl]          // 16-byte Folded Reload
	eor	z4.d, z4.d, z20.d
	str	z17, [x29, #14, mul vl]         // 16-byte Folded Spill
	eor	z17.d, z24.d, z25.d
	tbl	z20.b, { z5.b }, z11.b
	str	z4, [x29, #15, mul vl]          // 16-byte Folded Spill
	sxtw	x29, w25
	eor	z4.d, z22.d, z23.d
	tbl	z22.b, { z5.b }, z13.b
	tbl	z5.b, { z5.b }, z12.b
	tbl	z23.b, { z6.b }, z14.b
	add	x30, x2, x29
	ld1b	{ z24.b }, p0/z, [x2, x29]
	add	x29, sp, #16
	ldr	z26, [x29, #8, mul vl]          // 16-byte Folded Reload
	tbl	z6.b, { z6.b }, z15.b
	ld1b	{ z25.b }, p0/z, [x30, x5]
	add	w25, w25, #32
	eor	z5.d, z5.d, z23.d
	eor	z26.d, z26.d, z16.d
	ldr	z16, [x29, #9, mul vl]          // 16-byte Folded Reload
	eor	z6.d, z22.d, z6.d
	tbl	z22.b, { z25.b }, z15.b
	eor	z16.d, z16.d, z7.d
	ldr	z7, [x29, #10, mul vl]          // 16-byte Folded Reload
	str	z26, [x29, #8, mul vl]          // 16-byte Folded Spill
	mov	z26.d, z27.d
	mov	z27.d, z28.d
	mov	z28.d, z29.d
	mov	z29.d, z30.d
	mov	z30.d, z31.d
	mov	z31.d, z8.d
	eor	z7.d, z7.d, z17.d
	str	z16, [x29, #9, mul vl]          // 16-byte Folded Spill
	tbl	z16.b, { z24.b }, z12.b
	tbl	z17.b, { z25.b }, z14.b
	mov	z8.d, z9.d
	eor	z28.d, z28.d, z6.d
	eor	z29.d, z29.d, z5.d
	tbl	z5.b, { z24.b }, z13.b
	mov	z9.d, z10.d
	str	z7, [x29, #10, mul vl]          // 16-byte Folded Spill
	ldr	z7, [x29, #11, mul vl]          // 16-byte Folded Reload
	mov	z10.d, z0.d
	eor	z16.d, z16.d, z17.d
	eor	z7.d, z7.d, z4.d
	eor	z4.d, z18.d, z19.d
	tbl	z18.b, { z24.b }, z2.b
	tbl	z19.b, { z25.b }, z3.b
	eor	z5.d, z5.d, z22.d
	eor	z9.d, z9.d, z16.d
	str	z7, [x29, #11, mul vl]          // 16-byte Folded Spill
	eor	z7.d, z20.d, z21.d
	tbl	z20.b, { z24.b }, z11.b
	tbl	z21.b, { z25.b }, z1.b
	sxtw	x29, w26
	eor	z26.d, z26.d, z4.d
	eor	z4.d, z18.d, z19.d
	eor	z8.d, z8.d, z5.d
	add	w26, w26, #32
	add	x30, x2, x29
	ld1b	{ z17.b }, p0/z, [x2, x29]
	eor	z27.d, z27.d, z7.d
	ld1b	{ z6.b }, p0/z, [x30, x5]
	sxtw	x29, w27
	add	w27, w27, #32
	eor	z7.d, z20.d, z21.d
	eor	z30.d, z30.d, z4.d
	tbl	z19.b, { z17.b }, z11.b
	tbl	z5.b, { z17.b }, z12.b
	add	x30, x2, x29
	tbl	z18.b, { z6.b }, z3.b
	tbl	z20.b, { z6.b }, z1.b
	tbl	z22.b, { z6.b }, z15.b
	tbl	z6.b, { z6.b }, z14.b
	eor	z31.d, z31.d, z7.d
	ld1b	{ z7.b }, p0/z, [x2, x29]
	ld1b	{ z4.b }, p0/z, [x30, x5]
	tbl	z16.b, { z17.b }, z2.b
	tbl	z21.b, { z17.b }, z13.b
	sxtw	x29, w28
	add	w28, w28, #32
	eor	z17.d, z19.d, z20.d
	tbl	z24.b, { z7.b }, z13.b
	eor	z5.d, z5.d, z6.d
	tbl	z6.b, { z7.b }, z2.b
	tbl	z19.b, { z4.b }, z3.b
	add	x30, x2, x29
	ld1b	{ z20.b }, p0/z, [x2, x29]
	add	x29, sp, #16
	eor	z16.d, z16.d, z18.d
	eor	z18.d, z21.d, z22.d
	tbl	z22.b, { z7.b }, z11.b
	eor	z10.d, z10.d, z5.d
	tbl	z23.b, { z4.b }, z1.b
	tbl	z25.b, { z4.b }, z15.b
	eor	z5.d, z6.d, z19.d
	ldr	z19, [x29, #18, mul vl]         // 16-byte Folded Reload
	tbl	z7.b, { z7.b }, z12.b
	tbl	z4.b, { z4.b }, z14.b
	ld1b	{ z21.b }, p0/z, [x30, x5]
	tbl	z0.b, { z20.b }, z11.b
	tbl	z13.b, { z20.b }, z13.b
	tbl	z12.b, { z20.b }, z12.b
	tbl	z2.b, { z20.b }, z2.b
	eor	z19.d, z19.d, z16.d
	ldr	z20, [x29, #6, mul vl]          // 16-byte Folded Reload
	eor	z6.d, z22.d, z23.d
	tbl	z1.b, { z21.b }, z1.b
	tbl	z15.b, { z21.b }, z15.b
	tbl	z14.b, { z21.b }, z14.b
	eor	z4.d, z7.d, z4.d
	eor	z7.d, z24.d, z25.d
	tbl	z3.b, { z21.b }, z3.b
	str	z19, [x29, #18, mul vl]         // 16-byte Folded Spill
	ldr	z19, [x29, #17, mul vl]         // 16-byte Folded Reload
	ldr	z21, [x29, #3, mul vl]          // 16-byte Folded Reload
	eor	z20.d, z20.d, z18.d
	ldr	z18, [x29, #7, mul vl]          // 16-byte Folded Reload
	ldr	z16, [x29, #18, mul vl]         // 16-byte Folded Reload
	eor	z0.d, z0.d, z1.d
	eor	z1.d, z13.d, z15.d
	eor	z19.d, z19.d, z7.d
	eor	z21.d, z21.d, z4.d
	ldr	z4, [x29, #4, mul vl]           // 16-byte Folded Reload
	eor	z18.d, z18.d, z17.d
	eor	z17.d, z12.d, z14.d
	eor	z2.d, z2.d, z3.d
	ldr	z3, [x29, #5, mul vl]           // 16-byte Folded Reload
	str	z19, [x29, #17, mul vl]         // 16-byte Folded Spill
	ldr	z19, [x29, #16, mul vl]         // 16-byte Folded Reload
	eor	z4.d, z4.d, z6.d
	ldr	z6, [x29]                       // 16-byte Folded Reload
	ldr	z7, [x29, #17, mul vl]          // 16-byte Folded Reload
	eor	z3.d, z3.d, z5.d
	ldr	z5, [x29, #1, mul vl]           // 16-byte Folded Reload
	eor	z19.d, z19.d, z17.d
	eor	z6.d, z6.d, z1.d
	ldr	z1, [x29, #2, mul vl]           // 16-byte Folded Reload
	eor	z5.d, z5.d, z0.d
	str	z19, [x29, #16, mul vl]         // 16-byte Folded Spill
	ldr	z17, [x29, #16, mul vl]         // 16-byte Folded Reload
	eor	z1.d, z1.d, z2.d
	b.ne	.LBB6_7
	b	.LBB6_3
.LBB6_8:
	addvl	sp, sp, #19
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
.LBB6_9:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB7_10
// %bb.1:
	cmp	w1, #0
	rdvl	x11, #1
	rdvl	x8, #2
	rdvl	x12, #3
	mov	x9, xzr
	b.le	.LBB7_7
// %bb.2:
	ubfiz	x10, x1, #5, #32
	ptrue	p0.b
	mov	w11, w11
	mov	w12, w12
	mov	w13, #16                        // =0x10
.LBB7_3:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB7_5 Depth 2
	whilelt	p1.b, w9, w0
	b.eq	.LBB7_10
// %bb.4:                               //   in Loop: Header=BB7_3 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	add	x14, x9, x11
	movi	v3.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	add	x15, x9, x8
	add	x17, x9, x12
	whilelt	p3.b, w14, w0
	mov	x16, xzr
	whilelt	p4.b, w15, w0
	mov	x18, x3
	whilelt	p2.b, w17, w0
.LBB7_5:                                //   Parent Loop BB7_3 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x1, [x18], #8
	sxtw	x5, w16
	add	x16, x16, #32
	ld1b	{ z4.b }, p1/z, [x1, x9]
	ld1b	{ z5.b }, p3/z, [x1, x14]
	ld1b	{ z6.b }, p4/z, [x1, x15]
	ld1b	{ z7.b }, p2/z, [x1, x17]
	add	x1, x2, x5
	ld1b	{ z16.b }, p0/z, [x2, x5]
	ld1b	{ z17.b }, p0/z, [x1, x13]
	cmp	x10, x16
	movprfx	z18, z4
	and	z18.b, z18.b, #0xf
	lsr	z4.b, z4.b, #4
	movprfx	z19, z5
	and	z19.b, z19.b, #0xf
	lsr	z5.b, z5.b, #4
	movprfx	z20, z6
	and	z20.b, z20.b, #0xf
	lsr	z6.b, z6.b, #4
	movprfx	z21, z7
	and	z21.b, z21.b, #0xf
	lsr	z7.b, z7.b, #4
	tbl	z18.b, { z16.b }, z18.b
	tbl	z4.b, { z17.b }, z4.b
	tbl	z19.b, { z16.b }, z19.b
	tbl	z5.b, { z17.b }, z5.b
	tbl	z20.b, { z16.b }, z20.b
	tbl	z6.b, { z17.b }, z6.b
	tbl	z16.b, { z16.b }, z21.b
	tbl	z7.b, { z17.b }, z7.b
	eor3	z2.d, z2.d, z18.d, z4.d
	eor3	z1.d, z1.d, z19.d, z5.d
	eor3	z3.d, z3.d, z20.d, z6.d
	eor3	z0.d, z0.d, z16.d, z7.d
	b.ne	.LBB7_5
// %bb.6:                               //   in Loop: Header=BB7_3 Depth=1
	st1b	{ z2.b }, p1, [x4, x9]
	incb	x9, all, mul #4
	st1b	{ z1.b }, p3, [x4, x14]
	st1b	{ z3.b }, p4, [x4, x15]
	cmp	w0, w9
	st1b	{ z0.b }, p2, [x4, x17]
	b.gt	.LBB7_3
	b	.LBB7_10
.LBB7_7:
	movi	v0.2d, #0000000000000000
	mov	w10, w12
	mov	w11, w11
	add	x12, x4, x11
	add	x13, x4, x8
	add	x14, x4, x10
.LBB7_8:                                // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w9, w0
	b.eq	.LBB7_10
// %bb.9:                               //   in Loop: Header=BB7_8 Depth=1
	add	w15, w11, w9
	add	w16, w8, w9
	st1b	{ z0.b }, p0, [x4, x9]
	whilelt	p1.b, w15, w0
	add	w15, w10, w9
	whilelt	p0.b, w16, w0
	whilelt	p2.b, w15, w0
	st1b	{ z0.b }, p1, [x12, x9]
	st1b	{ z0.b }, p0, [x13, x9]
	st1b	{ z0.b }, p2, [x14, x9]
	incb	x9, all, mul #4
	cmp	w0, w9
	b.gt	.LBB7_8
.LBB7_10:
	ret
.Lfunc_end7:
	.size	gf_vect_dot_prod_sve2, .Lfunc_end7-gf_vect_dot_prod_sve2
                                        // -- End function
	.globl	gf_2vect_dot_prod_sve2          // -- Begin function gf_2vect_dot_prod_sve2
	.p2align	2
	.type	gf_2vect_dot_prod_sve2,@function
gf_2vect_dot_prod_sve2:                 // @gf_2vect_dot_prod_sve2
// %bb.0:
	cmp	w0, #16
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB8_11
// %bb.1:
	str	d8, [sp, #-16]!                 // 8-byte Folded Spill
	cmp	w1, #0
	rdvl	x11, #1
	rdvl	x12, #2
	rdvl	x13, #3
	mov	x8, xzr
	str	x19, [sp, #8]                   // 8-byte Spill
	b.le	.LBB8_7
// %bb.2:
	mov	w9, w11
	lsl	w10, w1, #5
	ubfiz	x11, x1, #5, #32
	ptrue	p0.b
	mov	w12, w12
	mov	w13, w13
	mov	w14, #16                        // =0x10
.LBB8_3:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB8_5 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB8_10
// %bb.4:                               //   in Loop: Header=BB8_3 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	add	x16, x8, x9
	movi	v3.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	add	x15, x8, x12
	movi	v1.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	add	x18, x8, x13
	movi	v0.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	x17, xzr
	whilelt	p3.b, w16, w0
	mov	x1, x3
	mov	w5, w10
	whilelt	p4.b, w15, w0
	whilelt	p2.b, w18, w0
.LBB8_5:                                //   Parent Loop BB8_3 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x6, [x1], #8
	sxtw	x7, w17
	sxtw	x19, w5
	add	x17, x17, #32
	add	w5, w5, #32
	ld1b	{ z16.b }, p3/z, [x6, x16]
	ld1b	{ z17.b }, p2/z, [x6, x18]
	ld1b	{ z18.b }, p1/z, [x6, x8]
	ld1b	{ z19.b }, p4/z, [x6, x15]
	ld1b	{ z20.b }, p0/z, [x2, x7]
	add	x6, x2, x7
	add	x7, x2, x19
	ld1b	{ z21.b }, p0/z, [x2, x19]
	ld1b	{ z24.b }, p0/z, [x6, x14]
	movprfx	z22, z16
	and	z22.b, z22.b, #0xf
	movprfx	z23, z17
	and	z23.b, z23.b, #0xf
	lsr	z16.b, z16.b, #4
	movprfx	z25, z19
	and	z25.b, z25.b, #0xf
	ld1b	{ z26.b }, p0/z, [x7, x14]
	movprfx	z27, z18
	and	z27.b, z27.b, #0xf
	lsr	z18.b, z18.b, #4
	lsr	z19.b, z19.b, #4
	lsr	z17.b, z17.b, #4
	tbl	z28.b, { z20.b }, z23.b
	tbl	z30.b, { z20.b }, z22.b
	tbl	z31.b, { z24.b }, z16.b
	tbl	z29.b, { z20.b }, z25.b
	tbl	z20.b, { z20.b }, z27.b
	tbl	z23.b, { z21.b }, z23.b
	tbl	z8.b, { z24.b }, z18.b
	tbl	z25.b, { z21.b }, z25.b
	tbl	z22.b, { z21.b }, z22.b
	tbl	z21.b, { z21.b }, z27.b
	tbl	z27.b, { z24.b }, z17.b
	tbl	z24.b, { z24.b }, z19.b
	tbl	z18.b, { z26.b }, z18.b
	tbl	z17.b, { z26.b }, z17.b
	tbl	z19.b, { z26.b }, z19.b
	tbl	z16.b, { z26.b }, z16.b
	eor3	z3.d, z3.d, z30.d, z31.d
	cmp	x11, x17
	eor3	z2.d, z2.d, z20.d, z8.d
	eor3	z1.d, z1.d, z29.d, z24.d
	eor3	z0.d, z0.d, z28.d, z27.d
	eor3	z4.d, z4.d, z21.d, z18.d
	eor3	z6.d, z6.d, z25.d, z19.d
	eor3	z7.d, z7.d, z23.d, z17.d
	eor3	z5.d, z5.d, z22.d, z16.d
	b.ne	.LBB8_5
// %bb.6:                               //   in Loop: Header=BB8_3 Depth=1
	ldr	x17, [x4, #8]
	st1b	{ z4.b }, p1, [x17, x8]
	ldr	x17, [x4, #8]
	st1b	{ z5.b }, p3, [x17, x16]
	ldr	x17, [x4, #8]
	st1b	{ z6.b }, p4, [x17, x15]
	ldr	x17, [x4, #8]
	st1b	{ z7.b }, p2, [x17, x18]
	ldr	x17, [x4]
	st1b	{ z2.b }, p1, [x17, x8]
	incb	x8, all, mul #4
	ldr	x17, [x4]
	st1b	{ z3.b }, p3, [x17, x16]
	cmp	w0, w8
	ldr	x16, [x4]
	st1b	{ z1.b }, p4, [x16, x15]
	ldr	x15, [x4]
	st1b	{ z0.b }, p2, [x15, x18]
	b.gt	.LBB8_3
	b	.LBB8_10
.LBB8_7:
	movi	v0.2d, #0000000000000000
	mov	w9, w13
	mov	w10, w12
	mov	w11, w11
.LBB8_8:                                // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB8_10
// %bb.9:                               //   in Loop: Header=BB8_8 Depth=1
	ldr	x12, [x4, #8]
	add	x13, x11, x8
	add	x14, x10, x8
	whilelt	p3.b, w13, w0
	add	x15, x9, x8
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
	b.gt	.LBB8_8
.LBB8_10:
	ldr	x19, [sp, #8]                   // 8-byte Reload
	ldr	d8, [sp], #16                   // 8-byte Folded Reload
.LBB8_11:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB9_11
// %bb.1:
	stp	d15, d14, [sp, #-96]!           // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	str	x29, [sp, #64]                  // 8-byte Spill
	stp	x20, x19, [sp, #80]             // 16-byte Folded Spill
	addvl	sp, sp, #-5
	cmp	w1, #0
	rdvl	x11, #1
	rdvl	x13, #2
	rdvl	x14, #3
	mov	x8, xzr
	b.le	.LBB9_7
// %bb.2:
	mov	w9, w11
	lsl	w10, w1, #6
	lsl	w11, w1, #5
	ubfiz	x12, x1, #5, #32
	ptrue	p0.b
	mov	w13, w13
	mov	w14, w14
	mov	w15, #16                        // =0x10
.LBB9_3:                                // =>This Loop Header: Depth=1
                                        //     Child Loop BB9_5 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB9_10
// %bb.4:                               //   in Loop: Header=BB9_3 Depth=1
	movi	v2.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	add	x17, x8, x9
	movi	v16.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	add	x16, x8, x13
	movi	v5.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	add	x1, x8, x14
	movi	v29.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	x18, xzr
	movi	v18.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	mov	x5, x3
	movi	v7.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	w6, w11
	whilelt	p2.b, w17, w0
	mov	w7, w10
	whilelt	p4.b, w16, w0
	whilelt	p3.b, w1, w0
.LBB9_5:                                //   Parent Loop BB9_3 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x19, [x5], #8
	sxtw	x20, w18
	str	z29, [sp, #3, mul vl]           // 16-byte Folded Spill
	add	x18, x18, #32
	ld1b	{ z21.b }, p3/z, [x19, x1]
	ld1b	{ z29.b }, p0/z, [x2, x20]
	str	z28, [sp, #4, mul vl]           // 16-byte Folded Spill
	ld1b	{ z20.b }, p4/z, [x19, x16]
	ld1b	{ z23.b }, p1/z, [x19, x8]
	ld1b	{ z28.b }, p2/z, [x19, x17]
	add	x19, x2, x20
	sxtw	x20, w7
	cmp	x12, x18
	movprfx	z25, z21
	and	z25.b, z25.b, #0xf
	lsr	z21.b, z21.b, #4
	ld1b	{ z30.b }, p0/z, [x19, x15]
	movprfx	z22, z20
	and	z22.b, z22.b, #0xf
	lsr	z20.b, z20.b, #4
	movprfx	z26, z23
	and	z26.b, z26.b, #0xf
	lsr	z24.b, z23.b, #4
	movprfx	z27, z28
	and	z27.b, z27.b, #0xf
	lsr	z23.b, z28.b, #4
	tbl	z0.b, { z29.b }, z25.b
	sxtw	x19, w6
	ld1b	{ z14.b }, p0/z, [x2, x20]
	tbl	z28.b, { z30.b }, z20.b
	add	w7, w7, #32
	add	w6, w6, #32
	tbl	z11.b, { z29.b }, z27.b
	tbl	z12.b, { z30.b }, z23.b
	ld1b	{ z10.b }, p0/z, [x2, x19]
	add	x19, x2, x19
	str	z0, [sp, #2, mul vl]            // 16-byte Folded Spill
	tbl	z0.b, { z30.b }, z21.b
	tbl	z30.b, { z30.b }, z24.b
	ld1b	{ z13.b }, p0/z, [x19, x15]
	add	x19, x2, x20
	tbl	z15.b, { z10.b }, z25.b
	ld1b	{ z9.b }, p0/z, [x19, x15]
	tbl	z31.b, { z10.b }, z27.b
	tbl	z25.b, { z14.b }, z25.b
	tbl	z27.b, { z14.b }, z27.b
	eor3	z3.d, z3.d, z11.d, z12.d
	str	z0, [sp, #1, mul vl]            // 16-byte Folded Spill
	tbl	z0.b, { z29.b }, z22.b
	tbl	z29.b, { z29.b }, z26.b
	tbl	z8.b, { z13.b }, z23.b
	tbl	z1.b, { z13.b }, z24.b
	tbl	z24.b, { z9.b }, z24.b
	tbl	z23.b, { z9.b }, z23.b
	str	z0, [sp]                        // 16-byte Folded Spill
	eor3	z2.d, z2.d, z29.d, z30.d
	ldr	z29, [sp, #3, mul vl]           // 16-byte Folded Reload
	ldr	z30, [sp]                       // 16-byte Folded Reload
	tbl	z0.b, { z10.b }, z22.b
	tbl	z10.b, { z10.b }, z26.b
	tbl	z22.b, { z14.b }, z22.b
	tbl	z26.b, { z14.b }, z26.b
	tbl	z14.b, { z13.b }, z21.b
	tbl	z13.b, { z13.b }, z20.b
	tbl	z21.b, { z9.b }, z21.b
	tbl	z20.b, { z9.b }, z20.b
	eor3	z29.d, z29.d, z30.d, z28.d
	ldr	z28, [sp, #4, mul vl]           // 16-byte Folded Reload
	ldr	z30, [sp, #2, mul vl]           // 16-byte Folded Reload
	ldr	z9, [sp, #1, mul vl]            // 16-byte Folded Reload
	eor3	z4.d, z4.d, z10.d, z1.d
	eor3	z5.d, z5.d, z31.d, z8.d
	eor3	z7.d, z7.d, z15.d, z14.d
	eor3	z16.d, z16.d, z26.d, z24.d
	eor3	z17.d, z17.d, z27.d, z23.d
	eor3	z6.d, z6.d, z0.d, z13.d
	eor3	z18.d, z18.d, z22.d, z20.d
	eor3	z19.d, z19.d, z25.d, z21.d
	eor3	z28.d, z28.d, z30.d, z9.d
	b.ne	.LBB9_5
// %bb.6:                               //   in Loop: Header=BB9_3 Depth=1
	ldr	x18, [x4, #16]
	st1b	{ z16.b }, p1, [x18, x8]
	ldr	x18, [x4, #16]
	st1b	{ z17.b }, p2, [x18, x17]
	ldr	x18, [x4, #16]
	st1b	{ z18.b }, p4, [x18, x16]
	ldr	x18, [x4, #16]
	st1b	{ z19.b }, p3, [x18, x1]
	ldr	x18, [x4, #8]
	st1b	{ z4.b }, p1, [x18, x8]
	ldr	x18, [x4, #8]
	st1b	{ z5.b }, p2, [x18, x17]
	ldr	x18, [x4, #8]
	st1b	{ z6.b }, p4, [x18, x16]
	ldr	x18, [x4, #8]
	st1b	{ z7.b }, p3, [x18, x1]
	ldr	x18, [x4]
	st1b	{ z2.b }, p1, [x18, x8]
	incb	x8, all, mul #4
	ldr	x18, [x4]
	st1b	{ z3.b }, p2, [x18, x17]
	cmp	w0, w8
	ldr	x17, [x4]
	st1b	{ z29.b }, p4, [x17, x16]
	ldr	x16, [x4]
	st1b	{ z28.b }, p3, [x16, x1]
	b.gt	.LBB9_3
	b	.LBB9_10
.LBB9_7:
	movi	v0.2d, #0000000000000000
	mov	w9, w14
	mov	w10, w13
	mov	w11, w11
.LBB9_8:                                // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB9_10
// %bb.9:                               //   in Loop: Header=BB9_8 Depth=1
	ldr	x12, [x4, #16]
	add	x13, x11, x8
	add	x14, x10, x8
	whilelt	p3.b, w13, w0
	add	x15, x9, x8
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
	b.gt	.LBB9_8
.LBB9_10:
	addvl	sp, sp, #5
	ldp	x20, x19, [sp, #80]             // 16-byte Folded Reload
	ldr	x29, [sp, #64]                  // 8-byte Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #96             // 16-byte Folded Reload
.LBB9_11:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB10_11
// %bb.1:
	stp	d15, d14, [sp, #-112]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	str	x29, [sp, #64]                  // 8-byte Spill
	stp	x22, x21, [sp, #80]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #96]             // 16-byte Folded Spill
	addvl	sp, sp, #-10
	cmp	w1, #0
	rdvl	x11, #1
	rdvl	x14, #2
	rdvl	x15, #3
	mov	x8, xzr
	b.le	.LBB10_7
// %bb.2:
	add	w12, w1, w1, lsl #1
	mov	w9, w11
	lsl	w10, w1, #6
	ubfiz	x13, x1, #5, #32
	ptrue	p0.b
	mov	w14, w14
	lsl	w11, w12, #5
	lsl	w12, w1, #5
	mov	w15, w15
	mov	w16, #16                        // =0x10
.LBB10_3:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB10_5 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB10_10
// %bb.4:                               //   in Loop: Header=BB10_3 Depth=1
	movi	v4.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	add	x17, x8, x9
	movi	v2.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	add	x18, x8, x14
	movi	v7.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	add	x1, x8, x15
	movi	v17.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	mov	x5, xzr
	movi	v6.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	mov	x6, x3
	movi	v18.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	mov	w7, w12
	movi	v5.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	w19, w10
	movi	v20.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	mov	w20, w11
	whilelt	p2.b, w17, w0
	str	z0, [sp, #9, mul vl]            // 16-byte Folded Spill
	whilelt	p4.b, w18, w0
	whilelt	p3.b, w1, w0
.LBB10_5:                               //   Parent Loop BB10_3 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x21, [x6], #8
	sxtw	x22, w5
	str	z19, [sp, #6, mul vl]           // 16-byte Folded Spill
	add	x5, x5, #32
	ld1b	{ z24.b }, p3/z, [x21, x1]
	ld1b	{ z25.b }, p1/z, [x21, x8]
	ld1b	{ z31.b }, p4/z, [x21, x18]
	ld1b	{ z30.b }, p2/z, [x21, x17]
	add	x21, x2, x22
	ld1b	{ z8.b }, p0/z, [x2, x22]
	ld1b	{ z9.b }, p0/z, [x21, x16]
	sxtw	x21, w7
	str	z1, [sp, #8, mul vl]            // 16-byte Folded Spill
	movprfx	z27, z24
	and	z27.b, z27.b, #0xf
	lsr	z24.b, z24.b, #4
	movprfx	z29, z31
	and	z29.b, z29.b, #0xf
	ld1b	{ z0.b }, p0/z, [x2, x21]
	add	x22, x2, x21
	movprfx	z28, z30
	and	z28.b, z28.b, #0xf
	ld1b	{ z1.b }, p0/z, [x22, x16]
	lsr	z30.b, z30.b, #4
	lsr	z31.b, z31.b, #4
	str	z20, [sp, #5, mul vl]           // 16-byte Folded Spill
	mov	z20.d, z2.d
	movprfx	z26, z25
	and	z26.b, z26.b, #0xf
	tbl	z19.b, { z0.b }, z27.b
	str	z3, [sp, #7, mul vl]            // 16-byte Folded Spill
	tbl	z2.b, { z8.b }, z28.b
	tbl	z3.b, { z9.b }, z30.b
	lsr	z25.b, z25.b, #4
	tbl	z14.b, { z8.b }, z29.b
	tbl	z11.b, { z9.b }, z31.b
	tbl	z12.b, { z8.b }, z27.b
	tbl	z13.b, { z9.b }, z24.b
	tbl	z15.b, { z8.b }, z26.b
	sxtw	x21, w19
	mov	z8.d, z16.d
	str	z19, [sp, #4, mul vl]           // 16-byte Folded Spill
	tbl	z19.b, { z1.b }, z24.b
	tbl	z10.b, { z9.b }, z25.b
	eor3	z7.d, z7.d, z2.d, z3.d
	tbl	z3.b, { z0.b }, z28.b
	add	x22, x2, x21
	eor3	z6.d, z6.d, z14.d, z11.d
	ld1b	{ z2.b }, p0/z, [x2, x21]
	ld1b	{ z11.b }, p0/z, [x22, x16]
	eor3	z5.d, z5.d, z12.d, z13.d
	sxtw	x21, w20
	mov	z16.d, z22.d
	str	z19, [sp, #3, mul vl]           // 16-byte Folded Spill
	tbl	z19.b, { z0.b }, z29.b
	eor3	z4.d, z4.d, z15.d, z10.d
	str	z3, [sp]                        // 16-byte Folded Spill
	tbl	z10.b, { z1.b }, z30.b
	tbl	z3.b, { z0.b }, z26.b
	tbl	z13.b, { z2.b }, z27.b
	tbl	z14.b, { z2.b }, z29.b
	tbl	z15.b, { z2.b }, z28.b
	tbl	z2.b, { z2.b }, z26.b
	mov	z0.d, z21.d
	mov	z21.d, z17.d
	str	z19, [sp, #2, mul vl]           // 16-byte Folded Spill
	tbl	z19.b, { z1.b }, z31.b
	tbl	z1.b, { z1.b }, z25.b
	mov	z17.d, z6.d
	tbl	z6.b, { z11.b }, z25.b
	ld1b	{ z12.b }, p0/z, [x2, x21]
	add	x21, x2, x21
	mov	z9.d, z5.d
	mov	z22.d, z18.d
	ld1b	{ z5.b }, p0/z, [x21, x16]
	mov	z18.d, z7.d
	mov	z7.d, z4.d
	str	z19, [sp, #1, mul vl]           // 16-byte Folded Spill
	ldr	z19, [sp, #9, mul vl]           // 16-byte Folded Reload
	tbl	z4.b, { z11.b }, z30.b
	eor3	z20.d, z20.d, z2.d, z6.d
	tbl	z27.b, { z12.b }, z27.b
	tbl	z29.b, { z12.b }, z29.b
	tbl	z28.b, { z12.b }, z28.b
	tbl	z26.b, { z12.b }, z26.b
	tbl	z12.b, { z11.b }, z24.b
	eor3	z19.d, z19.d, z3.d, z1.d
	ldr	z1, [sp, #8, mul vl]            // 16-byte Folded Reload
	ldr	z3, [sp]                        // 16-byte Folded Reload
	tbl	z11.b, { z11.b }, z31.b
	tbl	z25.b, { z5.b }, z25.b
	tbl	z24.b, { z5.b }, z24.b
	tbl	z31.b, { z5.b }, z31.b
	tbl	z5.b, { z5.b }, z30.b
	ldr	z30, [sp, #2, mul vl]           // 16-byte Folded Reload
	eor3	z1.d, z1.d, z3.d, z10.d
	ldr	z3, [sp, #7, mul vl]            // 16-byte Folded Reload
	ldr	z10, [sp, #1, mul vl]           // 16-byte Folded Reload
	mov	z6.d, z17.d
	mov	z17.d, z21.d
	str	z19, [sp, #9, mul vl]           // 16-byte Folded Spill
	ldr	z19, [sp, #6, mul vl]           // 16-byte Folded Reload
	mov	z2.d, z20.d
	ldr	z20, [sp, #5, mul vl]           // 16-byte Folded Reload
	eor3	z3.d, z3.d, z30.d, z10.d
	ldr	z30, [sp, #4, mul vl]           // 16-byte Folded Reload
	ldr	z10, [sp, #3, mul vl]           // 16-byte Folded Reload
	mov	z21.d, z0.d
	eor3	z17.d, z17.d, z15.d, z4.d
	mov	z4.d, z7.d
	mov	z7.d, z18.d
	mov	z18.d, z22.d
	mov	z22.d, z16.d
	mov	z16.d, z8.d
	eor3	z19.d, z19.d, z30.d, z10.d
	eor3	z20.d, z20.d, z13.d, z12.d
	eor3	z21.d, z21.d, z26.d, z25.d
	eor3	z23.d, z23.d, z27.d, z24.d
	cmp	x13, x5
	eor3	z18.d, z18.d, z14.d, z11.d
	eor3	z22.d, z22.d, z28.d, z5.d
	mov	z5.d, z9.d
	eor3	z16.d, z16.d, z29.d, z31.d
	add	w20, w20, #32
	add	w19, w19, #32
	add	w7, w7, #32
	b.ne	.LBB10_5
// %bb.6:                               //   in Loop: Header=BB10_3 Depth=1
	ldr	x5, [x4, #24]
	ldr	z0, [sp, #9, mul vl]            // 16-byte Folded Reload
	st1b	{ z21.b }, p1, [x5, x8]
	ldr	x5, [x4, #24]
	st1b	{ z22.b }, p2, [x5, x17]
	ldr	x5, [x4, #24]
	st1b	{ z16.b }, p4, [x5, x18]
	ldr	x5, [x4, #24]
	st1b	{ z23.b }, p3, [x5, x1]
	ldr	x5, [x4, #16]
	st1b	{ z2.b }, p1, [x5, x8]
	ldr	x5, [x4, #16]
	st1b	{ z17.b }, p2, [x5, x17]
	ldr	x5, [x4, #16]
	st1b	{ z18.b }, p4, [x5, x18]
	ldr	x5, [x4, #16]
	st1b	{ z20.b }, p3, [x5, x1]
	ldr	x5, [x4, #8]
	st1b	{ z0.b }, p1, [x5, x8]
	ldr	x5, [x4, #8]
	st1b	{ z1.b }, p2, [x5, x17]
	ldr	x5, [x4, #8]
	st1b	{ z3.b }, p4, [x5, x18]
	ldr	x5, [x4, #8]
	st1b	{ z19.b }, p3, [x5, x1]
	ldr	x5, [x4]
	st1b	{ z4.b }, p1, [x5, x8]
	incb	x8, all, mul #4
	ldr	x5, [x4]
	st1b	{ z7.b }, p2, [x5, x17]
	cmp	w0, w8
	ldr	x17, [x4]
	st1b	{ z6.b }, p4, [x17, x18]
	ldr	x17, [x4]
	st1b	{ z5.b }, p3, [x17, x1]
	b.gt	.LBB10_3
	b	.LBB10_10
.LBB10_7:
	movi	v0.2d, #0000000000000000
	mov	w9, w15
	mov	w10, w14
	mov	w11, w11
.LBB10_8:                               // =>This Inner Loop Header: Depth=1
	whilelt	p0.b, w8, w0
	b.eq	.LBB10_10
// %bb.9:                               //   in Loop: Header=BB10_8 Depth=1
	ldr	x12, [x4, #24]
	add	x13, x11, x8
	add	x14, x10, x8
	whilelt	p3.b, w13, w0
	add	x15, x9, x8
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
	b.gt	.LBB10_8
.LBB10_10:
	addvl	sp, sp, #10
	ldp	x20, x19, [sp, #96]             // 16-byte Folded Reload
	ldr	x29, [sp, #64]                  // 8-byte Reload
	ldp	x22, x21, [sp, #80]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #112            // 16-byte Folded Reload
.LBB10_11:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB11_9
// %bb.1:
	stp	d15, d14, [sp, #-128]!          // 16-byte Folded Spill
	stp	d13, d12, [sp, #16]             // 16-byte Folded Spill
	stp	d11, d10, [sp, #32]             // 16-byte Folded Spill
	stp	d9, d8, [sp, #48]               // 16-byte Folded Spill
	stp	x29, x25, [sp, #64]             // 16-byte Folded Spill
	stp	x24, x23, [sp, #80]             // 16-byte Folded Spill
	stp	x22, x21, [sp, #96]             // 16-byte Folded Spill
	stp	x20, x19, [sp, #112]            // 16-byte Folded Spill
	addvl	sp, sp, #-13
	add	w12, w1, w1, lsl #1
	lsl	w10, w1, #6
	lsl	w11, w1, #7
	lsl	w13, w1, #5
	ubfiz	x14, x1, #5, #32
	ptrue	p0.b
	lsl	w12, w12, #5
	mov	x8, xzr
	rdvl	x9, #1
	rdvl	x15, #2
	rdvl	x16, #3
	mov	w17, #16                        // =0x10
	b	.LBB11_4
.LBB11_2:                               //   in Loop: Header=BB11_4 Depth=1
	movi	v7.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v15.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
.LBB11_3:                               //   in Loop: Header=BB11_4 Depth=1
	ldr	x7, [x4, #32]
	st1b	{ z18.b }, p1, [x7, x8]
	ldr	x7, [x4, #32]
	st1b	{ z17.b }, p4, [x7, x6]
	ldr	x7, [x4, #32]
	st1b	{ z16.b }, p3, [x7, x5]
	ldr	x7, [x4, #32]
	st1b	{ z7.b }, p2, [x7, x18]
	ldr	x7, [x4, #24]
	st1b	{ z5.b }, p1, [x7, x8]
	ldr	x7, [x4, #24]
	st1b	{ z4.b }, p4, [x7, x6]
	ldr	x7, [x4, #24]
	st1b	{ z3.b }, p3, [x7, x5]
	ldr	x7, [x4, #24]
	st1b	{ z0.b }, p2, [x7, x18]
	ldr	x7, [x4, #16]
	st1b	{ z15.b }, p1, [x7, x8]
	ldr	x7, [x4, #16]
	st1b	{ z6.b }, p4, [x7, x6]
	ldr	x7, [x4, #16]
	st1b	{ z2.b }, p3, [x7, x5]
	ldr	x7, [x4, #16]
	st1b	{ z1.b }, p2, [x7, x18]
	ldr	x7, [x4, #8]
	st1b	{ z27.b }, p1, [x7, x8]
	ldr	x7, [x4, #8]
	st1b	{ z26.b }, p4, [x7, x6]
	ldr	x7, [x4, #8]
	st1b	{ z25.b }, p3, [x7, x5]
	ldr	x7, [x4, #8]
	st1b	{ z24.b }, p2, [x7, x18]
	ldr	x7, [x4]
	st1b	{ z23.b }, p1, [x7, x8]
	incb	x8, all, mul #4
	ldr	x7, [x4]
	st1b	{ z22.b }, p4, [x7, x6]
	cmp	w0, w8
	ldr	x6, [x4]
	st1b	{ z21.b }, p3, [x6, x5]
	ldr	x5, [x4]
	st1b	{ z20.b }, p2, [x5, x18]
	b.le	.LBB11_8
.LBB11_4:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB11_7 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB11_8
// %bb.5:                               //   in Loop: Header=BB11_4 Depth=1
	add	x6, x8, x9
	add	x5, x8, x15
	add	x18, x8, x16
	whilelt	p4.b, w6, w0
	whilelt	p3.b, w5, w0
	whilelt	p2.b, w18, w0
	cmp	w1, #1
	b.lt	.LBB11_2
// %bb.6:                               //   in Loop: Header=BB11_4 Depth=1
	movi	v23.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	mov	x7, xzr
	movi	v15.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	x19, x3
	movi	v18.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	mov	w20, w13
	movi	v26.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	mov	w21, w10
	movi	v4.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	mov	w22, w12
	movi	v21.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	mov	w23, w11
	movi	v2.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
.LBB11_7:                               //   Parent Loop BB11_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x24, [x19], #8
	sxtw	x25, w7
	str	z5, [sp, #10, mul vl]           // 16-byte Folded Spill
	add	x7, x7, #32
	ld1b	{ z29.b }, p1/z, [x24, x8]
	ld1b	{ z10.b }, p3/z, [x24, x5]
	ld1b	{ z30.b }, p2/z, [x24, x18]
	ld1b	{ z9.b }, p4/z, [x24, x6]
	add	x24, x2, x25
	ld1b	{ z12.b }, p0/z, [x2, x25]
	ld1b	{ z13.b }, p0/z, [x24, x17]
	sxtw	x25, w20
	str	z4, [sp, #5, mul vl]            // 16-byte Folded Spill
	movprfx	z28, z29
	and	z28.b, z28.b, #0xf
	lsr	z29.b, z29.b, #4
	movprfx	z8, z30
	and	z8.b, z8.b, #0xf
	lsr	z30.b, z30.b, #4
	movprfx	z31, z10
	and	z31.b, z31.b, #0xf
	lsr	z10.b, z10.b, #4
	add	x24, x2, x25
	str	z15, [sp, #8, mul vl]           // 16-byte Folded Spill
	movprfx	z11, z9
	and	z11.b, z11.b, #0xf
	tbl	z4.b, { z12.b }, z28.b
	tbl	z5.b, { z13.b }, z29.b
	str	z2, [sp, #12, mul vl]           // 16-byte Folded Spill
	lsr	z9.b, z9.b, #4
	ld1b	{ z15.b }, p0/z, [x2, x25]
	ld1b	{ z2.b }, p0/z, [x24, x17]
	str	z0, [sp, #7, mul vl]            // 16-byte Folded Spill
	tbl	z14.b, { z12.b }, z8.b
	tbl	z0.b, { z13.b }, z30.b
	sxtw	x24, w21
	str	z3, [sp, #6, mul vl]            // 16-byte Folded Spill
	tbl	z3.b, { z13.b }, z10.b
	str	z1, [sp, #9, mul vl]            // 16-byte Folded Spill
	tbl	z1.b, { z12.b }, z31.b
	tbl	z12.b, { z12.b }, z11.b
	str	z18, [sp, #1, mul vl]           // 16-byte Folded Spill
	tbl	z13.b, { z13.b }, z9.b
	tbl	z18.b, { z15.b }, z28.b
	str	z17, [sp, #2, mul vl]           // 16-byte Folded Spill
	tbl	z17.b, { z2.b }, z9.b
	tbl	z19.b, { z2.b }, z29.b
	str	z16, [sp, #3, mul vl]           // 16-byte Folded Spill
	tbl	z16.b, { z15.b }, z11.b
	eor3	z23.d, z23.d, z4.d, z5.d
	str	z7, [sp, #4, mul vl]            // 16-byte Folded Spill
	tbl	z7.b, { z2.b }, z10.b
	tbl	z2.b, { z2.b }, z30.b
	str	z6, [sp, #11, mul vl]           // 16-byte Folded Spill
	tbl	z6.b, { z15.b }, z31.b
	tbl	z15.b, { z15.b }, z8.b
	add	x25, x2, x24
	ld1b	{ z4.b }, p0/z, [x2, x24]
	sxtw	x24, w22
	eor3	z20.d, z20.d, z14.d, z0.d
	ld1b	{ z0.b }, p0/z, [x25, x17]
	eor3	z21.d, z21.d, z1.d, z3.d
	add	x25, x2, x24
	ld1b	{ z5.b }, p0/z, [x2, x24]
	sxtw	x24, w23
	tbl	z1.b, { z4.b }, z8.b
	eor3	z22.d, z22.d, z12.d, z13.d
	eor3	z27.d, z27.d, z18.d, z19.d
	eor3	z26.d, z26.d, z16.d, z17.d
	eor3	z25.d, z25.d, z6.d, z7.d
	eor3	z24.d, z24.d, z15.d, z2.d
	ld1b	{ z17.b }, p0/z, [x2, x24]
	add	x24, x2, x24
	ld1b	{ z16.b }, p0/z, [x25, x17]
	ld1b	{ z15.b }, p0/z, [x24, x17]
	tbl	z2.b, { z4.b }, z31.b
	tbl	z6.b, { z4.b }, z11.b
	str	z1, [sp]                        // 16-byte Folded Spill
	tbl	z4.b, { z4.b }, z28.b
	tbl	z1.b, { z0.b }, z29.b
	tbl	z12.b, { z0.b }, z30.b
	tbl	z3.b, { z0.b }, z10.b
	tbl	z7.b, { z0.b }, z9.b
	tbl	z18.b, { z5.b }, z8.b
	tbl	z19.b, { z5.b }, z31.b
	tbl	z13.b, { z5.b }, z11.b
	tbl	z14.b, { z16.b }, z9.b
	tbl	z5.b, { z5.b }, z28.b
	mov	z0.d, z27.d
	mov	z27.d, z26.d
	mov	z26.d, z25.d
	mov	z25.d, z24.d
	mov	z24.d, z23.d
	mov	z23.d, z22.d
	mov	z22.d, z21.d
	mov	z21.d, z20.d
	tbl	z20.b, { z16.b }, z29.b
	tbl	z8.b, { z17.b }, z8.b
	tbl	z31.b, { z17.b }, z31.b
	tbl	z11.b, { z17.b }, z11.b
	tbl	z17.b, { z17.b }, z28.b
	tbl	z28.b, { z16.b }, z30.b
	tbl	z16.b, { z16.b }, z10.b
	tbl	z29.b, { z15.b }, z29.b
	tbl	z30.b, { z15.b }, z30.b
	tbl	z10.b, { z15.b }, z10.b
	tbl	z9.b, { z15.b }, z9.b
	ldr	z15, [sp, #8, mul vl]           // 16-byte Folded Reload
	add	w23, w23, #32
	cmp	x14, x7
	add	w22, w22, #32
	add	w21, w21, #32
	add	w20, w20, #32
	eor3	z15.d, z15.d, z4.d, z1.d
	ldr	z4, [sp, #11, mul vl]           // 16-byte Folded Reload
	ldr	z1, [sp, #9, mul vl]            // 16-byte Folded Reload
	eor3	z4.d, z4.d, z6.d, z7.d
	ldr	z7, [sp]                        // 16-byte Folded Reload
	eor3	z1.d, z1.d, z7.d, z12.d
	ldr	z7, [sp, #10, mul vl]           // 16-byte Folded Reload
	str	z4, [sp, #11, mul vl]           // 16-byte Folded Spill
	ldr	z4, [sp, #12, mul vl]           // 16-byte Folded Reload
	ldr	z6, [sp, #11, mul vl]           // 16-byte Folded Reload
	eor3	z7.d, z7.d, z5.d, z20.d
	mov	z20.d, z21.d
	mov	z21.d, z22.d
	mov	z22.d, z23.d
	mov	z23.d, z24.d
	mov	z24.d, z25.d
	mov	z25.d, z26.d
	mov	z26.d, z27.d
	mov	z27.d, z0.d
	ldr	z0, [sp, #7, mul vl]            // 16-byte Folded Reload
	eor3	z4.d, z4.d, z2.d, z3.d
	ldr	z3, [sp, #6, mul vl]            // 16-byte Folded Reload
	str	z7, [sp, #10, mul vl]           // 16-byte Folded Spill
	ldr	z7, [sp, #4, mul vl]            // 16-byte Folded Reload
	ldr	z5, [sp, #10, mul vl]           // 16-byte Folded Reload
	eor3	z0.d, z0.d, z18.d, z28.d
	ldr	z18, [sp, #1, mul vl]           // 16-byte Folded Reload
	eor3	z3.d, z3.d, z19.d, z16.d
	str	z4, [sp, #12, mul vl]           // 16-byte Folded Spill
	ldr	z4, [sp, #5, mul vl]            // 16-byte Folded Reload
	ldr	z16, [sp, #3, mul vl]           // 16-byte Folded Reload
	eor3	z7.d, z7.d, z8.d, z30.d
	ldr	z2, [sp, #12, mul vl]           // 16-byte Folded Reload
	eor3	z18.d, z18.d, z17.d, z29.d
	ldr	z17, [sp, #2, mul vl]           // 16-byte Folded Reload
	eor3	z4.d, z4.d, z13.d, z14.d
	eor3	z16.d, z16.d, z31.d, z10.d
	eor3	z17.d, z17.d, z11.d, z9.d
	b.ne	.LBB11_7
	b	.LBB11_3
.LBB11_8:
	addvl	sp, sp, #13
	ldp	x20, x19, [sp, #112]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #96]             // 16-byte Folded Reload
	ldp	x24, x23, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x25, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #128            // 16-byte Folded Reload
.LBB11_9:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB12_9
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
	addvl	sp, sp, #-17
	add	w12, w1, w1, lsl #2
	add	w13, w1, w1, lsl #1
	lsl	w10, w1, #6
	lsl	w11, w1, #7
	lsl	w14, w1, #5
	ubfiz	x15, x1, #5, #32
	lsl	w12, w12, #5
	lsl	w13, w13, #5
	ptrue	p0.b
	mov	x8, xzr
	rdvl	x9, #1
	rdvl	x16, #2
	rdvl	x17, #3
	mov	w18, #16                        // =0x10
	b	.LBB12_4
.LBB12_2:                               //   in Loop: Header=BB12_4 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	movi	v30.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
.LBB12_3:                               //   in Loop: Header=BB12_4 Depth=1
	ldr	x19, [x4, #40]
	st1b	{ z18.b }, p1, [x19, x8]
	ldr	x19, [x4, #40]
	st1b	{ z17.b }, p4, [x19, x7]
	ldr	x19, [x4, #40]
	st1b	{ z16.b }, p3, [x19, x6]
	ldr	x19, [x4, #40]
	st1b	{ z6.b }, p2, [x19, x5]
	ldr	x19, [x4, #32]
	st1b	{ z5.b }, p1, [x19, x8]
	ldr	x19, [x4, #32]
	st1b	{ z4.b }, p4, [x19, x7]
	ldr	x19, [x4, #32]
	st1b	{ z2.b }, p3, [x19, x6]
	ldr	x19, [x4, #32]
	st1b	{ z0.b }, p2, [x19, x5]
	ldr	x19, [x4, #24]
	st1b	{ z8.b }, p1, [x19, x8]
	ldr	x19, [x4, #24]
	st1b	{ z7.b }, p4, [x19, x7]
	ldr	x19, [x4, #24]
	st1b	{ z3.b }, p3, [x19, x6]
	ldr	x19, [x4, #24]
	st1b	{ z1.b }, p2, [x19, x5]
	ldr	x19, [x4, #16]
	st1b	{ z27.b }, p1, [x19, x8]
	ldr	x19, [x4, #16]
	st1b	{ z26.b }, p4, [x19, x7]
	ldr	x19, [x4, #16]
	st1b	{ z25.b }, p3, [x19, x6]
	ldr	x19, [x4, #16]
	st1b	{ z31.b }, p2, [x19, x5]
	ldr	x19, [x4, #8]
	st1b	{ z30.b }, p1, [x19, x8]
	ldr	x19, [x4, #8]
	st1b	{ z28.b }, p4, [x19, x7]
	ldr	x19, [x4, #8]
	st1b	{ z29.b }, p3, [x19, x6]
	ldr	x19, [x4, #8]
	st1b	{ z24.b }, p2, [x19, x5]
	ldr	x19, [x4]
	st1b	{ z23.b }, p1, [x19, x8]
	incb	x8, all, mul #4
	ldr	x19, [x4]
	st1b	{ z22.b }, p4, [x19, x7]
	cmp	w0, w8
	ldr	x7, [x4]
	st1b	{ z21.b }, p3, [x7, x6]
	ldr	x6, [x4]
	st1b	{ z20.b }, p2, [x6, x5]
	b.le	.LBB12_8
.LBB12_4:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB12_7 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB12_8
// %bb.5:                               //   in Loop: Header=BB12_4 Depth=1
	add	x7, x8, x9
	add	x6, x8, x16
	add	x5, x8, x17
	whilelt	p4.b, w7, w0
	whilelt	p3.b, w6, w0
	whilelt	p2.b, w5, w0
	cmp	w1, #1
	b.lt	.LBB12_2
// %bb.6:                               //   in Loop: Header=BB12_4 Depth=1
	movi	v6.2d, #0000000000000000
	movi	v23.2d, #0000000000000000
	mov	x19, xzr
	movi	v30.2d, #0000000000000000
	movi	v27.2d, #0000000000000000
	mov	x20, x3
	movi	v8.2d, #0000000000000000
	movi	v5.2d, #0000000000000000
	mov	w21, w14
	movi	v18.2d, #0000000000000000
	movi	v22.2d, #0000000000000000
	mov	w22, w10
	movi	v28.2d, #0000000000000000
	movi	v26.2d, #0000000000000000
	mov	w23, w13
	movi	v7.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	mov	w24, w11
	movi	v17.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	mov	w25, w12
	movi	v29.2d, #0000000000000000
	movi	v25.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v24.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	movi	v0.2d, #0000000000000000
.LBB12_7:                               //   Parent Loop BB12_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x26, [x20], #8
	str	z0, [sp, #6, mul vl]            // 16-byte Folded Spill
	str	z8, [sp, #7, mul vl]            // 16-byte Folded Spill
	sxtw	x27, w19
	add	x19, x19, #32
	ld1b	{ z0.b }, p1/z, [x26, x8]
	ld1b	{ z8.b }, p4/z, [x26, x7]
	ld1b	{ z12.b }, p3/z, [x26, x6]
	ld1b	{ z13.b }, p2/z, [x26, x5]
	add	x26, x2, x27
	str	z2, [sp, #5, mul vl]            // 16-byte Folded Spill
	str	z1, [sp, #8, mul vl]            // 16-byte Folded Spill
	ld1b	{ z1.b }, p0/z, [x2, x27]
	cmp	x15, x19
	movprfx	z9, z0
	and	z9.b, z9.b, #0xf
	movprfx	z10, z8
	and	z10.b, z10.b, #0xf
	lsr	z8.b, z8.b, #4
	ld1b	{ z2.b }, p0/z, [x26, x18]
	lsr	z11.b, z0.b, #4
	movprfx	z14, z12
	and	z14.b, z14.b, #0xf
	lsr	z12.b, z12.b, #4
	movprfx	z15, z13
	and	z15.b, z15.b, #0xf
	lsr	z13.b, z13.b, #4
	sxtw	x26, w21
	str	z16, [sp, #1, mul vl]           // 16-byte Folded Spill
	tbl	z0.b, { z1.b }, z10.b
	str	z5, [sp, #3, mul vl]            // 16-byte Folded Spill
	tbl	z5.b, { z2.b }, z11.b
	add	w21, w21, #32
	str	z4, [sp, #4, mul vl]            // 16-byte Folded Spill
	tbl	z4.b, { z1.b }, z9.b
	tbl	z16.b, { z2.b }, z12.b
	str	z7, [sp, #15, mul vl]           // 16-byte Folded Spill
	tbl	z7.b, { z1.b }, z14.b
	tbl	z1.b, { z1.b }, z15.b
	str	z3, [sp, #16, mul vl]           // 16-byte Folded Spill
	tbl	z3.b, { z2.b }, z8.b
	tbl	z2.b, { z2.b }, z13.b
	add	x27, x2, x26
	str	z17, [sp]                       // 16-byte Folded Spill
	str	z6, [sp, #2, mul vl]            // 16-byte Folded Spill
	ld1b	{ z6.b }, p0/z, [x2, x26]
	ld1b	{ z17.b }, p0/z, [x27, x18]
	sxtw	x26, w22
	eor3	z23.d, z23.d, z4.d, z5.d
	eor3	z21.d, z21.d, z7.d, z16.d
	eor3	z22.d, z22.d, z0.d, z3.d
	eor3	z20.d, z20.d, z1.d, z2.d
	str	z18, [sp, #14, mul vl]          // 16-byte Folded Spill
	add	x27, x2, x26
	ld1b	{ z0.b }, p0/z, [x2, x26]
	tbl	z4.b, { z6.b }, z9.b
	ld1b	{ z2.b }, p0/z, [x27, x18]
	tbl	z5.b, { z17.b }, z11.b
	tbl	z18.b, { z6.b }, z15.b
	tbl	z1.b, { z6.b }, z14.b
	tbl	z3.b, { z17.b }, z12.b
	tbl	z6.b, { z6.b }, z10.b
	tbl	z7.b, { z17.b }, z8.b
	sxtw	x26, w23
	tbl	z19.b, { z17.b }, z13.b
	str	z23, [sp, #13, mul vl]          // 16-byte Folded Spill
	tbl	z16.b, { z0.b }, z14.b
	tbl	z17.b, { z2.b }, z12.b
	str	z22, [sp, #10, mul vl]          // 16-byte Folded Spill
	tbl	z22.b, { z0.b }, z9.b
	tbl	z23.b, { z2.b }, z11.b
	str	z21, [sp, #11, mul vl]          // 16-byte Folded Spill
	tbl	z21.b, { z2.b }, z8.b
	eor3	z30.d, z30.d, z4.d, z5.d
	str	z20, [sp, #12, mul vl]          // 16-byte Folded Spill
	tbl	z20.b, { z0.b }, z10.b
	tbl	z0.b, { z0.b }, z15.b
	tbl	z2.b, { z2.b }, z13.b
	add	x27, x2, x26
	ld1b	{ z4.b }, p0/z, [x2, x26]
	sxtw	x26, w24
	eor3	z28.d, z28.d, z6.d, z7.d
	eor3	z29.d, z29.d, z1.d, z3.d
	ld1b	{ z1.b }, p0/z, [x27, x18]
	eor3	z27.d, z27.d, z22.d, z23.d
	eor3	z25.d, z25.d, z16.d, z17.d
	add	x27, x2, x26
	ld1b	{ z6.b }, p0/z, [x2, x26]
	sxtw	x26, w25
	eor3	z26.d, z26.d, z20.d, z21.d
	eor3	z24.d, z24.d, z18.d, z19.d
	eor3	z31.d, z31.d, z0.d, z2.d
	ld1b	{ z18.b }, p0/z, [x2, x26]
	add	x26, x2, x26
	ld1b	{ z17.b }, p0/z, [x27, x18]
	ld1b	{ z23.b }, p0/z, [x26, x18]
	str	z27, [sp, #9, mul vl]           // 16-byte Folded Spill
	tbl	z2.b, { z1.b }, z13.b
	tbl	z3.b, { z4.b }, z14.b
	tbl	z5.b, { z1.b }, z12.b
	tbl	z7.b, { z4.b }, z10.b
	mov	z27.d, z26.d
	mov	z26.d, z25.d
	tbl	z25.b, { z4.b }, z15.b
	tbl	z16.b, { z1.b }, z8.b
	tbl	z4.b, { z4.b }, z9.b
	tbl	z1.b, { z1.b }, z11.b
	tbl	z19.b, { z6.b }, z15.b
	tbl	z20.b, { z6.b }, z14.b
	tbl	z21.b, { z6.b }, z10.b
	tbl	z22.b, { z17.b }, z8.b
	tbl	z6.b, { z6.b }, z9.b
	mov	z0.d, z31.d
	mov	z31.d, z30.d
	mov	z30.d, z28.d
	mov	z28.d, z29.d
	mov	z29.d, z24.d
	tbl	z24.b, { z17.b }, z11.b
	tbl	z15.b, { z18.b }, z15.b
	tbl	z14.b, { z18.b }, z14.b
	tbl	z10.b, { z18.b }, z10.b
	tbl	z18.b, { z18.b }, z9.b
	tbl	z9.b, { z17.b }, z13.b
	tbl	z17.b, { z17.b }, z12.b
	tbl	z11.b, { z23.b }, z11.b
	tbl	z13.b, { z23.b }, z13.b
	tbl	z12.b, { z23.b }, z12.b
	tbl	z23.b, { z23.b }, z8.b
	ldr	z8, [sp, #7, mul vl]            // 16-byte Folded Reload
	add	w25, w25, #32
	add	w24, w24, #32
	add	w23, w23, #32
	add	w22, w22, #32
	eor3	z8.d, z8.d, z4.d, z1.d
	ldr	z4, [sp, #15, mul vl]           // 16-byte Folded Reload
	ldr	z1, [sp, #8, mul vl]            // 16-byte Folded Reload
	eor3	z4.d, z4.d, z7.d, z16.d
	eor3	z1.d, z1.d, z25.d, z2.d
	ldr	z2, [sp, #5, mul vl]            // 16-byte Folded Reload
	ldr	z16, [sp, #1, mul vl]           // 16-byte Folded Reload
	mov	z25.d, z26.d
	mov	z26.d, z27.d
	ldr	z27, [sp, #9, mul vl]           // 16-byte Folded Reload
	eor3	z2.d, z2.d, z20.d, z17.d
	ldr	z17, [sp]                       // 16-byte Folded Reload
	ldr	z20, [sp, #12, mul vl]          // 16-byte Folded Reload
	str	z4, [sp, #15, mul vl]           // 16-byte Folded Spill
	ldr	z4, [sp, #16, mul vl]           // 16-byte Folded Reload
	eor3	z16.d, z16.d, z14.d, z12.d
	ldr	z7, [sp, #15, mul vl]           // 16-byte Folded Reload
	eor3	z17.d, z17.d, z10.d, z23.d
	ldr	z23, [sp, #13, mul vl]          // 16-byte Folded Reload
	eor3	z4.d, z4.d, z3.d, z5.d
	ldr	z5, [sp, #3, mul vl]            // 16-byte Folded Reload
	eor3	z5.d, z5.d, z6.d, z24.d
	mov	z24.d, z29.d
	mov	z29.d, z28.d
	mov	z28.d, z30.d
	mov	z30.d, z31.d
	mov	z31.d, z0.d
	ldr	z0, [sp, #6, mul vl]            // 16-byte Folded Reload
	str	z4, [sp, #16, mul vl]           // 16-byte Folded Spill
	ldr	z4, [sp, #4, mul vl]            // 16-byte Folded Reload
	ldr	z6, [sp, #2, mul vl]            // 16-byte Folded Reload
	ldr	z3, [sp, #16, mul vl]           // 16-byte Folded Reload
	eor3	z0.d, z0.d, z19.d, z9.d
	ldr	z19, [sp, #14, mul vl]          // 16-byte Folded Reload
	eor3	z4.d, z4.d, z21.d, z22.d
	eor3	z6.d, z6.d, z15.d, z13.d
	ldr	z22, [sp, #10, mul vl]          // 16-byte Folded Reload
	ldr	z21, [sp, #11, mul vl]          // 16-byte Folded Reload
	eor3	z19.d, z19.d, z18.d, z11.d
	str	z19, [sp, #14, mul vl]          // 16-byte Folded Spill
	ldr	z18, [sp, #14, mul vl]          // 16-byte Folded Reload
	b.ne	.LBB12_7
	b	.LBB12_3
.LBB12_8:
	addvl	sp, sp, #17
	ldp	x20, x19, [sp, #128]            // 16-byte Folded Reload
	ldp	x22, x21, [sp, #112]            // 16-byte Folded Reload
	ldp	x24, x23, [sp, #96]             // 16-byte Folded Reload
	ldp	x26, x25, [sp, #80]             // 16-byte Folded Reload
	ldp	x29, x27, [sp, #64]             // 16-byte Folded Reload
	ldp	d9, d8, [sp, #48]               // 16-byte Folded Reload
	ldp	d11, d10, [sp, #32]             // 16-byte Folded Reload
	ldp	d13, d12, [sp, #16]             // 16-byte Folded Reload
	ldp	d15, d14, [sp], #144            // 16-byte Folded Reload
.LBB12_9:
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
                                        // kill: def $w1 killed $w1 def $x1
	b.lt	.LBB13_9
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
	addvl	sp, sp, #-23
	add	w14, w1, w1, lsl #1
	add	w13, w1, w1, lsl #2
	lsl	w10, w1, #6
	lsl	w11, w1, #7
	lsl	w15, w1, #5
	ubfiz	x16, x1, #5, #32
	lsl	w12, w14, #6
	lsl	w13, w13, #5
	lsl	w14, w14, #5
	ptrue	p0.b
	mov	x8, xzr
	rdvl	x9, #1
	rdvl	x17, #2
	rdvl	x18, #3
	mov	w5, #16                         // =0x10
	b	.LBB13_4
.LBB13_2:                               //   in Loop: Header=BB13_4 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	movi	v28.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v9.2d, #0000000000000000
	movi	v29.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	movi	v17.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	str	z0, [sp, #16, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	movi	v18.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	movi	v11.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	movi	v3.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	str	z0, [sp, #21, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #17, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #15, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #20, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #14, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #19, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #13, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #18, mul vl]           // 16-byte Folded Spill
.LBB13_3:                               //   in Loop: Header=BB13_4 Depth=1
	ldr	x20, [x4, #48]
	ldr	z0, [sp, #13, mul vl]           // 16-byte Folded Reload
	st1b	{ z21.b }, p1, [x20, x8]
	ldr	x20, [x4, #48]
	st1b	{ z20.b }, p4, [x20, x19]
	ldr	x20, [x4, #48]
	st1b	{ z2.b }, p3, [x20, x7]
	ldr	x20, [x4, #48]
	st1b	{ z1.b }, p2, [x20, x6]
	ldr	x20, [x4, #40]
	st1b	{ z18.b }, p1, [x20, x8]
	ldr	x20, [x4, #40]
	st1b	{ z17.b }, p4, [x20, x19]
	ldr	x20, [x4, #40]
	st1b	{ z16.b }, p3, [x20, x7]
	ldr	x20, [x4, #40]
	st1b	{ z3.b }, p2, [x20, x6]
	ldr	x20, [x4, #32]
	st1b	{ z19.b }, p1, [x20, x8]
	ldr	x20, [x4, #32]
	st1b	{ z7.b }, p4, [x20, x19]
	ldr	x20, [x4, #32]
	st1b	{ z6.b }, p3, [x20, x7]
	ldr	x20, [x4, #32]
	st1b	{ z4.b }, p2, [x20, x6]
	ldr	x20, [x4, #24]
	st1b	{ z0.b }, p1, [x20, x8]
	ldr	z0, [sp, #14, mul vl]           // 16-byte Folded Reload
	ldr	x20, [x4, #24]
	st1b	{ z0.b }, p4, [x20, x19]
	ldr	z0, [sp, #15, mul vl]           // 16-byte Folded Reload
	ldr	x20, [x4, #24]
	st1b	{ z0.b }, p3, [x20, x7]
	ldr	z0, [sp, #16, mul vl]           // 16-byte Folded Reload
	ldr	x20, [x4, #24]
	st1b	{ z0.b }, p2, [x20, x6]
	ldr	z0, [sp, #18, mul vl]           // 16-byte Folded Reload
	ldr	x20, [x4, #16]
	st1b	{ z0.b }, p1, [x20, x8]
	ldr	z0, [sp, #19, mul vl]           // 16-byte Folded Reload
	ldr	x20, [x4, #16]
	st1b	{ z0.b }, p4, [x20, x19]
	ldr	z0, [sp, #20, mul vl]           // 16-byte Folded Reload
	ldr	x20, [x4, #16]
	st1b	{ z0.b }, p3, [x20, x7]
	ldr	z0, [sp, #21, mul vl]           // 16-byte Folded Reload
	ldr	x20, [x4, #16]
	st1b	{ z0.b }, p2, [x20, x6]
	ldr	z0, [sp, #17, mul vl]           // 16-byte Folded Reload
	ldr	x20, [x4, #8]
	st1b	{ z11.b }, p1, [x20, x8]
	ldr	x20, [x4, #8]
	st1b	{ z10.b }, p4, [x20, x19]
	ldr	x20, [x4, #8]
	st1b	{ z9.b }, p3, [x20, x7]
	ldr	x20, [x4, #8]
	st1b	{ z0.b }, p2, [x20, x6]
	ldr	x20, [x4]
	st1b	{ z8.b }, p1, [x20, x8]
	incb	x8, all, mul #4
	ldr	x20, [x4]
	st1b	{ z31.b }, p4, [x20, x19]
	cmp	w0, w8
	ldr	x19, [x4]
	st1b	{ z29.b }, p3, [x19, x7]
	ldr	x7, [x4]
	st1b	{ z28.b }, p2, [x7, x6]
	b.le	.LBB13_8
.LBB13_4:                               // =>This Loop Header: Depth=1
                                        //     Child Loop BB13_7 Depth 2
	whilelt	p1.b, w8, w0
	b.eq	.LBB13_8
// %bb.5:                               //   in Loop: Header=BB13_4 Depth=1
	add	x19, x8, x9
	add	x7, x8, x17
	add	x6, x8, x18
	whilelt	p4.b, w19, w0
	whilelt	p3.b, w7, w0
	whilelt	p2.b, w6, w0
	cmp	w1, #1
	b.lt	.LBB13_2
// %bb.6:                               //   in Loop: Header=BB13_4 Depth=1
	movi	v0.2d, #0000000000000000
	movi	v1.2d, #0000000000000000
	mov	x20, xzr
	movi	v3.2d, #0000000000000000
	movi	v8.2d, #0000000000000000
	mov	x21, x3
	movi	v11.2d, #0000000000000000
	movi	v19.2d, #0000000000000000
	mov	w22, w15
	movi	v18.2d, #0000000000000000
	movi	v21.2d, #0000000000000000
	mov	w23, w10
	str	z0, [sp, #18, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v31.2d, #0000000000000000
	movi	v10.2d, #0000000000000000
	movi	v7.2d, #0000000000000000
	mov	w24, w14
	movi	v17.2d, #0000000000000000
	movi	v20.2d, #0000000000000000
	mov	w25, w11
	movi	v29.2d, #0000000000000000
	movi	v9.2d, #0000000000000000
	mov	w26, w13
	str	z0, [sp, #13, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	movi	v6.2d, #0000000000000000
	movi	v16.2d, #0000000000000000
	movi	v2.2d, #0000000000000000
	mov	w27, w12
	movi	v28.2d, #0000000000000000
	movi	v4.2d, #0000000000000000
	str	z0, [sp, #19, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #14, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #20, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #15, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #17, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #21, mul vl]           // 16-byte Folded Spill
	movi	v0.2d, #0000000000000000
	str	z0, [sp, #16, mul vl]           // 16-byte Folded Spill
.LBB13_7:                               //   Parent Loop BB13_4 Depth=1
                                        // =>  This Inner Loop Header: Depth=2
	ldr	x28, [x21], #8
	str	z1, [sp, #5, mul vl]            // 16-byte Folded Spill
	str	z4, [sp, #12, mul vl]           // 16-byte Folded Spill
	sxtw	x29, w20
	mov	z30.d, z29.d
	ld1b	{ z0.b }, p1/z, [x28, x8]
	ld1b	{ z1.b }, p2/z, [x28, x6]
	ld1b	{ z4.b }, p3/z, [x28, x7]
	str	z19, [sp, #9, mul vl]           // 16-byte Folded Spill
	ld1b	{ z5.b }, p0/z, [x2, x29]
	mov	z29.d, z28.d
	str	z6, [sp, #11, mul vl]           // 16-byte Folded Spill
	ldr	z28, [sp, #18, mul vl]          // 16-byte Folded Reload
	add	x20, x20, #32
	movprfx	z12, z0
	and	z12.b, z12.b, #0xf
	lsr	z13.b, z0.b, #4
	ld1b	{ z0.b }, p4/z, [x28, x19]
	add	x28, x2, x29
	movprfx	z15, z1
	and	z15.b, z15.b, #0xf
	lsr	z14.b, z1.b, #4
	sxtw	x29, w22
	ld1b	{ z6.b }, p0/z, [x28, x5]
	movprfx	z1, z4
	and	z1.b, z1.b, #0xf
	lsr	z19.b, z4.b, #4
	str	z2, [sp, #4, mul vl]            // 16-byte Folded Spill
	movprfx	z2, z0
	and	z2.b, z2.b, #0xf
	lsr	z0.b, z0.b, #4
	add	x28, x2, x29
	str	z18, [sp, #22, mul vl]          // 16-byte Folded Spill
	str	z17, [sp, #6, mul vl]           // 16-byte Folded Spill
	ld1b	{ z17.b }, p0/z, [x28, x5]
	tbl	z18.b, { z5.b }, z1.b
	str	z16, [sp, #7, mul vl]           // 16-byte Folded Spill
	ld1b	{ z16.b }, p0/z, [x2, x29]
	tbl	z4.b, { z5.b }, z15.b
	str	z3, [sp, #8, mul vl]            // 16-byte Folded Spill
	tbl	z3.b, { z6.b }, z19.b
	sxtw	x28, w23
	str	z21, [sp, #2, mul vl]           // 16-byte Folded Spill
	tbl	z21.b, { z6.b }, z0.b
	tbl	z23.b, { z17.b }, z14.b
	str	z20, [sp, #3, mul vl]           // 16-byte Folded Spill
	tbl	z20.b, { z5.b }, z2.b
	tbl	z5.b, { z5.b }, z12.b
	str	z7, [sp, #10, mul vl]           // 16-byte Folded Spill
	tbl	z7.b, { z6.b }, z14.b
	tbl	z6.b, { z6.b }, z13.b
	tbl	z22.b, { z16.b }, z15.b
	eor3	z30.d, z30.d, z18.d, z3.d
	add	x29, x2, x28
	ldr	z3, [sp, #17, mul vl]           // 16-byte Folded Reload
	tbl	z24.b, { z16.b }, z1.b
	tbl	z25.b, { z17.b }, z19.b
	tbl	z26.b, { z16.b }, z12.b
	tbl	z27.b, { z17.b }, z13.b
	tbl	z16.b, { z16.b }, z2.b
	eor3	z8.d, z8.d, z5.d, z6.d
	eor3	z29.d, z29.d, z4.d, z7.d
	ld1b	{ z4.b }, p0/z, [x2, x28]
	ld1b	{ z5.b }, p0/z, [x29, x5]
	tbl	z17.b, { z17.b }, z0.b
	eor3	z3.d, z3.d, z22.d, z23.d
	eor3	z31.d, z31.d, z20.d, z21.d
	sxtw	x28, w24
	eor3	z9.d, z9.d, z24.d, z25.d
	tbl	z20.b, { z4.b }, z12.b
	tbl	z6.b, { z4.b }, z15.b
	eor3	z11.d, z11.d, z26.d, z27.d
	tbl	z21.b, { z5.b }, z13.b
	add	x29, x2, x28
	ld1b	{ z7.b }, p0/z, [x2, x28]
	eor3	z10.d, z10.d, z16.d, z17.d
	str	z3, [sp, #17, mul vl]           // 16-byte Folded Spill
	tbl	z16.b, { z5.b }, z14.b
	tbl	z17.b, { z4.b }, z1.b
	tbl	z3.b, { z5.b }, z19.b
	tbl	z4.b, { z4.b }, z2.b
	tbl	z5.b, { z5.b }, z0.b
	ld1b	{ z18.b }, p0/z, [x29, x5]
	tbl	z26.b, { z7.b }, z12.b
	eor3	z28.d, z28.d, z20.d, z21.d
	ldr	z20, [sp, #19, mul vl]          // 16-byte Folded Reload
	tbl	z24.b, { z7.b }, z2.b
	tbl	z22.b, { z7.b }, z1.b
	tbl	z7.b, { z7.b }, z15.b
	sxtw	x28, w25
	tbl	z27.b, { z18.b }, z13.b
	tbl	z25.b, { z18.b }, z0.b
	tbl	z23.b, { z18.b }, z19.b
	eor3	z20.d, z20.d, z4.d, z5.d
	ldr	z4, [sp, #20, mul vl]           // 16-byte Folded Reload
	tbl	z18.b, { z18.b }, z14.b
	add	x29, x2, x28
	ld1b	{ z5.b }, p0/z, [x2, x28]
	sxtw	x28, w26
	str	z28, [sp, #18, mul vl]          // 16-byte Folded Spill
	add	w26, w26, #32
	add	w25, w25, #32
	eor3	z4.d, z4.d, z17.d, z3.d
	ldr	z3, [sp, #21, mul vl]           // 16-byte Folded Reload
	cmp	x16, x20
	str	z20, [sp, #19, mul vl]          // 16-byte Folded Spill
	add	w24, w24, #32
	add	w23, w23, #32
	add	w22, w22, #32
	eor3	z3.d, z3.d, z6.d, z16.d
	ld1b	{ z6.b }, p0/z, [x29, x5]
	add	x29, x2, x28
	ld1b	{ z21.b }, p0/z, [x29, x5]
	str	z4, [sp, #20, mul vl]           // 16-byte Folded Spill
	tbl	z16.b, { z5.b }, z1.b
	tbl	z4.b, { z5.b }, z2.b
	tbl	z17.b, { z6.b }, z19.b
	tbl	z20.b, { z6.b }, z0.b
	str	z3, [sp, #21, mul vl]           // 16-byte Folded Spill
	ldr	z3, [sp, #13, mul vl]           // 16-byte Folded Reload
	tbl	z28.b, { z21.b }, z13.b
	eor3	z3.d, z3.d, z26.d, z27.d
	tbl	z26.b, { z21.b }, z0.b
	str	z3, [sp, #13, mul vl]           // 16-byte Folded Spill
	ldr	z3, [sp, #14, mul vl]           // 16-byte Folded Reload
	eor3	z3.d, z3.d, z24.d, z25.d
	str	z3, [sp, #14, mul vl]           // 16-byte Folded Spill
	ldr	z3, [sp, #15, mul vl]           // 16-byte Folded Reload
	eor3	z3.d, z3.d, z22.d, z23.d
	str	z3, [sp, #15, mul vl]           // 16-byte Folded Spill
	ldr	z3, [sp, #16, mul vl]           // 16-byte Folded Reload
	eor3	z3.d, z3.d, z7.d, z18.d
	ld1b	{ z18.b }, p0/z, [x2, x28]
	sxtw	x28, w27
	tbl	z7.b, { z5.b }, z12.b
	add	w27, w27, #32
	ld1b	{ z22.b }, p0/z, [x2, x28]
	add	x28, x2, x28
	ld1b	{ z27.b }, p0/z, [x28, x5]
	tbl	z23.b, { z18.b }, z15.b
	tbl	z24.b, { z18.b }, z1.b
	str	z3, [sp, #16, mul vl]           // 16-byte Folded Spill
	tbl	z3.b, { z5.b }, z15.b
	tbl	z25.b, { z18.b }, z2.b
	tbl	z18.b, { z18.b }, z12.b
	tbl	z15.b, { z22.b }, z15.b
	tbl	z5.b, { z22.b }, z1.b
	tbl	z2.b, { z22.b }, z2.b
	tbl	z22.b, { z22.b }, z12.b
	tbl	z12.b, { z21.b }, z14.b
	tbl	z21.b, { z21.b }, z19.b
	tbl	z1.b, { z27.b }, z19.b
	ldr	z19, [sp, #9, mul vl]           // 16-byte Folded Reload
	str	z3, [sp, #1, mul vl]            // 16-byte Folded Spill
	tbl	z3.b, { z6.b }, z14.b
	tbl	z6.b, { z6.b }, z13.b
	tbl	z13.b, { z27.b }, z13.b
	tbl	z14.b, { z27.b }, z14.b
	tbl	z0.b, { z27.b }, z0.b
	eor3	z19.d, z19.d, z7.d, z6.d
	ldr	z7, [sp, #10, mul vl]           // 16-byte Folded Reload
	str	z3, [sp]                        // 16-byte Folded Spill
	ldr	z27, [sp]                       // 16-byte Folded Reload
	ldr	z6, [sp, #11, mul vl]           // 16-byte Folded Reload
	mov	z3.d, z11.d
	eor3	z7.d, z7.d, z4.d, z20.d
	ldr	z4, [sp, #12, mul vl]           // 16-byte Folded Reload
	ldr	z20, [sp, #1, mul vl]           // 16-byte Folded Reload
	eor3	z6.d, z6.d, z16.d, z17.d
	ldr	z16, [sp, #7, mul vl]           // 16-byte Folded Reload
	ldr	z17, [sp, #6, mul vl]           // 16-byte Folded Reload
	mov	z11.d, z3.d
	ldr	z3, [sp, #8, mul vl]            // 16-byte Folded Reload
	eor3	z4.d, z4.d, z20.d, z27.d
	ldr	z20, [sp, #22, mul vl]          // 16-byte Folded Reload
	eor3	z16.d, z16.d, z24.d, z21.d
	ldr	z21, [sp, #2, mul vl]           // 16-byte Folded Reload
	eor3	z17.d, z17.d, z25.d, z26.d
	eor3	z3.d, z3.d, z23.d, z12.d
	eor3	z20.d, z20.d, z18.d, z28.d
	mov	z28.d, z29.d
	mov	z29.d, z30.d
	eor3	z21.d, z21.d, z22.d, z13.d
	str	z20, [sp, #22, mul vl]          // 16-byte Folded Spill
	ldr	z20, [sp, #3, mul vl]           // 16-byte Folded Reload
	ldr	z18, [sp, #22, mul vl]          // 16-byte Folded Reload
	eor3	z20.d, z20.d, z2.d, z0.d
	ldr	z2, [sp, #4, mul vl]            // 16-byte Folded Reload
	eor3	z2.d, z2.d, z5.d, z1.d
	ldr	z1, [sp, #5, mul vl]            // 16-byte Folded Reload
	eor3	z1.d, z1.d, z15.d, z14.d
	b.ne	.LBB13_7
	b	.LBB13_3
.LBB13_8:
	addvl	sp, sp, #23
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
.LBB13_9:
	ret
.Lfunc_end13:
	.size	gf_7vect_dot_prod_sve2, .Lfunc_end13-gf_7vect_dot_prod_sve2
                                        // -- End function
	.ident	"clang version 23.1.3 (https://github.com/llvm/llvm-project 0d261d1ca552c95a8f007e061c787ac7132fbcbc)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
