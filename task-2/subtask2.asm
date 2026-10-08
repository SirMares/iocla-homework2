%include "../include/io.mac"

struc date
    .day resb 1
    .month resb 1
    .year resw 1
endstruc

struc event
    .name resb 31
    .valid resb 1
    .date resb 4
endstruc

section .bss
temp resb 36         ; variabila auxiliara pt swap

section .text
    global sort_events
    extern printf

sort_events:
    ;; DO NOT MODIFY
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]      ; events
    mov ecx, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
    cmp ecx, 1              ; nu mai sortam 
    jbe end_sort

    dec ecx                 ; pana la lungime - 1
    xor ebp, ebp            ; folosim ebp ca flag pentru swap

outer_loop:
    xor ebp, ebp            ; resetam flag-ul de swap
    mov esi, 0              ; inner loop index

inner_loop:
    cmp esi, ecx
    jge inner_loop_end

    ; Calculam adresa evenimentului i
    mov eax, esi
    imul eax, event_size    ; eax = i * event_size
    lea edi, [ebx + eax]    ; edi = &events[i]
    lea eax, [edi + event_size] ; eax = &events[i+1]

    ; Compare valid fields
    mov dl, [edi + event.valid]
    mov dh, [eax + event.valid]
    cmp dl, dh
    jb need_swap            ; if valid[i] < valid[i+1], swap
    ja no_swap              ; if valid[i] > valid[i+1], no swap

    ; Daca ambele sunt valide, comparam datele
    cmp dl, 0
    jne valid_date_compare  

    ; Daca ambele sunt invalide, comparam datele
invalid_date_compare:
    mov dx, [edi + event.date + date.year]
    cmp dx, [eax + event.date + date.year]
    jg need_swap
    jl no_swap
    
    mov dl, [edi + event.date + date.month]
    cmp dl, [eax + event.date + date.month]
    jg need_swap
    jl no_swap
    ; Daca luna este egala, comparam ziua
    mov dl, [edi + event.date + date.day]
    cmp dl, [eax + event.date + date.day]
    jg need_swap
    jl no_swap

    jmp compare_names

valid_date_compare:
    ; Daca ambele sunt valide, comparam datele
    mov dx, [edi + event.date + date.year]
    cmp dx, [eax + event.date + date.year]
    jg need_swap
    jl no_swap
    ; Daca anul este egal, comparam luna
    mov dl, [edi + event.date + date.month]
    cmp dl, [eax + event.date + date.month]
    jg need_swap
    jl no_swap
    ; Daca luna este egala, comparăm ziua
    mov dl, [edi + event.date + date.day]
    cmp dl, [eax + event.date + date.day]
    jg need_swap
    jl no_swap

compare_names:
    push ecx
    push esi
    push edi
    push eax
    ; Comparam numele evenimentelor
    mov ecx, 31 
    mov esi, edi
    mov edi, eax
    xor eax, eax
    xor edx, edx

name_compare_loop:
    mov al, [esi]
    mov dl, [edi]
    cmp al, dl
    jl need_swap_pop
    jg no_swap_pop
    inc esi
    inc edi
    loop name_compare_loop

no_swap_pop:
    ; Daca numele sunt egale, nu facem swap
    pop eax
    pop edi
    pop esi
    pop ecx
    jmp no_swap

need_swap_pop:
    ; Daca numele sunt diferite, facem swap
    pop eax
    pop edi
    pop esi
    pop ecx

need_swap:
    push ecx
    push esi
    push edi
    push eax

    ; Facem interschimbarea evenimentelor (manual copy)
    mov ecx, event_size
    mov esi, edi        ; sursa (events[i])
    mov edi, temp       ; destinatie (temp)
copy_loop1:
    mov dl, [esi]
    mov [edi], dl
    inc esi
    inc edi
    dec ecx
    jnz copy_loop1

    mov ecx, event_size
    mov esi, [esp]      ; sursa (events[i+1])
    mov edi, [esp+4]    ; destinatie (events[i])
copy_loop2:
    mov dl, [esi]
    mov [edi], dl
    inc esi
    inc edi
    dec ecx
    jnz copy_loop2

    mov ecx, event_size
    mov esi, temp       ; sursa (temp)
    mov edi, [esp]      ; destinatie (events[i+1])
copy_loop3:
    mov dl, [esi]
    mov [edi], dl
    inc esi
    inc edi
    dec ecx
    jnz copy_loop3

    pop eax
    pop edi
    pop esi
    pop ecx
    mov ebp, 1

no_swap:
    ; Incrementam indexul pentru inner loop
    inc esi
    jmp inner_loop

inner_loop_end:
    ; Daca am facut un swap, continuam sortarea
    ; altfel, terminam sortarea
    test ebp, ebp
    jz end_sort
    dec ecx
    jnz outer_loop

end_sort:
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY