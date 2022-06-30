TITLE Elementary Arithmetic     (Proj1_tanglon.asm)

; Author: Lotto Long To Tang
; Last Modified: 29/6/2022
; OSU email address: tanglon@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 1                Due Date: 10/7/2022
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

; section for declaration of variables

intro1		BYTE	"         Elementary Arithmetic     by Lotto L.T. Tang",  0
intro2		BYTE	"Please enter 3 numbers A > B > C, and the program will calculate the sums and differences.",  0
prompt1		BYTE	"First Number: ",  0
numA		DWORD	?
prompt2		BYTE	"Second Number: ",  0
numB		DWORD	?
prompt3		BYTE	"Third Number: ",  0
numC		DWORD	?
plusSign	BYTE	" + ",  0
minusSign	BYTE	" - ",  0
equalSign	BYTE	" = ",  0
sumAB       DWORD   ?
minusAB     DWORD   ?
sumAC       DWORD   ?
minusAC     DWORD   ?
sumBC       DWORD   ?
minusBC     DWORD   ?
sumABC      DWORD   ?
goodBye     BYTE    "Thanks for using Elementary Arithmetic! Goodbye!",  0

; for extra credits - variables
ecRepeat    BYTE    "**EC: Program will ask if user wants to calculate again.",  0
ecVerify    BYTE    "**EC: Program verifies the numbers are in descending order.",  0
notDesc     BYTE    "ERROR: The numbers are not in descending order!",  0
notDescBye  BYTE    "Impressed?  Bye!",  0
quotientAB  DWORD   ?
remainderAB DWORD   ?
quotientAC  DWORD   ?
remainderAC DWORD   ?
quotientBC  DWORD   ?
remainderBC DWORD   ?

.code
main PROC

; introduction
	MOV		EDX,  OFFSET  intro1
	CALL	WriteString
	CALL	CrLf

    ;  display extra credit prompts


	MOV		EDX,  OFFSET  intro2
	CALL	WriteString
	CALL	CrLf

; get the data
	MOV		EDX,  OFFSET  prompt1
	CALL	WriteString
	CALL	ReadDec
	MOV		numA,  EAX
	MOV		EDX,  OFFSET  prompt2
	CALL	WriteString
	CALL	ReadDec
	MOV		numB,  EAX
	MOV		EDX,  OFFSET  prompt3
	CALL	WriteString
	CALL	ReadDec
	MOV		numC,  EAX

; calculate the required values
	MOV		EAX,  numA                                  ; Case 1 : A + B
	ADD     EAX,  numB
	MOV     sumAB,  EAX                                 ; store A + B into sumAB
	MOV     EAX,  0                                     ; initialize EAX to 0 (reset EAX)

	MOV		EAX,  numA                                  ; Case 2 : A - B
	SUB     EAX,  numB
	MOV     minusAB,  EAX                               ; store A - B into minusAB
	MOV     EAX,  0

    MOV		EAX,  numA                                  ; Case 3 : A + C
	ADD     EAX,  numC
	MOV     sumAC,  EAX                                 ; store A + C into sumAC
	MOV     EAX,  0

	MOV		EAX,  numA                                  ; Case 4 : A - C
	SUB     EAX,  numC
	MOV     minusAC,  EAX                               ; store A - C into minusAC
	MOV     EAX,  0

    MOV		EAX,  numB                                  ; Case 5 : B + C
	ADD     EAX,  numC
	MOV     sumBC,  EAX                                 ; store B + C into sumBC
	MOV     EAX,  0

    MOV		EAX,  numB                                  ; Case 6 : B - C
	SUB     EAX,  numC
	MOV     minusBC,  EAX                               ; store B - C into minusBC
	MOV     EAX,  0

    MOV		EAX,  sumAB                                 ; Case 7 : A + B + C
	ADD     EAX,  numC
	MOV     sumABC,  EAX                                ; store A + B + C into sumABC
	MOV     EAX,  0

; display the results
    CALL    CrLF                                        ; Display an empty line

    MOV     EAX, numA                                   ; Display Case 1: A + B
	CALL	WriteDec                                    ; move the operand to EAX for WriteDec
	MOV		EDX,  OFFSET  plusSign
	CALL	WriteString
	MOV		EAX,  numB
	CALL    WriteDec
	MOV		EDX,  OFFSET  equalSign
	CALL	WriteString
	MOV		EAX,  sumAB
	CALL    WriteDec
	CALL    CrLF
	MOV     EAX,  0                                     ; initialize EAX to 0 (reset EAX)

    MOV     EAX, numA                                   ; Display Case 2: A - B
	CALL	WriteDec                                    ; move the operand to EAX for WriteDec
	MOV		EDX,  OFFSET  minusSign
	CALL	WriteString
	MOV		EAX,  numB
	CALL    WriteDec
	MOV		EDX,  OFFSET  equalSign
	CALL	WriteString
	MOV		EAX,  minusAB
	CALL    WriteDec
	CALL    CrLF
	MOV     EAX,  0                                     ; initialize EAX to 0 (reset EAX)

    MOV     EAX, numA                                   ; Display Case 3: A + C
	CALL	WriteDec                                    ; move the operand to EAX for WriteDec
	MOV		EDX,  OFFSET  plusSign
	CALL	WriteString
	MOV		EAX,  numC
	CALL    WriteDec
	MOV		EDX,  OFFSET  equalSign
	CALL	WriteString
	MOV		EAX,  sumAC
	CALL    WriteDec
	CALL    CrLF
	MOV     EAX,  0                                     ; initialize EAX to 0 (reset EAX)

	MOV     EAX, numA                                   ; Display Case 4: A - C
	CALL	WriteDec                                    ; move the operand to EAX for WriteDec
	MOV		EDX,  OFFSET  minusSign
	CALL	WriteString
	MOV		EAX,  numC
	CALL    WriteDec
	MOV		EDX,  OFFSET  equalSign
	CALL	WriteString
	MOV		EAX,  minusAC
	CALL    WriteDec
	CALL    CrLF
	MOV     EAX,  0                                     ; initialize EAX to 0 (reset EAX)

    MOV     EAX, numB                                   ; Display Case 4: B + C
	CALL	WriteDec                                    ; move the operand to EAX for WriteDec
	MOV		EDX,  OFFSET  plusSign
	CALL	WriteString
	MOV		EAX,  numC
	CALL    WriteDec
	MOV		EDX,  OFFSET  equalSign
	CALL	WriteString
	MOV		EAX,  sumBC
	CALL    WriteDec
	CALL    CrLF
	MOV     EAX,  0                                     ; initialize EAX to 0 (reset EAX)

    MOV     EAX, numB                                   ; Display Case 5: B - C
	CALL	WriteDec                                    ; move the operand to EAX for WriteDec
	MOV		EDX,  OFFSET  minusSign
	CALL	WriteString
	MOV		EAX,  numC
	CALL    WriteDec
	MOV		EDX,  OFFSET  equalSign
	CALL	WriteString
	MOV		EAX,  minusBC
	CALL    WriteDec
	CALL    CrLF
	MOV     EAX,  0                                     ; initialize EAX to 0 (reset EAX)

    MOV     EAX,  numA                                  ; Display Case 6: A + B + C
	CALL	WriteDec                                    ; move the operand to EAX for WriteDec
	MOV		EDX,  OFFSET  plusSign
	CALL	WriteString
	MOV		EAX,  numB
	CALL    WriteDec
    MOV		EDX,  OFFSET  plusSign
	CALL	WriteString
    MOV		EAX,  numC
	CALL    WriteDec
	MOV		EDX,  OFFSET  equalSign
	CALL	WriteString
	MOV		EAX,  sumABC
	CALL    WriteDec
	CALL    CrLF
	MOV     EAX,  0                                     ; initialize EAX to 0 (reset EAX)
    CALL    CrLF                                        ; display an empty line

; say goodbye
    MOV     EDX,  OFFSET  goodBye
    CALL    WriteString

	Invoke ExitProcess,0	; exit to operating system

main ENDP

END main
