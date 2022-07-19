TITLE Prime Numbers     (Proj4_tanglon.asm)

; Author: Long To Lotto Tang
; Last Modified: 19/7/2022
; OSU email address: tanglon@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 4                Due Date: 24/7/2022
; Description: This program will ask for a positive integer and validate within the defined range [1...200], 
;	then calculate and display the prime numbers within the range
;              

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

; (insert variable definitions here)

; for introduction
intro1		BYTE	"Prime Numbers Programmed by Lotto Tang",  0
intro2		BYTE	"Enter the number of prime numbers you would like to see.",  0
intro3		BYTE	"I'll accept orders for up to 200 primes.",  0

.code
main PROC

; (insert executable instructions here)

	CALL	introduction


	Invoke ExitProcess,0	; exit to operating system

main ENDP

; (insert additional procedures here)

; To display the purpose of the program, the expected input from user and the output from the program
; preconditions: strings that describe the program and rules
; postconditions: EDX changed
; receivees: N/A
; returns: N/A

introduction PROC

	MOV		EDX,  OFFSET  intro1
	CALL	WriteString
	CALL	CrLF

	CALL	CrLF

	MOV		EDX,  OFFSET  intro2
	CALL	WriteString
	CALL	CrLF
	MOV		EDX,  OFFSET  intro3
	CALL	WriteString
	CALL	CrLF

	CALL	CrLF
	RET

introduction ENDP

; description of the procedure
; preconditions:
; postconditions:
; receivees:
; returns:

getUserData PROC

	RET

getUserData ENDP

; description of the procedure
; preconditions:
; postconditions:
; receivees:
; returns:

validate PROC

	RET

validate ENDP

; description of the procedure
; preconditions:
; postconditions:
; receivees:
; returns:

showPrimes PROC

	RET

showPrimes ENDP

; description of the procedure
; preconditions:
; postconditions:
; receivees:
; returns:

isPrime PROC

	RET

isPrime ENDP

; description of the procedure
; preconditions:
; postconditions:
; receivees:
; returns:

farewell PROC

	RET

farewell ENDP




END main
