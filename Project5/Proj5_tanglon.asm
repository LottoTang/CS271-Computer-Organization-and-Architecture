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
ARRAYSIZE = 3
MAX_COL = 20

.data

; (insert variable definitions here)

; for introduction
intro1      BYTE    "**Generating, Sorting, and Counting Random integers!** by Lotto",  0
intro2      BYTE    "This program generates ",  0
intro3      BYTE    " random integers between ",  0
intro4      BYTE    " and ",  0
intro5      BYTE    ", inclusive.",  0
intro6      BYTE    "The program will first display the random list, displays the median value of the list,",  0
intro7      BYTE    "displays the list sorted in ascending order, and finally displays the number of instances",  0
intro8      BYTE    "of each generated value, starting with the number of lowest.",  0

; for fillArray
randArray   DWORD   ARRAYSIZE DUP (?)               ; declare array (# of elements = ARRAYSIZE; initialize as ?)
unsorted1   BYTE    "Your unsorted random numbers:",  0

; for displayArray
output1     BYTE    " ",  0

; for sortList
sorted1     BYTE    "Your sorted random numbers:",  0


.code
main PROC

; (insert executable instructions here)

    CALL    Randomize                               ; initialize starting seed value of RandomRange

    CALL    introduction                            ; display greetings & general instructions

    PUSH    OFFSET  randArray                       ; push the address of the array on stack as parameter
    CALL    fillArray                               ; to fill up the array by random numbers range LO - HI

    PUSH    OFFSET  randArray                       ; push the address of the array on stack as parameter
    CALL    displayList

    PUSH    OFFSET  randArray
    CALL    sortList

    PUSH    OFFSET  randArray                       ; push the address of the array on stack as parameter
    CALL    displayList


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
	MOV     EAX,  ARRAYSIZE
	CALL    WriteDec
    MOV		EDX,  OFFSET  intro3
	CALL	WriteString
	MOV     EAX,  LO
	CALL    WriteDec
    MOV		EDX,  OFFSET  intro4
	CALL	WriteString
	MOV     EAX,  HI
	CALL    WriteDec
    MOV		EDX,  OFFSET  intro5
	CALL	WriteString


	CALL	CrLF
	MOV		EDX,  OFFSET  intro6
	CALL	WriteString

    CALL	CrLF
	MOV		EDX,  OFFSET  intro7
	CALL	WriteString

    CALL	CrLF
	MOV		EDX,  OFFSET  intro8
	CALL	WriteString
	CALL	CrLF
	RET

introduction ENDP

;============================================
fillArray PROC

; To fill up the entire array by random numbers ranging from LO - HI
; preconditions: 1) Push EBP; 2) ESI as address of randArray; 3) Change ECX to ARRAYSIZE; 4) Call RandomRange (Upper Bound to EAX)
; postconditions: 1) Advance of ESI after each fill in
; receives: 1) ESI & advancement; 2) Random number (EAX)
; returns: 1) using Indexed Operands [ESI], EAX to store the random number to randArray
;============================================

    CALL    CrLF
    MOV     EDX,  OFFSET  unsorted1
    CALL    WriteString
    CALL    CrLF

    ; start generating random numbers looping for ARRAYSIZE times
    PUSH    EBP
    MOV     EBP,  ESP                               ; set EBP to allow base+offset operations
    MOV     ESI,  [EBP+8]                           ; ESI is pointing to the 1st address of randArray
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

    POP     EBP
    RET     4                                       ; return the memory address of randArray

fillArray ENDP

;============================================
displayList PROC

; To display the entire array randArray
; preconditions: 1) Push EBP; 2) ESI as address of randArray; 3) Change ECX to ARRAYSIZE; 4) Display 20 elements per row as maximum
; postconditions: 1) EAX changed for WriteDec; 2) Advance of ESI after each fill in; 3) increment of row counter EBX
; receives: 1) Address of the array ESI and its value
; returns: 1) the output of value in the address from WriteDec
;============================================

    PUSH    EBP
    MOV     EBP,  ESP
    MOV     EBX,  0                                 ; set EBX as the row counter
    MOV     ESI,  [EBP+8]
    MOV     ECX,  ARRAYSIZE
    JMP     _displayArray

    _displayArray:

    MOV     EAX,  [ESI]                             ; copy the value from that address to EAX for WriteDec
    CALL    WriteDec
    MOV     EDX,  OFFSET  output1
    CALL    WriteString
    INC     EBX
    CMP     EBX,  MAX_COL
    JE      _nextRow
    JMP     _nextNumber

    _nextRow:
    CALL    CrLF
    MOV     EBX,  0
    JMP     _nextNumber

    _nextNumber:
    ADD     ESI,  4
    LOOP    _displayArray

    POP     EBP
    RET     4

displayList ENDP

;============================================
exchangeElements PROC

; To exchange the contents of the 2 elements
; preconditions: push the address of the 2 elements
; postconditions: N/A
; receives: address of the 2 elements
; returns: N/A (write the new value into the other address)
;============================================

    PUSH    EBP
    MOV     EBP,  ESP

    MOV     ESI,  [EBP+12]
    MOV     EBX,  [ESI]                             ; EBX now storing the 'smaller' value
    MOV     EDX,  [ESI+4]                           ; EDX now storing the target value (to compare with others)
    MOV     [ESI+4],  EBX
    MOV     [ESI],  EDX

    POP     EBP
    RET     8

exchangeElements ENDP

;============================================
sortList PROC

; To sort the array in ascending order
; preconditions: using insertion sort (outer and inner loop): push ECX
; postconditions: POP ECX to restore the outer loop
; receives: 1) ESI & advancement;
; returns: 1) the sorted array
;============================================

    PUSH    EBP
    MOV     EBP,  ESP
    MOV     ESI,  [EBP+8]
    MOV     ECX,  ARRAYSIZE
    DEC     ECX                                     ; insertion sort will only do ARRAYSIZE - 1 times

    _outerLoop:

    PUSH    ECX                                     ; save the outer loop counter
    PUSH    ESI                                     ; push the current address on stack (for comparing with other elements)
    MOV     EDI,  0
    MOV     EDI,  ESI                               ; initialize EDI to store the address of the target item (to compare with others)
    MOV     EBX,  [EDI]                             ; store the value of that address to EBX
    JMP     _innerLoop

    _innerLoop:

    ADD     ESI,  4                                 ; advance ESI to next address for comparison
    CMP     [ESI],  EBX
    JL      _updateMin
    JMP     _innerLoopContinue

    _innerLoopContinue:

    LOOP    _innerLoop
    PUSH    EAX
    PUSH    EDI
    CALL    exchangeElements                        ; exchange the elements once the min value is found

    POP     ESI                                     ; restore the swapped address
    ADD     ESI,  4                                 ; check for next address with the remaining
    POP     ECX                                     ; restore loop counter
    LOOP    _outerLoop

    MOV     EDX,  OFFSET  sorted1
    CALL    WriteString
    CALL    CrLf

    POP     EBP
    RET     4

    _updateMin:

    MOV     EAX,  ESI                             ; EAX now stores the address of the 'smaller' element
    MOV     EBX,  [EAX]
    JMP     _innerLoopContinue

sortList ENDP



END main
