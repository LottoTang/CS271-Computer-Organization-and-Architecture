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

.data

; (insert variable definitions here)

; for part 1
greeting1	BYTE	"Welcome to the Integer Accumulator by Lotto Tang",  0
intro1		BYTE	"We will be accumulating user-input negative integers between the specified bounds, then displaying" ,  0
intro2		BYTE	"statistics of the input values including minimum, maximum, and average values values, total sum, and" ,  0
intro3		BYTE	"total number of valid inputs." ,  0
prompt1		BYTE	"What is your name? ",  0
userName	BYTE	21 DUP (0)						; variable for asking userName; set the size as 20 (1 extra for null-terminated) as name should within 20 characters
greeting2	BYTE	"Hello there, ",  0

; for part 2
intro4		BYTE	"Please enter numbers in [",  0
comma		BYTE	", ",  0
intro5		BYTE	"] or [",  0
intro6		BYTE	"].",  0
						

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




	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
