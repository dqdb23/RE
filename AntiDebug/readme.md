## AntiDebug

# Overview

file PE64

![image](https://user-images.githubusercontent.com/87138860/224939050-27af66c1-80aa-45da-bb25-ada86750854f.png)

Load file vào ida ta thấy có hàm `IsDebuggerPresent()` 

![image](https://user-images.githubusercontent.com/87138860/224941662-f70d1075-d678-4d3f-9e02-dbb9b59885bd.png)

`IsDebuggerPresent()` là một hàm được cung cấp bởi Win32 API trong hệ điều hành Windows. Hàm này được sử dụng để kiểm tra xem chương trình đang được chạy có đang được giám sát bởi một trình gỡ lỗi (debugger) hay không.
Hàm `IsDebuggerPresent()` sẽ trả lại `True` nếu chương trình đang bị debug.
Vậy để chương trình chạy theo hướng ta muốn thì ta sẽ sửa  `jz short loc_140001136` thành `jmp short loc_140001136`.


![image](https://user-images.githubusercontent.com/87138860/224977569-30215170-360d-4f63-b8a2-8815a58ee092.png)

Ta thấy chương trình sử dụng hàng loạt hàm `GetTickCount()`. `GetTickCount()` là một hàm của Win API trả về số miligiây đã trôi qua kể từ khi hệ thống khởi động.

![image](https://user-images.githubusercontent.com/87138860/224984964-38790ffc-3c90-462b-8d42-230891657967.png)

Khi khởi động chương trình, hàm `sub_140001000()` sẽ chạy và khởi tạo giá trị cho biến `dword_140023BBC` bằng `GetTickCount()` => `GetTickCount() - dword_7FF733693BBC` bằng thời gian từ lúc khởi tạo giá trị `dword_140023BBC` cho đến thời điểm hiện tại.
Nếu `> 10` giây thì chương trình sẽ trả về `-1`.

Có thể hiểu là nếu ta debug tại một điểm nào đó quá `10s` thì chương trình sẽ bị dừng. Vậy nên ta sẽ sửa thử lên `7000s` :)). Bỏ qua những hàm check thời gian qua một bên, chương trình đọc dữ liệu từ `AntiDebug.exe` rồi lưu trữ vào `v6`.

![image](https://user-images.githubusercontent.com/87138860/224991904-d815a4e1-78d8-4e52-821a-ad04a8c76e5c.png)

Với hàm `sub_7FF7336710A0()`. Ta thấy lời gọi hàm `_acrt_iob_func(0)` ta có thể hiểu đây là hàm nhập `input` của chương trình và được lưu vào `v10`.


![image](https://user-images.githubusercontent.com/87138860/224992853-11f0e683-0de7-4e52-a50e-2744132f7e19.png)

Với vòng lặp `While`. Vòng lặp sẽ chạy đến khi `v4=30`, vòng lặp sẽ tìm các giá trị `v7` rồi kiểm tra `if ( v10[v4] != *((_BYTE *)v6 + v7) )`. 



# Script

```python
arr = open('AntiDebug.exe','rb')
v6 = arr.read()
flag=[]
a=0

key=[ 0x2B, 0x2D, 0x2D, 0x2B, 0x2D, 0x2B, 0x2B, 0x2D, 0x2D, 0x2B, 
  0x2D, 0x2B, 0x2D, 0x2B, 0x2B, 0x2D, 0x2D, 0x2B, 0x2B, 0x2D, 
  0x2B, 0x2B, 0x2A, 0x2B, 0x2D, 0x2B, 0x2D, 0x2B, 0x2D, 0x2B, 
  0x00, 0x00]
ex=[0x1EBD5,0x0CD1C,0x4AB6,0x110CD,0x13B07,0x0C89B,0x785B,0x0CC06,0x10A14,0x19ECD
,0x1219B,0x17F2,0x9524,0x173F1,0x6229,0x6229,0x173F1,0x0F85F,0x0CE6A
,0x14997,0x1E97,0x0A28,0x1,0x526E,0x7B2D,0x0F634,0x0F634
,0x17F2,0x538E,0x381E]

for i in range (30):
    if key[i] == 0x2b:
       v7 =  ex[i] + a
    if key[i] == 0x2d:
       v7 = a - ex[i]   
    if key[i]== 0x2a:
        v7 = a*ex[i] 
    a = v7
    flag.append(v6[v7])
    print(chr(flag[i]),end="")
```

## Flag

`CTF{M!sT3r_M3ese3k5_L00k_@_ME}`
