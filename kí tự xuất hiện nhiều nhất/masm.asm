INCLUDE Irvine32.inc

inputsize = 32
.DATA
    msg BYTE "Nhap chuoi :",0
    input db inputsize dup(0)
    stdHandle HANDLE ?
    byteRead dd ?
    countarray BYTE 256 DUP(0) ; 
    maxcount BYTE 0
    printChar db 0
.CODE
main PROC
    ; in thong bao
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov stdHandle, eax
    mov edx, offset msg
    invoke WriteConsole, stdHandle,edx, sizeof msg, byteRead,0
    
    ; doc input tu cua so console
    invoke GetStdHandle,STD_INPUT_HANDLE
    mov stdHandle, eax
    invoke ReadConsole, stdHandle, addr input, inputsize, addr byteRead,0

;dem so ki tu xuat hien luu vao countarray    
    mov esi, offset input
    mov edi, offset countarray
count_loop:
    movzx eax, BYTE PTR [esi]
    inc esi
    inc BYTE PTR [edi+eax] 
    cmp BYTE PTR [esi], 0dh
    jnz count_loop

mov ecx,0; coi ecx la max
mov eax,20h; eax = 20h (ki tu dau tien trong bang assci) 
mov edx,0; bien dem stack
find_max:
    cmp eax,7fh; so sanh voi ki tu cuoi cung 
    jge write; neu lon hon hoac bang thi nhay den write
    inc eax
    movzx ebx, BYTE PTR[edi+eax]; gan so lan xuat hien cua eax cho ebx
    cmp ebx,ecx
    jl find_max ; neu ebx < max thi nhay lai find_max
    je equalSum; neu ebx = ecx thi nhay den equalSum
    mov edx,1; neu ebx > max thi gan edx = 1 roi day eax vao stack, gan max = ebx
    push eax
    mov ecx,ebx
    jmp find_max



equalSum:
    push eax
    inc edx
    jmp find_max

write:
    mov ecx, edx 
    mov esi, 0
    l1:
       pop eax
       mov printChar[esi], al
       inc esi
       loop l1
    
invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdHandle, eax
invoke WriteConsole,stdHandle,ADDR printChar, 32, ADDR byteRead,0
    
invoke ExitProcess,0
main ENDP

END main




