# Anti-Debugging

## Over view

![image](https://user-images.githubusercontent.com/87138860/225652381-02b964a7-5f9b-457a-9213-21fee500592d.png)

File PE32.

Load file vào ida. Ta `Ctrl + e` để xem en try point của chương trình. 

![image](https://user-images.githubusercontent.com/87138860/225652768-5ccc3c49-002b-4aa6-98be-08626cad787b.png)

Ta thấy địa chỉ của `TlsCallback_0` nằm trước main entry point.

### TlsCallback

TLS (Thread Local Storage) là một cơ chế trong các hệ điều hành và các ngôn ngữ lập trình để quản lý dữ liệu cục bộ (local data) cho từng luồng (thread) trong một quá trình đa luồng (multithreaded process). Khi một quá trình được thực thi đa luồng, mỗi luồng sẽ có một bộ nhớ và một ngăn xếp riêng biệt, do đó việc truy cập dữ liệu cục bộ của một luồng từ một luồng khác có thể gây ra các lỗi đồng bộ hóa và xung đột dữ liệu.

TLS giải quyết vấn đề này bằng cách cung cấp cho mỗi luồng một không gian bộ nhớ riêng biệt để lưu trữ dữ liệu cục bộ mà không ảnh hưởng đến dữ liệu của các luồng khác. TLS được triển khai bằng cách cấp phát một vùng nhớ riêng biệt cho mỗi luồng, được gọi là "thread-local storage", và cung cấp các hàm API để quản lý việc lưu trữ và truy cập dữ liệu cục bộ trong TLS.

Còn trong TlsCallback của chương trình có gì? Hãy cùng tìm hiểu...

