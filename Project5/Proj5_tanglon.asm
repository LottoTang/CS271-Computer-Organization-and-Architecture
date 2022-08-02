TITLE Project 5: Random Array Generator     (Proj5_tanglon.asm)

; Author: Long To Lotto Tang
; Last Modified: 1/8/2022
; OSU email address: tanglon@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5                Due Date: 7/8/2022
; Description: This project will automatically generate an integer array
;              - number of elements: ARRAYSIZE[200]
;              - value of elements: random value in range LO[15] - HI[50]
;            Output:
;              - 1) Unsorted generated array;
;              - 2) Sorted array (in ascending order) with the median value of the whole array (round off)
;              - 3) Counted array (count the occurrence of each element; if no such value; 0 is displayed)
;
;            Sorting Algorithm:
;              - Example: 14 33 27 10 35 (14 as the sorted part; scan through the unsorted 33 - 35)
;              -          find the smallest among the unsorted part
;              -          swap with the rightmost part of the sorted array
;              -          10 33 | 14 27 35 (10 now is in sorted part; put the leftmost unsorted value into sorted part (33) for next comparison)
;              - Final:   10 14 27 33 35
;
;

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)
LO = 15
HI = 50
ARRAYSIZE = 20
MAX_COL = 20

; for displayMedian
ROUNDUPVAL = 5

.data

; (insert variable definitions here)

; for introduction
intro1      BYTE    " **Generating, Sorting, and Counting Random integers! ** by Lotto",  0
intro2      BYTE    "This program generates ",  0
intro3      BYTE    " random integers between ",  0
intro4      BYTE    " and ",  0
intro5      BYTE    ", inclusive.",  0
intro6      BYTE    "It then displays the original list, sorts the list, displays the median value of the list,",  0
intro7      BYTE    "displays the list sorted in ascending order, and finally displays the number of instances",  0
intro8      BYTE    "of each generated value, starting with the number of lowest",  0

; for fillArray
randArray   DWORD   ARRAYSIZE DUP (?)                       ; declare array (# of elements = ARRAYSIZE in uninitialized state)
unsorted1   BYTE    "Your unsorted random numbers:",  0

; for displayArray
output1     BYTE    " ",  0

; for sortList
sorted1     BYTE    "Your sorted random numbers:",  0

; for displayMedian
median1     BYTE    "The median value of the array: "

; for countList
count       DWORD   (HI - LO + 1) DUP (?)                      ; the maximum possibility is having all unique number from LO to HI
count1      BYTE    "Your list of instances of each generated number, starting with the smallest value:",  0

; for farewell
farewell1   BYTE    "Goodbye, and thanks for using my program!",  0

.code
main PROC

; (insert executable instructions here)

    CALL    Randomize                               ; initialize starting seed value of RandomRange

    CALL    introduction

    PUSH    OFFSET  randArray                       ; push the address of the array on stack as parameter
    CALL    fillArray

    PUSH    OFFSET  randArray
    CALL    displayList

    PUSH    OFFSET  randArray
    CALL    sortList

    PUSH    OFFSET  randArray
    CALL    displayMedian

    PUSH    OFFSET  randArray
    CALL    displayList

    PUSH    OFFSET  count
    PUSH    OFFSET  randArray
    CALL    countList

    PUSH    OFFSET  count
    CALL    displayListCount
    
    PUSH    OFFSET  farewell1
    CALL    farewell

	Invoke ExitProcess,0	                        ; exit to operating system

main ENDP

; (insert additional procedures here)

;============================================
introduction PROC

; To display the purpose and general instruction of the program
; preconditions: strings that describe the program and rules
; postconditions: EDX changed
; receives: offset of the string
; returns: the string messages
;============================================

	MOV		EDX,  OFFSET  intro1                    ; EDX is now pointing to intro1
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
; preconditions: 1) Setup stack frame; 2) ESI as address of randArray; 3) Change ECX to ARRAYSIZE; 4) Call RandomRange (Upper Bound to EAX)
; postconditions: 1) Advance of ESI after each fill in
; receives: 1) ESI & advancement; 2) Random number (EAX)
; returns: 1) store the random number to randArray
;============================================

    ; start generating random numbers looping for ARRAYSIZE times
    PUSH    EBP
    MOV     EBP,  ESP                               ; set EBP to allow base+offset operations

    CALL    CrLF
    MOV     EDX,  OFFSET  unsorted1
    CALL    WriteString
    CALL    CrLF

    MOV     ESI,  [EBP+8]                           ; ESI is pointing to the 1st address of randArray
    MOV     ECX,  ARRAYSIZE                         ; set counter as ARRAYSIZE to fill up the whole array
    JMP     _generateRandom

    _generateRandom:
    MOV     EAX,  HI
    SUB     EAX,  LO
    INC     EAX
    CALL    RandomRange                             ; generate random number from (0 - (HI-LOW))
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
    PUSHAD                                          ; reserve all the registers

    MOV     ESI,  [EBP+16]                          ; ESI is now pointing to the address of the array

    MOV     EDI,  [EBP+8]                           ; EDX now storing the difference in bytes between randArray[0] to current comparing value
    MOV     EDX,  [ESI+EDI]                         ; EDX is now storing the comparing value

    MOV     EBX,  [EBP+12]                          ; EBX is now storing the difference in bytes with the 'smaller' value with the comparing value
    ADD     EBX,  EDI                               ; EBX: the difference of bytes between randArray[0] to randArray[smaller value]
    MOV     EAX,  [ESI+EBX]                         ; EAX is now storing the 'smaller' value

    MOV     [ESI+EDI],  EAX                         ; swap
    MOV     [ESI+EBX],  EDX

    POPAD                                           ; restore the original registers
    POP     EBP
    RET     12

exchangeElements ENDP


;============================================
sortList PROC

; To sort the array in ascending order (using selection sort)
; preconditions: store the address of the rightmost sorted part in EDI, EBX as the value of the rightmost sorted part
;                once smaller value is found, EBX is updated, EAX stores the difference in bytes between the rightmost sorted part to the location of the 'smaller' value
; postconditions: POP ECX to restore the outer loop
; receives: 1) offset of randArray; 2) offset of string
; returns: 1) the sorted randArray
;============================================

    PUSH    EBP
    MOV     EBP,  ESP
    MOV     ESI,  [EBP+8]                           ; ESI is pointing to the 1st address of randArray
    MOV     EDX,  0                                 ; store the difference in bytes between randArray[0] to rightmost sorted part
    MOV     ECX,  ARRAYSIZE
    DEC     ECX                                     ; selection sort will only do ARRAYSIZE - 1 times

    _outerLoop:

    PUSH    ECX                                     ; save the outer loop counter
    PUSH    ESI                                     ; push the current address on stack (rightmost sorted part)
    MOV     EDI,  ESI                               ; initialize EDI to store the address of the rightmost sorted part
    MOV     EBX,  [EDI]                             ; store the value of that address to EBX
    JMP     _innerLoop

    _innerLoop:

    ADD     ESI,  4                                 ; advance ESI to next address for comparison (checking the unsorted part)
    CMP     [ESI],  EBX
    JL      _updateMin
    JMP     _innerLoopContinue

    _innerLoopContinue:

    LOOP    _innerLoop
    CMP     EBX,  [EDI]
    JNE     _goSwap
    JMP     _resumeSwap

    _goSwap:
    PUSH    OFFSET  randArray
    PUSH    EAX
    PUSH    EDX
    CALL    exchangeElements                        ; exchange the elements once the 'smaller' value among the unsorted part is found
    JMP     _resumeSwap

    _resumeSwap:
    POP     ESI                                     ; restore ESI
    ADD     ESI,  4                                 ; advance the rightmost sorted part to the next item for checking with the remaining unsorted part
    POP     ECX                                     ; restore loop counter
    ADD     EDX,  4                                 ; advance the difference of bytes between randArray[0] to current rightmost sorted part
    LOOP    _outerLoop

    POP     EBP
    RET     4

    _updateMin:

    MOV     EAX,  ESI
    SUB     EAX,  EDI                               ; EAX now stores the difference of bytes from the rightmost sorted part to 'smaller' value
    MOV     EBX,  [ESI]                             ; update EBX to check with remaining unsorted [ESI]
    JMP     _innerLoopContinue

sortList ENDP


;============================================
displayMedian PROC

; To display the median value of the randArray
; preconditions: the offset of the randArray and it is sorted
; postconditions: check if the ARRAYSIZE is odd/even to determine the median value
; receives: 1) the offset of the randArray and it is sorted
; returns: 1) the median value (in round off)
;============================================

    PUSH    EBP
    MOV     EBP,  ESP
    MOV     ESI,  [EBP+8]

    MOV     EAX,  ARRAYSIZE                         ; determine whether ARRAYSIZE is odd or even
    MOV     EBX,  2
    MOV     EDX,  0
    DIV     EBX                                     ; quotient (EAX) is storing the index of ARRAYSIZE for the median value (odd & even for difference cases)
    CMP     EDX,  0
    JE      _isEven
    JMP     _isOdd

    _isEven:

    MOV     EAX,  ARRAYSIZE * TYPE randArray
    MOV     EBX,  2
    MOV     EDX,  0
    DIV     EBX
    SUB     EAX,  TYPE randArray
    MOV     EBX,  [ESI + EAX]                       ; EBX is now storing the value of randArray[EAX] (in index representation)
    ADD     EAX,  TYPE randArray
    MOV     ECX,  [ESI + EAX]                       ; ECX is now storing the value of randArray[EAX+1] (in index representation)

    MOV     EDI,  EBX
    ADD     EDI,  ECX
    MOV     EAX,  EDI
    MOV     EBX,  2
    MOV     EDX,  0
    DIV     EBX
    MOV     EDI,  EAX                               ; EDI is now storing (EBX+ECX)/2

    MOV     EAX,  EDX                               ; this part is for checking whether need to round up or not
    MOV     EBX,  10
    MUL     EBX                                     ; EAX is now equal to remainder * 10
    MOV     EBX,  2
    DIV     EBX
    CMP     EAX,  ROUNDUPVAL
    JGE     _roundOff
    JMP     _noRoundOff

    _roundOff:

    INC     EDI
    MOV     EAX,  EDI                               ; for WriteDec
    JMP     _displayResult

    _noRoundOff:

    MOV     EAX,  EDI
    JMP     _displayResult

    _isOdd:

    MOV     EAX,  ARRAYSIZE
    MOV     EBX,  2
    MOV     EDX,  0
    DIV     EBX
    MOV     EBX,  TYPE  randArray
    MUL     EBX
    MOV     EDI,  [ESI + EAX]                       ; EDI is now storing the value of the median value
    MOV     EAX,  EDI                               ; place the median value in EAX for WriteDec
    JMP     _displayResult

    _displayResult:

    CALL    CrLF

    CALL    CrLF
    MOV     EDX,  OFFSET  median1
    CALL    WriteString
    CALL    WriteDec
    CALL    CrLF

    CALL    CrLF
    MOV     EDX,  OFFSET  sorted1
    CALL    WriteString
    CALL    CrLf

    CALL    CrLF

    POP     EBP
    RET     4

displayMedian ENDP


;============================================
countList PROC

; To count the occurrence of the values from the sorted randArray
; preconditions: the offset of the randArray and it is sorted
; postconditions: reset the counter to 0 for each value
; receives: 1) the offset of the randArray and it is sorted
; returns: 1) the count array
;============================================

    PUSH    EBP
    MOV     EBP,  ESP

    CALL    CrLF
    
    CALL    CrLF
    MOV     EDX,  OFFSET  count1
    CALL    WriteString
    CALL    CrLF

    MOV     ESI,  [EBP+8]                           ; ESI is now pointing to randArray
    MOV     EAX,  [ESI]                             ; EAX is storing the value within the address
    MOV     EDI,  [EBP+12]                          ; EDI is now pointing to count
    MOV     ECX,  ARRAYSIZE
    MOV     EBX,  1                                 ; counter for the unique value in randArray
    MOV     EDX,  4                                 ; to calculate the difference in bytes in count from count[0] to current
    JMP     _loopCount

    _loopCount:

    CMP     EAX,  [ESI + EDX]
    JE      _addCounter
    JMP     _writeCount

    _addCounter:

    INC     EBX
    ADD     EDX,  TYPE  randArray
    LOOP    _loopCount

    _writeCount:

    MOV     [EDI],  EBX
    ADD     EDI,  TYPE  count                       ; advance EDX for accessing next elements in count array
    MOV     EBX,  1                                 ; reset EBX for next unique value
    MOV     EAX,  [ESI + EDX]                       ; update EAX to store the next unique value
    ADD     EDX,  TYPE  randArray
    LOOP    _loopCount

    POP     EBP
    RET     8

countList ENDP

;============================================
displayListCount PROC

; To display the entire array count
; preconditions: 1) Push EBP; 2) ESI as address of randArray; 3) Change ECX to (HI - LO + 1); 4) Display 20 elements per row as maximum
; postconditions: 1) EAX changed for WriteDec; 2) Advance of ESI after each fill in; 3) increment of row counter EBX
; receives: 1) Address of the array ESI and its value
; returns: 1) the output of value in the address from WriteDec
;============================================

    PUSH    EBP
    MOV     EBP,  ESP
    MOV     EBX,  0                                 ; set EBX as the row counter
    MOV     ESI,  [EBP+8]
    MOV     EAX,  HI
    SUB     EAX,  LO
    ADD     EAX,  1
    MOV     ECX,  EAX
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

displayListCount ENDP


;============================================
farewell PROC

; To display the farewell message
; preconditions: strings that describe the program and rules
; postconditions: EDX changed
; receives: offset of the string
; returns: the string messages
;============================================

    PUSH    EBP
    MOV     EBP,  ESP                               ; set up the stack frame

    CALL    CrLF

    CALL    CrLF
    MOV     EDX,  [EBP+8]
    CALL    WriteString

    CALL    CrLF

    RET     4

farewell ENDP

END main