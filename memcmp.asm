.model tiny
.code
org 100h

locals @@

start: 
        push offset str1
        push offset str2
        push 4
        call memcmp
        add sp, 6

        ret


;--------------------------------------------------------;
;                   MEMCMP
; Function compare n bytes of str1 and str2
; Entry: (1)str1: pointer to the first string
;        (2)str2: pointer to the second string
;        (3)n: number of the comparing symbols(in cx)
; Destroys: di(1 ptr), si(2 ptr), cx(counter), 
; Return: 1 in cx if str1>str2; -1 in cx if str2>str1; 0 if they're equal
;--------------------------------------------------------;
memcmp      proc
    push bp
    mov bp, sp

    mov di, [bp + 8]
    mov si, [bp + 6]
    mov cx, [bp + 4]

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
    endp memcmp
    

str1: db "kkkk$"
str2: db "kkkr$"

end start