INCLUDE Irvine32.inc
inputSize=10000
.data
msg byte "Nhap so phan tu cua mang:", 0
msg2 byte "so nto trong mang:", 0
soPhantu dd 0
byteHandle dd ?
stdHandle HANDLE ?
arraychar db inputSize dup(?) 
arrayint dd 3200 dup(?)
arrayRS dd 3200 dup(?)
result db 32 dup(?),0
number dd 32 dup(?),0
.code

itoa PROC
push ebp
mov ebp,esp
mov esi,[ebp+8] 
xor eax,eax
mov eax,DWORD PTR [esi]
mov DWORD PTR[result],0  ; bien de in
mov ecx,offset result
mov BYTE PTR[ecx],0Ah	
dec ecx
mov BYTE PTR[ecx],0dh
xor edi,edi
mov edi,10
sub1: 
dec ecx
mov BYTE PTR[ecx],0
xor edx,edx
div edi
add edx,30h
add BYTE PTR[ecx],dl   ;store in ecx
test eax,eax
jnz sub1
mov esp,ebp
pop ebp
ret
itoa ENDP		;int to ascii


main PROC

mov edx, offset msg
call WriteString

invoke GetStdHandle,STD_INPUT_HANDLE ;nhap so phan tu
mov stdHandle,eax
invoke ReadConsole,
		stdHandle,
		ADDR soPhantu,
		inputSize,
		ADDR byteHandle,
		0
xor edi,edi
mov edi,offset soPhanTu
call atoi	;chuyen so phan tu thanh int va luu vao esi
xor esi,esi
mov esi,eax
mov ebx,offset arraychar

input:
dec esi
invoke GetStdHandle,STD_INPUT_HANDLE
mov stdHandle,eax
invoke ReadConsole,
		stdHandle,
		ebx,
		inputSize,
		ADDR byteHandle,
		0
add ebx,10
test esi,esi
jnz input
	


mov edi,offset soPhanTu 
call atoi
xor ecx,ecx
mov ecx,eax				;lay so phan tu vao ecx

mov ebx, offset arraychar
mov edx, offset arrayint

reverseCharToInt:
mov edi,ebx
call atoi
mov DWORD PTR [edx],eax
add edx,8
add ebx,10
dec ecx
test ecx,ecx
jnz reverseCharToInt ;chuyen mang char thanh mang int




mov edx, offset arrayint
mov esi, offset arrayRS
sub edx, 8
xor eax, eax

checkprime:
   add edx, 8
   cmp DWORD ptr [edx], 0h
   je print
   cmp DWORD ptr [edx], 2
   jle checkprime
   mov ebx, 1
   l1:
     inc ebx
	 mov eax, DWORD ptr [edx]
	 mov ecx, DWORD ptr [edx]
	 div bl
	 cmp ah, 0
	 je is_prime
	 mov eax, ecx
	 cmp ebx, eax
	 jne l1 
	 je checkprime


is_prime:
    mov eax, ecx
    mov DWORD ptr [esi], eax
	add esi, 8
	jmp checkprime

atoi:
	mov eax,0 
atoi_start:
	 movzx esi, BYTE PTR [edi]
	 cmp esi, 0Ah          ; Check for \n
     je done
	 cmp esi, 0dh          ; Check for \n
     je done
	 test esi, esi           ; Check for end of string 
     je done
	 sub esi,48
	 imul eax,10d
	 add eax,esi
	 inc edi
	 jmp atoi_start
done:
	ret

print:
mov edx, offset msg2
call WriteString
xor edx, edx

mov edx, offset arrayRS
   
   l2:
   mov ebx, DWORD PTR [edx]
   mov DWORD PTR [number], ebx 
   push offset number
   call itoa

   invoke GetStdHandle,STD_OUTPUT_HANDLE
   mov stdHandle,eax
   invoke WriteConsole,stdHandle, ecx, 32, ADDR byteHandle, 0

   add edx, 32
   cmp DWORD ptr [edx], 0h
   jne l2




invoke ExitProcess, 0
main ENDP
END main