.model tiny
.code
org 100h

locals @@

start:      
        mov di, offset mw
        push di
        call strlen
        add sp, 2

        mov dx, offset mw
        push dx
        push '3'
        push ax
        call memchr
        add sp, 6

        mov ax, 4c00h
        int 21h

;--------------------------------------------------------;
; MEMCHR
; Function finds out the first symbol in the string
; Entry: (1)di: pointer to the string; (2)needed symbol
;   (3)ah: the length of the comparing string:
;   if the string gets from the command line -> just wright mov ah, byte ptr ds:[80h], dec ah
;   if the string gets from offset just use strlen (returnes len to ah)
; Destroys: di, cl(counter, bl(needed symbol)
; Return: the adress of the symbol in cl
;--------------------------------------------------------;

memchr      proc
    push bp
    mov bp, sp

    mov di, [bp + 8]
    mov bl, [bp + 6]
    mov ax, [bp + 4]

    xor cl, cl

@@next_symb:
    inc cl 
    cmp byte ptr ds:[di], bl ;if ds:[di] == si(symbol) -> end function
    je @@symb_found
    cmp cl, ah ;if cl(counter) == ah(the max length) -> end of the programm
    je @@not_found
    inc di ;pointer++
    jmp @@next_symb

@@not_found:
    mov ah, 09h
    mov dx, offset not_found ;output error message
    int 21h
    jmp @@symb_found

not_found db "Symbol didn't found-_-$"

@@symb_found:
    pop bp
    ret
    endp memchr



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

mw db '123456$'

end start