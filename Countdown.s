	AREA	Countdown, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	LDR	R1, =cdWord	    ; wordAddress
	LDR	R2, =cdLetters	; listAddress
	LDRB R3, [R1]       ; wordLetter = Memory.byte(wordAddress)
	LDRB R4, [R2]       ; listLetter = Memory.byte(listAddress)
	LDR R0, =1          ; isPossible = 1
	
while
	CMP R4, #0          ; while (listLetter != 0)
	BEQ endwhile        ; {
	CMP R3, R4          ; if (wordLetter != listLetter)
	BEQ isInList        ; {
	ADD R2, R2, #1      ; listAddress++
	LDRB R4, [R2]       ; listLetter = Memory.byte(listAddress)
	B while             ; }
isInList
	MOV R3, #'$'        ; wordLetter = '$'
	MOV R4, #'$'        ; listLetter = '$'
	STRB R3, [R1]       ; store wordLetter
	STRB R4, [R2]       ; store listLetter
	ADD R2, R2, #1      ; listAddress++
	LDRB R4, [R2]       ; listLetter = Memory.byte(listAddress)
	B while
endwhile

	ADD R1, R1, #1      ; wordAddress++
	LDRB R3, [R1]       ; wordLetter = Memory.byte.(wordAddress)
	LDR	R2, =cdLetters	; reset listAddress
	LDRB R4, [R2]       ; listLetter = Memory.byte(listAddress)
	CMP R3, #0          ; if (wordLetter != 0)
	BEQ endComparison   ;   branch to while
	B while
endComparison           ; }

	LDR	R1, =cdWord	    ; reset wordAddress
	LDRB R3, [R1]       ; wordLetter = Memory.byte(wordAddress)
	
checkChar
	CMP R3, #0          ; while (wordLetter != 0)
	BEQ endCheckChar    ; {
	CMP R3, #'$'        ; if (wordLetter == '$') 
	BNE isNotPossible   ; {
	ADD R1, R1, #1      ; wordAddress++
	LDRB R3, [R1]       ; wordLetter = Memory.byte(wordAddress)
	B checkChar         ; } 
	
isNotPossible
	MOV R0, #0          ; isPossible = 0
	
endCheckChar            ; }

stop	B	stop

	AREA	TestData, DATA, READWRITE
	
cdWord
	DCB	"beets",0

cdLetters
	DCB	"daetebzsb",0
	
	END	
