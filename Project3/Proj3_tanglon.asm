TITLE Integer Accmulator    (Proj3_tanglon.asm)

; Author: Long To Lotto Tang
; Last Modified: 12th Jul 2022
; OSU email address: tanglon@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 3                Due Date: 17 Jul 2022
; Description: This project will ask for values (validated within boundaries) and display the minimum, maximum,
;			   average of the values, total sum and total number of valid inputs.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

; for part 2
RANGE1_LOWER = -200
RANGE1_UPPER = -100
RANGE2_LOWER = -50
RANGE2_UPPER = -1

; for part 4
ROUNDUPVAL = 5

.data

; (insert variable definitions here)

; for part 1
greeting1	BYTE	"Welcome to the Integer Accumulator by Lotto Tang",  0
intro1		BYTE	"We will be accumulating user-input negative integers between the specified bounds, then displaying" ,  0
intro2		BYTE	"statistics of the input values including minimum, maximum, and average values values, total sum, and" ,  0
intro3		BYTE	"total number of valid inputs." ,  0
prompt1		BYTE	"What is your name? ",  0
userName	BYTE	21 DUP (0)						; variable for asking userName, set the size as 20 (1 extra for null-terminated) as name should within 20 characters
greeting2	BYTE	"Hello there, ",  0

; for part 2
intro4		BYTE	"Please enter numbers in [",  0
comma		BYTE	", ",  0
intro5		BYTE	"] or [",  0
intro6		BYTE	"].",  0
intro7      BYTE    "Enter a non-negative number when you are finished to see results.",  0
prompt2     BYTE    " - Enter number: ",  0
extracd1    BYTE    "EC: Number the lines during user input",  0
extracd2    BYTE    "Line ",  0

countLine   DWORD    1
counter     DWORD    0                              ; store how many numbers
value       SDWORD   ?                              ; signed variable to store the negative value; results...
maxVal		SDWORD	-201                            ; initialize as the lowest possible value - 1
minVAL		SDWORD	0                               ; initialize as the largest possible value + 1
sum			SDWORD	0
average		SDWORD	?

; for part 2: error messages
warning1    BYTE    "Number Invalid!",  0

; for part 3
quotient	DWORD	?
remainder	DWORD	?
tenth		DWORD	-10
warning2    BYTE    "No numbers entered!",  0
outcome1    BYTE    "You have entered ",  0
outcome2    BYTE    " valid numbers.",  0
outcome3    BYTE    "The maximum valid number is ",  0
outcome4    BYTE    "The minimum valid number is ",  0
outcome5    BYTE    "The sum of your valid numbers is ",  0
outcome6    BYTE    "The rounded average is ",  0

; for part 4
farewell    BYTE    "We have to stop meeting like this. Farewell, ",  0

.code
main PROC

; (insert executable instructions here)

; part 1: Greetings and Introduction

	MOV		EDX,  OFFSET  greeting1
	CALL	WriteString
	CALL	CrLF
	MOV		EDX,  OFFSET  intro1
	CALL	WriteString
	CALL	CrLF
	MOV		EDX,  OFFSET  intro2
	CALL	WriteString
	CALL	CrLF
	MOV		EDX,  OFFSET  intro3
	CALL	WriteString
	CALL	CrLF

	MOV		EDX,  OFFSET  prompt1
	CALL	WriteString
	MOV		EDX,  OFFSET  userName					; point to the address of userName
	MOV		ECX,  SIZEOF  userName					; specify max characters (20); extra 1 for null-terminated
	CALL	ReadString								; ask for user's name
	MOV		EDX,  OFFSET  greeting2
	CALL	WriteString
	MOV		EDX,  OFFSET  userName
	CALL	WriteString
	CALL	CrLF

; part 2: Main Body (ask for user input for values, and do logical comparison)

	;--------------------------------------
	; This part is for displaying the boundaries
	;	this part is not hard coded as CONSTATNS may change, thus the values can also be changed accordingly
	;--------------------------------------

	MOV		EDX,  OFFSET  intro4
	CALL	WriteString
	MOV		EAX,	RANGE1_LOWER					; display RANGE1_LOWER (e.g. -200)
	CALL	WriteInt
	MOV		EDX,  OFFSET  comma						; display the format [a, b] or [c, d].
	CALL	WriteString
	MOV		EAX,	RANGE1_UPPER					; display RANGE1_LOWER (e.g. -200)
	CALL	WriteInt
	MOV		EDX,  OFFSET  intro5
	CALL	WriteString
	MOV		EAX,	RANGE2_LOWER
	CALL	WriteInt
	MOV		EDX,  OFFSET  comma
	CALL	WriteString
	MOV		EAX,	RANGE2_UPPER
	CALL	WriteInt
	MOV		EDX,  OFFSET  intro6
	CALL	WriteString
	CALL	CrLF

    ;--------------------------------------
	; This part is for asking user input
	;	acceptable input: -200 <= x <= -100 || -50 <= x <= -1
	;--------------------------------------

    MOV		EDX,  OFFSET  intro7
	CALL	WriteString
	CALL	CrLF
	CALL	CrLF
	MOV     EDX,  OFFSET  extracd1                  ; prompt for extra credit
    CALL	WriteString
	CALL	CrLF

; ask for user input; jump back here if non-zero is entered
_userInput:
	MOV     EDX,  OFFSET  extracd2                  ; prompt for extra credit
    CALL	WriteString
    MOV     EAX,  countLine
    CALL    WriteDec
	MOV		EDX,  OFFSET  prompt2
	CALL	WriteString
	CALL    ReadInt
	MOV		value,  EAX

	; check range [-200, -100]
	CMP     value,  RANGE1_LOWER
	JL      _invalid                                ; jump if input < -200
	CMP     value,  RANGE1_UPPER
	JG      _checkRange2Lower                       ; jump if input > -100
	JMP     _again                                  ; jump to _again since the logical operation is ||


; jump here if the entered value is invalid
_invalid:
    MOV     EDX,  OFFSET  warning1
    CALL    WriteString
	CALL	CrLF
    JMP     _userInput


; jump here if the entered value is valid
_again:
    INC     countLine
    INC     counter                                 ; increment counter to count number of values entered
	MOV		EAX,  value
    ADD     sum,  EAX
	MOV		EAX,  value								; re-initialize EAX to prevent any error
    CMP     EAX,  maxVal
    JG      _changeMax                              ; check max & min value
    JMP     _checkMin


; jump here if the entered value is invalid (greater than -100)
_checkRange2Lower:
    CMP     value,  RANGE2_LOWER
    JL      _invalid
    TEST    value,  RANGE2_UPPER			        ; using TEST here as CMP will modify the 1st operand, thus if CMP -1, RANGE2_UPPER, sign flag will set as 0 as the intermediate result is 0
    JNS     _nonNegative
    JMP     _again


; update max value
_changeMax:
    MOV		EAX,  value
	MOV     maxVal,  EAX
    JMP     _checkMin


; check min value
_checkMin:
    MOV		EAX,  value
	CMP     EAX,  minVal
    JL      _changeMin
    JMP     _userInput


; update min value
_changeMin:
    MOV		EAX,  value
	MOV     minVal,  EAX
    JMP     _userInput


; part 3: Main Body (Calculate average & displaying the results)

; jump here if the entered value is non-negative
_nonNegative:

    ;--------------------------------------
	; This part is for if counter = 0
	;	display error message
	;--------------------------------------
	CMP     counter,  0
	JZ      _noNumber

    ; for displaying the results
    MOV     EDX,  OFFSET  outcome1
    CALL    WriteString
    MOV     EAX,  counter                           ; display number of valid input
    CALL    WriteDec
    MOV     EDX,  OFFSET  outcome2
    CALL    WriteString
    CALL    CrLF

    MOV     EDX,  OFFSET  outcome3
    CALL    WriteString
    MOV     EAX,  maxVal
    CALL    WriteInt                                ; display max value
    CALL    CrLF

    MOV     EDX,  OFFSET  outcome4
    CALL    WriteString
    MOV     EAX,  minVal                            ; display min value
    CALL    WriteInt
    CALL    CrLF

    MOV     EDX,  OFFSET  outcome5
    CALL    WriteString
    MOV     EAX,  sum                               ; display the sum
    CALL    WriteInt
    CALL    CrLF

	;--------------------------------------
	; This part is for calculating the average number
	;	the average will be rounded up
	;--------------------------------------

	MOV     EDX,  OFFSET  outcome6					; display the rounded average
    CALL    WriteString
	
	MOV     EAX,  sum                               ; move sum (dividend) into AX
    CDQ                                             ; sign-extend AX into DX
    MOV     EBX,  counter                           ; move counter (divisor) into BX
    IDIV    EBX
    MOV     quotient,  EAX                          ; store quotient into variable
    MOV     remainder,  EDX                         ; store remainder into variable

	MOV		EAX,  remainder
	MUL		tenth
	CDQ
	MOV		EBX,  counter
	DIV		EBX
	CMP		EAX,  ROUNDUPVAL
	JG		_roundUp
	JMP		_noRoundUp

_roundUp:											
	MOV		EAX,  quotient
	DEC		EAX
	CALL	WriteInt
	CALL    CrLF
    JMP     _bye

_noRoundUp:
	MOV		EAX,  quotient
	CALL	WriteInt
	CALL    CrLF
    JMP     _bye

 ; display no numbers entered and jump to _bye
_noNumber:
    MOV     EDX,  OFFSET  warning2
    CALL    WriteString
    JMP     _bye


; part 4: Ending
_bye:
    CALL    CrLF
    MOV     EDX,  OFFSET  farewell
    CALL    WriteString
    MOV		EDX,  OFFSET  userName
	CALL	WriteString

	Invoke ExitProcess,0	                        ; exit to operating system
	;http://masm32.com/board/index.php?topic=1226.15
	;https://github.com/cacarrilloc/ASSEMBLY-PROJECTS-MASM/blob/master/Integer_Accumulator.asm
main ENDP

; (insert additional procedures here)

END main