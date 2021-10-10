;File		shift_rotate
;Version	V1.0
;Date		October 10,2021
; 			These work on both the normal Z80 and the Game Boy unless otherwise noted.
;			VASM says RLD and RRD don't exist on gameboy... I thought they did???

;Content	RRCA_RANGE - rotates a range of memory, e.g. &1000 = &23,&45,&67,&89 > &89,&23,&45,&67
;			RLCA_RANGE - rotates a range of memory, e.g. &1000 = &23,&45,&67,&89 > &45,&67,&89,&23	(bugged, doesn't work)
;			ShowPackedBCD_FromHL - Displays (HL) as a packed BCD byte to the screen. Non-destructive.
;Sample Usage

;	ld hl,&1000	(addr of 0th byte in range)
;	ld b,6		(byte count of range, valid values 2 thru 255)
;	call RRCA_RANGE

;	ld hl,&1003 (addr of LAST byte in range)
;	ld b,6		(byte count of range, valid values 2 thru 255)
;	call RLCA_RANGE

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RRCA_RANGE:
	ld a,(hl)
	push hl
	push bc
loop_RRCA_RANGE_FIRST:
		RRD
		INC HL
		z_djnz loop_RRCA_RANGE_FIRST
	pop bc
	pop hl
	push hl
	push bc
loop_RRCA_RANGE_SECOND:
		RRD
		INC HL
		z_djnz loop_RRCA_RANGE_SECOND
	pop bc
	pop hl
	RRD
	ret
	
RLCA_RANGE:
;rotates a range of memory, e.g. &1000 = &23,&45,&67,&89 > &45,&67,&89,&23
;point HL at the end of the memory range this time.
	ld a,(hl)
	push hl
	push bc
loop_RLCA_RANGE_FIRST:
		RLD
		DEC HL
		z_djnz loop_RLCA_RANGE_FIRST
	pop bc
	pop hl
	push hl
	push bc
loop_RLCA_RANGE_SECOND:
		RLD
		DEC HL
		z_djnz loop_RLCA_RANGE_SECOND
	pop bc
	pop hl
	RLD
	ret
	
ShowPackedBCDFromHL:
	ld a,&30
	RLD
	call PrintChar
	RLD
	call PrintChar
	RLD
	ret
	

	
	
