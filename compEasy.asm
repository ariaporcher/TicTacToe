
	extern main
	extern randomNum
	extern checkWinner
	extern drawBoard
	section .data

	
location:	db	"Enter a location on the board 1-16:", 10
len_loc:	equ 	$- location

new_line:	db 	10

user_char:	db 	'x' 	;120
comp_char:	db	'o'	;111

occupied:	db 	"This is not an empty space. Try again!", 10
len_occupied:	equ	$- occupied

board_str:	db 	"0000000000000000", 0

invalid:	db	"Invalid Input!", 10
len_invalid:	equ	$- invalid

tie_game:       db      "IT'S A DRAW!", 10
len_tie:        equ     $- tie_game

counter:	db	0
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	section .bss

user_loc:	resb	3


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	section .text
	global compEasy

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
	jmp compEasy
	
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

	
compEasy:
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
	
	;; computer play: call the random number generator to select a position
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
	jmp compEasy

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
	

