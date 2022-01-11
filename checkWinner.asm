
	extern drawBoard
	section .data

user_win:	db	"YOU WIN!", 10
user_len:	equ	$- user_win

comp_win:	db 	"COMPUTER WINS!", 10
comp_len:	equ 	$- comp_win

tie_game:	db	"IT'S A DRAW!", 10
len_tie:	equ	$- tie_game

user_char:	db 	"x"
comp_char:	db	"o"

counter:	db 	0
index:		db 	0
	
	section .bss

board_str:	resb 16
curr_char:	resb 1

	section .text
	global checkWinner


checkWinner:		
	mov [board_str], rdi
	mov r9, [rsi]
	mov [curr_char], r9b
	
	mov rax, 0
	; check 1st row
	mov r8b, [rdi+0]
	and r8b, [rdi+1]
	and r8b, [rdi+2]
	and r8b, [rdi+3]
	cmp r8b, [curr_char]
	jne SecondRow

	jmp end


SecondRow:
	mov r8b, [rdi+4]
	and r8b, [rdi+5]
	and r8b, [rdi+6]
	and r8b, [rdi+7]
	cmp [curr_char], r8b
	jne ThirdRow

	jmp end

ThirdRow:
	mov r8b, [rdi+8]
        and r8b, [rdi+9]
        and r8b, [rdi+10]
        and r8b, [rdi+11]
        cmp [curr_char], r8b
        jne FourthRow

        jmp end
	
FourthRow:
	mov r8b, [rdi+12]
        and r8b, [rdi+13]
        and r8b, [rdi+14]
        and r8b, [rdi+15]
        cmp [curr_char], r8b
        jne FirstCol

        jmp end

FirstCol:
        mov r8b, [rdi+0]
        and r8b, [rdi+4]
        and r8b, [rdi+8]
        and r8b, [rdi+12]
        cmp [curr_char], r8b
        jne SecondCol

	jmp end

SecondCol:
        mov r8b, [rdi+1]
        and r8b, [rdi+5]
        and r8b, [rdi+9]		
        and r8b, [rdi+13]
        cmp [curr_char], r8b
        jne ThirdCol

        jmp end

ThirdCol:
	mov r8b, [rdi+2]
        and r8b, [rdi+6]
        and r8b, [rdi+10]
        and r8b, [rdi+14]
        cmp [curr_char], r8b
        jne FourthCol

        jmp end

FourthCol:
        mov r8b, [rdi+3]
        and r8b, [rdi+7]
        and r8b, [rdi+11]
        and r8b, [rdi+15]
        cmp [curr_char], r8b
        jne DiagonalOne

	jmp end

DiagonalOne:
	mov r8b, [rdi+0]
        and r8b, [rdi+5]
        and r8b, [rdi+10]
        and r8b, [rdi+15]
        cmp [curr_char], r8b
        jne DiagonalTwo

        jmp end

DiagonalTwo:
        mov r8b, [rdi+3]
        and r8b, [rdi+6]
        and r8b, [rdi+9]
        and r8b, [rdi+12]
        cmp [curr_char], r8b
        jne return

	jmp end


return:
	ret

end:	
	mov r10b, [curr_char]
	cmp r10b, 120
	jne compWins
	
userWins:
	mov rax, 1
	mov rdi, 1
	mov rsi, user_win
	mov rdx, user_len
	syscall
	
	mov rax, 1
	ret
	

compWins:
	call drawBoard
	mov rax, 1
	mov rdi, 1
	mov rsi, comp_win
	mov rdx, comp_len
	syscall

	mov rax, 1
	ret	



