				
	extern printf
	extern compEasy
	extern compHard
	extern randomNum
	extern drawBoard
	
	section .data

welcome:	db	"Welcome to TIC-TAC-ASSEMBLY", 10
len_mes:	equ	$- welcome

options:	db 	"Pick an option from the menu below:", 10
len_options:	equ	$- options
	
option_a:	db	"a - easy", 10
len_a:		equ	$- option_a

option_b:	db	"b - hard", 10
len_b:		equ	$- option_b	

option_q:	db	"q - quit", 10
len_q:		equ	$- option_q

new_line:	db 	10

invalid_mes:	db 	"Invalid Input!", 10
len_invalid:	equ	$- invalid_mes

test:	        db	"back in main", 10
len_test:	equ	$- test

easter_mes:	db	"YOU'VE FOUND THE EASTER EGG!!!!!", 10
len_easter:	equ	$- easter_mes
	
counter:	db	0
	
    
easter_egg:	db	10
		db		"@@@        @@@",10
		db		"@@@@      @@@@   @@@@  @@ @@@  @@ @@@ @@      @@",10
		db		"@@ @@    @@ @@  @@  @@ @@@  @@ @@@  @@ @@    @@ ",10
		db		"@@  @@  @@  @@ @@@@@@  @@      @@       @@  @@  ",10
		db		"@@   @@@@   @@  @@     @@      @@        @@@@   ",10
		db		"@@    @@    @@   @@@@  @@      @@         @@    ",10
        	db		"                                         @@     ",10
        	db		" 				    @@  @@      ",10
        	db		"                                     @@@@       ", 10
		db	10
	
		db	"  @@@@   @@              @@          @@            	              ", 10
		db	"@@    @@ @@                          @@        	 	      ", 10
		db	"@@       @@ @@@  @@ @@@  @@   @@@@ @@@@@@  @@ @@  @@      @@@    @@@@", 10
		db	"@@       @@@  @@ @@@  @@ @@  @@      @@    @@@  @@  @@  @@  @@  @@   ", 10
		db	"@@       @@   @@ @@      @@   @@@    @@    @@   @@  @@ @@   @@   @@@ ", 10
		db	" @@   @@ @@   @@ @@      @@     @@   @@ @@ @@       @@ @@   @@     @@", 10
		db	"  @@@@   @@   @@ @@       @@ @@@@     @@   @@       @@  @@@@ @@ @@@@ ", 10
		db	10
		
	
egg_len:	equ	$- easter_egg




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	section .bss

user_input:	resb  2



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	section .text
	global main

exit:
	mov rax, 60
        xor rdi,rdi
        syscall

printLine:
	;;prints new line
	mov rax, 1
        mov rdi, 1
        mov rsi, new_line
        mov rdx, 1
        syscall
	ret

printOptions:
	;; print menu options to user
	mov rax, 1
        mov rdi, 1
        mov rsi, options
        mov rdx, len_options
        syscall

	mov rax, 1
        mov rdi, 1
        mov rsi, option_a
        mov rdx, len_a
        syscall

	mov rax, 1
        mov rdi, 1
        mov rsi, option_b
        mov rdx, len_b
        syscall

	mov rax, 1
        mov rdi, 1
        mov rsi, option_q
        mov rdx, len_q
        syscall

	;; read in user input
	mov rax, 0 
	mov rdi, 0
	mov rsi, user_input
	mov rdx, 2   
	syscall

	;; stores user_input in r9 & checks validity
	xor r9, r9
	mov r9b, [user_input]

	;;  if r9 is equal to 'a' (97 in ASCII), call compEasy
	cmp r9, 97
	jz compEasy
	
	;;  if r9 is equal to 'b' (98 in ASCII), call compHard
	cmp r9, 98
	jz compHard

	;;  if r9 is equal to 'q' (113 in ASCII), quit
	cmp r9, 113
	jz exit
	
	cmp r9, 99
	jz count

	
invalid:	
	;;  if r9 not equal to 'a', 'b' or 'q' print invalid statement
	;;  and call function again
	mov rax, 1
        mov rdi, 1
        mov rsi, invalid_mes
        mov rdx, len_invalid
        syscall
	
	call printLine
	call printOptions	
	ret

count:
	inc byte [counter]
	mov r10b, [counter]
	cmp r10b, 4
	je easterEgg
	jmp invalid
	
easterEgg:
	call printLine	

	mov rax, 1
	mov rdi, 1
	mov rsi, easter_mes
	mov rdx, len_easter
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, easter_egg
	mov rdx, egg_len
	syscall
	call printLine

main:
	mov rax, 1
        mov rdi, 1
        mov rsi, welcome
        mov rdx, len_mes
        syscall
	
	call printOptions
	
	;; exit main
	call exit
