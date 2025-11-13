IF EXISTS (SELECT name FROM sys.databases WHERE name = N'QuanLyChungCu')
    DROP DATABASE QuanLyChungCu;
GO

CREATE DATABASE QuanLyChungCu;
GO
USE QuanLyChungCu;
GO

-- Khu căn hộ --
CREATE TABLE KhuCanHo (
    MaKhu VARCHAR(10) PRIMARY KEY,
    TenKhu NVARCHAR(100) NOT NULL,
    SoTang INT NOT NULL,
    SoCanHo INT NOT NULL
);

-- Căn hộ --
CREATE TABLE CanHo (
    MaCanHo VARCHAR(10) PRIMARY KEY,
    MaKhu VARCHAR(10) NOT NULL,
    DienTich FLOAT NOT NULL CHECK (DienTich > 0),
    Gia BIGINT NOT NULL CHECK (Gia > 0),
    TrangThai NVARCHAR(20) NOT NULL DEFAULT N'Trống',
    FOREIGN KEY (MaKhu) REFERENCES KhuCanHo(MaKhu)
);

-- Chủ căn hộ -- 
CREATE TABLE ChuCanHo (
    MaChu VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SDT NVARCHAR(15),
    Email NVARCHAR(100),
    MaCanHo VARCHAR(10) NOT NULL UNIQUE,
    FOREIGN KEY (MaCanHo) REFERENCES CanHo(MaCanHo)
);

-- Cư dân --
CREATE TABLE CuDan (
    MaCuDan VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    CCCD NVARCHAR(20) UNIQUE,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    SDT NVARCHAR(15),
    Email NVARCHAR(100),
    MaCanHo VARCHAR(10) NOT NULL,
    QuanHeVoiChuHo NVARCHAR(50),
    FOREIGN KEY (MaCanHo) REFERENCES CanHo(MaCanHo)
);

-- Tài khoản --
CREATE TABLE TaiKhoan (
    TenDangNhap NVARCHAR(50) PRIMARY KEY,
    MatKhau NVARCHAR(100) NOT NULL,
    LoaiTaiKhoan NVARCHAR(20) CHECK (LoaiTaiKhoan IN (N'Admin', N'Chủ hộ')),
    MaChu VARCHAR(10) NULL,
    FOREIGN KEY (MaChu) REFERENCES ChuCanHo(MaChu)
);

-- Dịch vụ --
CREATE TABLE DichVu (
    MaDichVu VARCHAR(10) PRIMARY KEY,
    TenDichVu NVARCHAR(100) NOT NULL,
    DonGia MONEY CHECK (DonGia >= 0),
    DonViTinh NVARCHAR(50)
);

-- Sử dụng dịch vụ --
CREATE TABLE SuDungDichVu (
    MaSuDung VARCHAR(10) PRIMARY KEY,
    MaCanHo VARCHAR(10) NOT NULL,            
    MaDichVu VARCHAR(10) NOT NULL,           
    SoLuong INT CHECK (SoLuong > 0),
    FOREIGN KEY (MaCanHo) REFERENCES CanHo(MaCanHo),
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu)
);

-- Hóa đơn --
CREATE TABLE HoaDon (
    MaHoaDon VARCHAR(10) PRIMARY KEY,
    MaChu VARCHAR(10) NOT NULL,
    NgayLap DATE DEFAULT GETDATE(),
    TongTien MONEY NOT NULL,
    TrangThai NVARCHAR(50) CHECK (TrangThai IN (N'Đã thanh toán', N'Chưa thanh toán')),
    FOREIGN KEY (MaChu) REFERENCES ChuCanHo(MaChu)
);

-- Thông báo chung --
CREATE TABLE ThongBaoChung (
    MaThongBao VARCHAR(10) PRIMARY KEY,
    TieuDe NVARCHAR(200) NOT NULL,
    NoiDung NVARCHAR(MAX) NOT NULL,
    NgayGui DATE DEFAULT GETDATE()
);

-- Thông báo riêng --
CREATE TABLE ThongBaoRieng (
    MaThongBao VARCHAR(10) PRIMARY KEY,
    MaChu VARCHAR(10) NOT NULL,
    TieuDe NVARCHAR(200) NOT NULL,
    NoiDung NVARCHAR(MAX) NOT NULL,
    NgayDang DATE DEFAULT GETDATE(),
    FOREIGN KEY (MaChu) REFERENCES ChuCanHo(MaChu)
);

-- Khiếu nại --
CREATE TABLE KhieuNai (
    MaKhieuNai VARCHAR(10) PRIMARY KEY,
    MaCuDan VARCHAR(10) NOT NULL,
    TieuDe NVARCHAR(200) NOT NULL,
    NoiDung NVARCHAR(MAX),
    NgayGui DATE DEFAULT GETDATE(),
    TrangThai NVARCHAR(50) CHECK (TrangThai IN (N'Đang xử lý', N'Đã giải quyết')),
    FOREIGN KEY (MaCuDan) REFERENCES CuDan(MaCuDan)
);

-- Data mẫu --
INSERT INTO KhuCanHo (MaKhu, TenKhu, SoTang, SoCanHo) VALUES
('KH01', N'Khu A', 10, 20),
('KH02', N'Khu B', 8, 16);

INSERT INTO CanHo (MaCanHo, MaKhu, DienTich, Gia, TrangThai) VALUES
('CHH01', 'KH01', 80, 2000000000, N'Đã có chủ'),
('CHH02', 'KH01', 50, 1200000000, N'Đã có chủ'),
('CHH03', 'KH02', 70, 1800000000, N'Đã có chủ'),
('CHH04', 'KH02', 120, 3500000000, N'Đã có chủ');

INSERT INTO ChuCanHo (MaChu, HoTen, SDT, Email, MaCanHo) VALUES
('CH01', N'Nguyen Van A', '0901111111', 'a@gmail.com', 'CHH01'),
('CH02', N'Tran Thi B', '0902222222', 'b@gmail.com', 'CHH02'),
('CH03', N'Le Van C', '0903333333', 'c@gmail.com', 'CHH03'),
('CH04', N'Pham Van D', '0904444444', 'd@gmail.com', 'CHH04');

INSERT INTO CuDan (MaCuDan, HoTen, CCCD, NgaySinh, GioiTinh, SDT, Email, MaCanHo, QuanHeVoiChuHo) VALUES
('CD01', N'Nguyen Van A', '123456789', '1980-01-01', N'Nam', '0901111111', 'a@gmail.com', 'CHH01', N'Chủ hộ'),
('CD02', N'Nguyen Thi X', '123456780', '1982-02-02', N'Nữ', '0901111112', 'x@gmail.com', 'CHH01', N'Vợ'),
('CD03', N'Nguyen Van B', '123456781', '2010-03-03', N'Nam', NULL, NULL, 'CHH01', N'Con'),
('CD04', N'Nguyen Van C', '123456782', '2012-04-04', N'Nữ', NULL, NULL, 'CHH01', N'Con'),

('CD05', N'Tran Thi B', '987654321', '1990-05-05', N'Nữ', '0902222222', 'b@gmail.com', 'CHH02', N'Chủ hộ'),

('CD06', N'Le Van C', '111222333', '1985-06-06', N'Nam', '0903333333', 'c@gmail.com', 'CHH03', N'Chủ hộ'),
('CD07', N'Le Thi Y', '111222334', '1986-07-07', N'Nữ', '0903333334', 'y@gmail.com', 'CHH03', N'Vợ'),

('CD08', N'Pham Van D', '444555664', '1950-08-08', N'Nam', NULL, NULL, 'CHH04', N'Bố'),
('CD09', N'Pham Thi Z', '444555665', '1952-09-09', N'Nữ', NULL, NULL, 'CHH04', N'Mẹ'),
('CD10', N'Pham Van E', '444555666', '1980-10-10', N'Nam', '0904444445', 'e@gmail.com', 'CHH04', N'Chủ hộ'),
('CD11', N'Pham Thi F', '444555667', '1982-11-11', N'Nữ', '0904444446', 'f@gmail.com', 'CHH04', N'Vợ'),
('CD12', N'Pham Van G', '444555668', '2010-12-12', N'Nam', NULL, NULL, 'CHH04', N'Con'),
('CD13', N'Pham Van H', '444555669', '2012-01-01', N'Nữ', NULL, NULL, 'CHH04', N'Con');

INSERT INTO TaiKhoan (TenDangNhap, MatKhau, LoaiTaiKhoan, MaChu) VALUES
('a', '123', N'Chủ hộ', 'CH01'),
('b', '123', N'Chủ hộ', 'CH02'),
('c', '123', N'Chủ hộ', 'CH03'),
('d', '123', N'Chủ hộ', 'CH04'),
('admin', 'admin123', N'Admin', NULL);

INSERT INTO DichVu (MaDichVu, TenDichVu, DonGia, DonViTinh) VALUES
('DV01', N'Điện', 3500, N'kWh'),
('DV02', N'Nước', 20000, N'm3'),
('DV03', N'Internet', 300000, N'tháng'),
('DV04', N'Rác', 15000, N'tháng'),
('DV05', N'Vệ sinh chung', 50000, N'tháng'),
('DV06', N'Gửi xe máy', 50000, N'xe/tháng'),
('DV07', N'Gửi ô tô', 500000, N'xe/tháng');

INSERT INTO SuDungDichVu (MaSuDung, MaCanHo, MaDichVu, SoLuong) VALUES
('SD01', 'CHH01', 'DV01', 100),
('SD02', 'CHH01', 'DV02', 10),
('SD03', 'CHH01', 'DV03', 1),
('SD04', 'CHH01', 'DV04', 1),
('SD05', 'CHH01', 'DV05', 1),
('SD06', 'CHH01', 'DV06', 1),

('SD07', 'CHH02', 'DV01', 80),
('SD08', 'CHH02', 'DV02', 8),
('SD09', 'CHH02', 'DV03', 1),
('SD10', 'CHH02', 'DV04', 1),
('SD11', 'CHH02', 'DV05', 1),

('SD12', 'CHH03', 'DV01', 90),
('SD13', 'CHH03', 'DV02', 9),
('SD14', 'CHH03', 'DV03', 1),
('SD15', 'CHH03', 'DV04', 1),
('SD16', 'CHH03', 'DV05', 1),
('SD17', 'CHH03', 'DV06', 1),

('SD18', 'CHH04', 'DV01', 150),
('SD19', 'CHH04', 'DV02', 15),
('SD20', 'CHH04', 'DV03', 1),
('SD21', 'CHH04', 'DV04', 1),
('SD22', 'CHH04', 'DV05', 1),
('SD23', 'CHH04', 'DV06', 2),
('SD24', 'CHH04', 'DV07', 1);

INSERT INTO HoaDon (MaHoaDon, MaChu, NgayLap, TongTien, TrangThai) VALUES
('HD01', 'CH01', '2025-11-01', 965000, N'Chưa thanh toán'),
('HD02', 'CH02', '2025-11-01', 805000, N'Chưa thanh toán'),
('HD03', 'CH03', '2025-11-01', 910000, N'Chưa thanh toán'),
('HD04', 'CH04', '2025-11-01', 1790000, N'Chưa thanh toán');

INSERT INTO ThongBaoChung (MaThongBao, TieuDe, NoiDung, NgayGui) VALUES
('TBC01', N'Bảo trì thang máy', N'Khu A và Khu B sẽ bảo trì thang máy từ 9h đến 12h', '2025-11-10'),
('TBC02', N'Thông báo đóng phí dịch vụ', N'Các chủ hộ vui lòng đóng phí dịch vụ tháng 11 trước ngày 15/11', '2025-11-01');

INSERT INTO ThongBaoRieng (MaThongBao, MaChu, TieuDe, NoiDung, NgayDang) VALUES
('TBR01', 'CH02', N'Thông báo riêng chủ hộ B', N'Xin nhắc chủ hộ B kiểm tra nước sinh hoạt', '2025-11-07'),
('TBR02', 'CH04', N'Thông báo riêng chủ hộ D', N'Xin nhắc chủ hộ D dọn vệ sinh khu vực chung', '2025-11-08'),
('TBR03', 'CH01', N'Thông báo riêng chủ hộ A', N'Xin nhắc chủ hộ A đóng tiền điện', '2025-11-05');

INSERT INTO KhieuNai (MaKhieuNai, MaCuDan, TieuDe, NoiDung, NgayGui, TrangThai) VALUES
('KN01', 'CD02', N'Điện quá cao', N'Hoá đơn điện tháng 11 cao bất thường', '2025-11-05', N'Đang xử lý'),
('KN02', 'CD07', N'Nước bị rò rỉ', N'Có hiện tượng rò rỉ nước trong căn hộ', '2025-11-06', N'Đang xử lý'),
('KN03', 'CD12', N'Vệ sinh chưa tốt', N'Khu vực chung chưa được vệ sinh đúng lịch', '2025-11-07', N'Đang xử lý');