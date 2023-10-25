global get_words
global compare_func
global sort

section .data
len_1:
    dd 0
ok:
    db 0
initial_eax:
    dd 0
initial_ebx:
    dd 0
initial_ecx:
    dd 0
initial_edx:
    dd 0

section .text

extern strcmp
extern strlen

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0

    ; TODO sort
    mov [initial_eax], eax
    mov [initial_ebx], ebx
    mov [initial_ecx], ecx
    mov [initial_edx], edx

    while_ok:
        and BYTE [ok], 0

    push DWORD [esp + 8]
    pop esi ; -> adresa in vectorul de pointeri (adica *words)

    push DWORD [esp + 12]
    pop ecx
    dec ecx

    push DWORD [esp + 16]
    pop ebx ; sizeof(char *) -> un pointer adica 4 octeti

    loop_1:
        cmp ecx, 0
        je end_loop_1

        and DWORD [len_1], 0

        xor eax, eax
        or eax, [esi]

        ; strlen
        push edx
        push ecx
        push eax

        call strlen

        or DWORD [len_1], eax

        pop eax
        pop ecx
        pop edx
        ; end_strlen

        add esi, 4

        xor eax, eax
        mov eax, [esi]

        ; strlen
        push edx
        push ecx
        push eax

        call strlen

        ; or DWORD [len_2], eax

        cmp [len_1], al
        jl inc_loop_1
        cmp [len_1], al
        je same_len

        swap:
            or BYTE [ok], 1

            xor eax, eax
            xor ebx, ebx

            mov eax, [esi - 4]   ; conținutul de la adresa esi-4 în registru EAX
            mov ebx, [esi]       ; conținutul de la adresa esi în registru EBX

            xchg eax, ebx        ; swap-ul între conținuturile registrului EAX și EBX

            mov [esi - 4], eax   ; salvam conținutul din EAX la adresa esi-4
            mov [esi], ebx       ; salvam conținutul din EBX la adresa esi
        end_swap:

        inc_loop_1:
        pop eax
        pop ecx
        pop edx

            dec ecx
            jmp loop_1

    end_loop_1:

    cmp BYTE [ok], 1
    je while_ok

    end_while_ok:

    jmp end_same_len
    same_len:

        push DWORD [esi - 4]
        push DWORD [esi]

        call strcmp

        pop ebx
        pop ebx

        cmp eax, -1
        je swap

        jmp inc_loop_1

    end_same_len:

    mov eax, [initial_eax]
    mov ebx, [initial_ebx]
    mov ecx, [initial_ecx]
    mov edx, [initial_edx]

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    push DWORD [esp + 8]
	pop edx  ; -> adresa stringului

    push DWORD [esp + 12]
    pop esi ; -> adresa in vectorul de pointeri (adica *words)

    push DWORD [esp + 16]
    pop eax

    push ecx
    push ebx

    xor ecx, ecx
    or ecx, eax

    for_1:
        cmp ecx, 0
		je end_for_1

        ; mov
        xor eax, eax
        or eax, [esi]

        introduce_word:
            xor ebx, ebx
            or ebx, [edx]
            cmp bl, ' '
            je increment1
            cmp bl, 0
            je increment1
            cmp bl, ','
            je increment2
            cmp bl, '.'
            je increment2

            and DWORD [eax], 0
            or BYTE [eax], bl
            inc eax

            increment2:
                inc DWORD edx
                jmp introduce_word

        increment1:
            add DWORD esi, 4
            inc edx
            dec ecx
            jmp for_1

    end_for_1:

    pop ebx
    pop ecx

    leave
    ret