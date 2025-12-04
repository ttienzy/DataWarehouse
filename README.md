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

Dự án tập trung vào việc phân tích toàn diện các hoạt động kinh doanh của chuỗi rạp chiếu phim, bao gồm 2 mảng chính:

1.  **Doanh thu vé (Ticketing):** Phân tích doanh thu theo phim, suất chiếu, tỷ lệ lấp đầy rạp và hành vi đặt vé của khách hàng.
2.  **Doanh thu dịch vụ ăn uống & phụ trợ (Concession):** Phân tích hiệu quả bán hàng tại quầy bắp nước (Combo, đồ ăn nhẹ), hiệu suất làm việc của nhân viên và quản lý danh mục sản phẩm.

## Kiến Trúc Hệ Thống

Hệ thống được xây dựng theo kiến trúc kho dữ liệu kinh điển:

1.  **OLTP Database (Nguồn):** SQL Server ghi nhận giao dịch bán vé và bán hàng tại quầy hàng ngày.
2.  **ETL (Extract - Transform - Load):** Sử dụng **SSIS** để trích xuất, làm sạch và đồng bộ dữ liệu. Luồng xử lý được chia thành 2 nhánh song song: Xử lý Vé (Booking) và Xử lý Bán Hàng (Concession).
3.  **Data Warehouse (Đích):** SQL Server lưu trữ dữ liệu theo mô hình **Galaxy Schema (Fact Constellation)** - cho phép nhiều bảng Fact chia sẻ các bảng Dimension chung.
4.  **Business Intelligence (BI):** Power BI kết nối trực tiếp để trực quan hóa dữ liệu.

## Cấu Trúc Thư Mục

.
├── assets/ # Chứa các hình ảnh, tài liệu liên quan
├── etl/ # Chứa dự án SSIS (Visual Studio Solution)
├── mock_data.ipynb # Jupyter Notebook tạo dữ liệu giả lập (đã cập nhật logic Concession)
├── ole_db_sources.sql # Script tạo bảng nguồn (CinemaOLTP)
├── ole_db_destination.sql # Script tạo bảng đích (CinemaDataWarehouse)
└── README.md # File hướng dẫn

## Yêu Cầu Công Nghệ

- **SQL Server 2019** hoặc mới hơn.
- **SQL Server Management Studio (SSMS)**.
- **Visual Studio 2019** (với extension **SSIS Projects**).
- **Python 3.x** (thư viện: `pandas`, `faker`, `sqlalchemy`).
- **Power BI Desktop**.

## Hướng Dẫn Cài Đặt và Chạy Dự Án

### Bước 1: Thiết Lập Cơ Sở Dữ Liệu

1.  Mở **SSMS** và kết nối đến SQL Server.
2.  Tạo 2 database trống: `CinemaOLTP` và `CinemaDataWarehouse`.
3.  Chạy file `ole_db_sources.sql` trên `CinemaOLTP` (đã bao gồm các bảng Staff, Inventory, ConcessionSale).
4.  Chạy file `ole_db_destination.sql` trên `CinemaDataWarehouse`.

### Bước 2: Tạo Dữ Liệu Giả Lập (Mock Data)

1.  Mở `mock_data.ipynb` bằng Jupyter/VS Code.
2.  Cập nhật chuỗi kết nối (connection string) tới `CinemaOLTP`.
3.  Chạy (Run All) để sinh dữ liệu cho cả Vé và Hàng hóa.

### Bước 3: Chạy Quy Trình ETL

1.  Mở solution trong thư mục `etl/` bằng **Visual Studio**.
2.  Kiểm tra kết nối trong **Connection Managers**.
3.  Mở file `Package.dtsx`. Lưu ý luồng Control Flow hiện có 2 nhánh chạy song song.
4.  Nhấn **Start (F5)**. Đảm bảo toàn bộ các task (bao gồm Fact_Booking và Fact_ConcessionSale) đều hiển thị tích xanh.

### Bước 4: Phân Tích Dữ Liệu với Power BI

1.  Mở Power BI Desktop, kết nối `CinemaDataWarehouse`.
2.  Thiết lập Relationship giữa các bảng Fact và Dim chung (Date, Cinema).

## Thiết Kế Kho Dữ Liệu (Star Schema)

Hệ thống mở rộng thành mô hình Galaxy Schema với 2 bảng Fact chính và các Dimension vệ tinh:

### Bảng Fact (Sự kiện kinh doanh)

- **Fact_Booking:** Lưu giao dịch đặt vé (`TicketQty`, `TicketAmount`).
- **Fact_ConcessionSale:** (Mới) Lưu giao dịch bán hàng ăn uống (`Quantity`, `TotalAmount`, `CostAmount`).

### Bảng Dimension (Góc nhìn phân tích)

- **Dim_Date:** Chiều thời gian chuẩn (Dùng chung cho cả 2 Fact).
- **Dim_Cinema:** Thông tin rạp chiếu (Dùng chung).
- **Dim_Customer:** Thông tin khách hàng thành viên.
- **Dim_Movie:** Thông tin phim.
- **Dim_Showtime:** Thông tin suất chiếu.
- **Dim_Staff:** (Mới) Thông tin nhân viên bán hàng (Ca làm việc, vị trí).
- **Dim_Inventory:** (Mới) Danh mục sản phẩm (Bắp, Nước, Combo, Đồ lưu niệm).

## Một Số Phân Tích Kinh Doanh (Ví dụ)

**Về Vé (Booking):**

- Top 5 phim doanh thu cao nhất quý.
- Phân tích xu hướng xem phim theo khung giờ vàng.

**Về Bán Hàng (Concession):**

- **Tỷ lệ đính kèm (Attach Rate):** Tỷ lệ khách hàng mua bắp nước trên tổng số vé bán ra.
- **Hiệu quả nhân viên:** Top nhân viên có doanh thu bán hàng cao nhất (Upsell tốt nhất).
- **Lợi nhuận sản phẩm:** So sánh doanh thu và giá vốn của các gói Combo so với bán lẻ.
- **Doanh thu chéo:** Rạp nào có doanh thu vé thấp nhưng doanh thu bắp nước cao?
