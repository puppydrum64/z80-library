; TITLE: GB_RLD_RRD.ASM
; VERSION 1.0
; DATE: OCTOBER 10TH, 2021

; THIS DOCUMENT CONTAINS A SOFTWARE IMPLEMENTATION OF THE Z80 RLD AND RRD COMMANDS.
; THIS IS INTENDED FOR GAME BOY AND GAME BOY COLOR. A TRUE Z80 DOESN'T NEED THESE.
; FOR BREVITY'S SAKE, RLD AND RRD WILL NOT BE EXPLAINED HERE.
; UNFORTUNATELY THESE ARE MUCH MUCH SLOWER THAN THEIR Z80 COUNTERPARTS. 
;	THERE IS LITTLE THAT CAN BE DONE TO REMEDY THIS.

; SWAP IS A GB/GBC EXCLUSIVE COMMAND, EQUIVALENT TO 4 RRCs BUT DOES NOT CHANGE THE CARRY

; RRCA_16 (HL) IS A MACRO FOUND IN "Z80_MACROS_SHIFTROTATE.ASM"
; THE MACRO DOES THE FOLLOWING:
;	OR A
;	RRA
;	RR (HL)
;	JR NC, +
;		SET 7,A	;THE JUMP ABOVE SKIPS THIS IF THE CARRY IS CLEAR
;  +:

gb_rrd:
	push bc
		push af
			and %11110000	;FILTER OUT BOTTOM NIBBLE
			ld c,a			;TEMP STORE TOP NIBBLE IN C
		pop af
		and %00001111		;FILTER OUT TOP NIBBLE OF A
		RRCA_16 (HL)		
		RRCA_16 (HL)	
		RRCA_16 (HL)	
		RRCA_16 (HL)	
		swap a				;SWAP NIBBLES OF A
		or c				;GET THE TOP NIBBLE BACK
	pop bc
	ret
	
gb_rld:
	push bc
		ld c,0
		swap a
		or a	;clear the carry
		
		rla
		rl (hl)
		rl c
		
		rla
		rl (hl)
		rl c
		
		rla
		rl (hl)
		rl c
		
		rla			;THE TOP NIBBLE OF A IS WHAT IT WAS BEFORE WE STARTED.
		rl (hl)		;HL'S BOTTOM NIBBLE IS THE ORIGINAL BOTTOM NIBBLE OF A.
		rl c		;C NOW CONTAINS THE NIBBLE THAT WAS PUSHED OUT OF HL
		
		or c  
	pop bc
	ret