TITLE Prime Numbers     (Proj4_tanglon.asm)

; Author: Long To Lotto Tang
; Last Modified: 19/7/2022
; OSU email address: tanglon@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 4                Due Date: 24/7/2022
; Description: This program will ask for an integer and validate within the defined range [1...200],
;	then calculate and display the number of prime numbers within the range

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

LOWER_BOUND = 1
UPPER_BOUND = 200
ROW_MAX = 10

.data

; (insert variable definitions here)

; for introduction
intro1		BYTE	"Prime Numbers Programmed by Lotto Tang",  0
intro2		BYTE	"Enter the number of prime numbers you would like to see.",  0
intro3		BYTE	"I'll accept orders for up to 200 primes.",  0

; for validate
error1      BYTE    "No primes for you! Number out of range. Try again.",  0

; for getUserData
prompt1     BYTE    "Enter the number of primes to display [,  0
prompt2     BYTE    " ... ",  0
prompt3     BYTE    "]: ",  0

; for showPrimes
output1     BYTE    "   ",  0

.code
main PROC

; (insert executable instructions here)

	CALL	introduction



	Invoke ExitProcess,0	; exit to operating system

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
	RET

introduction ENDP

;============================================
validate PROC

; To validate the user input range between [1 ... 200]
; preconditions: user input passed in EAX
; postconditions: if in range, return EBX as 0; if out of range, show error messages and EBX as 1
; receives: user input in EAX
; returns: return the validated input from EAX to 'value'
;============================================
    ; check ranges
    MOV     EBX,  0                                 ; initialize EBX as 0 (default as true)
    CMP     EAX,  LOWER_BOUND                       ; user's input is stored in EAX from previous procedure
    JL      _error
    CMP     EAX,  UPPER_BOUND
    JG      _error

    ; validated input
    MOV     value,  EAX                             ; EAX is now storing the user input
    MOV     EBX,  0                                 ; assign EBX as 0 again to make sure the data is validated
	RET

	; jump here if invalid data found
	_error:
	MOV     EDX,  OFFSET  error1                    ; display error message
	CALL    WriteString
	CALL    CrLF
	MOV     EBX,  1
    RET                                             ; EBX as 1 to indicate error spotted

validate ENDP

;============================================
getUserData PROC

; To get an integer ranged between [1...200]
; preconditions: printing the instructions
; postconditions: EDX changed (for WriteString); EAX changed (user data in and in range)
; receives: N/A
; returns: the validated data will be stored in global variables 'value'
;============================================

; jump here for asking input
_askInput:
    MOV     EDX,  OFFSET  prompt1
    CALL    WriteString
    MOV     EAX,  LOWER_BOUND
    CALL    WriteDec
    MOV     EDX,  OFFSET  prompt2
    CALL    WriteString
    MOV     EAX,  UPPER_BOUND
    CALL    WriteDec
    MOV     EDX,  OFFSET  prompt3
    CALL    WriteString

    MOV     EAX,  0                                 ; initialize EAX as 0
    CALL    ReadInt                                 ; ask for user input
    CALL    CrLF

    CALL    validate                                ; call validate to check if within range
    CMP     EBX,  1                                 ; returned EBX: if 0 (valid input); 1 (invalid input)
    JE      _askInput                               ; ask user's input again if EBX = 1
    RET                                             ; validate already move EAX into 'value' already

getUserData ENDP

;============================================
showPrimes PROC

; To display the number of prime numbers (number depends on user's value)
; preconditions: display the prime numbers in at most 10 numbers per row
; postconditions: EDX changed (for WriteString); EAX changed (for displaying prime numbers)
; receives: prime numbers from isPrime
; returns: the formatted output for prime numbers
;============================================

    _checkPrime:
    MOV     EAX,  2                                 ; 1 is not prime by definition, start with 2
    MOV     EBX,  1                                 ; counter for max. output for a row
    MOV     ECX,  value                             ; for setting up counter to loop 'value' times

    CALL    isPrime
    CMP     EAX,  0
    JE      _displayPrime
    INC     EAX
    LOOP    _checkPrime

    ; jump here if isPrime returns 0
    _displayPrime:
    CALL    WriteDec
    MOV     EDX,  OFFSET  output1
    CALL    WriteString
    INC     EBX
    CMP     EBX,  MAX_ROW
    JE      _nextRow
    LOOP    _checkPrime

    ; jump here if a row contains 10 values
    _nextRow:
    CALL    CrLF
    MOV     EBX,  1
    LOOP    _checkPrime

	RET

showPrimes ENDP

;============================================
isPrime PROC

; To receive candidate value, return 1 for prime; 0 for not prime
; preconditions: setting up the inner loop counter (from value 2 to sqrt(value)); push the original ECX for recovery
; postconditions: change of EAX (divisor); ECX (counter); EDX (remainder)
; receives: the candidate value EAX
; returns: boolean 1 for prime; 0 for non-prime
;============================================

    PUSH    ECX                                     ; save outerloop ECX 


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