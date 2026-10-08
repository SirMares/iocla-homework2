%include "../include/io.mac"

extern printf
global remove_numbers

section .data
	fmt db "%d", 10, 0

section .text

; function signature: 
; void remove_numbers(int *a, int n, int *target, int *ptr_len);

remove_numbers:
	;; DO NOT MODIFY
	push    ebp
	mov     ebp, esp
	pusha

	mov     esi, [ebp + 8] ; source array
	mov     ebx, [ebp + 12] ; n
	mov     edi, [ebp + 16] ; dest array
	mov     edx, [ebp + 20] ; pointer to dest length

	;; DO NOT MODIFY
   

	;; Your code starts here
	;eliminam numerele impare si puterile de 2
	xor eax, eax ; i = 0
	xor ecx, ecx
	loop:
		cmp eax, ebx ; comparam i cu n
		jge end_loop
		;pt numar impar
		mov edx, [esi + eax * 4] ; edx = a[i]
		and edx, 1 ; verificam daca e impar
		cmp edx, 0
		jne remove
		;pt putere de 2
		;punem pe stiva eax ca sa salvam valoarea
		mov edx, [esi + eax * 4] ; edx = a[i]
		push eax ; salvam valoarea
		mov eax, edx 
		sub eax, 1 ; scadem 1
		and edx, eax ; verificam daca e putere de 2
		pop eax ; luam inapoi valoarea
		cmp edx, 0
		je remove
		; copiem restul numerelor
		mov edx, [esi + eax * 4] ; edx = a[i]
		mov [edi + ecx * 4], edx ; copiem in vectorul de destinatie
		add ecx, 1
		add eax, 1
		jmp loop

	remove:
		add eax, 1
		jmp loop
	end_loop:
		mov edx, [ebp + 20] ; pointer la dest length
		mov [edx], ecx ; lungimea vectorului de destinatie
		mov eax, 0 ; return 0
	;; Your code ends here
	

	;; DO NOT MODIFY

	popa
	leave
	ret
	
	;; DO NOT MODIFY
