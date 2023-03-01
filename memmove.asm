.model tiny
.code
org 100h

start       
        





;--------------------------------------------------------;
;                   MEMMOVE
; Function copies string from ds:si to es:di, it also copies intersecting strings
; Entry: (1)dst: pointer to the destination string
;        (2)src: pointer to the source string
;        (3)number of the copying symbols(in cx)
; Destroys: di, si, cx, 
; Return: the adress of the symbol in cl
;--------------------------------------------------------;
memmove         proc




end start