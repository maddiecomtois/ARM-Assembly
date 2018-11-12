	AREA	Lotto, CODE, READONLY
	IMPORT	main
	EXPORT	start

start
	LDR R2, =0                   ; ticketNumber = 0
	LDR R9, =0                   ; drawNumber = 0
	LDR	R1, =TICKETS             ; load ticketAddress
	LDRB R2, [R1]                ; ticketNumber = Memory.byte(ticketAddress)
	LDR R3, =0                   ; matchCounter = 0
	LDR R4, =0                   ; match4 = 0
	LDR R5, =0                   ; match5 = 0
	LDR R6, =0                   ; match6 = 0
	LDR R7, =COUNT               ; load countAddress
	LDRB R7, [R7]                ; numOfTickets = Memory.byte(countAddress)
	LDR R8, =DRAW                ; load lotteryDrawAddress
	LDRB R9, [R8]                ; drawNumber = Memory.byte(lotteryDrawAddress)
	LDR R10, =0                  ; drawCounter = 0
	LDR R11, =0                  ; numOfRounds = 0
	LDR R12, =0                  ; ticketCounter = 0
	
while
	CMP R11, R7                  ; while (numOfRounds != numOfTickets)
	BEQ endwhile                 ; {
	CMP R2, R9                   ; if (ticketNumber != drawNumber)
	BEQ matchfound
	ADD R10, R10, #1             ; drawCounter++
	CMP R10, #6                  ; if (drawCounter != 6)
	BEQ nextDrawNumber           ; {
	ADD R8, R8, #1               ; lotteryDrawAddress++
	LDRB R9, [R8]                ; drawNumber = Memory.byte(lotteryDrawAddress)
	B while                      ; }
	
matchfound
	ADD R3, R3, #1               ; matchCounter++
	MOV R10, #0                  ; drawCounter = 0
	ADD R1, R1, #1               ; ticketAddress++
	ADD R12, R12, #1			 ; ticketCounter++
	CMP R12, #6                  ; if (ticketCounter != 6)
	BEQ evaluateTicket           ; {
	LDRB R2, [R1]                ; ticketNumber = Memory.byte(ticketAddress)
	LDR R8, =DRAW                ; load lotteryDrawAddress
	LDRB R9, [R8]                ; drawNumber = Memory.byte(lotteryDrawAddress)
	B while                      ; }

nextDrawNumber
	MOV R10, #0                  ; drawCounter = 0
	ADD R12, R12, #1             ; ticketCounter++
	CMP R12, #6                  ; if (ticketCounter != 6)
	BEQ evaluateTicket           ; {
	ADD R1, R1, #1               ; ticketAddress++
	LDRB R2, [R1]                ; ticketNumber = Memory.byte(ticketAddress)
	LDR R8, =DRAW                ; reload lotteryDrawAddress
	LDRB R9, [R8]                ; drawNumber = Memory.byte(lotteryDrawAddress)
	B while                      ; }

evaluateTicket
	CMP R3, #4                   ; if (matchCounter == 4)
	BEQ match4                   ;    branch to match4
	CMP R3, #5                   ; if (matchCounter == 5)
	BEQ match5                   ;    branch to match5
	CMP R3, #6                   ; if (matchCounter == 6)
	BEQ match6                   ;    branch to match6
	B nextTicket                 ; else branch to nextTicket
	
match4
	ADD R4, R4, #1			   	 ; match4++
	B nextTicket
match5
	ADD R5, R5, #1               ; match5++
	B nextTicket
match6
	ADD R6, R6, #1               ; match6++

	
nextTicket
	ADD R11, R11, #1             ; numOfRounds++
	MOV R12, #0                  ; ticketCounter = 0
	MOV R10, #0                  ; drawCounter = 0
	MOV R3, #0                   ; matchCounter = 0
	ADD R1, R1, #1               ; ticketAddress++
	LDRB R2, [R1]                ; ticketNumber = Memory.byte(ticketAddress)
	LDR R8, =DRAW                ; reload lotteryDrawAddress
	LDRB R9, [R8]                ; drawNumber = Memory.byte(lotteryDrawAddress)
	B while
endwhile                         ; }
	
	MOV R0, R4                   ; R0 = match4
	LDR R4, =MATCH4              ; load match4Address
	STR R0, [R4]                 ; store match4 in match4Address
	MOV R0, R5                   ; R0 = match5
	LDR R5, =MATCH5              ; load match5Address
	STR R0, [R5]                 ; store match5 in match5Address
	MOV R0, R6                   ; R0 = match6
	LDR R6, =MATCH6              ; load match6Address
	STR R0, [R6]                 ; store R0 in match6Address
	
stop	B	stop 



	AREA	TestData, DATA, READWRITE
	
COUNT	DCD	3			; Number of Tickets
TICKETS	DCB	3, 8, 11, 21, 22, 31 ; Tickets
	DCB	7, 23, 25, 28, 29, 32
	DCB	10, 11, 12, 22, 26, 30
	

DRAW	DCB	10, 11, 12, 22, 26, 30	; Lottery Draw

MATCH4	DCD	0
MATCH5	DCD	0
MATCH6	DCD	0

	END	
