
	section .data

message:	db	"In randomNum", 10
len_mes:	equ	$- message
	
	section .text
	global randomNum


randomNum:
	
	mov r8, 16
	xor rax, rax
	rdseed r9
	mov rax, 1103515245
        mul r9
        add rax, 12345
        mov r10, 65536
        xor rdx, rdx
        div r10
        xor r10, r10
        mov r10, rax
        xor rdx, rdx
        div r8
        xor rax, rax
        mov rax, rdx

	ret
	
