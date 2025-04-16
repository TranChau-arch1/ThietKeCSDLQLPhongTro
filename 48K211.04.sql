create database PTRO 
use PTRO

create table Quan_Tri(
QT_TenDN char(10) not null primary key,
QT_MK varchar(10) not null)

create table Chu_Tro(
CT_CCCD char(12) not null primary key,
CT_Ten nvarchar(50) not null,
CT_SDT char(10) not null unique,
CT_GioiTinh bit not null,
CT_HoKhau nvarchar(100))

create table Khach_Thue(
KT_CCCD char(12) not null primary key,
KT_Ten nvarchar(50) not null,
KT_SDT char(10) not null unique,
KT_GioiTinh bit not null,
KT_HoKhau nvarchar(100))

create table Bien_So_Xe(
BSX_ID char(11) not null primary key,
kt_cccd char(12) not null,
foreign key (kt_cccd) references Khach_Thue(kt_cccd))

create table TK_Khach_Thue(
TKKT_TenDN char(10) not null primary key,
TKKT_MK varchar(10) not null,
kt_cccd char(12) not null,
foreign key (kt_cccd) references Khach_Thue(kt_cccd))

create table Phong_Tro(
P_ID char(7) not null primary key,
P_SoLuong int,
P_GiaPhong float not null,
P_TinhTrang bit not null) --1. đang cho thuê/ 0. đang trống

create table Hop_Dong(
HDong_ID char(7) not null primary key,
HDong_TinhTrang char(1) not null, --1. Còn hạn/ 0. Kết thúc hợp đồng/ 2. Gia hạn hợp đồng/ 3. Huỷ hợp đồng
ct_cccd char(12) not null,
kt_cccd char(12) not null,
p_id char(7) not null,
HDong_NgayBatDau date not null,
HDong_NgayKetThuc date not null ,
HDong_TienDatCoc float not null,
foreign key (ct_cccd) references Chu_Tro(ct_cccd),
foreign key (kt_cccd) references Khach_Thue(kt_cccd),
foreign key (p_id) references Phong_Tro(p_id)) 

create table Dich_Vu(
DV_ID char(7) not null primary key,
DV_Ten nvarchar(50) not null,
DV_DonGia float not null)

create table Hoa_Don(
HDon_ID char(10) not null primary key,
HDon_NgayThangNam date not null,
HDon_TinhTrang bit not null, --0. Chưa thanh toán/ 1. Đã thanh toán
p_id char(7) not null,
foreign key (p_id) references Phong_Tro(p_id))

create table HDon_Chi_Tiet(
hdon_id char(10) not null,
dv_id char(7) not null,
HdonCT_SoCu int,
HdonCT_SoMoi int,
primary key (hdon_id, dv_id),
foreign key (hdon_id) references Hoa_Don (hdon_id),
foreign key (dv_id) references Dich_Vu (dv_id)) 

--1.Module tạo dữ liệu dump cho bảng Quan_Tri:

CREATE OR ALTER PROCEDURE InsertQuantri
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @QT_TenDN CHAR(10);
    DECLARE @QT_MK VARCHAR(10);
    DECLARE @Chars NVARCHAR(36) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    
    WHILE @Counter <= 1000
    BEGIN

        SET @QT_TenDN = 'Mgmt_' + 
                        RIGHT('0000' + CAST(@Counter AS VARCHAR(4)), 4); 

        SET @QT_MK = (
            SELECT TOP 1 
                SUBSTRING(@Chars, ABS(CHECKSUM(NEWID())) % LEN(@Chars) + 1, 10)
        );

        INSERT INTO Quan_Tri (QT_TenDN, QT_MK)
        VALUES (@QT_TenDN, @QT_MK);

        SET @Counter = @Counter + 1;
    END
END;
GO

EXEC InsertQuantri;
GO

select * from Quan_Tri

--2. Module tạo dữ liệu dump cho bảng Chu_Tro:


CREATE OR ALTER PROCEDURE InsertChuTro
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @CT_CCCD CHAR(12);
    DECLARE @CT_Ten NVARCHAR(100); 
    DECLARE @CT_SDT CHAR(10);
    DECLARE @CT_GioiTinh BIT;
    DECLARE @CT_HoKhau NVARCHAR(100);

    DECLARE @FirstNames TABLE (ID INT, Name NVARCHAR(50));
    DECLARE @LastNames TABLE (ID INT, Name NVARCHAR(50));
    DECLARE @MiddleNames TABLE (ID INT, Name NVARCHAR(50));
    DECLARE @DiaChi TABLE (DiaChi NVARCHAR(100));
    DECLARE @TinhThanh TABLE (TinhThanh NVARCHAR(50));

    INSERT INTO @FirstNames (ID, Name) VALUES
    (1, N'Nguyễn'),
    (2, N'Trần'),
    (3, N'Lê'),
    (4, N'Phạm'),
    (5, N'Ngô'),
    (6, N'Đinh'),
    (7, N'Hồ'),
    (8, N'Tô'),
    (9, N'Bùi'),
    (10, N'Vũ');

    INSERT INTO @MiddleNames (ID, Name) VALUES
    (1, N'Văn'),
    (2, N'Thi'),
    (3, N'Minh'),
    (4, N'Nhật'),
    (5, N'Quốc'),
    (6, N'Phúc'),
    (7, N'Tuấn'),
    (8, N'Tuệ'),
    (9, N'Hùng'),
    (10, N'Hoài');

    INSERT INTO @LastNames (ID, Name) VALUES
    (1, N'An'),
    (2, N'Bình'),
    (3, N'Chi'),
    (4, N'Duy'),
    (5, N'Hoàng'),
    (6, N'Hương'),
    (7, N'Khánh'),
    (8, N'Linh'),
    (9, N'Mai'),
    (10, N'Nam');

    INSERT INTO @DiaChi (DiaChi) VALUES 
        (N'Nguyễn Thị Minh Khai'), 
        (N'Đường Lê Lợi'), 
        (N'Đường Trần Hưng Đạo'), 
        (N'Đường Phạm Văn Đồng'), 
        (N'Đường Hoàng Văn Thụ');

    INSERT INTO @TinhThanh (TinhThanh) VALUES 
        (N'Hà Nội'), (N'Hồ Chí Minh'), (N'Hải Phòng'), (N'Đà Nẵng'), 
        (N'Cần Thơ'), (N'Khánh Hòa'), (N'Bình Dương'), (N'Thừa Thiên Huế'),
        (N'An Giang'), (N'Bà Rịa - Vũng Tàu'), (N'Bắc Ninh'), (N'Bạc Liêu'),
        (N'Bắc Giang'), (N'Bến Tre'), (N'Bình Định'), (N'Bình Thuận'), 
        (N'Cà Mau'), (N'Cao Bằng'), (N'Dak Lak'), (N'Dak Nông'),
        (N'Diễn Châu'), (N'Đắk Nông'), (N'Hà Giang'), (N'Hà Nam'),
        (N'Hà Tĩnh'), (N'Hưng Yên'), (N'Khánh Hòa'), (N'Lai Châu'),
        (N'Lạng Sơn'), (N'Lào Cai'), (N'Nghệ An'), (N'Ninh Bình'),
        (N'Ninh Thuận'), (N'Phú Thọ'), (N'Phú Yên'), (N'Quảng Bình'),
        (N'Quảng Nam'), (N'Quảng Ngãi'), (N'Quảng Ninh'), (N'Sóc Trăng'),
        (N'Tây Ninh'), (N'Thái Bình'), (N'Thái Nguyên'), (N'Thừa Thiên Huế'),
        (N'Tiền Giang'), (N'Tuyên Quang'), (N'Vĩnh Long'), (N'Vĩnh Phúc'),
        (N'Yên Bái');

    WHILE @Counter <= 1000
    BEGIN

        SET @CT_CCCD = RIGHT('000000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(12)), 12);

        SET @CT_Ten = (SELECT TOP 1 Name FROM @FirstNames ORDER BY NEWID()) + ' ' +
                       (SELECT TOP 1 Name FROM @MiddleNames ORDER BY NEWID()) + ' ' + 
                       (SELECT TOP 1 Name FROM @LastNames ORDER BY NEWID());

        SET @CT_SDT = '0' + RIGHT('0000000000' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(10)), 9);

        SET @CT_GioiTinh = CAST(ABS(CHECKSUM(NEWID())) % 2 AS BIT);

        DECLARE @DiaChiTemp NVARCHAR(100);
        SET @DiaChiTemp = (SELECT TOP 1 DiaChi FROM @DiaChi ORDER BY NEWID());
        
        DECLARE @TinhThanhTemp NVARCHAR(50);
        SET @TinhThanhTemp = (SELECT TOP 1 TinhThanh FROM @TinhThanh ORDER BY NEWID());

        SET @CT_HoKhau = @DiaChiTemp + ', ' + @TinhThanhTemp;

        INSERT INTO Chu_Tro (CT_CCCD, CT_Ten, CT_SDT, CT_GioiTinh, CT_HoKhau)
        VALUES (@CT_CCCD, @CT_Ten, @CT_SDT, @CT_GioiTinh, @CT_HoKhau);

        SET @Counter = @Counter + 1;
    END
END;
GO

EXEC InsertChuTro;
GO

select * from Chu_Tro

-- 3.Module tạo dữ liệu dump cho bảng Khach_Thue:

CREATE OR ALTER PROCEDURE InsertKhachThue
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @CCCD CHAR(12);
    DECLARE @HoTen NVARCHAR(50); 
    DECLARE @SDT CHAR(10);
    DECLARE @GioiTinh BIT;
    DECLARE @HoKhau NVARCHAR(100);

    DECLARE @Ho TABLE (Ho NVARCHAR(50));
    DECLARE @TenDem TABLE (TenDem NVARCHAR(50));
    DECLARE @Ten TABLE (Ten NVARCHAR(50));
    DECLARE @DiaChi TABLE (DiaChi NVARCHAR(100));
    DECLARE @TinhThanh TABLE (TinhThanh NVARCHAR(50));

    INSERT INTO @Ho (Ho) VALUES (N'Nguyễn'), (N'Trần'), (N'Lê'), (N'Phạm'), (N'Hoàng'), (N'Phan'), (N'Vũ'), (N'Đặng'), (N'Bùi'), (N'Đỗ');

    INSERT INTO @TenDem (TenDem) VALUES (N'Văn'), (N'Thị'), (N'Quang'), (N'Thúy'), (N'Minh'), (N'Thanh'), (N'Ngọc'), (N'Hữu');

    INSERT INTO @Ten (Ten) VALUES (N'An'), (N'Bình'), (N'Chi'), (N'Dương'), (N'Hà'), (N'Hùng'), (N'Khánh'), (N'Lan'), (N'Linh'), (N'Nam');

    -- Sample street names (you can expand this list)
    INSERT INTO @DiaChi (DiaChi) VALUES 
        (N'Nguyễn Thị Minh Khai'), (N'Đường Lê Lợi'), (N'Đường Trần Hưng Đạo'), 
        (N'Đường Phạm Văn Đồng'), (N'Đường Hoàng Văn Thụ');

    -- List of all 63 provinces and cities in Vietnam
    INSERT INTO @TinhThanh (TinhThanh) VALUES 
        (N'Hà Nội'), (N'Hồ Chí Minh'), (N'Hải Phòng'), (N'Đà Nẵng'), 
        (N'Cần Thơ'), (N'Khánh Hòa'), (N'Bình Dương'), (N'Thừa Thiên Huế'),
        (N'An Giang'), (N'Bà Rịa - Vũng Tàu'), (N'Bắc Ninh'), (N'Bạc Liêu'),
        (N'Bắc Giang'), (N'Bến Tre'), (N'Bình Định'), (N'Bình Thuận'), 
        (N'Cà Mau'), (N'Cao Bằng'), (N'Dak Lak'), (N'Dak Nông'),
        (N'Diễn Châu'), (N'Đắk Nông'), (N'Hà Giang'), (N'Hà Nam'),
        (N'Hà Tĩnh'), (N'Hưng Yên'), (N'Khánh Hòa'), (N'Lai Châu'),
        (N'Lạng Sơn'), (N'Lào Cai'), (N'Nghệ An'), (N'Ninh Bình'),
        (N'Ninh Thuận'), (N'Phú Thọ'), (N'Phú Yên'), (N'Quảng Bình'),
        (N'Quảng Nam'), (N'Quảng Ngãi'), (N'Quảng Ninh'), (N'Sóc Trăng'),
        (N'Tây Ninh'), (N'Thái Bình'), (N'Thái Nguyên'), (N'Thừa Thiên Huế'),
        (N'Tiền Giang'), (N'Tuyên Quang'), (N'Vĩnh Long'), (N'Vĩnh Phúc'),
        (N'Yên Bái');

    WHILE @Counter <= 1000
    BEGIN
        SET @CCCD = RIGHT('000000000000' + CAST(ABS(CHECKSUM(NEWID())) % 1000000000000 AS VARCHAR(12)), 12);

        DECLARE @HoTemp NVARCHAR(50);
        DECLARE @TenDemTemp NVARCHAR(50);
        DECLARE @TenTemp NVARCHAR(50);

        SELECT TOP 1 @HoTemp = Ho FROM @Ho ORDER BY NEWID();
        SELECT TOP 1 @TenDemTemp = TenDem FROM @TenDem ORDER BY NEWID();
        SELECT TOP 1 @TenTemp = Ten FROM @Ten ORDER BY NEWID();

        SET @HoTen = @HoTemp + ' ' + @TenDemTemp + ' ' + @TenTemp;

        SET @SDT = '09' + RIGHT('000000000' + CAST(ABS(CHECKSUM(NEWID())) % 1000000000 AS VARCHAR(9)), 8);

        SET @GioiTinh = ABS(CHECKSUM(NEWID()) % 2);

        DECLARE @DiaChiTemp NVARCHAR(100);
        SELECT TOP 1 @DiaChiTemp = DiaChi FROM @DiaChi ORDER BY NEWID();

        DECLARE @TinhThanhTemp NVARCHAR(50);
        SELECT TOP 1 @TinhThanhTemp = TinhThanh FROM @TinhThanh ORDER BY NEWID();

        SET @HoKhau = @DiaChiTemp + ', ' + @TinhThanhTemp;

        INSERT INTO Khach_Thue (KT_CCCD, KT_Ten, KT_SDT, KT_GioiTinh, KT_HoKhau)
        VALUES (@CCCD, @HoTen, @SDT, @GioiTinh, @HoKhau);

        SET @Counter = @Counter + 1;
    END
END;
GO

exec InsertKhachThue
go

select * from Khach_Thue

--4. Module tạo dữ liệu dump cho bảng Bien_So_Xe

CREATE OR ALTER PROCEDURE InsertBienSoXe
AS
BEGIN
    DECLARE @Counter INT = 0; 
    DECLARE @BSX_ID CHAR(11);
    DECLARE @KT_CCCD CHAR(12);

    WHILE @Counter < 1000
    BEGIN
        SET @BSX_ID = RIGHT('00000000000' + CAST(@Counter + 1 AS VARCHAR(11)), 11);

        SELECT TOP 1 @KT_CCCD = KT_CCCD FROM Khach_Thue ORDER BY NEWID();

        INSERT INTO Bien_So_Xe (BSX_ID, KT_CCCD)
        VALUES (@BSX_ID, @KT_CCCD);

        SET @Counter = @Counter + 1;
    END
END;
GO

EXEC InsertBienSoXe;
GO

select * from Bien_So_xe

--5. Module tạo dữ liệu dump cho bảng TK_Khach_Thue:

CREATE OR ALTER PROCEDURE InsertTKKhachThue
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @TKKT_TenDN CHAR(10);
    DECLARE @TKKT_MK VARCHAR(10);
    DECLARE @KT_CCCD CHAR(12);

    WHILE @Counter <= 1000
    BEGIN

        SET @TKKT_TenDN = 'User_' + RIGHT('00000' + CAST(@Counter AS VARCHAR(5)), 5);

        SET @TKKT_MK = LEFT(CAST(NEWID() AS VARCHAR(36)), 10);

        SELECT TOP 1 @KT_CCCD = KT_CCCD
        FROM Khach_Thue
        WHERE NOT EXISTS (
            SELECT 1 FROM TK_Khach_Thue WHERE KT_CCCD = Khach_Thue.KT_CCCD
        )
        ORDER BY NEWID();

        IF @KT_CCCD IS NOT NULL
        BEGIN
            INSERT INTO TK_Khach_Thue (TKKT_TenDN, TKKT_MK, KT_CCCD)
            VALUES (@TKKT_TenDN, @TKKT_MK, @KT_CCCD);

            SET @Counter = @Counter + 1;
        END
    END
END;
GO

EXEC InsertTKKhachThue;
GO

select * from TK_Khach_Thue

--6. Module tạo dữ liệu dump cho bảng Phong_Tro:

CREATE OR ALTER PROCEDURE InsertPhongTro
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @P_ID CHAR(7); 
    DECLARE @P_SoLuong INT;
    DECLARE @P_GiaPhong FLOAT;
    DECLARE @P_TinhTrang BIT;

    DECLARE @UsedIDs TABLE (P_ID CHAR(7)); 

    BEGIN TRANSACTION;

    WHILE @Counter <= 1000
    BEGIN
        SET @P_ID = 'P' + RIGHT('000000' + CAST(@Counter AS VARCHAR(6)), 6); 

        -- Kiểm tra P_ID không trùng lặp trong bảng Phong_Tro và trong bảng tạm @UsedIDs
        IF NOT EXISTS (SELECT 1 FROM Phong_Tro WHERE P_ID = @P_ID)
           AND NOT EXISTS (SELECT 1 FROM @UsedIDs WHERE P_ID = @P_ID)  
        BEGIN
            SET @P_SoLuong = ABS(CHECKSUM(NEWID()) % 3) + 1;  -- Số lượng phòng từ 1 đến 3
            SET @P_GiaPhong = 500000 + (CAST(ABS(CHECKSUM(NEWID())) % 9500000 AS FLOAT));  -- Giá phòng từ 500k đến 10 triệu
            SET @P_TinhTrang = CAST(ABS(CHECKSUM(NEWID())) % 2 AS BIT);  -- 1 hoặc 0 (Đang cho thuê hoặc trống)

            -- Chèn dữ liệu vào bảng Phong_Tro
            INSERT INTO Phong_Tro (P_ID, P_SoLuong, P_GiaPhong, P_TinhTrang)
            VALUES (@P_ID, @P_SoLuong, @P_GiaPhong, @P_TinhTrang);

            -- Ghi nhận ID đã sử dụng
            INSERT INTO @UsedIDs (P_ID) VALUES (@P_ID);
        END

        SET @Counter = @Counter + 1;  -- Tăng @Counter sau mỗi lần lặp
    END

    COMMIT TRANSACTION;
END;
GO

EXEC InsertPhongTro;
GO

select * from Phong_Tro

--7. Module tạo dữ liệu dump cho bảng Hop_Dong:

CREATE OR ALTER PROCEDURE InsertHopDong
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @HDong_ID CHAR(7);
    DECLARE @HDong_TinhTrang CHAR(1);
    DECLARE @ct_cccd CHAR(12);
    DECLARE @kt_cccd CHAR(12);
    DECLARE @P_ID CHAR(7);
    DECLARE @HDong_NgayBatDau DATE;
    DECLARE @HDong_NgayKetThuc DATE;
    DECLARE @HDong_TienDatCoc FLOAT;

    WHILE @Counter <= 1000
    BEGIN
        -- Generate HDong_ID ensuring it is 7 characters long
        SET @HDong_ID = 'H' + RIGHT('00000' + CAST(@Counter AS VARCHAR(5)), 6); 

        SET @HDong_TinhTrang = CAST(ABS(CHECKSUM(NEWID())) % 2 AS CHAR(1));

        -- Randomly select a landlord and tenant
        SET @ct_cccd = (SELECT TOP 1 CT_CCCD FROM Chu_Tro ORDER BY NEWID());
        SET @kt_cccd = (SELECT TOP 1 KT_CCCD FROM Khach_Thue ORDER BY NEWID());
        SET @P_ID = (SELECT TOP 1 P_ID FROM Phong_Tro ORDER BY NEWID());

        -- Generate random contract start date within the past 365 days
        SET @HDong_NgayBatDau = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365) * -1, GETDATE());

        -- Generate contract end date 30 days after start date
        SET @HDong_NgayKetThuc = DATEADD(DAY, 180, @HDong_NgayBatDau); 

        -- Ensure the contract end date does not exceed the current date
        IF @HDong_NgayKetThuc > GETDATE()
        BEGIN
            SET @HDong_NgayKetThuc = GETDATE(); -- Set end date to current date if it exceeds
        END

        -- Generate random deposit amount
        SET @HDong_TienDatCoc = CAST(ABS(CHECKSUM(NEWID())) % 1000 AS FLOAT);

        -- Insert contract into Hop_Dong table
        INSERT INTO Hop_Dong (HDong_ID, HDong_TinhTrang, ct_cccd, kt_cccd, p_id, HDong_NgayBatDau, HDong_NgayKetThuc, HDong_TienDatCoc)
        VALUES (@HDong_ID, @HDong_TinhTrang, @ct_cccd, @kt_cccd, @P_ID, @HDong_NgayBatDau, @HDong_NgayKetThuc, @HDong_TienDatCoc);

        -- Increment counter for the next contract
        SET @Counter = @Counter + 1;
    END
END;
GO

EXEC InsertHopDong;
GO

select * from Hop_Dong

--8. Module tạo dữ liệu dump cho bảng Dich_Vu:

CREATE OR ALTER PROCEDURE InsertDichVu
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @serviceName NVARCHAR(50);
    DECLARE @price FLOAT;
    DECLARE @DV_ID CHAR(7);

    WHILE @i <= 1000
    BEGIN
        SET @serviceName = N'Dịch vụ ' + CAST(@i AS NVARCHAR(5));

        SET @price = ROUND((RAND() * (1000 - 100) + 100), 2);

        SET @DV_ID = 'DV' + RIGHT('00000' + CAST(@i AS NVARCHAR(5)), 5); 

        IF NOT EXISTS (SELECT 1 FROM Dich_Vu WHERE DV_ID = @DV_ID)
        BEGIN
            INSERT INTO Dich_Vu (DV_ID, DV_Ten, DV_DonGia)
            VALUES (@DV_ID, @serviceName, @price);
        END

        SET @i = @i + 1;
    END
END;
GO

EXEC InsertDichVu;
GO

select * from Dich_Vu

--9. Module tạo dữ liệu dump cho bảng Hoa_Don:

CREATE OR ALTER PROCEDURE InsertHoaDon
AS
BEGIN
    DECLARE @Counter INT = 1;  
    DECLARE @HDon_ID CHAR(7);  -- Ensure this is 7 characters long
    DECLARE @HDon_NgayThangNam DATE;
    DECLARE @HDon_TinhTrang BIT; 
    DECLARE @P_ID CHAR(7);

    WHILE @Counter <= 1000
    BEGIN

        SET @HDon_ID = 'HD' + RIGHT('0000' + CAST(@Counter AS VARCHAR(4)), 4); 

        SET @HDon_NgayThangNam = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), '2023-01-01');

        SET @HDon_TinhTrang = ABS(CHECKSUM(NEWID()) % 2);

        SET @P_ID = (SELECT TOP 1 P_ID FROM Phong_Tro ORDER BY NEWID());

        INSERT INTO Hoa_Don (HDon_ID, HDon_NgayThangNam, HDon_TinhTrang, P_ID)
        VALUES (@HDon_ID, @HDon_NgayThangNam, @HDon_TinhTrang, @P_ID);

        SET @Counter = @Counter + 1;
    END
END;
GO

EXEC InsertHoaDon;
GO

select * from Hoa_Don

--10. Module tạo dữ liệu dump cho bảng HDon_Chi_Tiet:

CREATE OR ALTER PROCEDURE InsertHDonChiTiet
AS
BEGIN
    DECLARE @Counter INT = 1;
    DECLARE @hdon_id CHAR(10);
    DECLARE @dv_id CHAR(7);
    DECLARE @HdonCT_SoCu INT;
    DECLARE @HdonCT_SoMoi INT;

    WHILE @Counter <= 1000
    BEGIN
        -- Lấy ngẫu nhiên một HDon_ID và NgayThangNam từ bảng Hoa_Don
        SELECT TOP 1 @hdon_id = HDon_ID
        FROM Hoa_Don
        ORDER BY NEWID();

        -- Lấy ngẫu nhiên một dv_id từ bảng Dich_Vu
        SELECT TOP 1 @dv_id = DV_ID
        FROM Dich_Vu
        ORDER BY NEWID();

        -- Tạo chỉ số cũ và mới (giả định) cho dịch vụ
        SET @HdonCT_SoCu = ABS(CHECKSUM(NEWID())) % 100;
        SET @HdonCT_SoMoi = @HdonCT_SoCu + (ABS(CHECKSUM(NEWID())) % 10);

        -- Chèn vào bảng HDon_Chi_Tiet, ngày sẽ giống với ngày từ bảng Hoa_Don
        INSERT INTO HDon_Chi_Tiet (hdon_id, dv_id, HdonCT_SoCu, HdonCT_SoMoi)
        VALUES (@hdon_id, @dv_id, @HdonCT_SoCu, @HdonCT_SoMoi);

        SET @Counter = @Counter + 1;
    END
END;
GO
EXEC InsertHDonChiTiet;
GO

select * from HDon_Chi_Tiet

-- Các module xử lý
-- Module 1: Cập nhật tình trạng phòng trọ khi hợp đồng kết thúc/ huỷ và khi hợp đồng gia hạn/ thêm mới
--Loại: after
--Sự kiện: insert, update
--Bảng: hop_dong
--Process: 
--1. Kiểm tra tình trạng hợp đồng (HDong_TinhTrang) ở bảng inserted:
--2. Nếu tình trạng là '0' (kết thúc hợp đồng) hoặc '3' (huỷ hợp đồng): Cập nhật bảng Phong_Tro: Tình trạng phòng trọ (P_TinhTrang) trở về 0 (phòng trống).
--3. Nếu tình trạng là '1' (đang cho thuê) hoặc '2' (gia hạn hợp đồng): Cập nhật bảng Phong_Tro: Tình trạng phòng trọ (P_TinhTrang) trở về 1 (đang cho thuê).

CREATE OR ALTER TRIGGER CapNhatTinhTrangPhong
ON Hop_Dong
AFTER INSERT, UPDATE
AS
BEGIN

    IF EXISTS (SELECT 1 
               FROM inserted i
               WHERE i.HDong_TinhTrang IN ('0', '3')) 
    BEGIN
        UPDATE Phong_Tro
        SET P_TinhTrang = 0 -- 0: Phòng trống
        FROM Phong_Tro PT
        INNER JOIN inserted i ON PT.P_ID = i.P_ID
        WHERE i.HDong_TinhTrang IN ('0', '3');
    END

    IF EXISTS (SELECT 1 
               FROM inserted i
               WHERE i.HDong_TinhTrang IN ('1', '2'))
    BEGIN
        UPDATE Phong_Tro
        SET P_TinhTrang = 1 -- 1: Đang thuê
        FROM Phong_Tro PT
        INNER JOIN inserted i ON PT.P_ID = i.P_ID
        WHERE i.HDong_TinhTrang IN ('1', '2');
    END
END
GO

-- Khi thêm mới hợp đồng
INSERT INTO Hop_Dong (HDong_ID, HDong_TinhTrang, ct_cccd, kt_cccd, p_id, HDong_NgayBatDau, HDong_NgayKetThuc, HDong_TienDatCoc)
VALUES ('H001001', '1', '000004310315','000019983549', 'P000034', '2024-01-01', '2024-12-31', 500000);

-- Kiểm tra lại trạng thái của phòng trọ tương ứng
SELECT P_TinhTrang
FROM Phong_Tro
WHERE P_ID = 'P000034'

-- Cập nhật hợp đồng để hủy hợp đồng
UPDATE Hop_Dong
SET HDong_TinhTrang = '3' -- Hủy hợp đồng
WHERE HDong_ID = 'H000002';

-- Kiểm tra lại trạng thái của phòng trọ tương ứng
SELECT P_TinhTrang
FROM Phong_Tro
WHERE P_ID = 'P000966'

--Module 2: Thay đổi mật khẩu cho tài khoản khách thuê
--Phân tích:
--Input: @TKKT_tendn, @matkhaucu, @matkhaumoi
--Output: thongbao
--Process: 
--1. Kiểm tra tên đăng nhập và mật khẩu cũ có tồn tại trong bảng Tk_khach_thue không
--2. Nếu có thì thực hiện update tk_khach_thue
--					set tkkt_mk=@matkhaumoi
--					where tkkt_tendn=@tkkt_tendn
--		và hiển thị thông báo 'Mật khẩu đã được thay đổi thành công'
--3. Ngược lại hiển thị thông báo 'Tên đăng nhập hoặc mật khẩu cũ không đúng'


CREATE OR ALTER PROCEDURE ThayDoiMatKhau (@TKKT_TenDN CHAR(10), @MatKhauCu VARCHAR(10),  @MatKhauMoi VARCHAR(10), @thongbao nvarchar(50) out)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM TK_Khach_Thue WHERE TKKT_TenDN = @TKKT_TenDN AND TKKT_MK = @MatKhauCu)
	begin
        UPDATE TK_Khach_Thue
        SET TKKT_MK = @MatKhauMoi
        WHERE TKKT_TenDN = @TKKT_TenDN;
        set @thongbao= N'Mật khẩu đã được thay đổi thành công';
    END
    ELSE
    BEGIN
       set @thongbao=  N'Tên đăng nhập hoặc mật khẩu cũ không đúng';
    END
END
GO

declare @thongbao1 nvarchar(50)
exec ThayDoiMatKhau 'User_00001', '4840A487-4', 'memoe', @thongbao1 out
print @thongbao1

select * from TK_Khach_Thue
--Module 3: Chỉnh sửa thông tin khách thuê với các thông tin SĐT, Họ tên, Giới tính, Hộ khẩu.
--Phân tích: 
--Loại: after
--Sự kiện: update
--Bảng: Khách thuê
--Process: 
--1. Lấy CCCD khách thuê từ bảng inserted --> @KH_CCCD
--2. Nếu @KH_CCCD không tồn tại trong bảng Khach_thue thì thông báo N'Thông báo: Mã khách thuê' +@KH_CCCD+ N'không tồn tại'
--3. Ngược lại print N'Thông báo: Thông tin khách thuê ' + @KT_CCCD + N' đã được cập nhật.'

create or alter trigger Chinh_sua_thong_tin_Khach_Thue
on Khach_Thue
after update
as
begin

    declare @KT_CCCD char(12)
    select 
        @KT_CCCD = KT_CCCD
    from inserted;

    if not exists ( select 1 
					from Khach_Thue 
					where KT_CCCD = @KT_CCCD)
    begin
        print N'Mã khách thuê ' + @KT_CCCD + N' không tồn tại.'
        rollback
    end
    print N'Thông báo: Thông tin khách thuê ' + @KT_CCCD + N' đã được cập nhật.'
end


update Khach_Thue
set KT_SDT='0855052520'
where KT_CCCD='000002332194'

select * from Khach_Thue
where KT_CCCD='000002481674'

--Module 4: Thông báo Hợp đồng hết hạn
--Phân tích: 
--Input: N/A
--Output: Thông báo: Hợp đồng + (mã hợp đồng) + sẽ hết hạn vào ngày + (ngày kết thúc hợp đồng)
--Process: 
--1. Tìm các hợp đồng có ngày kết thúc trong khoảng từ 1 đến 3 ngày kể từ ngày hiện tại và có trạng thái hợp đồng là 1 hoặc 2.
--2. Sử dụng con trỏ (Hopdong_Cursor) để duyệt qua các kết quả tìm được.
--3. Với mỗi hợp đồng tìm thấy, in thông báo có định dạng:
	--N'Thông báo: Hợp đồng ' + @HDong_ID + N' sẽ hết hạn vào ngày ' + CONVERT(varchar, @HDong_ngayKetthuc)

create or 
alter proc Thongbao_hethanHD
as
begin
    declare @HDong_ngayKetthuc date, @HDong_ID char(7)

    declare HopDong_Cursor cursor for
    select HDong_NgayKetThuc, HDong_ID
    from Hop_Dong
    where DATEDIFF(DAY, GETDATE(), HDong_NgayKetThuc) <= 3 and DATEDIFF(DAY, GETDATE(), HDong_NgayKetThuc) >= 0
														   and HDong_TinhTrang in (1, 2)

    open HopDong_Cursor

    fetch next from HopDong_Cursor into @HDong_ngayKetthuc, @HDong_ID

    while @@FETCH_STATUS = 0
	begin

        print N'Thông báo: Hợp đồng ' + @HDong_ID + N' sẽ hết hạn vào ngày ' + CONVERT(varchar, @HDong_ngayKetthuc)

        fetch next from HopDong_Cursor into @HDong_ngayKetthuc, @HDong_ID
    end

    close HopDong_Cursor
    deallocate HopDong_Cursor
end

exec Thongbao_hethanHD

select * from Hop_Dong

--Module 5: Kiểm tra xem khách thuê đã thanh toán tiền trọ và các khoản phí khác chưa.
--Phân tích:
--Input: P_id, Hdon_id
--Output: Thông báo
--Process: 
--1. Kiểm tra P_id và Hdon_id có tồn tại trong bảng hoá đơn không
--2. Nếu không hiển thị thông báo 'Không tồn tại' và kết thúc
--3. Ngược lại thì trả về tình trạng hoá đơn trong bảng hoá đơn

create or alter proc KiemtrathanhtoanHD (@P_ID char(7), @Hdon_id char(10), @thongbao nvarchar(50) out)
as
begin
	if (select count(*)
		from Hoa_Don
		where p_id=@P_ID and HDon_ID=@Hdon_id)=0
	begin
		set @thongbao= N'Không tồn tại'
		return
	end
	else
		declare @tinhtranghd int
		select  @tinhtranghd=HDon_TinhTrang
		from Hoa_Don
		where p_id=@P_ID and HDon_ID=@Hdon_id

		if  @tinhtranghd=1
		begin
			set @thongbao=N'Đã thanh toán'
		end
		else
		begin
			set @thongbao=N'Chưa thanh toán'
		end
end

declare @thongbao nvarchar(50)
exec KiemtrathanhtoanHD 'P000747', 'HD0948', @thongbao out
print @thongbao

select * from Hoa_Don


--Module 6. Kiểm tra tên và mật khẩu của khách thuê khi đăng nhập vào hệ thống

--Phân tích: 
--Input: @tendn, @matkhau
--Output: 0:Tài khoản không hợp lệ
--		  1 :Tài khoản hợp lệ
--Process: 
--1. Kiểm tra tên và tài khoản có tồn tại trong bảng Tài khoản khách thuê không. Nếu có thì trả về 1 ngược lại thì trả về 0

create or alter proc checkTen_DNvaMat_khau (@TenDN CHAR(10), @MatKhau VARCHAR(50), @thongbao bit output)
AS
BEGIN
     IF EXISTS (SELECT 1 
               FROM TK_Khach_Thue 
               WHERE TKKT_TenDN = @TenDN 
                 AND TKKT_Mk = @MatKhau)
    BEGIN
        SET @thongbao = 1
    END
    ELSE
    BEGIN
        SET @thongbao = 0
    END
END

declare @thongbao bit
exec checkTen_DNvaMat_khau 'User_00001', '78B15F66-4', @thongbao out
print @thongbao

select * from TK_Khach_Thue

--Module 7. Tính tổng chi phí dịch vụ của một hóa đơn
--Phân tích:
--Input: @Hdon_id
--Output: result
--Process:
--1. Kiểm tra Mã hoá đơn cón tồn tại trong bảng hoá đơn không
--2. Nếu không hiển thị thông báo ‘Mã hoá đơn không tồn tại’ và kế thúc
--3. Tính tổng chi phí dịch vụ = sum((chỉ số mới - chỉ số cũ) của từng dịch vụ từ bảng HDon_Chi_Tiet * đơn giá dịch vụ tương ứng từ bảng Dich_Vu)

create or alter function Tinh_CPDV_Thang_Nam (@HDon_ID char(10))
returns nvarchar(100)
as
begin
    declare @TongChiPhi float
	DECLARE @Result nvarchar(100)
	if (select count(*) 
		from hoa_don
		where hdon_id=@HDon_ID)=0
	begin
		set @result= N'Mã hoá đơn không tồn tại'
		return @result
	end

	set @TongChiPhi=cast(@tongchiphi as float)
    select @TongChiPhi  = SUM((HdonCT_SoMoi - HdonCT_SoCu) * DV.DV_DonGia)
    from HDon_Chi_Tiet HCT join Dich_Vu DV on HCT.dv_id = DV.DV_ID
    where HCT.hdon_id = @HDon_ID 

	set @Result = CAST(@TongChiPhi as nvarchar(100))

    return @Result
end
go

select dbo.Tinh_CPDV_Thang_Nam('HD0001')  

--Module 8.  Tính thành tiền cho hoá đơn
--Phân tích:
--Input:  @P_ID, @Thang, @Nam
--Output: Thanh tien
--Process: 
--1. Kiểm tra mã hoá đơn có tồn tại trong bảng hoá đơn với điều kiện mã phòng = @p_id; tháng =@tháng; năm =@năm
--2. Nếu không tồn tại thì hiển thị 'Không tồn tại hoá đơn' và dừng lại
--3. Lấy mã hoá đơn dựa vào mã phòng, tháng, năm -->@Hdon_id
--4. Lấy tiền phòng từ bảng phòng dựa vào mã phòng -->@tienphong
--5. Tiền dịch vụ = dbo.Tinh_CPDV_Thang_nam(@HDon_id) --> @tiendichvu ( gọi lại hàm do đã tạo trước đó)
--6. Thành tiền = @tienphong + @tiendichvu -->@thanhtien

create or alter proc Tinh_Thanh_Tien_Hoa_Don ( @P_ID CHAR(10), @Thang INT, @Nam INT, @ThanhTien FLOAT OUTPUT)   
AS
BEGIN
    DECLARE @TienPhong numeric(20,2), @TienDichVu numeric(20,2), @HDon_ID CHAR(10);

	if (select count(*) 
		from hoa_don 
		where P_id=@P_ID and month(HDon_NgayThangNam)=@Thang and year(Hdon_Ngaythangnam)=@Nam)=0
	begin
		print N'Không tồn tại hoá đơn'
		return
	end

    SELECT @HDon_ID = HDon_ID
    FROM Hoa_Don
    WHERE P_ID = @P_ID and month(HDon_NgayThangNam)=@Thang and year(Hdon_Ngaythangnam)=@Nam

    SELECT @TienPhong = P_GiaPhong 
    FROM Phong_Tro
    WHERE P_ID = @P_ID;

    SET @TienDichVu = dbo.Tinh_CPDV_Thang_nam(@HDon_ID)

    SET @ThanhTien = @TienPhong + @TienDichVu;

END
GO

DECLARE @ThanhTien numeric(20,2);
EXEC Tinh_Thanh_Tien_Hoa_Don 'P100916', 4, 2023, @ThanhTien OUTPUT;
PRINT @thanhtien

--Module 9: Xuất hoá đơn

--Phân tích:
--Input: @P_ID, @Thang, @Nam
--Output: Nếu có hóa đơn, đầu ra của module là một tập hợp các bản ghi (rows) chứa thông tin về dịch vụ liên quan đến hóa đơn cho phòng đã cho.
--		Nếu không có hóa đơn, hiển thị 'Không có hoá đơn'.
--Process: 
--1. Kiểm tra mã hoá đơn có tồn tại trong bảng hoá đơn không? dựa vào @P_id, @thang, @nam
--2. Nếu không thì hiển thị 'Không có hoá đơn' và dừng
--3. Nếu có thì thực hiện hiển thị ra các bản ghi chứa thông tin về dịch vụ liên quan đến hoá đơn của phòng.

create or alter proc XuatHoaDon (@P_ID CHAR(10), @Thang INT, @Nam INT)
AS
BEGIN
    DECLARE @TongTien FLOAT

    IF (SELECT COUNT(*) 
        FROM Hoa_Don 
        WHERE P_ID = @P_ID 
          AND MONTH(HDon_NgayThangNam) = @Thang 
          AND YEAR(HDon_NgayThangNam) = @Nam) = 0
    BEGIN
        print N'Không có hóa đơn';
		return
    END
    ELSE
    BEGIN
        SELECT DV.DV_Ten AS TenDichVu, HCT.HdonCT_SoCu AS SoDau, HCT.HdonCT_SoMoi AS SoCuoi, DV.DV_DonGia AS DonGia, 
            (HCT.HdonCT_SoMoi - HCT.HdonCT_SoCu) * DV.DV_DonGia AS ThanhTien 
        FROM HDon_Chi_Tiet HCT JOIN Dich_Vu DV ON HCT.dv_id = DV.DV_ID
								JOIN Hoa_Don HD ON HCT.hdon_id = HD.HDon_ID
        WHERE HD.P_ID = @P_ID AND MONTH(HD.HDon_NgayThangNam) = @Thang 
								AND YEAR(HD.HDon_NgayThangNam) = @Nam;
    END
END
GO

exec XuatHoaDon 'P000916', 4, 2023

SELECT * FROM Hoa_Don

--Module 10: Cập nhật đơn giá dịch vụ
--Phân tích:
--Input: @DV_id, @DV_dongia
--Output: thong bao
--Process: 
--1. Kiem tra ma dich vu co ton tai trong bang Dich_vu khong
--2. Neu khong thi hien thi thong bao 'Ma dich vu khong ton tai' va ket thuc
--3. Nguoc lai update dich_vu
--		set dv_dongia=@dv_dongia
--		where dv_id=@dv_id
--4. Neu @@rowcount <=0 thi hien thi thong bao 'Cap nhat that bai'
--5. Nguoc lai thi hien thi thong bao 'Cap nhat thanh cong'

create or alter proc updategiadichvu(@DV_ID CHAR(10), @dv_dongia nvarchar(50), @thongbao nvarchar(50) out)
AS
BEGIN
    IF (SELECT COUNT(*) FROM Dich_Vu WHERE DV_ID = @DV_ID) = 0
    BEGIN
        set @thongbao=N'Mã dịch vụ không tồn tại'
        return
    END
	else
	begin
		update Dich_Vu
		set DV_DonGia=@dv_dongia
		where DV_ID=@DV_ID
	end

	if @@ROWCOUNT<=0
	begin
		set @thongbao=N'Cập nhật thất bại'
	end
	else
	begin
		set @thongbao=N'Cập nhật thành công'
	end
end
-- test thành công
declare @thongbao nvarchar(50) 
exec updategiadichvu 'DV00001', 200, @thongbao out
print @thongbao

-- test thất bại do mã giao dịch không tồn tại
declare @thongbao nvarchar(50) 
exec updategiadichvu 'DV10000', 200, @thongbao out
print @thongbao

select * from Dich_Vu

