INCLUDE Irvine32.inc 
inputsize=32
.data

   msg BYTE "Nhap chuoi can dao nguoc:",0
   input db inputsize dup(0)
   stdHandle HANDLE ?
   byteRead dd ?
   
.code
main proc

mov edx, OFFSET msg
call WriteString

invoke GetStdHandle, STD_INPUT_HANDLE
mov stdHandle, eax

invoke ReadConsole,stdHandle, ADDR input, inputsize, ADDR byteRead, 0 ;??c d? li?u t? c?a s? console 

mov ecx, byteRead ;  gán giá tr? ecx cho s? l??ng ký t? ??c ???c
mov esi, 0

;??a input vào stack 
l1:
    movzx eax,input[esi]
    push eax
    inc esi
    loop l1

mov ecx, byteRead
mov esi,0

;l?y ng??c eax t? stack ra và l?u l?i vào input
l2:
   pop eax
   mov input[esi], al
   inc esi
   loop l2

invoke GetStdHandle,STD_OUTPUT_HANDLE
mov stdHandle, eax
invoke WriteConsole,stdHandle,ADDR input, inputsize, ADDR byteRead,0

exit

main endp
end main