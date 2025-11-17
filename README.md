# Đồ Án Kho Dữ Liệu: Phân Tích Kinh Doanh Rạp Chiếu Phim

## Mục Lục

- [Bối Cảnh Nghiệp Vụ](#bối-cảnh-nghiệp-vụ)
- [Kiến Trúc Hệ Thống](#kiến-trúc-hệ-thống)
- [Cấu Trúc Thư Mục](#cấu-trúc-thư-mục)
- [Yêu Cầu Công Nghệ](#yêu-cầu-công-nghệ)
- [Hướng Dẫn Cài Đặt và Chạy Dự Án](#hướng-dẫn-cài-đặt-và-chạy-dự-án)
  - [Bước 1: Thiết Lập Cơ Sở Dữ Liệu](#bước-1-thiết-lập-cơ-sở-dữ-liệu)
  - [Bước 2: Tạo Dữ Liệu Giả Lập (Mock Data)](#bước-2-tạo-dữ-liệu-giả-lập-mock-data)
  - [Bước 3: Chạy Quy Trình ETL](#bước-3-chạy-quy-trình-etl)
  - [Bước 4: Phân Tích Dữ Liệu với Power BI](#bước-4-phân-tích-dữ-liệu-với-power-bi)
- [Thiết Kế Kho Dữ Liệu (Star Schema)](#thiết-kế-kho-dữ-liệu-star-schema)
- [Một Số Phân Tích Kinh Doanh (Ví dụ)](#một-số-phân-tích-kinh-doanh-ví-dụ)

## Bối Cảnh Nghiệp Vụ

Dự án tập trung vào việc phân tích các hoạt động kinh doanh cốt lõi của một chuỗi rạp chiếu phim, bao gồm:

- Doanh thu bán vé theo phim, thể loại, rạp chiếu, và các khung thời gian.
- Chân dung và hành vi của khách hàng (nhóm tuổi, hạng thành viên, tần suất mua vé).
- Hiệu quả hoạt động của các suất chiếu (tỷ lệ lấp đầy, khung giờ vàng).

## Kiến Trúc Hệ Thống

Hệ thống được xây dựng theo kiến trúc kho dữ liệu kinh điển:

1.  **OLTP Database (Nguồn):** Một CSDL quan hệ (SQL Server) được thiết kế tinh gọn để ghi nhận các giao dịch hàng ngày.
2.  **ETL (Extract - Transform - Load):** Sử dụng **SQL Server Integration Services (SSIS)** để trích xuất dữ liệu từ nguồn, biến đổi (làm sạch, tính toán, gộp dữ liệu) và nạp vào kho dữ liệu.
3.  **Data Warehouse (Đích):** Một CSDL riêng (SQL Server) được thiết kế theo mô hình Lược đồ Hình sao (Star Schema) để tối ưu cho việc truy vấn và phân tích.
4.  **Business Intelligence (BI):** Sử dụng **Power BI** để kết nối vào Data Warehouse, xây dựng các báo cáo và dashboard trực quan.

## Cấu Trúc Thư Mục

.
├── assets/ # Chứa các hình ảnh, tài liệu liên quan
├── etl/ # Chứa dự án SSIS (Visual Studio Solution)
├── mock_data.ipynb # Jupyter Notebook để tạo dữ liệu giả lập
├── ole_db_sources.sql # Script SQL để tạo CSDL nguồn (OLTP)
├── ole_db_destination.sql# Script SQL để tạo CSDL đích (Data Warehouse)
└── README.md # File hướng dẫn

## Yêu Cầu Công Nghệ

- **SQL Server 2019** hoặc mới hơn.
- **SQL Server Management Studio (SSMS)**.
- **Visual Studio 2019** hoặc mới hơn (với extension **SQL Server Integration Services Projects**).
- **Python 3.x** với các thư viện: `pandas`, `faker`, `sqlalchemy`.
- **Power BI Desktop**.

## Hướng Dẫn Cài Đặt và Chạy Dự Án

Thực hiện theo các bước sau để triển khai lại toàn bộ dự án.

### Bước 1: Thiết Lập Cơ Sở Dữ Liệu

1.  Mở **SSMS** và kết nối đến SQL Server instance của bạn.
2.  Tạo 2 database trống:
    - `CinemaOLTP` (cho dữ liệu nguồn)
    - `CinemaDataWarehouse` (cho kho dữ liệu)
3.  Mở và chạy file `ole_db_sources.sql` trên database `CinemaOLTP`.
4.  Mở và chạy file `ole_db_destination.sql` trên database `CinemaDataWarehouse`.

### Bước 2: Tạo Dữ Liệu Giả Lập (Mock Data)

1.  Mở file `mock_data.ipynb` bằng Jupyter Notebook hoặc VS Code.
2.  Chỉnh sửa chuỗi kết nối (connection string) trong file để trỏ đến database `CinemaOLTP` của bạn.
3.  Chạy tất cả các cell trong notebook để tạo và nạp dữ liệu vào CSDL nguồn.

### Bước 3: Chạy Quy Trình ETL

1.  Mở file solution `.sln` trong thư mục `etl/` bằng **Visual Studio**.
2.  Trong panel **Solution Explorer**, kiểm tra các **Connection Managers** ở dưới cùng và đảm bảo chúng đang trỏ đúng đến 2 database `CinemaOLTP` và `CinemaDataWarehouse` của bạn.
3.  Mở file `Package.dtsx`.
4.  Nhấn nút **Start (F5)** để thực thi gói ETL. Quá trình sẽ dọn dẹp và nạp toàn bộ dữ liệu từ nguồn sang đích.

### Bước 4: Phân Tích Dữ Liệu với Power BI

_(Phần này sẽ được cập nhật sau)_

1.  Mở Power BI Desktop.
2.  Kết nối đến database `CinemaDataWarehouse`.
3.  Xây dựng các biểu đồ và báo cáo dựa trên các bảng Fact và Dimension.

## Thiết Kế Kho Dữ Liệu (Star Schema)

Kho dữ liệu được thiết kế theo mô hình Lược đồ Hình sao với 1 bảng Fact và 5 bảng Dimension:

- **Fact_Booking:** Chứa các số đo về giao dịch đặt vé như `TotalTickets`, `FinalAmount`.
- **Dim_Customer:** Chứa thông tin khách hàng.
- **Dim_Movie:** Chứa thông tin về phim và thể loại.
- **Dim_Cinema:** Chứa thông tin về rạp chiếu.
- **Dim_Showtime:** Chứa các thuộc tính của suất chiếu (khung giờ, ngày cuối tuần).
- **Dim_Date:** Bảng chiều thời gian chuẩn.

## Một Số Phân Tích Kinh Doanh (Ví dụ)

- Top 5 phim có doanh thu cao nhất trong quý.
- Tỷ lệ đóng góp doanh thu theo từng thành phố/rạp chiếu.
- Phân tích doanh thu theo khung giờ (sáng/chiều/tối) và ngày trong tuần.
- Chân dung khách hàng theo độ tuổi và hạng thành viên.
