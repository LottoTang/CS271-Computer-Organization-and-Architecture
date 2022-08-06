TITLE String Primitives and Macros     (Proj6_tanglon.asm)

; Author: Long To Lotto Tang
; Last Modified: 6/8/2022
; OSU email address: tanglon@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 6                Due Date: 12/8/2022
; Description: 1) Design, implement and call low-level I/O procedures
;              2) Implement and use macros

INCLUDE Irvine32.inc

; (insert macro definitions here)

;============================================
mGetString	MACRO	prompt1, userString, userInputCount, userInputLength	

; To read input string
; preconditions: N/A
; postconditions: input string will be stored on userString; userInputLength will be updated accordingly (number of characters entered)
; receives: 1) prompt1							: as instruction
;			2) userString						: array to store the input string
;			3) userInputCount					: to store the maximum permitted length of the input (for ReadString)
;			4) userInputLength					: to store the length of the input
;
; returns:	1) userString						: updated array with input string
;			2) userInputLength					: variable strong the length of the input string
;============================================

	PUSH		EAX
	PUSH		ECX
	PUSH		EDX

	MOV			EDX,  prompt1
	CALL		WRITESTRING
	MOV			EDX,	userString
	MOV			ECX,	userInputCount
	CALL		READSTRING
	MOV			userInputLength,  EAX										; userInputLength: number of characters

	POP			EDX
	POP			ECX
	POP			EAX

ENDM

;============================================
mGetStringSimplified	MACRO	userString, userInputCount, userInputLength	

; To read input string (for invalid data input spotted)
; preconditions: N/A
; postconditions: input string will be stored on userString; userInputLength will be updated accordingly (number of characters entered)
; receives: 1) userString						: array to store the input string
;			2) userInputCount					: to store the maximum permitted length of the input (for ReadString)
;			3) userInputLength					: to store the length of the input
;
; returns:	1) userString						: updated array with input string
;			2) userInputLength					: variable strong the length of the input string
;============================================

	PUSH		EAX
	PUSH		ECX
	PUSH		EDX

	MOV			EDX,	userString
	MOV			ECX,	userInputCount
	CALL		READSTRING
	MOV			userInputLength,  EAX										; userInputLength: number of characters

	POP			EDX
	POP			ECX
	POP			EAX

ENDM

;============================================
mDisplayString	MACRO	outputString										

; To display the string (this macro aims for displaying the validated input string, not intended for general instructions/ simple text)
; preconditions: N/A
; postconditions: N/A
; receives: 1) outputString						: as the offset of the string

; returns:	N/A (simply output to screen)
	
	PUSH		EDX

	MOV			EDX,  outputString
	CALL		WRITESTRING

	POP			EDX

ENDM

;============================================

; (insert constant definitions here)

MAX_CHAR	=	12															; MAX RANGE FOR 32BIT SIGNED: -2147483648 TO 2147483647 (11 CHAR + 1 FOR NULL)
MAX_INPUT	=	10															; 10 INPUTS ARE REQUIRED
LARGEST		=	2147483647
SMALLEST	=	-2147483648

.data

; (insert variable definitions here)

; for introduction
intro1				BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",  0
intro2				BYTE	"Written by: Lotto Tang",  0
intro3				BYTE	"Please provide 10 signed decimal integers.",  0
intro4				BYTE	"Each number needs to be small enough to fit inside a 32 bit register. After you have finished inputting the raw numbers I will display a list of the",  0
intro5				BYTE	"integers, their sum, and their average value.",  0

; for mGetString
userString			BYTE	MAX_CHAR	DUP	(?)									; FOR STORING THE STRING FORMAT INPUT
userInputLength		DWORD	?
prompt1				BYTE	"Please enter an signed number: ",  0

; for ReadVal
userVal				SDWORD	MAX_INPUT	DUP	(0)									; FOR STORING THE CONVERTED VALUES FROM userString
error1				BYTE	"ERROR: You did not enter a signed number or your number was too big.",  0
error2				BYTE	"Please try again: ",  0
sign				BYTE	0													; SET 0 AS POSITIVE, -1 AS NEGATIVE

.code
main PROC

; (insert executable instructions here)
	
	; ------------------------------------------------
	; Procedure: introduction
	PUSH		OFFSET	intro1
	PUSH		OFFSET	intro2
	PUSH		OFFSET	intro3
	PUSH		OFFSET	intro4
	PUSH		OFFSET	intro5
	CALL		introduction
	; ------------------------------------------------

	; Procedure: ReadVal (as requested, loop will perform in main)

	MOV			ECX,	MAX_INPUT


	PUSH		OFFSET	prompt1
	PUSH		OFFSET	userString
	PUSH		OFFSET	userInputLength
	PUSH		OFFSET	userVal
	PUSH		OFFSET	error1
	PUSH		OFFSET	error2
	PUSH		OFFSET	sign
	CALL		ReadVal



	Invoke		ExitProcess,	0											; EXIT TO OS
main ENDP

; (insert additional procedures here)

;============================================
introduction PROC

; To display the purposes and instructions of the program
; preconditions: setup stack frame and access oarameters on runtime stack using Base+Offset
; postconditions: clear stack frame
; receives: push the required strings on runtime stack
; returns: number of bytes that pushed on runtime stack to clear the stack frame
;============================================

	PUSH		EBP															; SET UP STACK FRAME
	MOV			EBP,	ESP										

	MOV			EDX,	[EBP+24]
	CALL		WRITESTRING
	CALL		CRLF

	MOV			EDX,	[EBP+20]
	CALL		WRITESTRING
	CALL		CRLF

	CALL		CRLF

	MOV			EDX,	[EBP+16]
	CALL		WRITESTRING
	CALL		CRLF

	MOV			EDX,	[EBP+12]
	CALL		WRITESTRING
	CALL		CRLF

	MOV			EDX,	[EBP+8]
	CALL		WRITESTRING
	CALL		CRLF

	CALL		CRLF

	POP			EBP											
	RET			20															; CLEAR PARAMTERS ON STACK

introduction ENDP

;============================================

ReadVal PROC

; 1) To call mGetString to get user input in form of a string of digits; 
; 2) convert string of ASCII digits to its numeric value representation;
; 3) validate the number
; 4) store the value in memory

; preconditions: setup stack frame and access parameters on runtime stack using Base+Offset; array in Register Indirect accessing
; postconditions: numArray will store the validated values

; receives: 1) push offset of prompt1 [EBP+32]; userString [EBP+28]; userInputLength [EBP+24] (for calling mGetString) 
;			2) push offset of userVal [EBP+20]
;			3) push offset of error1 [EBP+16]; error2 [EBP+12]
;			4) push offset of sign [EBP+8] (0 AS POSITIVE; 1 AS NEGATIVE)
;
; returns: 1) userVal is updated fill 10 validated signed integers
;============================================

	PUSH		EBP
	MOV			EBP,	ESP
	PUSHAD

	_stringToValOuter:

	mGetString	[EBP+32], [EBP+28], MAX_CHAR, [EBP+24]						; INVOKE mGetString

	; SET UP INNER LOOP FOR CONVERTING STRING TO VALUE 1 BY 1

	MOV			ESI,	[EBP+28]											; userString [EBP+28] is holding the input string
	MOV			ECX,	[EBP+24]											; userInputLength [EBP+24] is holding the length of the input
	MOV			EDI,	[EBP+20]

	MOV			EBX,	10													; FOR MULTIPLICATION CALCULATION
	MOV			EAX,	0													; INITIALIZATION (FOR LODSB)
	MOV			EDX,	0													; AS SUM ACCUMULATOR
	

	_stringToValInner:

	; GO THROUGH THE STRING FOWARD
	LODSB

	CMP			AL,  45														; CHECK IF IT IS A NEGATIVE VALUE
	JE			_isNegative
	CMP			AL,  48
	JB			_notValid
	CMP			AL,  57
	JA			_notValid
	JMP			_validDigit

	_isNegative:

	PUSH		EAX
	MOV			EAX,  1
	MOV			[EBP+8],  EAX
	POP			EAX

	; AL IS HOLDING 0 - 9 NOW
	_validDigit:

	SUB			AL,  48

	PUSH		EAX															; SAVE THE CURRENT DIGIT IN AL
	MOV			EAX,	[EDI]												; MOVE THE PREVIOUS ACCUMULATED VALUE TO EDX
	MUL			EBX
	MOV			EDX,	EAX													; ADVANCE THE PREVIOUS ACCMULATED VALUE BY * 10
	POP			EAX

	_addUp:
	
	ADD			EDX,	EAX
	CMP			EDX,	LARGEST
	JA			_notValid
	CMP			EDX,	SMALLEST
	JL			_notValid
	JMP			_advanceNextDigit
	
	_notValid:

	MOV			EDX,	[EBP+16]
	CALL		WRITESTRING
	CALL		CRLF
	MOV			EDX,	[EBP+12]
	CALL		WRITESTRING

	mGetStringSimplified	[EBP+28], MAX_CHAR, [EBP+24]					; INVOKE mGetStringSimplified (for error spotted)
	
	MOV			ESI,	[EBP+28]											; userString [EBP+28] is holding the input string
	MOV			ECX,	[EBP+24]											; userInputLength [EBP+24] is holding the length of the input
	JMP			_stringToValInner

	_advanceNextDigit:

	MOV			[EDI],	EDX													; SAVE THE LATEST ACCUMULATED SUM

	LOOP		_stringToValInner

	MOV			EAX,  [EDI]
	CALL		WRITEINT

	POPAD
	POP			EBP
	RET			28

ReadVal ENDP

END main
