%include "../include/io.mac"

extern printf
global check_row
global check_column
global check_box

section .bss
    vect resb 9  ; Vector pentru cifrele 1-9

section .text

; int check_row(char* sudoku, int row);
check_row:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov     esi, [ebp + 8]  ; char* sudoku, pointer to 81-long char array
    mov     edx, [ebp + 12]  ; int row 
    ;; DO NOT MODIFY
   
    ;; Freestyle starts here
    ; Initializare vector - implementare manuala
    mov ecx, 9
    mov edi, vect
    xor eax, eax
init_row_vect:
    mov [edi], al
    inc edi
    loop init_row_vect

    mov eax, edx        ; row
    mov ebx, 9
    mul ebx             ; row * 9
    add esi, eax        ; esi = sudoku + row * 9

    ; Parcurgem linia
    mov ecx, 9
row_loop:
    mov al, [esi]
    ; Testam daca cifra e valida (1-9)
    cmp al, 1
    jl next_row_cell
    cmp al, 9
    jg next_row_cell
    
    ; Verificam daca cifra a mai aparut
    mov edi, vect
    add edi, eax
    sub edi, 1          ; edi = vect + val - 1
    cmp byte [edi], 0
    jne row_not_ok
    mov byte [edi], 1
    
next_row_cell:
    inc esi
    loop row_loop

    ; Daca am ajuns aici, linia e corecta
    mov eax, 1
    jmp end_check_row

row_not_ok:
    mov eax, 2
    ;; Freestyle ends here
end_check_row:
    ;; DO NOT MODIFY
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret
    ;; DO NOT MODIFY

; int check_column(char* sudoku, int column);
check_column:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov     esi, [ebp + 8]  ; char* sudoku, pointer to 81-long char array
    mov     edx, [ebp + 12]  ; int column 
    ;; DO NOT MODIFY
   
    ;; Freestyle starts here
    mov ecx, 9
    mov edi, vect
    xor eax, eax
init_col_vect:
    mov [edi], al
    inc edi
    loop init_col_vect

    ; Parcurge coloana
    mov ecx, 9
    mov ebx, edx        ; column
column_loop:
    mov eax, ecx
    dec eax             ; row = 0..8
    mov edi, 9
    mul edi             ; row * 9
    add eax, ebx        ; row * 9 + column
    mov al, [esi + eax] ; valoarea din sudoku
    
    cmp al, 1
    jl next_column_cell
    cmp al, 9
    jg next_column_cell
    
    ; Verifica daca cifra a mai aparut
    mov edi, vect
    add edi, eax
    sub edi, 1          ; edi = vect + val - 1
    cmp byte [edi], 0
    jne column_not_ok
    mov byte [edi], 1
    
next_column_cell:
    loop column_loop

    ; Daca am ajuns aici, coloana e corecta
    mov eax, 1
    jmp end_check_column

column_not_ok:
    mov eax, 2
    ;; Freestyle ends here
end_check_column:
    ;; DO NOT MODIFY
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret
    ;; DO NOT MODIFY

; int check_box(char* sudoku, int box);
check_box:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    push ebx
    push ecx
    push edx
    push esi
    push edi

    mov     esi, [ebp + 8]  ; char* sudoku, pointer to 81-long char array
    mov     edx, [ebp + 12]  ; int box 
    ;; DO NOT MODIFY
   
    ;; Freestyle starts here
    mov ecx, 9
    mov edi, vect
    xor eax, eax
init_box_vect:
    mov [edi], al
    inc edi
    loop init_box_vect

    ; Calculeaza offset-ul casutei
    ; box_row = box / 3 * 3
    ; box_col = box % 3 * 3
    mov eax, edx        ; box
    mov ebx, 3
    xor edx, edx
    div ebx             ; eax = box / 3, edx = box % 3
    
    ; Calculeaza box_row * 27 + box_col * 3
    imul eax, eax, 27   ; box / 3 * 27
    imul edx, edx, 3    ; box % 3 * 3
    add eax, edx        ; offset initial
    
    ; Parcurge casuta 3x3
    mov ecx, 3          ; pentru randuri
box_row_loop:
    push ecx
    mov ecx, 3          ; pentru coloane
    mov ebx, eax        ; salveaza offset-ul de inceput al randului
    
box_col_loop:
    mov dl, [esi + eax] ; valoarea din sudoku
    
    cmp dl, 1
    jl next_box_cell
    cmp dl, 9
    jg next_box_cell
    
    ; Verifica daca cifra a mai aparut
    mov edi, vect
    add edi, edx
    sub edi, 1          ; edi = vect + val - 1
    cmp byte [edi], 0
    jne box_not_ok
    mov byte [edi], 1
    
next_box_cell:
    inc eax             ; urmatoarea coloana
    loop box_col_loop
    
    add ebx, 9          ; trece la urmatorul rand
    mov eax, ebx
    pop ecx
    loop box_row_loop

    ; Daca am ajuns aici, casuta e corecta
    mov eax, 1
    jmp end_check_box

box_not_ok:
    pop ecx             
    mov eax, 2
    ;; Freestyle ends here
end_check_box:
    ;; DO NOT MODIFY
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret
    ;; DO NOT MODIFY