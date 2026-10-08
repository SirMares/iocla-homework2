%include "../include/io.mac"

struc date
    .day resb 1
    .month resb 1
    .year  resw 1
endstruc

struc event
    .name resb 31
    .valid resb 1
    .date resd 1
endstruc

section .data

section .text
    global check_events
    extern printf

check_events:
    ;; DO NOT MODIFY
    enter 0,0
    pusha

    mov ebx, [ebp + 8]      ; events
    mov ecx, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
    xor eax, eax            ; counter (i = 0)

loop:
    cmp eax, ecx
    jge end_loop
    
    ; Calculam adresa evenimentului
    push eax            
    imul eax, 36           ; i * sizeof(event)
    mov edi, ebx
    add edi, eax            ; edi = &events[i]
    pop eax               
      
    ; Verificam anul (1990 <= year <= 2030)
    mov dx, [edi + event.date + date.year]
    cmp dx, 1990
    jl invalid
    cmp dx, 2030
    jg invalid

    ; month (1 <= month <= 12)
    mov dl, [edi + event.date + date.month]
    xor dh, dh              
    cmp dx, 1
    jl invalid
    cmp dx, 12
    jg invalid

    ; day
    mov dl, [edi + event.date + date.day]
    xor dh, dh              
    cmp dx, 1
    jl invalid
    
    ; pt Februarie
    mov dl, [edi + event.date + date.month]  
    xor dh, dh
    cmp dx, 2              
    je february

    ; Lunile cu 30 de zile
    cmp dx, 4              ; April
    je check_30
    cmp dx, 6              ; June
    je check_30
    cmp dx, 9              ; September
    je check_30
    cmp dx, 11             ; November
    je check_30

    ; Celelalte au 31 de zile
    mov dl, [edi + event.date + date.day]  ; reload day
    xor dh, dh
    cmp dx, 31
    jg invalid
    jmp valid

february:
    mov dl, [edi + event.date + date.day]  ; reload day
    xor dh, dh
    cmp dx, 28
    jg invalid
    jmp valid

check_30:
    mov dl, [edi + event.date + date.day]  ; reload day
    xor dh, dh
    cmp dx, 30
    jg invalid
    jmp valid

invalid:
    mov byte [edi + event.valid], 0
    inc eax
    jmp loop

valid:
    mov byte [edi + event.valid], 1
    inc eax
    jmp loop
    
end_loop:
    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY