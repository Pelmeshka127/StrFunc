.model tiny
.code
org 100h

locals @@

start:      
        mov ah, byte ptr ds:[80h]
        dec ah
        mov di, 82h

        push di
        call strlen
        add sp, 2

        mov ax, 4c00h
        int 21h

;--------------------------------------------------------;
; STRLEN
; Function counts the length of the string
; Entry: (1) pointer to the string
; Destroys: di(the pointer of the string), ah(the length)
; Return: the count of the symbols in ah;
;--------------------------------------------------------;

strlen      proc

    push bp
    mov bp, sp
    
    mov di, [bp + 4] ;di = string pointer

    xor ah, ah

@@next_symb:
    cmp byte ptr ds:[di], '$'; if ds:[di] == $ -> end
    je @@end_func

    cmp byte ptr ds:[di], 0dh; if ds:[di] == \n -> end
    je @@end_func

    inc di ;symbol++
    inc ah ;counter++
    jmp @@next_symb

@@end_func:
    pop bp
    ret
    endp strlen

end start

