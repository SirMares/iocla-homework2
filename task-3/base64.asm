%include "../include/io.mac"

extern printf
global base64

section .data
	alphabet db 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
	fmt db "%d", 10, 0

section .text

base64:
	;; DO NOT MODIFY

    push ebp
    mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; source array
	mov ebx, [ebp + 12] ; n
	mov edi, [ebp + 16] ; dest array
	mov edx, [ebp + 20] ; pointer to dest length

	;; DO NOT MODIFY

	; -- Your code starts here --

    xor ecx, ecx              ; ECX = 0 si este indexul pentru iterare

.encode_loop:
    cmp ecx, ebx              ; if ecx >= input length, ne oprim
    jge .done

    ; verificam daca mai avem 3 bytes de citit
    movzx eax, byte [esi + ecx]     ; Byte 1
    shl eax, 16

    movzx edx, byte [esi + ecx + 1] ; Byte 2
    shl edx, 8
    or eax, edx

    movzx edx, byte [esi + ecx + 2] ; Byte 3
    or eax, edx                     ; EAX = 24 bits from 3 bytes

    ; extragem si stocam 4 caractere Base64
    mov edx, eax
    shr edx, 18  ; extragem cei mai semnificativi 6 biti
    and edx, 0x3F ; mascam doar cei 6 biti
    mov dl, [alphabet + edx] ; luam caracterul corespunzator din alphabet
    mov [edi], dl ;stocam in destinatie
    inc edi ; maresc pointerul destinatiei
    ; repetam pentru ceilalti 3 bytes

    mov edx, eax
    shr edx, 12 ;extragem urmatorii 6 biti
    and edx, 0x3F ; mascam doar cei 6 biti
    mov dl, [alphabet + edx]
    mov [edi], dl
    inc edi

    mov edx, eax
    shr edx, 6 ; extragem urmatorii 6 biti
    and edx, 0x3F
    mov dl, [alphabet + edx]
    mov [edi], dl
    inc edi

    and eax, 0x3F ; extragem ultimii 6 biti
    mov al, [alphabet + eax]
    mov [edi], al
    inc edi

    add ecx, 3 ;avansam 3 bytes
    jmp .encode_loop ; continuam cu urmatorul set de 3 bytes

.done:
    ; Salvam lungimea destinatiei
    mov eax, edi
    sub eax, [ebp + 16]      ; encoded length = edi - target
    mov edx, [ebp + 20]
    mov [edx], eax

; -- Your code ends here --


	;; DO NOT MODIFY

	popa
	leave
	ret

	;; DO NOT MODIFY