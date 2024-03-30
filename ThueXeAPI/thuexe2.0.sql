CREATE TABLE IF NOT EXISTS `nguoidung` (
  `ma_nguoi_dung` INT NOT NULL AUTO_INCREMENT,
  `ten_nguoi_dung` VARCHAR(50) NOT NULL,
  `mat_khau_hash` VARCHAR(256) NOT NULL, -- Tăng độ dài để hỗ trợ mã hóa mạnh mẽ hơn
  `ho_ten` VARCHAR(50) NOT NULL,
  `hinh_dai_dien` VARCHAR(200) DEFAULT '',
  `ngay_dang_ky` DATE NOT NULL,
  `so_dien_thoai` VARCHAR(15) DEFAULT NULL, -- Điều chỉnh độ dài phù hợp
  `dia_chi_nguoi_dung` VARCHAR(200) DEFAULT NULL,
  `loai_nguoi_dung` INT DEFAULT 0, -- Thêm trường mới để phân loại người dùng
  PRIMARY KEY (`ma_nguoi_dung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `loaixe` (
  `ma_loai_xe` INT NOT NULL AUTO_INCREMENT,
  `ten_loai_xe` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`ma_loai_xe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `DiaChi` (
  `ma_dia_chi` INT NOT NULL AUTO_INCREMENT,
  `dia_chi` VARCHAR(200) NOT NULL,
  `thanh_pho` VARCHAR(50) DEFAULT NULL,
  `quoc_gia` VARCHAR(50) DEFAULT NULL,
  `zip_code` VARCHAR(10) DEFAULT NULL,
  PRIMARY KEY (`ma_dia_chi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `xe` (
  `ma_xe` INT NOT NULL AUTO_INCREMENT,
  `ten_xe` VARCHAR(50) NOT NULL,
  `trang_thai` INT NOT NULL,
  `chu_so_huu` INT NOT NULL,
  `ma_loai_xe` INT NOT NULL,
  `gia_thue` DECIMAL(10, 2) DEFAULT NULL, -- Đổi kiểu dữ liệu để chính xác hơn
  `ma_dia_chi` INT DEFAULT NULL, -- Thay đổi để sử dụng bảng DiaChi mới
  `da_xac_minh` INT DEFAULT 0,
  PRIMARY KEY (`ma_xe`),
  KEY `chu_so_huu` (`chu_so_huu`),
  KEY `ma_loai_xe` (`ma_loai_xe`),
  KEY `ma_dia_chi` (`ma_dia_chi`),
  CONSTRAINT `xe_ibfk_1` FOREIGN KEY (`chu_so_huu`) REFERENCES `nguoidung` (`ma_nguoi_dung`),
  CONSTRAINT `xe_ibfk_2` FOREIGN KEY (`ma_loai_xe`) REFERENCES `loaixe` (`ma_loai_xe`),
  CONSTRAINT `xe_ibfk_3` FOREIGN KEY (`ma_dia_chi`) REFERENCES `DiaChi` (`ma_dia_chi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `ThongTinCoBanXe` (
  `ma_thong_tin_co_ban` INT NOT NULL AUTO_INCREMENT,
  `ma_xe` INT NOT NULL,
  `model` VARCHAR(50) DEFAULT NULL,
  `hang_sx` VARCHAR(50) DEFAULT NULL, -- Hãng sản xuất
  `so_cho` INT DEFAULT NULL,
  PRIMARY KEY (`ma_thong_tin_co_ban`),
  CONSTRAINT `ttcbxe_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `ThongTinKyThuatXe` (
  `ma_thong_tin_ky_thuat` INT NOT NULL AUTO_INCREMENT,
  `ma_xe` INT NOT NULL,
  `nam_san_xuat` INT DEFAULT NULL,
  `mau_sac` VARCHAR(50) DEFAULT NULL,
  `quang_duong` INT DEFAULT NULL, -- Quãng đường đã đi
  `tinh_nang` TEXT DEFAULT NULL, -- Mô tả các tính năng đặc biệt của xe
  `nhien_lieu` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`ma_thong_tin_ky_thuat`),
  CONSTRAINT `ttktxe_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `datxe` (
  `ma_dat_xe` INT NOT NULL AUTO_INCREMENT,
  `ngay_bat_dau` DATE NOT NULL,
  `ngay_ket_thuc` DATE NOT NULL,
  `trang_thai_dat_xe` INT NOT NULL,
  `dia_chi_nhan_xe` INT DEFAULT NULL, -- Liên kết với bảng DiaChi
  `tong_tien_thue` DECIMAL(10, 2) DEFAULT NULL,
  `ma_xe` INT DEFAULT NULL,
  `ma_nguoi_dat_xe` INT NOT NULL,
  PRIMARY KEY (`ma_dat_xe`),
  CONSTRAINT `datxe_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`),
  CONSTRAINT `datxe_fk_2` FOREIGN KEY (`ma_nguoi_dat_xe`) REFERENCES `nguoidung` (`ma_nguoi_dung`),
  CONSTRAINT `datxe_fk_3` FOREIGN KEY (`dia_chi_nhan_xe`) REFERENCES `DiaChi` (`ma_dia_chi`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `danhgia` (
  `ma_danh_gia` INT NOT NULL AUTO_INCREMENT,
  `ma_xe` INT NOT NULL,
  `ma_nguoi_dung` INT NOT NULL,
  `so_sao` INT NOT NULL,
  `binh_luan` TEXT,
  `thoi_gian` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ma_danh_gia`),
  CONSTRAINT `danhgia_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`),
  CONSTRAINT `danhgia_fk_2` FOREIGN KEY (`ma_nguoi_dung`) REFERENCES `nguoidung` (`ma_nguoi_dung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `hinhanh` (
  `ma_hinh_anh` INT NOT NULL AUTO_INCREMENT,
  `loai_hinh` INT NOT NULL,
  `hinh` VARCHAR(200) NOT NULL,  
  `ma_xe` INT NOT NULL,
  PRIMARY KEY (`ma_hinh_anh`),
  CONSTRAINT `hinhanh_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `lichsuthue` (
  `ma_lich_su` INT NOT NULL AUTO_INCREMENT,
  `ma_xe` INT NOT NULL,
  `ma_nguoi_thue` INT NOT NULL,
  `ngay_bat_dau` DATE NOT NULL,
  `ngay_ket_thuc` DATE NOT NULL,
  `ghi_chu` TEXT,
  PRIMARY KEY (`ma_lich_su`),
  KEY `ma_xe` (`ma_xe`),
  KEY `ma_nguoi_thue` (`ma_nguoi_thue`),
  CONSTRAINT `lichsuthue_ibfk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`),
  CONSTRAINT `lichsuthue_ibfk_2` FOREIGN KEY (`ma_nguoi_thue`) REFERENCES `nguoidung` (`ma_nguoi_dung`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
INSERT INTO `loaixe` (`ma_loai_xe`, `ten_loai_xe`) VALUES
(1, 'Sedan'),
(2, 'SUV'),
(3, 'Convertible'),
(4, 'Coupe'),
(5, 'Hatchback'),
(6, 'Wagon'),
(7, 'Van'),
(8, 'Mini Van'),
(9, 'Pickup Truck'),
(10, 'Sports Car'),
(11, 'Hybrid'),
(12, 'Electric'),
(13, 'Luxury'),
(14, 'Crossover'),
(15, 'Roadster'),
(16, 'Truck'),
(17, 'Compact'),
(18, 'Mid-size'),
(19, 'Full-size'),
(20, 'Off-Road');
INSERT INTO `nguoidung` (`ma_nguoi_dung`, `ten_nguoi_dung`, `mat_khau_hash`, `ho_ten`, `hinh_dai_dien`, `ngay_dang_ky`, `so_dien_thoai`, `dia_chi_nguoi_dung`, `loai_nguoi_dung`) VALUES
(1, 'user01', 'hashed_password_1', 'Nguyen Van A', 'avt1.jpg', '2023-12-01', '0123456789', '123 Nguyen Trai, Hanoi', 0),
(100, 'Agent', 'hashed_password_100', 'Agent', 'agent.jpg', '2023-12-01', '0123456789', '123 Nguyen Trai, Hanoi', 1),
(2, 'user02', 'hashed_password_2', 'Tran Thi B', 'avt2.jpg', '2023-12-02', '9876543210', '456 Le Loi, Ho Chi Minh', 0);
-- Giả định tạo mã địa chỉ mới cho mỗi địa chỉ xe
INSERT INTO `DiaChi` (`dia_chi`, `thanh_pho`, `quoc_gia`, `zip_code`) VALUES
('Hanoi', 'Hanoi', 'Vietnam', '100000'),
('Ho Chi Minh City', 'Ho Chi Minh', 'Vietnam', '700000'),
('Da Nang', 'Da Nang', 'Vietnam', '550000'),
('Nha Trang', 'Khanh Hoa', 'Vietnam', '650000'),
('Ha Long', 'Quang Ninh', 'Vietnam', '200000'),
('Hue', 'Thua Thien Hue', 'Vietnam', '530000'),
('Can Tho', 'Can Tho', 'Vietnam', '900000'),
('Phu Quoc', 'Kien Giang', 'Vietnam', '920000'),
('Vinh', 'Nghe An', 'Vietnam', '460000'),
('Bien Hoa', 'Dong Nai', 'Vietnam', '810000');
-- Chèn dữ liệu vào bảng `xe`, sử dụng ma_dia_chi giả định đã được tạo.
INSERT INTO `xe` (`ten_xe`, `trang_thai`, `chu_so_huu`, `ma_loai_xe`, `gia_thue`, `ma_dia_chi`) VALUES
('Toyota Corolla', 0, 100, 1, 300000, 1),
('Volkswagen Golf', 0, 100, 4, 350000, 2),
('Ford Focus', 0, 100, 4, 320000, 3),
('Honda Accord', 0, 100, 1, 400000, 4),
('BMW X3', 0, 100, 2, 1200000, 5),
('Audi Q5', 0, 100, 2, 1300000, 6),
('Mercedes A-Class', 0, 100, 1, 1100000, 7),
('Nissan Rogue', 0, 100, 2, 500000, 8),
('Hyundai Elantra', 0, 100, 1, 300000, 9),
('Mazda CX-3', 0, 100, 2, 450000, 10),
('Kia Sorento', 0, 100, 2, 600000, 1),
('Chevrolet Malibu', 0, 100, 1, 350000, 2),
('Subaru Forester', 0, 100, 2, 700000, 3),
('Jeep Cherokee', 0, 100, 2, 800000, 4),
('Tesla Model S', 0, 100, 1, 2000000, 5),
('Lexus RX', 0, 100, 2, 1400000, 6),
('Volvo XC60', 0, 100, 2, 1300000, 7),
('Fiat 500', 0, 100, 4, 250000, 8),
-- Đối với xe Fiat 500 bị lặp lại, giả định đây là một sai sót và chỉ thêm một lần.
('Fiat 10000', 0, 100, 4, 250000, 8);
INSERT INTO `datxe` (`ngay_bat_dau`, `ngay_ket_thuc`, `trang_thai_dat_xe`, `dia_chi_nhan_xe`, `tong_tien_thue`, `ma_xe`, `ma_nguoi_dat_xe`) VALUES
('2023-12-10', '2023-12-12', 1, 1, 1000000, 1, 1), -- Giả định ma_xe = 1 tương ứng với 'Toyota Corolla'
('2023-12-15', '2023-12-20', 1, 2, 6000000, 2, 2); -- Giả định ma_xe = 2 tương ứng với 'Volkswagen Golf'
-- Chèn hình ảnh chính cho mỗi xe
INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(1, 'hinh1.jpg', 1),
(1, 'hinh2.jpg', 2),
(1, 'hinh3.jpg', 3);

-- Chèn hình ảnh phụ cho các xe
INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(0, 'hinh4.jpg', 1),
(0, 'hinh5.jpg', 1),
(0, 'hinh6.jpg', 2),
(0, 'hinh7.jpg', 2),
(0, 'hinh8.jpg', 3),
(0, 'hinh9.jpg', 3);
-- Hình ảnh chính cho mỗi xe
INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(1, 'main_toyota_corolla.jpg', 1),
(1, 'main_volkswagen_golf.jpg', 2),
(1, 'main_ford_focus.jpg', 3),
(1, 'main_honda_accord.jpg', 4),
(1, 'main_bmw_x3.jpg', 5),
(1, 'main_audi_q5.jpg', 6),
(1, 'main_mercedes_a_class.jpg', 7),
(1, 'main_nissan_rogue.jpg', 8),
(1, 'main_hyundai_elantra.jpg', 9);

-- Hình ảnh phụ cho các xe, giả định mỗi xe có 2 hình phụ
INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(0, 'sub1_toyota_corolla.jpg', 1),
(0, 'sub2_toyota_corolla.jpg', 1),
(0, 'sub1_volkswagen_golf.jpg', 2),
(0, 'sub2_volkswagen_golf.jpg', 2),
(0, 'sub1_ford_focus.jpg', 3),
(0, 'sub2_ford_focus.jpg', 3),
(0, 'sub1_honda_accord.jpg', 4),
(0, 'sub2_honda_accord.jpg', 4),
(0, 'sub1_bmw_x3.jpg', 5),
(0, 'sub2_bmw_x3.jpg', 5),
(0, 'sub1_audi_q5.jpg', 6),
(0, 'sub2_audi_q5.jpg', 6),
(0, 'sub1_mercedes_a_class.jpg', 7),
(0, 'sub2_mercedes_a_class.jpg', 7),
(0, 'sub1_nissan_rogue.jpg', 8),
(0, 'sub2_nissan_rogue.jpg', 8),
(0, 'sub1_hyundai_elantra.jpg', 9),
(0, 'sub2_hyundai_elantra.jpg', 9);
-- Hình ảnh chính cho mỗi xe
INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(1, 'main_mazda_cx3.jpg', 10),
(1, 'main_kia_sorento.jpg', 11),
(1, 'main_chevrolet_malibu.jpg', 12),
(1, 'main_subaru_forester.jpg', 13),
(1, 'main_jeep_cherokee.jpg', 14),
(1, 'main_tesla_model_s.jpg', 15),
(1, 'main_lexus_rx.jpg', 16),
(1, 'main_volvo_xc60.jpg', 17),
(1, 'main_fiat_500.jpg', 18);

-- Hình ảnh phụ cho các xe, giả định mỗi xe có 2 hình phụ
INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(0, 'sub1_mazda_cx3.jpg', 10),
(0, 'sub2_mazda_cx3.jpg', 10),
(0, 'sub1_kia_sorento.jpg', 11),
(0, 'sub2_kia_sorento.jpg', 11),
(0, 'sub1_chevrolet_malibu.jpg', 12),
(0, 'sub2_chevrolet_malibu.jpg', 12),
(0, 'sub1_subaru_forester.jpg', 13),
(0, 'sub2_subaru_forester.jpg', 13),
(0, 'sub1_jeep_cherokee.jpg', 14),
(0, 'sub2_jeep_cherokee.jpg', 14),
(0, 'sub1_tesla_model_s.jpg', 15),
(0, 'sub2_tesla_model_s.jpg', 15),
(0, 'sub1_lexus_rx.jpg', 16),
(0, 'sub2_lexus_rx.jpg', 16),
(0, 'sub1_volvo_xc60.jpg', 17),
(0, 'sub2_volvo_xc60.jpg', 17),
(0, 'sub1_fiat_500.jpg', 18),
(0, 'sub2_fiat_500.jpg', 18);
-- Hình ảnh chính cho mỗi xe
INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(1, 'main_fiat_10000.jpg', 19); -- Chỉ có 1 xe còn lại trong ví dụ này

-- Hình ảnh phụ cho xe cuối cùng, giả định xe này cũng có 2 hình phụ
INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(0, 'sub1_fiat_10000.jpg', 19),
(0, 'sub2_fiat_10000.jpg', 19);
-- Thêm thông tin cơ bản cho các xe
INSERT INTO `ThongTinCoBanXe` (`ma_xe`, `model`, `hang_sx`, `so_cho`) VALUES
(1, 'Corolla 2018', 'Toyota', 5),
(2, 'Golf 2019', 'Volkswagen', 5),
(3, 'Focus 2018', 'Ford', 5),
(4, 'Accord 2019', 'Honda', 5),
(5, 'X3 2020', 'BMW', 5),
(6, 'Q5 2021', 'Audi', 5),
(7, 'A-Class 2019', 'Mercedes-Benz', 5),
(8, 'Rogue 2020', 'Nissan', 5),
(9, 'Elantra 2021', 'Hyundai', 5),
(10, 'CX-3 2021', 'Mazda', 5),
(11, 'Sorento 2019', 'Kia', 7),
(12, 'Malibu 2018', 'Chevrolet', 5),
(13, 'Forester 2020', 'Subaru', 5),
(14, 'Cherokee 2021', 'Jeep', 5),
(15, 'Model S 2020', 'Tesla', 5),
(16, 'RX 2021', 'Lexus', 5),
(17, 'XC60 2019', 'Volvo', 5),
(18, '500 2018', 'Fiat', 4),
(19, '10000 2018', 'Fiat', 4);
-- Thêm thông tin kỹ thuật cho các xe
INSERT INTO `ThongTinKyThuatXe` (`ma_xe`, `nam_san_xuat`, `mau_sac`, `quang_duong`, `tinh_nang`,`nhien_lieu`) VALUES
(1, 2018, 'Trắng', 50000, 'Tiết kiệm nhiên liệu, động cơ ổn định','Xăng'),
(2, 2019, 'Đen', 30000, 'Thiết kế gọn nhẹ, tiện lợi trong thành phố','Xăng'),
(3, 2018, 'Xám', 45000, 'Phù hợp cho gia đình, không gian rộng rãi','Xăng'),
-- Tiếp tục với các xe còn lại...
(19, 2018, 'Đỏ', 25000, 'Thiết kế thể thao, dễ dàng di chuyển trong thành phố','Xăng');
-- Tiếp tục thêm thông tin kỹ thuật cho các xe
INSERT INTO `ThongTinKyThuatXe` (`ma_xe`, `nam_san_xuat`, `mau_sac`, `quang_duong`, `tinh_nang`) VALUES
(4, 2019, 'Bạc', 30000, 'Rộng rãi, thoải mái cho cả gia đình'),
(5, 2020, 'Xanh dương', 20000, 'SUV sang trọng với nhiều tính năng cao cấp'),
(6, 2021, 'Đen', 15000, 'Thiết kế đẹp, hiệu suất mạnh mẽ'),
(7, 2019, 'Trắng', 25000, 'Xe compact sang trọng với nội thất cao cấp'),
(8, 2020, 'Đỏ', 20000, 'SUV gia đình với không gian rộng lớn'),
(9, 2021, 'Xanh lá', 10000, 'Tiết kiệm nhiên liệu, thích hợp cho việc sử dụng hàng ngày'),
(10, 2021, 'Vàng', 12000, 'Nhỏ gọn, linh hoạt, thích hợp di chuyển trong thành phố'),
(11, 2019, 'Nâu', 40000, 'SUV đa năng, phù hợp với mọi lối sống'),
(12, 2018, 'Xám', 50000, 'Sedan thoải mái, tiện nghi với giá cả phải chăng'),
(13, 2020, 'Trắng', 35000, 'SUV đáng tin cậy, phù hợp cho mọi chuyến phiêu lưu'),
(14, 2021, 'Đen', 25000, 'SUV sẵn sàng cho mọi cuộc phiêu lưu'),
(15, 2020, 'Bạc', 5000, 'Sedan điện sang trọng với khả năng tự lái'),
(16, 2021, 'Xanh dương', 15000, 'Crossover sang trọng với nhiều tính năng an toàn'),
(17, 2019, 'Xanh lá', 22000, 'SUV an toàn, thoải mái với thiết kế Scandinavia'),
(18, 2018, 'Đỏ', 30000, 'Chiếc city car biểu tượng với thiết kế độc đáo');
-- Tạo mẫu dữ liệu lịch sử thuê cho các xe
INSERT INTO `lichsuthue` (`ma_xe`, `ma_nguoi_thue`, `ngay_bat_dau`, `ngay_ket_thuc`, `ghi_chu`) VALUES
(1, 1, '2023-01-05', '2023-01-10', 'Chuyến đi nghỉ mát cuối tuần'),
(2, 2, '2023-02-15', '2023-02-20', 'Chuyến công tác tại HCM'),
(3, 1, '2023-03-01', '2023-03-05', 'Di chuyển trong thành phố'),
(4, 2, '2023-04-10', '2023-04-15', 'Du lịch cùng gia đình'),
(5, 1, '2023-05-20', '2023-05-25', 'Chuyến đi dã ngoại'),
(6, 2, '2023-06-15', '2023-06-20', 'Chuyến đi công tác dài ngày'),
(7, 1, '2023-07-05', '2023-07-10', 'Thuê xe cho kỳ nghỉ'),
(8, 2, '2023-08-25', '2023-08-30', 'Chuyến đi du lịch tại Đà Nẵng'),
(9, 1, '2023-09-15', '2023-09-20', 'Chuyến đi ngắn ngày'),
(10, 2, '2023-10-05', '2023-10-10', 'Chuyến đi tiếp xúc khách hàng');
-- Tạo mẫu dữ liệu đánh giá cho các xe
INSERT INTO `danhgia` (`ma_xe`, `ma_nguoi_dung`, `so_sao`, `binh_luan`, `thoi_gian`) VALUES
(1, 1, 5, 'Xe rất mới và sạch sẽ. Trải nghiệm lái xe tuyệt vời.', '2023-01-11'),
(2, 2, 4, 'Thoải mái và tiện lợi, nhưng hơi tiêu thụ nhiều nhiên liệu.', '2023-02-21'),
(3, 1, 4, 'Phù hợp cho chuyến đi ngắn ngày trong thành phố.', '2023-03-06'),
(4, 2, 5, 'Gia đình tôi rất hài lòng với chất lượng xe.', '2023-04-16'),
(5, 1, 3, 'Xe ổn, nhưng hệ thống định vị không chính xác lắm.', '2023-05-26'),
(6, 2, 5, 'Xe sang trọng và mạnh mẽ. Rất đáng giá.', '2023-06-21'),
(7, 1, 4, 'Tôi thích thiết kế và không gian bên trong của xe.', '2023-07-11'),
(8, 2, 4, 'Xe rất thoải mái cho chuyến đi du lịch.', '2023-08-31'),
(9, 1, 5, 'Xe nhỏ gọn, rất phù hợp để di chuyển trong thành phố.', '2023-09-21'),
(10, 2, 4, 'Xe có nhiều không gian và rất thoải mái.', '2023-10-11');
