
	extern main
	extern randomNum
	extern checkWinner
	extern drawBoard
	section .data


location:	db  	"Enter a location on the board 1-16:", 10
len_loc:	equ 	$- location

new_line:	db 	10

user_char:	db 	'x'
comp_char:	db	'o'

occupied:	db 	"This is not an empty space. Try again!", 10
len_occupied:	equ	$- occupied

board_str:	db	"0000000000000000", 0	

invalid:        db      "Invalid Input!", 10
len_invalid:    equ     $- invalid

tie_game:       db      "IT'S A DRAW!", 10
len_tie:        equ     $- tie_game

counter:        db    0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	section .bss

user_loc:	resb	3

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	section .text
	global compHard

exit:
	mov rax, 60
	xor rdi, rdi
	syscall
	

checkSlot:
        ;; put a char on the board to represent the user/comp selected position
        mov r10, 48
        cmp [board_str + rdi], r10b
        jne isOccupied
        call assignChar
        ret

	
assignChar:
        mov r9, [rsi]
        mov [board_str + rdi], r9b
        ret

	
isOccupied:
        cmp rsi, user_char
        jne currComp
        mov rax, 1
        mov rdi, 1
        mov rsi, occupied
        mov rdx, len_occupied
        syscall
        jmp compHard

	
currComp:
	call randomNum
	mov rdi, rax
	jmp checkSlot

	
printMsg:
	;; print prompt for user's location
	mov rax, 1
	mov rdi, 1
	mov rsi, location
	mov rdx, len_loc
	syscall
	
	;;  read in user's board location
	mov rax, 0
	mov rdi, 0
	mov rsi, user_loc
	mov rdx, 3
	syscall

	;; check validity of user input. If they input q, quit
	;; the game 
	mov r8b, [user_loc]
	cmp r8, 113
	jz exit

	ret
	
invalidInput:
        mov rax, 1
        mov rdi, 1
        mov rsi, invalid
        mov rdx, len_invalid
        syscall
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
compHard:	
	mov rdi, board_str
	call drawBoard
	call printMsg
	xor r9, r9
	xor r10, r10
	mov r9b, [user_loc]
	mov r10b, [user_loc + 1]

	;; checks the number of ints entered by user and sends the values
	;; as parameters to be converted to decimal ints. 
	mov rdi, r9
        mov rsi, r10
        cmp r10, 10
        jnz doubleInt

	
singleInt:
        ;; converts ASCII val to decimal   
        xor rax, rax
        sub rdi, 48
        mov rax, rdi
	
	;; check validity of input 
        cmp rax, 1
        jb invalidInput
        jmp finish
        

	
doubleInt:
        ;; converts user input(double int) to decimal 
        sub rdi, 48
        sub rsi, 48
        xor rax, rax
        mov rax, 10
        mul rdi
        add rax, rsi

	;; check validity of input                                               
        cmp rax, 16
        jg invalidInput

finish:	
	;; send the user's location as a parameter to check if that
	;; slot is empty
	sub rax, 1
	mov rdi, rax
	mov rsi, user_char
	call checkSlot
	mov rdi, board_str
        call drawBoard
	
	;; send the board as a parameter to checkWinner
	mov rdi, board_str
	mov rsi, user_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie

RowOneCheckOne:		
	
	mov rax, 0
	mov r8b, 'x'
	and r8b,[board_str+0]
	and r8b, [board_str+1]
	and r8b, [board_str+2]

	cmp r8b, [user_char] 
	jne RowOneCheckTwo
	mov r12, 48
	cmp r12b, [board_str+3]
	jne RowOneCheckTwo


FillRowOnePosOne:
	mov r10b, [comp_char]
	mov [board_str+3], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie
	jmp compHard
	
RowOneCheckTwo:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+0]
	and r8b, [board_str+1]
	and r8b, [board_str+3]

	cmp r8b, [user_char] 
	jne RowOneCheckThree
	mov r12b, 48
	cmp r12b, [board_str+2]
	jne RowOneCheckThree

FillRowOnePosTwo:
	mov r10b, [comp_char]
	mov [board_str+2], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie
	jmp compHard

RowOneCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+0]
	and r8b, [board_str+2]
	and r8b, [board_str+3]

	cmp r8b, [user_char] 
	jne RowOneCheckFour
	mov r12, 48
	cmp r12b, [board_str+1]
	jne RowOneCheckFour

	je FillRowOnePosThree 

FillRowOnePosThree:
	mov r10b, [comp_char]	
	mov [board_str+1], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	call checkTie
	je clearBoard
	jmp compHard


RowOneCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+1]
	and r8b, [board_str+2]
	and r8b, [board_str+3]

	cmp r8b, [user_char] 
	jne RowTwoCheckOne
	mov r12, 48
	cmp r12b, [board_str+0]
	jne RowTwoCheckOne

	je FillRowOnePosFour 

FillRowOnePosFour:
	mov r10b, [comp_char]	
	mov [board_str+0], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	call checkTie
	je clearBoard
	jmp compHard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RowTwoCheckOne:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b,[board_str+4]
	and r8b,[board_str+5]
	and r8b,[board_str+6]

	cmp r8b, [user_char] 
	jne RowTwoCheckTwo
	mov r12, 48
	cmp r12b, [board_str+7]
	jne RowTwoCheckTwo

	je FillRowTwoPosOne

FillRowTwoPosOne:
	mov r10b, [comp_char]	
	mov [board_str+7], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie		
	jmp compHard
	
RowTwoCheckTwo:	
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+4]
	and r8b, [board_str+5]
	and r8b, [board_str+7]

	cmp r8b, [user_char] 
	jne RowTwoCheckThree
	mov r12, 48
	cmp r12b, [board_str+6]
	jne RowTwoCheckThree

	je FillRowTwoPosTwo 

FillRowTwoPosTwo:
	mov r10b, [comp_char]	
	mov [board_str+6], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie		
	jmp compHard

RowTwoCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+4]
	and r8b, [board_str+6]
	and r8b, [board_str+7]

	cmp r8b, [user_char] 
	jne RowTwoCheckFour	
	mov r12, 48
	cmp r12b, [board_str+5]
	jne RowTwoCheckFour

	je FillRowTwoPosThree 

FillRowTwoPosThree:	
	mov r10b, [comp_char]
	mov [board_str+5], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard


RowTwoCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+5]
	and r8b, [board_str+6]
	and r8b, [board_str+7]

	cmp r8b, [user_char] 
	jne RowThreeCheckOne	
	mov r12, 48
	cmp r12b, [board_str+4]
	jne RowThreeCheckOne

	je FillRowTwoPosFour 

FillRowTwoPosFour:
	mov r10b, [comp_char]	
	mov [board_str+4], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RowThreeCheckOne:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+8]
	and r8b, [board_str+9]
	and r8b, [board_str+10]

	cmp r8b, [user_char] 
	jne RowThreeCheckTwo	
	mov r12, 48
	cmp r12b, [board_str+11]
	jne RowThreeCheckTwo

	je FillRowThreePosOne

FillRowThreePosOne:
	mov r10b, [comp_char]	
	mov [board_str+11], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
RowThreeCheckTwo:	
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+8]
	and r8b, [board_str+9]
	and r8b, [board_str+11]

	cmp r8b, [user_char] 
	jne RowThreeCheckThree	
	mov r12, 48
	cmp r12b, [board_str+10]
	jne RowThreeCheckThree

	je FillRowThreePosTwo 

FillRowThreePosTwo:
	mov r10b, [comp_char]	
	mov [board_str+10], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

RowThreeCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+8]
	and r8b, [board_str+10]
	and r8b, [board_str+11]

	cmp r8b, [user_char] 
	jne RowThreeCheckFour	
	mov r12, 48
	cmp r12b, [board_str+9]
	jne RowThreeCheckFour

	je FillRowThreePosThree 

FillRowThreePosThree:
	mov r10b, [comp_char]
	mov [board_str+9], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard


RowThreeCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+9]
	and r8b, [board_str+10]
	and r8b, [board_str+11]

	cmp r8b, [user_char] 
	jne RowFourCheckOne		
	mov r12, 48
	cmp r12b, [board_str+8]
	jne RowFourCheckOne

	je FillRowThreePosFour 

FillRowThreePosFour:
	mov r10b, [comp_char]	
	mov [board_str+8], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
RowFourCheckOne:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+12]
	and r8b, [board_str+13]
	and r8b, [board_str+14]

	cmp r8b, [user_char] 
	jne RowFourCheckTwo
	mov r12, 48
	cmp r12b, [board_str+15]
	jne RowFourCheckTwo

	je FillRowFourPosOne

FillRowFourPosOne:
	mov r10b, [comp_char]	
	mov [board_str+15], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
RowFourCheckTwo:	
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+12]
	and r8b, [board_str+13]
	and r8b, [board_str+15]

	cmp r8b, [user_char] 
	jne RowFourCheckThree		
	mov r12, 48
	cmp r12b, [board_str+14]
	jne RowFourCheckThree

	je FillRowFourPosTwo 

FillRowFourPosTwo:
	mov r10b, [comp_char]
	mov [board_str+14], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

RowFourCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+12]
	and r8b, [board_str+14]
	and r8b, [board_str+15]

	cmp r8b, [user_char] 
	jne RowFourCheckFour	
	mov r12, 48
	cmp r12b, [board_str+13]
	jne RowFourCheckFour

	je FillRowFourPosThree 

FillRowFourPosThree:
	mov r10b, [comp_char]	
	mov [board_str+13], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard


RowFourCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+13]
	and r8b, [board_str+14]
	and r8b, [board_str+15]

	cmp r8b, [user_char] 
	jne ColOneCheckOne	
	mov r12, 48
	cmp r12b, [board_str+12]
	jne ColOneCheckOne

	je FillRowFourPosFour 

FillRowFourPosFour:
	mov r10b, [comp_char]	
	mov [board_str+12], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ColOneCheckOne:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+0]
	and r8b, [board_str+4]
	and r8b, [board_str+8]

	cmp r8b, [user_char] 
	jne ColOneCheckTwo		
	mov r12, 48
	cmp r12b, [board_str+12]
	jne ColOneCheckTwo

	je FillColOnePosOne

FillColOnePosOne:
	mov r10b, [comp_char]	
	mov [board_str+12], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
ColOneCheckTwo:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+0]
	and r8b, [board_str+4]
	and r8b, [board_str+12]

	cmp r8b, [user_char] 
	jne ColOneCheckThree		
	mov r12, 48
	cmp r12b, [board_str+8]
	jne ColOneCheckThree

	je FillColOnePosTwo 

FillColOnePosTwo:
	mov r10b, [comp_char]	
	mov [board_str+8], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

ColOneCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+0]
	and r8b, [board_str+8]
	and r8b, [board_str+12]

	cmp r8b, [user_char] 
	jne ColOneCheckFour	
	mov r12, 48
	cmp r12b, [board_str+4]
	jne ColOneCheckFour

	je FillColOnePosThree 

FillColOnePosThree:
	mov r10b, [comp_char]	
	mov [board_str+4], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard


ColOneCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+4]
	and r8b, [board_str+8]
	and r8b, [board_str+12]

	cmp r8b, [user_char] 
	jne ColTwoCheckOne		
	mov r12, 48
	cmp r12b, [board_str+0]
	jne ColTwoCheckOne

	je FillColOnePosFour 

FillColOnePosFour:
	mov r10b, [comp_char]	
	mov [board_str+0], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ColTwoCheckOne:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+1]
	and r8b, [board_str+5]
	and r8b, [board_str+9]

	cmp r8b, [user_char] 
	jne ColTwoCheckTwo		
	mov r12, 48
	cmp r12b, [board_str+13]
	jne ColTwoCheckTwo

	je FillColTwoPosOne

FillColTwoPosOne:
	mov r10b, [comp_char]
	mov [board_str+13], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
ColTwoCheckTwo:	
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+1]
	and r8b, [board_str+5]
	and r8b, [board_str+13]

	cmp r8b, [user_char] 
	jne ColTwoCheckThree	
	mov r12, 48
	cmp r12b, [board_str+9]
	jne ColTwoCheckThree

	je FillColTwoPosTwo 

FillColTwoPosTwo:
	mov r10b, [comp_char]	
	mov [board_str+9], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

ColTwoCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+1]
	and r8b, [board_str+9]
	and r8b, [board_str+13]

	cmp r8b, [user_char] 
	jne ColTwoCheckFour		
	mov r12, 48
	cmp r12b, [board_str+5]
	jne ColTwoCheckFour

	je FillColTwoPosThree 

FillColTwoPosThree:
	mov r10b, [comp_char]	
	mov [board_str+5], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard


ColTwoCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+5]
	and r8b, [board_str+9]
	and r8b, [board_str+13]

	cmp r8b, [user_char] 
	jne ColThreeCheckOne		
	mov r12, 48
	cmp r12b, [board_str+1]
	jne ColThreeCheckOne

	je FillColTwoPosFour 

FillColTwoPosFour:
	mov r10b, [comp_char]	
	mov [board_str+1], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ColThreeCheckOne:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+2]
	and r8b, [board_str+6]
	and r8b, [board_str+10]

	cmp r8b, [user_char] 
	jne ColThreeCheckTwo		
	mov r12, 48
	cmp r12b, [board_str+14]
	jne ColThreeCheckTwo

	je FillColThreePosOne

FillColThreePosOne:
	mov r10b, [comp_char]	
	mov [board_str+14], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
ColThreeCheckTwo:	
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+2]
	and r8b, [board_str+6]
	and r8b, [board_str+14]

	cmp r8b, [user_char] 
	jne ColThreeCheckThree		
	mov r12, 48
	cmp r12b, [board_str+10]
	jne ColThreeCheckThree

	je FillColThreePosTwo 

FillColThreePosTwo:
	mov r10b, [comp_char]	
	mov [board_str+10], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

ColThreeCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+2]
	and r8b, [board_str+10]
	and r8b, [board_str+14]

	cmp r8b, [user_char] 
	jne ColThreeCheckFour		
	mov r12, 48
	cmp r12b, [board_str+6]
	jne ColThreeCheckFour

	je FillColThreePosThree 

FillColThreePosThree:
	mov r10b, [comp_char]	
	mov [board_str+6], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard


ColThreeCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+6]
	and r8b, [board_str+10]
	and r8b, [board_str+14]

	cmp r8b, [user_char] 
	jne ColFourCheckOne		
	mov r12, 48
	cmp r12b, [board_str+2]
	jne ColFourCheckOne

	je FillColThreePosFour 

FillColThreePosFour:
	mov r10b, [comp_char]	
	mov [board_str+2], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

ColFourCheckOne:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+3]
	and r8b, [board_str+7]
	and r8b, [board_str+11]

	cmp r8b, [user_char] 
	jne ColFourCheckTwo		
	mov r12, 48
	cmp r12b, [board_str+15]
	jne ColFourCheckTwo

	je FillColFourPosOne

FillColFourPosOne:
	mov r10b, [comp_char]	
	mov [board_str+15], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
ColFourCheckTwo:	
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+3]
	and r8b, [board_str+7]
	and r8b, [board_str+15]

	cmp r8b, [user_char] 
	jne ColFourCheckThree		
	mov r12, 48
	cmp r12b, [board_str+11]
	jne ColFourCheckThree

	je FillColFourPosTwo 

FillColFourPosTwo:
	mov r10b, [comp_char]
	mov [board_str+11], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

ColFourCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+3]
	and r8b, [board_str+11]
	and r8b, [board_str+15]

	cmp r8b, [user_char] 
	jne ColFourCheckFour		
	mov r12, 48
	cmp r12b, [board_str+7]
	jne ColFourCheckFour

	je FillColFourPosThree 

FillColFourPosThree:
	mov r10b, [comp_char]
	mov [board_str+7], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard


ColFourCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+7]
	and r8b, [board_str+11]
	and r8b, [board_str+15]

	cmp r8b, [user_char] 
	jne DiagOneCheckOne		
	mov r12, 48
	cmp r12b, [board_str+3]
	jne DiagOneCheckOne

	je FillColFourPosFour 

FillColFourPosFour:
	mov r10b, [comp_char]
	mov [board_str+3], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
DiagOneCheckOne:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+0]
	and r8b, [board_str+5]
	and r8b, [board_str+10]

	cmp r8b, [user_char] 
	jne DiagOneCheckTwo			
	mov r12, 48
	cmp r12b, [board_str+15]
	jne DiagOneCheckTwo

	je FillDiagOnePosOne

FillDiagOnePosOne:
	mov r10b, [comp_char]
	mov [board_str+15], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
DiagOneCheckTwo:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+0]
	and r8b, [board_str+5]
	and r8b, [board_str+15]

	cmp r8b, [user_char] 
	jne DiagOneCheckThree			
	mov r12, 48
	cmp r12b, [board_str+10]
	jne DiagOneCheckThree

	je FillDiagOnePosTwo 

FillDiagOnePosTwo:
	mov r10b, [comp_char]	
	mov [board_str+10], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

DiagOneCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+0]
	and r8b, [board_str+10]
	and r8b, [board_str+15]

	cmp r8b, [user_char] 
	jne DiagOneCheckFour		
	mov r12, 48
	cmp r12b, [board_str+5]
	jne DiagOneCheckFour

	je FillDiagOnePosThree 

FillDiagOnePosThree:
	mov r10b, [comp_char]	
	mov [board_str+5], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard


DiagOneCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+5]
	and r8b, [board_str+10]
	and r8b, [board_str+15]

	cmp r8b, [user_char] 
	jne DiagTwoCheckOne		
	mov r12, 48
	cmp r12b, [board_str+0]
	jne DiagTwoCheckOne

	je FillDiagOnePosFour 

	
FillDiagOnePosFour:
	mov r10b, [comp_char]	
	mov [board_str+0], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DiagTwoCheckOne:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+3]
	and r8b, [board_str+6]
	and r8b, [board_str+9]
	cmp r8b, [user_char] 
	jne DiagTwoCheckTwo		
	mov r12, 48
	cmp r12b, [board_str+12]
	jne DiagTwoCheckTwo

	je FillDiagTwoPosOne

FillDiagTwoPosOne:
	mov r10b, [comp_char]	
	mov [board_str+12], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
DiagTwoCheckTwo:	
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+3]
	and r8b, [board_str+6]
	and r8b, [board_str+12]

	cmp r8b, [user_char] 
	jne DiagTwoCheckThree		
	mov r12, 48
	cmp r12b, [board_str+9]
	jne DiagTwoCheckThree

	je FillDiagTwoPosTwo 

FillDiagTwoPosTwo:
	mov r10b, [comp_char]	
	mov [board_str+9], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard

DiagTwoCheckThree:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+3]
	and r8b, [board_str+9]
	and r8b, [board_str+12]

	cmp r8b, [user_char] 
	jne DiagTwoCheckFour		
	mov r12, 48
	cmp r12b, [board_str+6]
	jne DiagTwoCheckFour

	je FillDiagTwoPosThree 

FillDiagTwoPosThree:
	mov r10b, [comp_char]	
	mov [board_str+6], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard


DiagTwoCheckFour:		
	
	mov rax, 0
	mov r8b, "x"
	and r8b, [board_str+6]
	and r8b, [board_str+9]
	and r8b, [board_str+12]

	cmp r8b, [user_char] 
	jne computerRand
	mov r12, 48
	cmp r12b, [board_str+3]
	jne computerRand

	je FillDiagTwoPosFour 

FillDiagTwoPosFour:
	mov r10b, [comp_char]	
	mov [board_str+3], r10b
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie	
	jmp compHard
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
computerRand: ;;call the random number generator to select a position
	call randomNum		
	mov rdi, rax
	mov rsi, comp_char
	call checkSlot
	mov rdi, board_str
	mov rsi, comp_char
	call checkWinner
	cmp rax, 1
	je clearBoard
	call checkTie
	jmp compHard

	ret
	
checkTie:
        inc byte [counter]
        mov r12b, [counter]
        cmp r12b, 16
        je isTie
        ret

isTie:
        mov rdi, board_str
        call drawBoard
        mov rax, 1
        mov rdi, 1
        mov rsi, tie_game
        mov rdx, len_tie
        syscall
	mov r11b, 0
	mov byte [counter], r11b
	call clearBoard
	
clearBoard:
	mov r11b, 0
	mov byte [counter], r11b
	xor r10, r10
        mov r10b, "0"
        mov [board_str + 0], r10b
        mov [board_str + 1], r10b
        mov [board_str + 2], r10b
        mov [board_str + 3], r10b
        mov [board_str + 4], r10b
        mov [board_str + 5], r10b
        mov [board_str + 6], r10b
        mov [board_str + 7], r10b
        mov [board_str + 8], r10b
        mov [board_str + 9], r10b
        mov [board_str + 10], r10b
        mov [board_str + 11], r10b
        mov [board_str + 12], r10b
        mov [board_str + 13], r10b
        mov [board_str + 14], r10b
        mov [board_str + 15], r10b
	jmp main
