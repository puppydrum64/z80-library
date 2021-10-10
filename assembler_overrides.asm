;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ASSEMBLER OVERRIDES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; use these if your assembler doesn't support Game Boy commands
; this version of VASM doesn't seem to correctly assemble some of them


	ifdef gbz80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		macro gb_out_c
		; equivalent of LD (&FF00+C),A
		; stores accumulator into the memory address &FF00 offset by C.
		; this takes the place of OUT,C
		;
			byte &E2
		endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		macro gb_out,val
		;stores accumulator into (&FF\val)
		;e.g. gb_out &43 = LD (&FF43),A
		;vasm assembles this like it would on a normal Z80, 
		;	which wastes 1 byte. Use this macro instead
			byte &E0,\val
		endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		macro gb_in_C
		;equivalent of LD A,(&FF00+C)
		;loads accumulator from memory address &FF00 offset by C
		;this takes the place of IN,C
			byte &F2
		endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		macro gb_in,val
		;loads accumulator from (&FF\val)
		;e.g. gb_in &22 = LD A,(&FF22)
		;vasm assembles this like it would on a normal Z80, 
		;	which wastes 1 byte. Use this macro instead.
			byte &F0,\val
		endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		macro UnwindStack,imm
		;adds a fixed numeric value to the stack pointer.
		;useful if you pushed multiple regs but don't care about
		;getting them back.
			byte &E8,\imm
		endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		macro LD_HL_SP_PLUS_N,imm
		;adds N to the stack pointer and loads that value into HL. 
		;The addition of N applies during the calculation only.
		;The actual value of the stack pointer is unchanged.
			byte &F8,\imm
		endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	endif
