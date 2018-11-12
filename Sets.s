	AREA	Sets, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	LDR R1, =AElems   ; Aaddress = address of A elements
	LDR R2, =0		  ; Avalue
	LDR R3, =BElems   ; Baddress = address of B elements
	LDR R4, =0        ; Bvalue
	LDR R5, =CElems   ; Caddress = address of C elements
	LDR R7, =ASize    ; size of A elements
	LDR R7, [R7]      ; Asize = Memory.word(Asize)
	LDR R8, =BSize    ; size of B elements
	LDR R8, [R8]      ; Bsize = Memory.word(Bsize)
	LDR R9, =CSize    ; size of C elements
	LDR R6, [R9]      ; Csize = Memory.word(Csize)
	LDR R10, =0       ; Acounter = 0
	LDR R11, =0       ; Bcounter = 0

	
Awhile
	LDR R2, [R1]      ; Avalue = Memory.word(Aaddress)
	LDR R4, [R3]      ; Bvalue = Memory.word(Baddress)
	CMP R11, R8       ; if (Bcounter == Bsize)
	BEQ endofloop     ;    branch to endofloop
	CMP R2, R4        ; if (Avalue == Bvalue)
	BEQ equal         ;    branch to equal
	ADD R3, R3, #4    ; Baddress += 4
	ADD R11, R11, #1  ; Bcounter++
	B   Awhile

endofloop
	STR R2, [R5]      ; store Avalue in CElems
	ADD R5, R5, #4    ; Caddress += 4
	ADD R6, R6, #1    ; Csize++
	ADD R10, R10, #1  ; Acounter++
	CMP R10, R7       ; if (Acounter == Asize)
	BEQ endALoop      ;   branch to endALoop 
	ADD R1, R1, #4    ; Aaddress += 4
	LDR R3, =BElems   ; reset Baddress
	MOV R11, #0       ; Bcounter = 0;
	B   Awhile

equal
	CMP R10, R7       ; if (Acounter == Asize)
	BEQ endALoop      ;   branch to endALoop
	ADD R1, R1, #4    ; Aaddress += 4
	ADD R10, R10, #1  ; Acounter += 1
	LDR R3, =BElems   ; reset Baddress
	MOV R11, #0       ; Bcounter = 0
	B   Awhile
	
endALoop
	
	LDR R1, =AElems   ; Aaddress = address of A elements
	LDR R3, =BElems   ; Baddress = address of B elements
	LDR R10, =0       ; Acounter = 0
	LDR R11, =0       ; Bcounter = 0

Bwhile
	LDR R2, [R1]      ; Avalue = Memory.word(Aaddress)
	LDR R4, [R3]      ; Bvalue = Memory.word(Baddress)
	CMP R10, R7       ; if (Acounter == Asize)
	BEQ endofloopB    ;    branch to endofloopB
	CMP R2, R4        ; if (Avalue == Bvalue)
	BEQ equalB        ;    branch to equal
	ADD R1, R1, #4    ; Aaddress += 4
	ADD R10, R10, #1  ; Acounter++
	B   Bwhile
	
endofloopB
	STR R4, [R5]      ; store Bvalue in CElems
	CMP R11, R8       ; if (Bcounter == Bsize)
	BEQ endBLoop      ;   branch to endBLoop 
	ADD R5, R5, #4    ; Caddress += 4
	ADD R6, R6, #1    ; Csize++
	ADD R3, R3, #4    ; Baddress += 4
	ADD R11, R11, #1  ; Bcounter++
	LDR R1, =AElems   ; reset Aaddress
	MOV R10, #0       ; Acounter = 0;
	B   Bwhile

equalB
	CMP R11, R8       ; if (Bcounter == Bsize)
	BEQ endBLoop      ;   branch to endBLoop
	ADD R3, R3, #4    ; Baddress += 4
	ADD R11, R11, #1  ; Bcounter += 1
	LDR R1, =AElems   ; reset Aaddress
	MOV R10, #0       ; Acounter = 0
	B   Bwhile	

endBLoop

	STR R6, [R9]      ; store Csize

stop	B	stop


	AREA	TestData, DATA, READWRITE
	
ASize	DCD	8			; Number of elements in A
AElems	DCD	4, 6, 2, 13, 19, 7, 1, 3	; Elements of A

BSize	DCD	6			; Number of elements in B
BElems	DCD	13, 9, 1, 9, 5, 8	; Elements of B

CSize	DCD	0			; Number of elements in C
CElems	SPACE	56			    ; Elements of C 

	END	
