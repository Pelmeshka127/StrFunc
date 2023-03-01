.model tiny
.code
org 100h

locals @@

start: 
        push offset dst
        push offset src
        call strcpy
        add sp, 4

        ret


;--------------------------------------------------------;
;                   MEMCPY
; Function copies string from ds:si to es:di
; Entry: (1)dst: pointer to the destination string
;        (2)src: pointer to the source string
; Destroys: di, si, cx(the length of the src) 
; Return: the adress of the symbol in cl
;--------------------------------------------------------;
strcpy      proc
    push bp
    mov bp, sp

    push [bp + 4] ;pushing src to the strlen function
    call strlen
    add sp, 2

    mov si, [bp + 4] ;si = src string
    mov di, [bp + 6] ;di = dst string
    mov cl, ah ;len of the src (ah) is cl
    add cl, 1 ;adding the '$' symbol to the end of the string

    rep movsb ;copies strint with the length = cx

    pop bp
    ret
    endp strcpy

include str_lib.asm

dst: db 20h dup(?)
src: db 'abcdef$'

end start