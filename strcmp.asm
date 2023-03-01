.model tiny
.code
org 100h

locals @@

start: 
        push offset str1
        push offset str2
        call strcmp
        add sp, 4

        ret


;--------------------------------------------------------;
;                   MEMCMP
; Function compare n bytes of str1 and str2
; Entry: (1)str1: pointer to the first string
;        (2)str2: pointer to the second string
; Destroys: di(1 ptr), si(2 ptr), cx(counter), 
; Return: 1 in cx if str1>str2; -1 in cx if str2>str1; 0 if they're equal
;--------------------------------------------------------;
strcmp      proc
    push bp
    mov bp, sp

    push [bp + 6] ;pushing first string in order to get its length
    call strlen 
    add sp, 2

    mov ch, ah ;ch = length_1
    
    push [bp + 4] ;pushing second string in order to get its length
    call strlen ;ah = length_2
    add sp, 2

    cmp ah, ch ;if ah >= ch
    jae @@len_1
    jb @@len_2

@@len_1:
    mov ch, ah ;ch = ah

@@len_2:

    repe cmpsb

    je @@equal
    ja @@str_1
    jb @@str_2

@@equal:
    xor cx, cx
    jmp @@end_func

@@str_1:
    mov cx, 1
    jmp @@end_func

@@str_2:
    mov cx, -1
    jmp @@end_func

@@end_func:
    pop bp
    ret
    endp strcmp
    

str1: db "kkkk$"
str2: db "kkk$"

include str_lib.asm

end start