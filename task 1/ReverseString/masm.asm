INCLUDE Irvine32.inc 
inputsize=32
.data

   msg BYTE "Nhap chuoi can dao nguoc:",0
   input db inputsize dup(0)
   stdHandle HANDLE ?
   byteRead dd ?
   
.code
main proc

invoke GetStdHandle, STD_OUTPUT_HANDLE
mov stdHandle, eax
mov edx, offset msg
invoke WriteConsole, stdHandle,edx, sizeof msg, byteRead,0

invoke GetStdHandle, STD_INPUT_HANDLE
mov stdHandle, eax

invoke ReadConsole,stdHandle, ADDR input, inputsize, ADDR byteRead, 0 ;Doc du lieu tu cua so console

mov ecx, byteRead ;  gan luong ki tu doc duoc cho ecx
mov esi, 0

;Day input vao stack 
l1:
    movzx eax,input[esi]
    push eax
    inc esi
    loop l1

mov ecx, byteRead
mov esi,0

;lay eax ra khoi stack roi gan lai cho input
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
