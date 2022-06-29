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

intro1		BYTE	"         Elementary Arithmetic     by Lotto L.T. Tang",  0			
intro2		BYTE	"Please enter 3 numbers A > B > C, and the program will calculate the sums and differences.",  0
prompt1		BYTE	"First Number: ",  0
numA		DWORD	?		
prompt2		BYTE	"Second Number: ",  0
numB		DWORD	?
prompt3		BYTE	"Third Number: ",  0
numC		DWORD	?
result		DWORD	?								; store the temporary result from calculation
plusSign	BYTE	" + ",  0						
minusSign	BYTE	" - ",  0
equalSign	BYTE	" = ",  0


.code
main PROC

; introduction
	MOV		EDX,  OFFSET  intro1
	CALL	WriteString
	CALL	CrLf
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
	; Case 1: A + B
	MOV		EAX,  numA
	CALL	WriteDec
	MOV		EDX,  OFFSET  plusSign
	CALL	WriteString
	ADD		EAX,  numB								
	MOV		result,  EAX								; store EAX (result of A+B into result)
	MOV		EAX,  numB									; move numB into EAX for calling WriteDec
	CALL	WriteDec
	MOV		EDX,  OFFSET  equalSign
	CALL	WriteString
	MOV		EAX,  result
	CALL	WriteDec	

		; Case 1: A + B
	MOV		EAX,  numA
	CALL	WriteDec
	MOV		EDX,  OFFSET  plusSign
	CALL	WriteString
	ADD		EAX,  numB								
	MOV		result,  EAX								; store EAX (result of A+B into result)
	MOV		EAX,  numB									; move numB into EAX for calling WriteDec
	CALL	WriteDec
	MOV		EDX,  OFFSET  equalSign
	CALL	WriteString
	MOV		EAX,  result
	CALL	WriteDec

	Invoke ExitProcess,0	; exit to operating system

main ENDP

END main
