 TITLE Simple Comparator     (Comparator.asm)

; Author: Redfield
; Last Modified:
; OSU email address: ONID_ID@oregonstate.edu
; Course number/section:   CS271 Section ???
; Project Number:                 Due Date:
; Description: This program gets two unsigned values from the user,
;	and determines which is greater (or if they are equal), then
;	notifies the user of the conclusion.

;	Note: This program does not perform any data validation.
;   If the user gives invalid input, the output will be
;   meaningless.

INCLUDE Irvine32.inc

.data

; Constants
LOWER_RANGE = 1
UPPER_RANGE = 100

a           SDWORD   ?
b           SDWORD   ?
rules1      BYTE     "Enter two unsigned values, a and b. I will tell you which is greater.",13,10,0
prompt1     BYTE     "Enter value for a: ",0
prompt2     BYTE     "Enter value for b: ",0
error		BYTE	 "Please enter a value greater than 0!", 0
isGreater   BYTE     " is greater than ",0
isEqual     BYTE     "The two values you entered are equal",0
seeya       BYTE     ". Thanks for playing!",13,10,0

; for range validation
prompt3		BYTE	"Please enter a value in between 1 & 100: ", 0
error2		BYTE	"The value is smaller than 1!", 0
error3		BYTE	"The value is larger than 100!", 0
prompt4		BYTE	"You have entered: ", 0
bye			BYTE	"Thanks for using the program! Bye!", 0

.code
main PROC

  mov    EDX, OFFSET rules1
  call   WriteString

  ; Get value a
_getA:
  mov    EDX, OFFSET prompt1
  call   WriteString
  call   ReadInt
  CMP	 EAX, 0
  JL	 _errorA
  mov    a, EAX
  JMP	 _getB

_errorA:
  MOV	 EDX, OFFSET error
  CALL	 WriteString
  CALL	 CrLF
  JMP	 _getA
  
  ; Get value b
_getB:
  mov    EDX, OFFSET prompt2
  call   WriteString
  call   ReadInt
  CMP	 EAX, 0
  JL	 _errorB
  mov    b, EAX
  JMP	 _bothOK	; both values are valid

_errorB:
  MOV	 EDX, OFFSET error
  CALL	 WriteString
  CALL	 CrLF
  JMP	 _getB


  ; Print which is greater
_bothOK:
  mov    EAX, a
  cmp    EAX, b
  ja     _aGreater
  jb     _bGreater
  mov    EDX, OFFSET isEqual  ; They are equal
  call   WriteString
  jmp    _goodbye

_aGreater:     ; a is greater than b
  mov    EAX, a
  call   WriteDec
  mov    EDX, OFFSET isGreater
  call   WriteString
  mov    EAX, b
  call   WriteDec
  jmp    _goodbye

_bGreater:     ; b is greater than a
  mov    EAX, b
  call   WriteDec
  mov    EDX, OFFSET isGreater
  call   WriteString
  mov    EAX, a
  call   WriteDec

 _goodbye:
  mov    EDX, OFFSET seeya
  call   WriteString

; for data validation (range)
_checkRange:
  MOV	 EDX, OFFSET prompt3
  CALL	 WriteString
  CALL	 ReadInt
  CMP	 EAX, LOWER_BOUND
  JL	 _errorLowerBound
  CMP	 EAX, UPPER_BOUND
  JA	 _errorUpperBound
  JMP	 _bye

_errorLowerBound:
  MOV	 EDX, OFFSET error2
  CALL	 WriteString
  CALL	 CrLF
  JMP	 _checkRange

_errorUpperBound:
  MOV	 EDX, OFFSET error3
  CALL	 WriteString
  CALL	 CrLF
  JMP	 _checkRange

_bye:
  MOV	 EDX, OFFSET prompt4
  CALL	 WriteString
  CALL	 WriteDec
  CALL	 CrLF
  MOV	 EDX, OFFSET bye
  CALL	 WriteString

  Invoke ExitProcess,0	; exit to operating system
main ENDP


END main
