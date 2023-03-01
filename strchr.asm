.model tiny
.code
org 100h

locals @@

start:      
        mov ah, byte ptr ds:[80h]
        dec ah
        mov di, 82h

        push di
        push '2'
        call strchr
        add sp, 4

        mov ax, 4c00h
        int 21h

;--------------------------------------------------------;
;                   STRTCHR
; Function finds out the first symbol in the string
; Entry: (1)di: pointer to the string; (2)needed symbol
; Destroys: di, cl(counter, bl(needed symbol)
; Return: the adress of the symbol in cl
;--------------------------------------------------------;

strchr      proc

    push bp
    mov bp, sp

    push [bp + 6]
    call strlen
    add sp, 2

    push [bp + 6]
    push [bp + 4]
    push ax
    call memchr
    add sp, 6
    
    pop bp
    ret
    endp strchr

include str_lib.asm

end start