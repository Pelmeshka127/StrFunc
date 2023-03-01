.code

;--------------------------------------------------------;
;                  STRLEN
; Function counts the length of the string
; Entry: (1)di: pointer to the string
; Destroys: di, ah
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

;--------------------------------------------------------;

;--------------------------------------------------------;
;                   MEMCHR
; Function finds out the first symbol in the string
; Entry: (1)di: pointer to the string; (2)needed symbol
;   (3)ah: the length of the comparing string:
;   if the string gets from the command line -> just wright mov ah, byte ptr ds:[80h], dec ah
;   if the string gets from offset just use strlen (returnes len to ah)
; Destroys: di, cl(counter, bl(needed symbol)
; Return: the pointer to the symbol in cl
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

;--------------------------------------------------------;

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

;--------------------------------------------------------;

;--------------------------------------------------------;
;                   MEMCPY
; Function copies string from ds:si to es:di
; Entry: (1)dst: pointer to the destination string
;        (2)src: pointer to the source string
;        (3)number of the copying symbols(in cx)
; Destroys: di, si, cx, 
; Return: the adress of the symbol in cl
;--------------------------------------------------------;
memcpy      proc
    push bp
    mov bp, sp

    mov si, [bp + 6] ;si = src string
    mov cx, [bp + 4] ;cx = counter

    push [bp + 6]
    call strlen
    add sp, 2

    mov di, [bp + 8] ;di = dst string
    cmp ah, cl
    jb @@two_large
    jmp @@memcopy

@@two_large:
    mov ah, 09h
    mov dx, offset incorrect_num_of_symbols
    int 21h
    jmp @@end_func

incorrect_num_of_symbols db "Number of symbols is bigger thah length of the src$"

@@memcopy:
    rep movsb ;copies strint with the length = cx
    mov byte ptr ds:[di], "$"

@@end_func:
    pop bp
    ret
    endp memcpy

;--------------------------------------------------------;

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

;--------------------------------------------------------;

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

;--------------------------------------------------------;

;--------------------------------------------------------;
;                   STRCMP
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