INCLUDE Irvine32.inc

inputsize = 1024
.data
array db 256 dup(0)
msg1 byte "secret key: ",0
msg2 byte "plain text: ",0
plaintext db inputsize dup(0)
sckey db inputsize dup(0)
cyphertext db inputsize dup(0)
hInput dd ?
hOutput dd ?
byteRead dd ?
keylen dd ?
plainlen dd ?
cipherPrintText db inputSize dup (0),0
byteWritten dd ?

.code


itohex proc ;from int to hex to print
	push ebp
	mov ebp,esp
	mov eax,[ebp+8]	;cipherText
	mov ecx,DWORD PTR [plainlen]		;count var
	mov edx,offset cipherPrintText
	dec eax ;prepare for loop
	nexthex:
		inc eax			;go through each element in cipher Text
		mov esi,0		;var to check 
		cmp ecx,0		;countdown cipher len and check
		jle done
		dec ecx
		movzx ebx,BYTE PTR[eax]	;take hex one by one 
		shr ebx,4		;shift right to get 4 first bits
		cmp bl,9
		jle addBase10	;if 1-9
	addHex:
		add bl,37h		;if A-F
		mov BYTE PTR[edx],bl
		inc edx
		inc esi
		cmp esi,2
		je nexthex
	nextdigit:
		movzx ebx,BYTE PTR[eax] ;get hex again to convert 4 last bit
		and ebx,0fh				;xor 1111 to get 4 last bit
		cmp bl,9				
		jle addBase10			;if 1-9
		jmp addHex				;if A-F
	

	addBase10:
		add bl,30h				;get number in ascii to print
		mov BYTE PTR[edx],bl	;save to cipherTextPrint
		inc edx					;i++
		inc esi					;check bit in 1 hex digit
		cmp esi,2				;if 2 go to next hex
		je nexthex
		jmp nextdigit			;else go to 2nd digit in current hex
	done:
	mov BYTE PTR[edx],0dh		;push 0dh to calculate strlen
	mov esp,ebp
	pop ebp
	ret
itohex endp
main PROC
invoke GetStdHandle,STD_INPUT_HANDLE
mov hInput, eax
invoke GetStdHandle,STD_OUTPUT_HANDLE
mov hOutput, eax

mov edx, offset msg1
call WriteString

invoke ReadConsole,hInput, ADDR sckey, inputsize, ADDR byteRead, 0 

mov eax, byteRead 
sub eax, 2
mov DWORD PTR [keylen], eax
xor eax, eax

mov eax, 0
mov ecx, 256
mov edi , offset array
l1:
   mov BYTE PTR array[eax], al
   inc eax
   loop l1

xor ebx, ebx ;i
xor ecx, ecx ;j
ksa:
   
   xor eax, eax
   mov al, byte ptr array[ebx]     ;al = array[i]
   add ecx, eax                    ;j = j + array[i]
   
   xor eax, eax
   mov eax, ebx                    ;eax = i
   mov ch, byte ptr [keylen]        
   div ch                          ;ah = i mod keylen
   xor edx, edx
   xor ch, ch
   mov dl, ah                      
   mov al, byte ptr sckey[edx]     ;al = sckey[i mod keylen]
   add ecx, eax                    ;j= j + array[i] + sckey[i mod keylen]
   
   xor eax, eax
   mov eax, ecx
   xor edx, edx
   mov cx, 256
   div cx;   j =j mod 256
   xor ecx, ecx
   mov ecx, edx ; edx = j mod 256

   xor edx, edx
   mov dh, byte ptr array[ecx]
   mov dl, byte ptr array[ebx]
   mov byte ptr array[ecx], dl
   mov byte ptr array[ebx], dh
   inc ebx
   cmp ebx, 256
   jl ksa

xor eax, eax
mov eax, offset array
mov edx, offset msg2
call WriteString

invoke ReadConsole,hInput, ADDR plaintext, inputsize, ADDR byteRead, 0 

mov eax, byteRead 
sub eax, 2
mov DWORD PTR [plainlen], eax
xor eax, eax

xor ecx,ecx 
xor esi,esi     ; i=0
xor edi,edi     ; j=0
prga:
	mov eax,esi      ; eax =i
	add eax,1	     ; eax = i+1
	xor ebx,ebx 
	mov bx,256	
	xor edx,edx
	div bx          ;  dx= (i+1) mod 256
	xor eax, eax
	mov esi, edx     ; i= (i+1) mod 256
	mov al, byte ptr array[esi]   ; eax = array[(i+1)mod 256] = array[i]

	xor ebx, ebx
	mov ebx, edi     ; ebx= j
	add ebx, eax     ;  j= j+ array[i]
	xor eax, eax
	mov eax, ebx     ; eax= j + array[i]
	xor ebx,ebx
	mov bx, 256
	xor edx, edx
	div bx           ;  dx= (j+ array[i]) mod 256
	mov edi, edx

	xor eax, eax
	xor edx, edx
	mov al, byte ptr array[esi]
	mov dl, byte ptr array[edi]
	mov byte ptr array[edi], al
	mov byte ptr array[esi], dl

	xor eax, eax
	mov al, byte ptr array[esi]
	add al, byte ptr array[edi]      ; eax= s[i]+s[j]
	xor ebx,ebx
	mov bx, 256
	xor edx, edx
	div bx                           ;  dx= eax mod 256
    xor eax,eax
	mov al, byte ptr array[edx]; 
    xor al , byte ptr plaintext[ecx]
    mov byte ptr cyphertext[ecx], al
	xor eax, eax
	mov eax, offset cyphertext
	inc ecx
	cmp cl, byte ptr [plainlen]
	jl prga

push offset cyphertext
call itohex
invoke WriteConsole, hOutput, addr cipherPrintText,sizeof cipherPrintText, byteWritten, 0


invoke ExitProcess, 0
main ENDP
END main