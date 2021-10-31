; CHECKERBOARD COMPRESSION/DECOMPRESSION ALGORITHM
;	VERSION 1.0
;	DATE: 31 OCTOBER 2021
;	REQUIRED FILES: 
;		RLD_RRD.ASM
;		ANY MULTIPLICATION FUNCTION THAT CAN RETURN AN 8-BIT PRODUCT OF TWO 8-BIT FACTORS.


; THIS TECHNIQUE COMPRESSES A CHECKERBOARD OF ARBITRARY SIZE INTO 5 BYTES.
;	CURRENTLY THE SIZE LIMIT IS (PATTERN_SIZE * REPS PER ROW < 255)
;   THE PATTERNS NEED NOT BE A TRUE "CHECKERBOARD" EITHER - ANY REPEATING PATTERN WILL DO.

; FUTURE GOALS:
;   ADD SUPPORT FOR OPTIONAL SHIFTING OF SUBSEQUENT LINE NUMBERS
;   OPTIONALLY PLACE A "NEW LINE" CONTROL CODE AFTER EACH LINE IN THE OUTPUT
;   SUPPORT LARGER DATA SIZES THAN 8-BIT "CHECKERS" AND 8-BIT ROW COUNTS/LENGTHS


; EXAMPLE CHECKERBOARD (UNCOMPRESSED):

;PATTERN = 0,1
;PATTERN SIZE = 2
;REPS PER ROW = 4
;TOTAL ROWS = 8
;OFFSET EVERY OTHER ROW = TRUE

;	0 1 0 1 0 1 0 1	
;	1 0 1 0 1 0 1 0
;	0 1 0 1 0 1 0 1
;	1 0 1 0 1 0 1 0
;	0 1 0 1 0 1 0 1
;	1 0 1 0 1 0 1 0
;	0 1 0 1 0 1 0 1
;	1 0 1 0 1 0 1 0


;COMPRESSED:
;	E2 0 1 %111snnnn 08

;	En = BEGINNING OF CHECKERBOARD ENCODING
;	0, 1: DATA
;	%111onnnn = REPEAT n TIMES TO FINISH ONE ROW, s = OFFSET EVERY OTHER ROW BY 1 (NOT IMPLEMENTED YET - CODE BELOW ASSUMES THAT THIS BIT IS ALWAYS SET.)
;	8  = 8 ROWS


UnpackCheckerboard:
	; you can load a checkerboard directly like so:
	;	LD HL,pointer_to_compressed_checkerboard
	;	LD DE,output_ram
	;	call UnpackCheckerboard
	; Or, you can have a compressed construct in an array of linear graphics data, and check each byte read for 0xEn (where n = any hex digit)
	push de
		ld de,LineRam				;hl still points to the En control byte
		ld a,(hl)			        ;get the control byte into A
		and &0F				        ;we only need the bottom half
		ld c,a				
		ld b,0					;load BC with bottom half of control byte
		push de
			push bc
				inc hl			;get hl into position to start of compressed data
				ldir			;memcpy into line ram
			pop bc
		pop de
		ld a,(hl)			        ;now hl conveniently points to next control byte.
		; bit 4,a				;if bit 4 set, shift each odd row by 1. Implement this later.
		;for now assume we always want to shift each odd row by 1, it's not much of a "checkerboard"
		;	if we don't!
		and &0F			             	;we don't need the top half.
		ld b,a			             	;this value is how many reps of the checkers are in this "line"
		;b = 4, c = 2
		inc hl
		ld a,(hl)				;get checkerboard row count. This algorithm doesn't assume the checkerboard is square.
		ld (CheckerRowCount),a	 		;store in checkerboard ram
		;c = length of data
		;b = reps per line.
		
		; MULTIPLY B BY C HERE WITH THE FUNCTION OF YOUR CHOICE, PRESERVING
		;	ALL OTHER REGISTERS.
		;   OUTPUT THE PRODUCT TO L AND THE MEMORY LOCATION "looptemp_checkerboard"
       		;   PRODUCT MUST BE 255 OR SMALLER TO PROPERLY WORK. 
		ld hl, LineRam
	pop de	
loop_memcpyToCheckerboardRam:
	ld a,(hl)
	ld (de),a
	inc de
	inc hl
	ld a,L
	cp c
	jr c,dontResetL
		ld L,0			;this works because LineRam is page-aligned
dontResetL:
	z_djnz loop_memcpyToCheckerboardRam
	
	;next line of data, offset it by one from the last.
	ld hl,LineRam
	ld a,c
	inc a
	push bc
		ld b,a
		dec b			;fixes "off-by-one" error
		call RRCA_RANGE		;rotate the bytes one to the right. See "RLD_RRD.ASM" for details. Preserves BC and HL. Doesn't alter DE.
	pop bc
	ld a,(looptemp_checkerboard)
	ld b,a				;get loop counter back into B
	push hl
		ld hl,CheckerRowCount
		dec (hl)
	pop hl
	jp nz,loop_memcpyToCheckerBoardRam
	ret
	
;;;;; PROGRAM RAM
looptemp_checkerboard:
	byte 0
CheckerRowCount:
;you'll want to save this elsewhere after decompressing to linear data to aid with printing.
;otherwise your program won't know where a "new line" begins!
	byte 0
	
	align 8		;aligns the array below so that its base address has a low byte of zero. This is necessary for the routine to work properly.
LineRam:		
	ds 64,0
	
CheckerboardRam:	;output can be stored here as linear data. Use of this ram is optional, the function is intended to be able to output directly to
			;	video memory or a buffer, up to the programmer's discretion.
			;Alignment of this address to a 256-byte boundary is optional.
	ds 256,0
