-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Dec 21, 2023 at 06:59 AM
-- Server version: 8.0.31
-- PHP Version: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `thuexe`
--

-- --------------------------------------------------------

--
-- Table structure for table `datxe`
--

DROP TABLE IF EXISTS `datxe`;
CREATE TABLE IF NOT EXISTS `datxe` (
  `ma_dat_xe` int NOT NULL AUTO_INCREMENT,
  `ngay_bat_dau` date NOT NULL,
  `ngay_ket_thuc` date NOT NULL,
  `trang_thai_dat_xe` int NOT NULL,
  `dia_chi_nhan_xe` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `so_ngay_thue` int DEFAULT NULL,
  `tong_tien_thue` int DEFAULT NULL,
  `ma_xe` int DEFAULT NULL,
  `ma_nguoi_dat_xe` int NOT NULL,
  PRIMARY KEY (`ma_dat_xe`),
  KEY `ma_xe` (`ma_xe`),
  KEY `ma_nguoi_dat_xe` (`ma_nguoi_dat_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `hinhanh`
--

DROP TABLE IF EXISTS `hinhanh`;
CREATE TABLE IF NOT EXISTS `hinhanh` (
  `ma_hinh_anh` int NOT NULL AUTO_INCREMENT,
  `loai_hinh` int NOT NULL,
  `hinh` varchar(200) NOT NULL,  
  `ma_xe` int NOT NULL,
  PRIMARY KEY (`ma_hinh_anh`),
  KEY `ma_xe` (`ma_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;



-- --------------------------------------------------------

--
-- Table structure for table `loaixe`
--

DROP TABLE IF EXISTS `loaixe`;
CREATE TABLE IF NOT EXISTS `loaixe` (
  `ma_loai_xe` int NOT NULL AUTO_INCREMENT,
  `ten_loai_xe` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`ma_loai_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;



-- --------------------------------------------------------

--
-- Table structure for table `nguoidung`
--

DROP TABLE IF EXISTS `nguoidung`;
CREATE TABLE IF NOT EXISTS `nguoidung` (
  `ma_nguoi_dung` int NOT NULL AUTO_INCREMENT,
  `ten_nguoi_dung` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `mat_khau_hash` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `ho_ten` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `hinh_dai_dien` varchar(200) DEFAULT '',
  `ngay_dang_ky` date NOT NULL,
  `so_dien_thoai` varchar(50) DEFAULT '00000000',
  `dia_chi_nguoi_dung` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ma_nguoi_dung`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;


-- --------------------------------------------------------

--
-- Table structure for table `xe`
--

DROP TABLE IF EXISTS `xe`;
CREATE TABLE IF NOT EXISTS `xe` (
  `ma_xe` int NOT NULL AUTO_INCREMENT,
  `ten_xe` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `trang_thai` int NOT NULL,
  `model` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `hang_sx` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `dia_chi` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `mo_ta` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `gia_thue` int DEFAULT NULL,
  `so_cho` int DEFAULT NULL,
  `chu_so_huu` int NOT NULL,
  `ma_loai_xe` int NOT NULL,
  PRIMARY KEY (`ma_xe`),
  KEY `chu_so_huu` (`chu_so_huu`),
  KEY `ma_loai_xe` (`ma_loai_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;



--
-- Constraints for dumped tables
--

--
-- Constraints for table `datxe`
--
ALTER TABLE `datxe`
  ADD CONSTRAINT `datxe_ibfk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`),
  ADD CONSTRAINT `datxe_ibfk_2` FOREIGN KEY (`ma_nguoi_dat_xe`) REFERENCES `nguoidung` (`ma_nguoi_dung`);

--
-- Constraints for table `hinhanh`
--
ALTER TABLE `hinhanh`
  ADD CONSTRAINT `hinhanh_ibfk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`);

--
-- Constraints for table `xe`
--
ALTER TABLE `xe`
  ADD CONSTRAINT `xe_ibfk_1` FOREIGN KEY (`chu_so_huu`) REFERENCES `nguoidung` (`ma_nguoi_dung`),
  ADD CONSTRAINT `xe_ibfk_2` FOREIGN KEY (`ma_loai_xe`) REFERENCES `loaixe` (`ma_loai_xe`);

--
-- Dumping data for table `loaixe`
--

-- Insert data into `loaixe`
INSERT INTO `loaixe` (`ma_loai_xe`, `ten_loai_xe`) VALUES
(1, 'Sedan'),
(2, 'SUV'),
(3, 'Convertible'),
(4, 'Convertible');

-- Insert data into `nguoidung`
INSERT INTO `nguoidung` (`ma_nguoi_dung`, `ten_nguoi_dung`, `mat_khau_hash`, `ho_ten`, `hinh_dai_dien`, `ngay_dang_ky`, `so_dien_thoai`, `dia_chi_nguoi_dung`) VALUES
(1, 'user01', '1', 'Nguyen Van A', 'avt1.jpg', '2023-12-01', '0123456789', '123 Nguyen Trai, Hanoi'),
(100, 'Agent', '1', 'Agent', 'agent.jpg', '2023-12-01', '0123456789', '123 Nguyen Trai, Hanoi'),
(2, 'user02', '1', 'Tran Thi B', 'avt2.jpg', '2023-12-02', '9876543210', '456 Le Loi, Ho Chi Minh');

INSERT INTO `xe` (`ten_xe`, `trang_thai`, `model`, `hang_sx`, `dia_chi`, `mo_ta`, `gia_thue`, `so_cho`, `chu_so_huu`, `ma_loai_xe`) VALUES
('Toyota Corolla', 0, 'Corolla 2018', 'Toyota', 'Hanoi', 'Reliable city car', 300000, 5, 100, 1),
('Volkswagen Golf', 0, 'Golf 2019', 'Volkswagen', 'Ho Chi Minh City', 'Compact with great mileage', 350000, 5, 100, 4),
('Ford Focus', 0, 'Focus 2018', 'Ford', 'Da Nang', 'Family hatchback with spacious interior', 320000, 5, 100, 4),
('Honda Accord', 0, 'Accord 2019', 'Honda', 'Nha Trang', 'Spacious and comfortable sedan', 400000, 5, 100, 1),
('BMW X3', 0, 'X3 2020', 'BMW', 'Ha Long', 'Luxury compact SUV', 1200000, 5, 100, 2),
('Audi Q5', 0, 'Q5 2021', 'Audi', 'Hue', 'Stylish and powerful SUV', 1300000, 5, 100, 2),
('Mercedes A-Class', 0, 'A-Class 2019', 'Mercedes-Benz', 'Can Tho', 'Compact luxury', 1100000, 5, 100, 1),
('Nissan Rogue', 0, 'Rogue 2020', 'Nissan', 'Phu Quoc', 'Family-friendly SUV', 500000, 5, 100, 2),
('Hyundai Elantra', 0, 'Elantra 2021', 'Hyundai', 'Vinh', 'Economical sedan for everyday use', 300000, 5, 100, 1),
('Mazda CX-3', 0, 'CX-3 2021', 'Mazda', 'Bien Hoa', 'Small SUV with excellent handling', 450000, 5, 100, 2),
('Kia Sorento', 0, 'Sorento 2019', 'Kia', 'Hanoi', 'Versatile SUV for all your needs', 600000, 7, 100, 2),
('Chevrolet Malibu', 0, 'Malibu 2018', 'Chevrolet', 'Ho Chi Minh City', 'Comfortable midsize sedan', 350000, 5, 100, 1),
('Subaru Forester', 0, 'Forester 2020', 'Subaru', 'Da Nang', 'Rugged and reliable SUV', 700000, 5, 100, 2),
('Jeep Cherokee', 0, 'Cherokee 2021', 'Jeep', 'Nha Trang', 'Adventure-ready SUV', 800000, 5, 100, 2),
('Tesla Model S', 0, 'Model S 2020', 'Tesla', 'Ha Long', 'Electric luxury sedan with autopilot', 2000000, 5, 100, 1),
('Lexus RX', 0, 'RX 2021', 'Lexus', 'Hue', 'Luxury crossover SUV', 1400000, 5, 100, 2),
('Volvo XC60', 0, 'XC60 2019', 'Volvo', 'Can Tho', 'Safe and stylish SUV', 1300000, 5, 100, 2),
('Fiat 500', 0, '500 2018', 'Fiat', 'Phu Quoc', 'Iconic and chic city car', 250000, 4, 100, 4),
('Fiat 10000', 0, '500 2018', 'Fiat', 'Phu Quoc', 'Iconic and chic city car', 250000, 4, 100, 4);

-- Insert data into `datxe`
INSERT INTO `datxe` (`ma_dat_xe`, `ngay_bat_dau`, `ngay_ket_thuc`, `trang_thai_dat_xe`, `dia_chi_nhan_xe`, `so_ngay_thue`, `tong_tien_thue`, `ma_xe`, `ma_nguoi_dat_xe`) VALUES
(1, '2023-12-10', '2023-12-12', 1, '123 Nguyen Trai, Hanoi', 2, 1000000, 34, 1),
(2, '2023-12-15', '2023-12-20', 1, '456 Le Loi, Ho Chi Minh', 5, 6000000, 35, 2);

-- Insert data into `hinhanh`
-- Assuming `ma_xe` values range from 1 to 20 and each should have one `loai_hinh` 1
INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(1, 'hinh1.jpg', 23),
(1, 'hinh1.jpg', 24),
(1, 'hinh1.jpg', 25),
(1, 'hinh1.jpg', 26),
(1, 'hinh1.jpg', 27),
(1, 'hinh1.jpg', 28),
(1, 'hinh1.jpg', 29),
(1, 'hinh1.jpg', 30),
(1, 'hinh1.jpg', 31),
(1, 'hinh1.jpg', 32),
(1, 'hinh1.jpg', 33),
(1, 'hinh1.jpg', 34),
(1, 'hinh1.jpg', 35),
(1, 'hinh1.jpg', 36),
(1, 'hinh1.jpg', 37),
(1, 'hinh1.jpg', 38),
(1, 'hinh1.jpg', 39),
(1, 'hinh1.jpg', 40),
(1, 'hinh1.jpg', 41);


INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(0, 'hinh2.jpg', 23),
(0, 'hinh3.jpg', 23),
(0, 'hinh2.jpg', 24),
(0, 'hinh3.jpg', 24),
(0, 'hinh2.jpg', 25),
(0, 'hinh3.jpg', 25),
(0, 'hinh2.jpg', 26),
(0, 'hinh3.jpg', 26),
(0, 'hinh2.jpg', 27),
(0, 'hinh3.jpg', 27),
(0, 'hinh2.jpg', 28),
(0, 'hinh3.jpg', 28),
(0, 'hinh2.jpg', 29),
(0, 'hinh3.jpg', 29),
(0, 'hinh2.jpg', 30),
(0, 'hinh3.jpg', 30),
(0, 'hinh2.jpg', 31),
(0, 'hinh3.jpg', 31),
(0, 'hinh2.jpg', 32),
(0, 'hinh3.jpg', 32),
(0, 'hinh2.jpg', 33),
(0, 'hinh3.jpg', 33),
(0, 'hinh2.jpg', 34),
(0, 'hinh3.jpg', 34),
(0, 'hinh2.jpg', 35),
(0, 'hinh3.jpg', 35),
(0, 'hinh2.jpg', 36),
(0, 'hinh3.jpg', 36),
(0, 'hinh2.jpg', 37),
(0, 'hinh3.jpg', 37),
(0, 'hinh2.jpg', 38),
(0, 'hinh3.jpg', 38),
(0, 'hinh2.jpg', 39),
(0, 'hinh3.jpg', 39),
(0, 'hinh2.jpg', 40),
(0, 'hinh3.jpg', 40),
(0, 'hinh2.jpg', 41),
(0, 'hinh3.jpg', 41);

INSERT INTO `hinhanh` (`loai_hinh`, `hinh`, `ma_xe`) VALUES
(0, 'hinh5.jpg', 23),
(0, 'hinh6.jpg', 23),
(0, 'hinh5.jpg', 24),
(0, 'hinh6.jpg', 24),
(0, 'hinh5.jpg', 25),
(0, 'hinh6.jpg', 25),
(0, 'hinh5.jpg', 26),
(0, 'hinh6.jpg', 26),
(0, 'hinh5.jpg', 27),
(0, 'hinh6.jpg', 27),
(0, 'hinh5.jpg', 28),
(0, 'hinh6.jpg', 28),
(0, 'hinh5.jpg', 29),
(0, 'hinh6.jpg', 29),
(0, 'hinh5.jpg', 30),
(0, 'hinh6.jpg', 30),
(0, 'hinh5.jpg', 31),
(0, 'hinh6.jpg', 31),
(0, 'hinh5.jpg', 32),
(0, 'hinh6.jpg', 32),
(0, 'hinh5.jpg', 33),
(0, 'hinh6.jpg', 33),
(0, 'hinh5.jpg', 34),
(0, 'hinh6.jpg', 34),
(0, 'hinh5.jpg', 35),
(0, 'hinh6.jpg', 35),
(0, 'hinh5.jpg', 36),
(0, 'hinh6.jpg', 36),
(0, 'hinh5.jpg', 37),
(0, 'hinh6.jpg', 37),
(0, 'hinh5.jpg', 38),
(0, 'hinh6.jpg', 38),
(0, 'hinh5.jpg', 39),
(0, 'hinh6.jpg', 39),
(0, 'hinh5.jpg', 40),
(0, 'hinh6.jpg', 40),
(0, 'hinh5.jpg', 41),
(0, 'hinh6.jpg', 41);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
