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


Ta sẽ đặt breakpoint bên dưới vòng for để xem hàm  `loc_4006E5)()` sau khi được giả mã.

![image](https://user-images.githubusercontent.com/87138860/227218471-8077ec11-75c2-4744-885c-c26ff9076a63.png)

Sau đó, ta sẽ snapshot memory lại.

![image](https://user-images.githubusercontent.com/87138860/226839319-b30a2710-3507-4c76-a7e7-b9b8d18b9918.png)

Có thể thấy hàm sau khi giải mã xong sử dụng một vài kĩ thuật disassembly.

Thứ nhất, ta thấy code `mov` và `add` những số rất lớn vào `eax` rồi thực hiện `jnb`, nhưng đoạn code hoàn toàn vô nghĩa vì nó sẽ không đủ điều kiện để thay đổi giá trị cờ `CF`. Thứ hai, hàm `jnb` sẽ chỉ đến một địa điểm sai (rơi vào giữa câu lệnh tiếp theo).

Ta sẽ sửa các hàm nhảy bị lỗi bằng `U/C` và `nop` các phần code vô nghĩa.

![image](https://user-images.githubusercontent.com/87138860/227219858-b4dea85f-e9d9-4a1a-b19c-d84c9a8979e8.png)

Đây là thành quả thu được sau khi sửa @@.

Trong đó `v0` là input sẽ được mã hóa qua các vòng lặp rồi được so sánh với các phần tử của `byte_4008EB`.

## Script

```python

arr=[0x48, 0x5f, 0x36, 0x35, 0x35, 0x25, 0x14, 0x2c, 0x1d, 0x01, 0x03, 0x2d,
     0x0c, 0x6f, 0x35, 0x61, 0x7e, 0x34, 0x0a, 0x44, 0x24, 0x2c, 0x4a, 0x46,
     0x19, 0x59, 0x5b, 0x0e, 0x78, 0x74, 0x29, 0x13, 0x2c]

for i in range (256):
    v2 = i
    flag= bytearray(arr)
    for j in range (1337):
        for k in range (len(arr)-1,-1,-1):
            v2 = flag[k] ^ v2
            flag[k] = flag[k] ^ v2
    if v2 == 0x50:
        print(flag)
```

## Flag

`pctf{ok_nothing_too_fancy_there!}`

