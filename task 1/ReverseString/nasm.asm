section .data
  message db "Enter a string: "
  len equ $-message
  

section .bss
   input resb 50
   reversed resb 50
section .text
  global _start
_start:
  ;Day thong bao
  mov edx, len
  mov eax, 4
  mov ecx, message
  mov ebx, 1
  int 0x80
  
  ;Doc string nhap vao
  mov eax, 3
  mov ebx, 0
  mov ecx, input
  mov edx, 50
  int 0x80
  
  ;Lay do dai input
  mov esi,input
  mov edi,input +50
  mov ecx, 0
  
  count:
  cmp byte [esi], 0
  je reverse
  inc esi
  inc ecx
  mov edx, ecx
  jmp count

  reverse:
       mov esi,0
       
       l1:
          movzx eax, byte [input + esi]
          push eax
          inc esi
          loop l1
       mov esi, 0
       mov ecx , edx
       l2:
          pop eax
          mov [reversed + esi], al
          inc esi
          loop l2


 
  ;in ket qua
  mov eax, 4
  mov ebx, 2
  mov ecx, reversed
  
  int 0x80
  
  mov eax, 1
  int 0x80