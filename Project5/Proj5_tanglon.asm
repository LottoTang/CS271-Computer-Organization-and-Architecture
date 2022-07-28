TITLE Project 5: Random Array Generator     (Proj5_tanglon.asm)

; Author: Long To Lotto Tang
; Last Modified: 28/7/2022
; OSU email address: tanglon@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5                Due Date: 7/8/2022
; Description: This project will automatically generate an integer array
;              - number of elements: a random number of ARRAYSIZE[200]
;              - value of elements: in range LO[15] - HI[50]
;            Output:
;              - 1) Unsorted generated array; with the median value of the whole array (round off)
;              - 2) Sorted array (in ascending order)
;              - 3) Counted array (count the occurrence of each element; if no such value; 0 is displayed)
;

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)
LO = 15
HI = 50
ARRAYSIZE = 200

.data

; (insert variable definitions here)

; for introduction
intro1      BYTE    "Generating, Sorting, and Counting Random integers!              Programmed by Lotto",  0
intro2      BYTE    "This program generates 200 random integers between 15 and 50, inclusive.",  0
intro3      BYTE    "It then displays the original list, sorts the list, displays the median value of the list,",  0
intro4      BYTE    "displays the list sorted in ascending order, and finally displays the number of instances",  0
intro5      BYTE    "of each generated value, starting with the number of lowest.",  0

; for fillArray
list        DWROD   ARRAYSIZE DUP (?)               ; declare array (# of elements = ARRAYSIZE; initialize as ?)
ranVal      DWORD   ?



.code
main PROC

; (insert executable instructions here)

    CALL    randomize                               ; initialize starting seed value of RandomRange

    CALL    introduction                            ; display greetings & general instructions

    PUSH    OFFSET,  list                           ; push the address of the array on stack as parameter
    CALL    fillArray                               ; to fill up the array by random numbers range LO - HI


	Invoke ExitProcess,0	                        ; exit to operating system

main ENDP

; (insert additional procedures here)

;============================================
introduction PROC

; To display the purpose and general instruction of the program
; preconditions: strings that describe the program and rules
; postconditions: EDX changed
; receives: N/A
; returns: N/A
;============================================

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
	MOV		EDX,  OFFSET  intro4
	CALL	WriteString
	CALL	CrLF

    CALL	CrLF
	MOV		EDX,  OFFSET  intro5
	CALL	WriteString
	CALL	CrLF
	RET

introduction ENDP

;============================================
fillArray PROC

; To fill up the entire array by random numbers ranging from LO - HI
; preconditions: 1) Push EBP; 2) ESI as address of list; 3) Change ECX to ARRAYSIZE; 4) Call RandomRange (Upper Bound to EAX)
; postconditions: 1) Advance of ESI after each fill in
; receives: 1) ESI & advancement; 2) Random number (EAX)
; returns: 1) using Indexed Operands [ESI], EAX to store the random number to list
;============================================

    PUSH    EBP
    MOV     EBP,  ESP                               ; set EBP to allow base+offset operations
    MOV     ESI,  [EBP+8]                           ; ESI is pointing to the 1st address of list
    MOV     ECX,  ARRAYSIZE                         ; set counter as ARRAYSIZE to fill up the whole array
    JMP     _generateRandom

    _generateRandom:
    MOV     EAX,  HI
    SUB     EAX,  LO
    CALL    RandomRange                             ; generate random number from (0- (HI-LOW))
    ADD     EAX,  LO                                ; add LO to match within the range LO - HI
    MOV     [ESI],  EAX                             ; put the random value to corresponding array's address using Indirect Operands
    ADD     ESI,  4
    LOOP    _generateRandom                         ; the process should loop for ARRAYSIZE times


fillArray ENDP

END main
