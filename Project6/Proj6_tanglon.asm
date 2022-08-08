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
EDGE_MIN	=	2147483648

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
sign				BYTE	0	                                                ; SET 0 AS POSITIVE, -1 AS NEGATIVE

; for WriteVal
space               BYTE    ", ",  0
writeValMessage1    BYTE    "You entered the following numbers: ",  0
tempString          BYTE    MAX_CHAR   DUP (?)

; for calSumAverage
sumMessage1         BYTE    "The sum of these numbers is: ",  0
averageMessage1     BYTE    "The truncated average is: ",  0
sum                 SDWORD  0
average             SDWORD  0

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
	MOV			EDX,	OFFSET	userVal

	_askVal:
	PUSH		OFFSET	prompt1
	PUSH		OFFSET	userString
	PUSH		OFFSET	userInputLength
	PUSH		EDX
	PUSH		OFFSET	error1
	PUSH		OFFSET	error2
	PUSH		OFFSET	sign
	CALL		ReadVal
	ADD			EDX,	4
	LOOP		_askVal
	; ------------------------------------------------

	; ------------------------------------------------
	; Procedure: calSumAverage
	PUSH		OFFSET	sign
	PUSH		OFFSET  tempString
	PUSH		OFFSET  averageMessage1
	PUSH		OFFSET  average
	PUSH		OFFSET  sumMessage1
	PUSH		OFFSET  sum
	PUSH		OFFSET  userVal
	CALL		calSumAverage



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

	MOV			EAX,  1
	MOV			[EBP+8],  EAX                                               ; SET sign AS 1, INDICATING NEGATIVE NUMBER
	JMP			_advanceNextDigit

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
	CMP			ECX,	1													; EDGE CASE, FOR -2147483648 AS THE PROGRAM WILL NEGATE AT THE LAST
	JE			_edgeCase

	_addUpContd:
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

	MOV			EAX,	0
	MOV			[EDI],	EAX													; clear the invalid values within the array
	MOV			EDX,	0													; AS SUM ACCUMULATOR

	mGetStringSimplified	[EBP+28], MAX_CHAR, [EBP+24]					; INVOKE mGetStringSimplified (for error spotted)

	MOV			ESI,	[EBP+28]											; userString [EBP+28] is holding the input string
	MOV			ECX,	[EBP+24]											; userInputLength [EBP+24] is holding the length of the input
	JMP			_stringToValInner

	_advanceNextDigit:

	MOV			[EDI],	EDX													; SAVE THE LATEST ACCUMULATED SUM
	LOOP		_stringToValInner
	MOV			EAX,	1
	CMP			[EBP+8],	EAX
	JE			_negate
	JMP			_finish1Loop

	_edgeCase:
	MOV			EAX,  1
	CMP			[EBP+8],  EAX
	JNE			_addUpContd
	CMP			EDX,	EDGE_MIN
	JA			_notValid
	JMP			_advanceNextDigit

	_negate:

	PUSHAD

	MOV			EAX,  [EDI]
	MOV			EBX,	-1
	MUL			EBX
	MOV			[EDI],	EAX
	MOV			EAX,  0
	MOV			[EBP+8],	EAX												; RESET THE VALUE OF SIGN
	POPAD

	_finish1Loop:
	POPAD
	POP			EBP
	RET			28

ReadVal ENDP


;============================================

WriteVal PROC

; 1) convert values in userVal to its ASCII digits representation;
; 2) store the ASCII conversion to tempString [EBP+12]
; 3) invoke mDisplayString to display the converted string

; preconditions: setup stack frame and access parameters on runtime stack using Base+Offset; array in Register Indirect accessing
; postconditions: the offset of the converted string

; receives: 1) push offset userVal [EBP+8]
;           2) push offset tempString [EBP+12]
;			3) push offset sign	[EBP+16] (0 AS POSITIVE; 1 AS NEGATIVE)
;
; returns: 1) N/A (display string output for all 10 values)
;============================================

    PUSH        EBP
    MOV         EBP,    ESP

	PUSHAD

	MOV			ESI,	[EBP+8]
	MOV			EDI,	[EBP+12]
	MOV			EBX,	[EBP+16]
	MOV			EBX,	0													; DEFAULT THE VALUE IS POSITIVE

	MOV			EAX,	ESI												; STORE THE VALUE IN EAX
	MOV			ECX,	1													; FOR COUNTUNG PURPOSE

	_signCheck:

	CMP			EAX,	0
	JL			_negativeVal
	JMP			_convert2ASCII

	_negativeVal:

	NEG			EAX															; NEGATE TO POSITIVE VALUE FOR EASIER PROCESSING (SIGN WILL BE HANDLED LATER)
	MOV			EBX,	1
	MOV			[EBP+16],	EBX												; STORE THE RESULT BACK TO SIGN
	

	;============================================
	; EXAMPLE EAX = 280
	; 1ST DIVISION: EAX = 28; EDX = 0										; PUSH TO STACK; ECX = 2
	; 2ND DIVISION:	EAX = 2;  EDX = 8										; PUSH TO STACK; ECX = 3
	; 3RD DIVISION:	EAX = 0;  EDX = 2										; JMP TO _lastDigit; PUSH TO STACK; (STACK: top: 2 8 0 bottom); ECX = 3)
	;============================================
	
	_convert2ASCII:

	MOV			EBX,	10
	CDQ
	IDIV		EBX															; EAX IS STORING THE QUOTIENT; EDX IS STORING THE REMAINDER

	CMP			EAX,	0
	JE			_lastDigit													; E.G. 2/10 --> EAX = 0; EDX = 2 (NO MORE DIGIT TO BE DIVIDED)
	JMP			_convertCond

	_convertCond:

	ADD			EDX,	48													; JUMP HERE IF DIVISION IS STILL AVAILABLE
	PUSH		EDX
	ADD			ECX,	1
	JMP			_convert2ASCII												; FOR FURTHER DIVISION	

	_lastDigit:

	ADD			EDX,	48
	PUSH		EDX															; PUSH THE VALUE TO STRING TO STACK

	MOV			EBX,	[EBP+16]
	CMP			EBX,	1
	JE			_addNegativeSign											; NEED TO HANDLE THE NEGATIVE SIGN
	JMP			_pop2String

	_addNegativeSign:

	PUSH		45															; '-' TO STACK
	ADD			ECX,	1

	_pop2String:
	POP			EAX
	STOSB																	; STORE THE VALUE IN AL TO EDI
	LOOP		_pop2String

	mdisplayString	[EBP+12]

	POPAD
    POP         EBP
    RET         12

WriteVal ENDP

;============================================
calSumAverage PROC

; 1) To calculate the sum and average from userVal
; 2) Display the results via mDisplayString

; preconditions: setup stack frame and access parameters on runtime stack using Base+Offset; array in Register Indirect accessing
; postconditions: variable sum will be modified

; receives: 1) push offset of averageMessage1 [EBP+24]
;			1) push offset of average [EBP+20]
;           2) push offset of string [EBP+16]
;           3) push offset of sum [EBP+12]
;           4) push offset of userVal [EBP+8]
;
; returns: 1) sum is updated; output the value of sum
;============================================

    PUSH        EBP

    MOV         EBP,    ESP
    MOV         ESI,    [EBP+8]                                             ; ESI IS NOW STORING userVal
    MOV         ECX,    MAX_INPUT                                           ; MAX_INPUT AS GLOBAL VARIABLE (AS REQUIRED, 10 INPUTS ARE REQUIRED)
	MOV			EAX,	0
	MOV			EBX,	0

    _calSum:

    MOV         EBX,    [ESI]                                               ; MOVE ELEMENTS FROM userVal
    ADD         EAX,    EBX
    ADD         ESI,    4                                                   ; ADVANCE ESI
    LOOP        _calSum


    MOV         [EBP+12],   EAX                                             ; PLACE THE TOTAL BACK TO SUM

	mDisplayString  [EBP+16]

	PUSH		[EBP+32]
	PUSH		[EBP+28]
	PUSH		[EBP+12]
	CALL		WriteVal
    CALL        CrLF
	JMP			_calAverage

    _calAverage:

    CDQ
    MOV			EBX,	MAX_INPUT
	IDIV		EBX
    MOV         [EBP+20],   EAX

	mDisplayString  [EBP+24]
	PUSH		[EBP+32]
	PUSH		[EBP+28]
	PUSH		[EBP+20]
	CALL		WriteVal
    CALL        CrLF

    POP         EBP
    RET         28

calSumAverage ENDP

;============================================



END main