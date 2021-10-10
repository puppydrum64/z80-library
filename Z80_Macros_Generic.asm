;GENERAL-PURPOSE Z80 MACROS
;WORKS WITH BOTH STANDARD Z80 AND GAME BOY
;ONLY COMMANDS THAT DON'T EXIST ON EITHER ARE HERE.
;-------------------------------------------
	macro pushall	
		push af
		push bc
		push de
		push hl
		ifndef gbZ80
			push ix
			push iy
		endif
	endm
;-------------------------------------------
	macro popall
		ifndef gbZ80
			pop iy
			pop ix
		endif
		pop hl
		pop de
		pop bc
		pop af
	endm
;-------------------------------------------
	macro CLC
	;clears the carry, non-destructively.
		or a	
	endm
;-------------------------------------------
	macro compareBCtoZero
	;destroys accumulator.
		ld a,b
		or c		
		;if a = 0 after this, bc = 0.
	endm
;-------------------------------------------
	macro compareDEtoZero
	;destroys accumulator.
		ld a,d
		or e
		;if a = 0 after this, de = 0
	endm
;-------------------------------------------
	macro compareHLtoZero
	;destroys accumulator
		ld a,h
		or l
		;if a = 0 after this, hl = 0
;-------------------------------------------
	macro ld_mem2mem,dest,src
		;load an 8 bit value from one memory address and store it in another.
		;type the addresses without brackets!
		;accumulator gets clobbered.
			ld a,(\src)
			ld (\dest),a
	endm
;-------------------------------------------
	macro ld_mem2mem_safe,dest,src
		;same as above but backs up the accumulator and pops it when done.
			push af
				ld_mem2mem dest,src
			pop af
	endm
;-------------------------------------------
	macro xchg,regpair1,regpair2
	;lets you exchange regs you normally couldn't such as HL with IX.
		push \regpair1
		push \regpair2
		pop \regpair1
		pop \regpair2
	endm
;-------------------------------------------
	macro z_ld_hl_de
		push de
		pop hl
	endm
;-------------------------------------------
	macro z_ld_de_hl
		push hl
		pop de
	endm
;-------------------------------------------
	macro z_ld_hl_bc
		push bc
		pop hl
	endm
;-------------------------------------------
	macro z_ld_bc_hl
		push hl
		pop bc
	endm
;-------------------------------------------
	macro z_ld_de_bc
		push bc
		pop de
	endm
;-------------------------------------------
	macro z_ld_bc_de
		push de
		pop bc
	endm
;-------------------------------------------
	macro z_ld_hl_ix
		ifdef gbz80
			push af
				ld a,(r_ixh)
				ld h,a
				ld a,(r_ixl)
				ld l,a
			pop af
		else
			push ix
			pop hl
		endif
	endm
;-------------------------------------------
	macro z_ld_hl_iy
		ifdef gbz80
			push af
				ld a,(r_iyh)
				ld h,a
				ld a,(r_iyl)
				ld l,a
			pop af		
		else
			push iy
			pop hl
		endif
	endm
;-------------------------------------------
	macro z_ld_ix_hl
		ifdef gbz80
			push af
				ld a,h
				ld (r_ixh),a
				ld a,l
				ld (r_ixl),a
			pop af
		else
			push hl
			pop ix
		endif
	endm
;-------------------------------------------
	macro z_ld_iy_hl
		ifdef gbz80
			push af
				ld a,h
				ld (r_iyh),a
				ld a,l
				ld (r_iyl),a
			pop af
		else
			push hl
			pop iy
		endif
	endm
;-------------------------------------------