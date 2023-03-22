# crackmexxx

## Over view

![image](https://user-images.githubusercontent.com/87138860/226822583-fc3398e2-965e-4620-9b29-7abcd61fdcb7.png)

file ELF64

## Reverse

load file vào ida

![image](https://user-images.githubusercontent.com/87138860/226822898-bb8f5d1c-590f-4e0c-a2e1-adf32c569d0e.png)

Ta có thể thấy hàm `loc_4006E5)()` dùng để check flag

![image](https://user-images.githubusercontent.com/87138860/226823053-41c94de1-cf0b-4bd9-a103-e5b8be793cee.png)

nhưng có vẻ nó đã bị mã hóa hoặc gì đó. Và hàm  `sub_400526()` dùng để giải mã hàm `loc_4006E5)()`

![image](https://user-images.githubusercontent.com/87138860/226823311-b7c743d0-dbe9-46bd-acd3-19f364c9b899.png)


ta sẽ dump hàm `loc_4006E5)()` bằng gdb : `dump binary memory result.bin 0x4006e5 0x40090d`


