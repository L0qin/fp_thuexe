-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 05, 2024 at 01:46 PM
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
-- Database: `thuexedb`
--

-- --------------------------------------------------------

--
-- Table structure for table `danhgia`
--

DROP TABLE IF EXISTS `danhgia`;
CREATE TABLE IF NOT EXISTS `danhgia` (
  `ma_danh_gia` int NOT NULL AUTO_INCREMENT,
  `ma_xe` int NOT NULL,
  `ma_nguoi_dung` int NOT NULL,
  `so_sao` int NOT NULL,
  `binh_luan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `thoi_gian` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ma_danh_gia`),
  KEY `danhgia_fk_1` (`ma_xe`),
  KEY `danhgia_fk_2` (`ma_nguoi_dung`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `danhgia`
--

INSERT INTO `danhgia` (`ma_danh_gia`, `ma_xe`, `ma_nguoi_dung`, `so_sao`, `binh_luan`, `thoi_gian`) VALUES
(1, 1, 1, 5, 'Xe rất mới và sạch sẽ. Trải nghiệm lái xe tuyệt vời.', '2023-01-11 00:00:00'),
(2, 2, 2, 4, 'Thoải mái và tiện lợi, nhưng hơi tiêu thụ nhiều nhiên liệu.', '2023-02-21 00:00:00'),
(3, 3, 1, 4, 'Phù hợp cho chuyến đi ngắn ngày trong thành phố.', '2023-03-06 00:00:00'),
(4, 4, 2, 5, 'Gia đình tôi rất hài lòng với chất lượng xe.', '2023-04-16 00:00:00'),
(5, 5, 1, 3, 'Xe ổn, nhưng hệ thống định vị không chính xác lắm.', '2023-05-26 00:00:00'),
(6, 6, 2, 5, 'Xe sang trọng và mạnh mẽ. Rất đáng giá.', '2023-06-21 00:00:00'),
(7, 7, 1, 4, 'Tôi thích thiết kế và không gian bên trong của xe.', '2023-07-11 00:00:00'),
(8, 8, 2, 4, 'Xe rất thoải mái cho chuyến đi du lịch.', '2023-08-31 00:00:00'),
(9, 9, 1, 5, 'Xe nhỏ gọn, rất phù hợp để di chuyển trong thành phố.', '2023-09-21 00:00:00'),
(10, 10, 2, 4, 'Xe có nhiều không gian và rất thoải mái.', '2023-10-11 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `datxe`
--

DROP TABLE IF EXISTS `datxe`;
CREATE TABLE IF NOT EXISTS `datxe` (
  `ma_dat_xe` int NOT NULL AUTO_INCREMENT,
  `ngay_bat_dau` date NOT NULL,
  `ngay_ket_thuc` date NOT NULL,
  `trang_thai_dat_xe` int DEFAULT '0',
  `dia_chi_nhan_xe` int DEFAULT NULL,
  `tong_tien_thue` decimal(10,2) DEFAULT NULL,
  `ma_xe` int DEFAULT NULL,
  `ma_nguoi_dat_xe` int NOT NULL,
  `ma_chu_xe` int NOT NULL,
  `ghi_chu` text COLLATE utf8mb4_unicode_ci,
  `giam_gia` int DEFAULT NULL,
  `ma_voucher` int DEFAULT NULL,
  PRIMARY KEY (`ma_dat_xe`),
  KEY `datxe_fk_1` (`ma_xe`),
  KEY `datxe_fk_2` (`ma_nguoi_dat_xe`),
  KEY `datxe_fk_3` (`dia_chi_nhan_xe`),
  KEY `fk_voucher_datxe` (`ma_voucher`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `datxe`
--

INSERT INTO `datxe` (`ma_dat_xe`, `ngay_bat_dau`, `ngay_ket_thuc`, `trang_thai_dat_xe`, `dia_chi_nhan_xe`, `tong_tien_thue`, `ma_xe`, `ma_nguoi_dat_xe`, `ma_chu_xe`, `ghi_chu`, `giam_gia`, `ma_voucher`) VALUES
(1, '2023-12-10', '2023-12-12', 1, 1, '1000000.00', 1, 1, 1, NULL, NULL, NULL),
(2, '2023-12-15', '2023-12-20', 1, 2, '6000000.00', 2, 2, 1, NULL, NULL, NULL),
(3, '2024-04-02', '2024-04-03', 0, 1, '0.00', 1, 101, 0, '', 0, NULL),
(4, '2024-04-02', '2024-04-03', 2, 1, '0.00', 1, 101, 100, '', 0, NULL),
(5, '2024-04-02', '2024-04-03', -1, 1, '0.00', 6, 101, 100, '', 0, NULL),
(6, '2024-04-02', '2024-04-03', 0, 1, '0.00', 1, 101, 100, '', 0, NULL),
(7, '2024-04-02', '2024-04-03', 0, 1, '0.00', 2, 101, 100, 'sf', 0, NULL),
(8, '2024-04-02', '2024-04-03', 0, 1, '0.00', 1, 101, 100, '', 0, NULL),
(9, '2024-04-02', '2024-04-30', 0, 1, '0.00', 1, 101, 100, 'ghhgghh', 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `diachi`
--

DROP TABLE IF EXISTS `diachi`;
CREATE TABLE IF NOT EXISTS `diachi` (
  `ma_dia_chi` int NOT NULL AUTO_INCREMENT,
  `dia_chi` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `thanh_pho` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quoc_gia` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip_code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ma_dia_chi`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `diachi`
--

INSERT INTO `diachi` (`ma_dia_chi`, `dia_chi`, `thanh_pho`, `quoc_gia`, `zip_code`) VALUES
(1, 'Hanoi', 'Hanoi', 'Vietnam', '100000'),
(2, 'Ho Chi Minh City', 'Ho Chi Minh', 'Vietnam', '700000'),
(3, 'Da Nang', 'Da Nang', 'Vietnam', '550000'),
(4, 'Nha Trang', 'Khanh Hoa', 'Vietnam', '650000'),
(5, 'Ha Long', 'Quang Ninh', 'Vietnam', '200000'),
(6, 'Hue', 'Thua Thien Hue', 'Vietnam', '530000'),
(7, 'Can Tho', 'Can Tho', 'Vietnam', '900000'),
(8, 'Phu Quoc', 'Kien Giang', 'Vietnam', '920000'),
(9, 'Vinh', 'Nghe An', 'Vietnam', '460000'),
(10, 'Bien Hoa', 'Dong Nai', 'Vietnam', '810000'),
(11, '123 Test Street, Test City', NULL, NULL, NULL),
(12, '123 Test Street, Test City', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `dieukhoansudung`
--

DROP TABLE IF EXISTS `dieukhoansudung`;
CREATE TABLE IF NOT EXISTS `dieukhoansudung` (
  `ma_dieu_khoan` int NOT NULL AUTO_INCREMENT,
  `phien_ban` varchar(50) DEFAULT '1.0',
  `tieu_de` varchar(255) DEFAULT NULL,
  `noi_dung` longtext,
  `ngay_hieu_luc` datetime DEFAULT CURRENT_TIMESTAMP,
  `ngay_tao` datetime DEFAULT CURRENT_TIMESTAMP,
  `ngay_cap_nhat_cuoi` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `trang_thai` int DEFAULT '1',
  PRIMARY KEY (`ma_dieu_khoan`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `dieukhoansudung`
--

INSERT INTO `dieukhoansudung` (`ma_dieu_khoan`, `phien_ban`, `tieu_de`, `noi_dung`, `ngay_hieu_luc`, `ngay_tao`, `ngay_cap_nhat_cuoi`, `trang_thai`) VALUES
(1, NULL, 'Lưu Ý Quan Trọng Khi Thuê Xe', 'Kiểm Tra Danh Mục Xe: Trước khi đặt xe, hãy kiểm tra kỹ danh mục xe có sẵn trên ứng dụng của chúng tôi. Đảm bảo chọn loại xe phản ánh đúng nhu cầu và số lượng người đi cùng.\n\nXác Thực Thông Tin: Hãy chắc chắn rằng bạn cung cấp thông tin cá nhân và thanh toán chính xác. Thông tin không chính xác có thể gây trở ngại trong quá trình thuê hoặc tạo ra sự phiền toái sau này.\n\nKiểm Tra Giá và Chính Sách: Đọc kỹ chính sách thuê xe và kiểm tra giá thuê trước khi xác nhận đặt xe. Điều này giúp bạn hiểu rõ về các khoản phí bổ sung, điều kiện huỷ bỏ, và các yêu cầu khác.\n\nKiểm Tra Đánh Giá và Phản Hồi: Trước khi quyết định, hãy đọc các đánh giá và phản hồi từ các khách hàng trước đó. Điều này giúp bạn có cái nhìn tổng quan về chất lượng dịch vụ của chúng tôi.\n\nThời Gian Thuê và Trả Xe: Đảm bảo bạn hiểu rõ về thời gian thuê và trả xe. Việc trả xe muộn có thể phát sinh phí phạt. Nếu có bất kỳ thay đổi nào trong kế hoạch của bạn, vui lòng thông báo trước để chúng tôi có thể sắp xếp lại.\n\nLiên Hệ Hỗ Trợ: Trong trường hợp có bất kỳ vấn đề nào xuất hiện trong quá trình thuê hoặc sử dụng xe, hãy liên hệ ngay với dịch vụ khách hàng của chúng tôi để được hỗ trợ kịp thời.\n\nKiểm Tra Trạng Thái Xe: Trước khi nhận xe, hãy kiểm tra kỹ trạng thái của xe và ghi lại bất kỳ tổn thất nào. Điều này giúp bạn tránh việc bị buộc phải trả phí cho những tổn thất không phải do bạn gây ra.\n\nBảo Dưỡng và An Toàn: Hãy tuân thủ các quy tắc an toàn giao thông và bảo dưỡng xe đúng cách trong suốt thời gian sử dụng. Nếu gặp phải vấn đề kỹ thuật hoặc tai nạn, hãy báo ngay cho chúng tôi để được hỗ trợ.\n\nChúng tôi hy vọng rằng những lưu ý trên sẽ giúp bạn có trải nghiệm thuê xe trơn tru và tiện lợi trên ứng dụng của chúng tôi.', '2024-04-01 00:00:00', '2024-04-04 20:57:42', '2024-04-05 15:41:50', 1),
(2, '1.0', 'Điều Khoản Sử Dụng Dịch Vụ Thuê Xe', 'Chào mừng bạn đến với ứng dụng thuê xe của chúng tôi. Trước khi bạn sử dụng dịch vụ, vui lòng đọc kỹ và hiểu rõ các điều khoản và điều kiện sau đây:\r\n\r\nĐăng Ký và Tài Khoản:\r\n\r\nBạn phải đăng ký một tài khoản để sử dụng dịch vụ thuê xe của chúng tôi.\r\nBạn cam kết cung cấp thông tin cá nhân chính xác và hoàn chỉnh khi đăng ký tài khoản.\r\nQuyền Lợi và Trách Nhiệm:\r\n\r\nBạn có quyền thuê xe theo các điều kiện đã được quy định trên ứng dụng.\r\nBạn phải chịu trách nhiệm cho việc sử dụng xe và phải tuân thủ các quy định về an toàn giao thông.\r\nThanh Toán:\r\n\r\nBạn đồng ý thanh toán phí thuê xe theo các phương thức thanh toán được chấp nhận trên ứng dụng.\r\nCác khoản phí bổ sung như phí bảo hiểm, phí nhiên liệu và phí phạt sẽ được thông báo rõ ràng trước khi bạn xác nhận đặt xe.\r\nHuỷ Đặt Xe:\r\n\r\nBạn có thể huỷ đặt xe mà không phải trả phí nếu thực hiện trước thời hạn được quy định trên ứng dụng.\r\nViệc huỷ đặt xe sau thời hạn quy định có thể phát sinh phí huỷ đặt.\r\nBảo Mật Thông Tin:\r\n\r\nChúng tôi cam kết bảo vệ thông tin cá nhân của bạn và sử dụng thông tin đó chỉ cho mục đích cung cấp dịch vụ.\r\nBạn không được chia sẻ tài khoản và thông tin đăng nhập của mình với bất kỳ ai khác.\r\nThay Đổi và Cập Nhật:\r\n\r\nChúng tôi có quyền thay đổi hoặc cập nhật các điều khoản và điều kiện này mà không cần thông báo trước.\r\nBạn có trách nhiệm kiểm tra và cập nhật thông tin về điều khoản và điều kiện mới khi chúng được cập nhật.\r\nBằng cách sử dụng dịch vụ thuê xe của chúng tôi, bạn đồng ý tuân thủ các điều khoản và điều kiện được nêu trên. Việc vi phạm các điều khoản này có thể dẫn đến hậu quả pháp lý.', '2024-04-04 20:57:42', '2024-04-04 20:57:42', '2024-04-04 20:57:42', 1),
(3, '1.0', 'Giấy tờ thuê xe', 'Chọn 1 trong 2 hình thức:\nGPLX & CCCD(Đối chiếu)\nGPLX & Passport(Chủ xe tạm giữ)', '2024-04-04 20:57:42', '2024-04-04 20:57:42', '2024-04-04 20:57:42', 1),
(4, '1.0', 'Tài sản thế chấp', '30 triệu (tiền mặt/chuyển khoảng cho chủ xe khi nhận xe) hoặc Xe máy (kèm cà vẹt gốc) giá trị 30 triệu', '2024-04-04 20:57:42', '2024-04-04 20:57:42', '2024-04-04 20:57:42', 1),
(5, '1.0', 'Lưu ý giao dịch', 'Giao dịch qua fp_thuexe để chúng tôi bảo vệ bạn tốt nhất trong trường hợp bị huỷ chuyến ngoài ý muốn & phát sinh sự cố có bảo hiểm', '2024-04-04 20:57:42', '2024-04-04 20:57:42', '2024-04-04 20:57:42', 1),
(6, '1.0', '-', '-', '2024-04-04 20:57:42', '2024-04-04 20:57:42', '2024-04-04 20:57:42', 1);

-- --------------------------------------------------------

--
-- Table structure for table `hinhanh`
--

DROP TABLE IF EXISTS `hinhanh`;
CREATE TABLE IF NOT EXISTS `hinhanh` (
  `ma_hinh_anh` int NOT NULL AUTO_INCREMENT,
  `loai_hinh` int NOT NULL,
  `hinh` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ma_xe` int NOT NULL,
  PRIMARY KEY (`ma_hinh_anh`),
  KEY `hinhanh_fk_1` (`ma_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hinhanh`
--

INSERT INTO `hinhanh` (`ma_hinh_anh`, `loai_hinh`, `hinh`, `ma_xe`) VALUES
(1, 1, 'hinh1.jpg', 1),
(2, 1, 'hinh2.jpg', 2),
(3, 1, 'hinh3.jpg', 3),
(4, 0, 'hinh3.jpg', 1),
(5, 0, 'hinh3.jpg', 1),
(6, 0, 'hinh3.jpg', 2),
(7, 0, 'hinh3.jpg', 2),
(8, 0, 'hinh3.jpg', 3),
(9, 0, 'hinh3.jpg', 3),
(10, 1, 'hinh3.jpg', 1),
(11, 1, 'hinh3.jpg', 2),
(12, 1, 'hinh3.jpg', 3),
(13, 1, 'hinh3.jpg', 4),
(14, 1, 'hinh3.jpg', 5),
(15, 1, 'hinh3.jpg', 6),
(16, 1, 'hinh3.jpg', 7),
(17, 1, 'hinh3.jpg', 8),
(18, 1, 'hinh3.jpg', 9),
(19, 0, 'hinh3.jpg', 1),
(20, 0, 'hinh3.jpg', 1),
(21, 0, 'hinh3.jpg', 2),
(22, 0, 'hinh3.jpg', 2),
(23, 0, 'hinh3.jpg', 3),
(24, 0, 'hinh3.jpg', 3),
(25, 0, 'hinh3.jpg', 4),
(26, 0, 'hinh3.jpg', 4),
(27, 0, 'hinh3.jpg', 5),
(28, 0, 'hinh3.jpg', 5),
(29, 0, 'hinh3.jpg', 6),
(30, 0, 'hinh3.jpg', 6),
(31, 0, 'hinh3.jpg', 7),
(32, 0, 'hinh3.jpg', 7),
(33, 0, 'hinh3.jpg', 8),
(34, 0, 'hinh3.jpg', 8),
(35, 0, 'hinh3.jpg', 9),
(36, 0, 'hinh3.jpg', 9),
(37, 1, 'hinh3.jpg', 10),
(38, 1, 'hinh3.jpg', 11),
(39, 1, 'hinh3.jpg', 12),
(40, 1, 'hinh3.jpg', 13),
(41, 1, 'hinh3.jpg', 14),
(42, 1, 'hinh3.jpg', 15),
(43, 1, 'hinh3.jpg', 16),
(44, 1, 'hinh3.jpg', 17),
(45, 1, 'hinh3.jpg', 18),
(46, 0, 'hinh3.jpg', 10),
(47, 0, 'hinh3.jpg', 10),
(48, 0, 'hinh3.jpg', 11),
(49, 0, 'hinh3.jpg', 11),
(50, 0, 'hinh3.jpg', 12),
(51, 0, 'hinh3.jpg', 12),
(52, 0, 'hinh3.jpg', 13),
(53, 0, 'hinh3.jpg', 13),
(54, 0, 'hinh3.jpg', 14),
(55, 0, 'hinh3.jpg', 14),
(56, 0, 'hinh3.jpg', 15),
(57, 0, 'hinh3.jpg', 15),
(58, 0, 'hinh3.jpg', 16),
(59, 0, 'hinh3.jpg', 16),
(60, 0, 'hinh3.jpg', 17),
(61, 0, 'hinh3.jpg', 17),
(62, 0, 'hinh3.jpg', 18),
(63, 0, 'hinh3.jpg', 18),
(64, 1, 'hinh3.jpg', 19),
(65, 0, 'hinh3.jpg', 19),
(66, 0, 'hinh3.jpg', 19),
(67, 1, 'img1201711776810448.jpg', 20),
(68, 1, 'img1211711951130399.jpg', 21),
(69, 0, 'img0211711951130604.jpg', 21),
(70, 0, 'img0211711951130708.jpg', 21),
(71, 3, 'img3211711951130757.jpg', 21),
(72, 3, 'img3211711951130824.jpg', 21),
(73, 3, 'img3211711951130876.jpg', 21);

-- --------------------------------------------------------

--
-- Table structure for table `lichsuthue`
--

DROP TABLE IF EXISTS `lichsuthue`;
CREATE TABLE IF NOT EXISTS `lichsuthue` (
  `ma_lich_su` int NOT NULL AUTO_INCREMENT,
  `ma_xe` int NOT NULL,
  `ma_nguoi_thue` int NOT NULL,
  `ngay_bat_dau` date NOT NULL,
  `ngay_ket_thuc` date NOT NULL,
  `ghi_chu` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`ma_lich_su`),
  KEY `ma_xe` (`ma_xe`),
  KEY `ma_nguoi_thue` (`ma_nguoi_thue`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lichsuthue`
--

INSERT INTO `lichsuthue` (`ma_lich_su`, `ma_xe`, `ma_nguoi_thue`, `ngay_bat_dau`, `ngay_ket_thuc`, `ghi_chu`) VALUES
(1, 1, 1, '2023-01-05', '2023-01-10', 'Chuyến đi nghỉ mát cuối tuần'),
(2, 2, 2, '2023-02-15', '2023-02-20', 'Chuyến công tác tại HCM'),
(3, 3, 1, '2023-03-01', '2023-03-05', 'Di chuyển trong thành phố'),
(4, 4, 2, '2023-04-10', '2023-04-15', 'Du lịch cùng gia đình'),
(5, 5, 1, '2023-05-20', '2023-05-25', 'Chuyến đi dã ngoại'),
(6, 6, 2, '2023-06-15', '2023-06-20', 'Chuyến đi công tác dài ngày'),
(7, 7, 1, '2023-07-05', '2023-07-10', 'Thuê xe cho kỳ nghỉ'),
(8, 8, 2, '2023-08-25', '2023-08-30', 'Chuyến đi du lịch tại Đà Nẵng'),
(9, 9, 1, '2023-09-15', '2023-09-20', 'Chuyến đi ngắn ngày'),
(10, 10, 2, '2023-10-05', '2023-10-10', 'Chuyến đi tiếp xúc khách hàng');

-- --------------------------------------------------------

--
-- Table structure for table `loaithongbao`
--

DROP TABLE IF EXISTS `loaithongbao`;
CREATE TABLE IF NOT EXISTS `loaithongbao` (
  `ma_loai_thong_bao` int NOT NULL AUTO_INCREMENT,
  `ten_loai` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_ta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`ma_loai_thong_bao`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loaithongbao`
--

INSERT INTO `loaithongbao` (`ma_loai_thong_bao`, `ten_loai`, `mo_ta`) VALUES
(1, 'Xác Nhận Đặt Xe', 'Thông báo xác nhận việc đặt xe đã thành công.'),
(2, 'Nhắc Nhở Thuê Xe', 'Thông báo nhắc nhở về việc thuê xe sắp tới.'),
(3, 'Khuyến Mãi', 'Thông báo về các chương trình khuyến mãi mới hoặc giảm giá.'),
(4, 'Yêu Cầu Phản Hồi', 'Yêu cầu gửi phản hồi sau khi thuê xe.')
(5, 'Yêu cầu thuê xe', 'Yêu cầu thuê xe từ người dùng.')
;

-- --------------------------------------------------------

--
-- Table structure for table `loaixe`
--

DROP TABLE IF EXISTS `loaixe`;
CREATE TABLE IF NOT EXISTS `loaixe` (
  `ma_loai_xe` int NOT NULL AUTO_INCREMENT,
  `ten_loai_xe` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`ma_loai_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `loaixe`
--

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

-- --------------------------------------------------------

--
-- Table structure for table `nguoidung`
--

DROP TABLE IF EXISTS `nguoidung`;
CREATE TABLE IF NOT EXISTS `nguoidung` (
  `ma_nguoi_dung` int NOT NULL AUTO_INCREMENT,
  `ten_nguoi_dung` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mat_khau_hash` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ho_ten` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hinh_dai_dien` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '',
  `ngay_dang_ky` date NOT NULL,
  `so_dien_thoai` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dia_chi_nguoi_dung` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `loai_nguoi_dung` int DEFAULT '0',
  `trang_thai` int DEFAULT '1',
  PRIMARY KEY (`ma_nguoi_dung`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nguoidung`
--

INSERT INTO `nguoidung` (`ma_nguoi_dung`, `ten_nguoi_dung`, `mat_khau_hash`, `ho_ten`, `hinh_dai_dien`, `ngay_dang_ky`, `so_dien_thoai`, `dia_chi_nguoi_dung`, `loai_nguoi_dung`, `trang_thai`) VALUES
(1, 'user01', '$2b$10$72Ux6q4WA7r4gJsQKzbm9O/GZKs7Ned8p84YLnaF3u9HJahyL80LK', 'Nguyen Van A', 'avt1.jpg', '2023-12-01', '0123456789', '123 Nguyen Trai, Hanoi', 0, 1),
(2, 'user02', '$2b$10$72Ux6q4WA7r4gJsQKzbm9O/GZKs7Ned8p84YLnaF3u9HJahyL80LK', 'Tran Thi B', 'avt2.jpg', '2023-12-02', '9876543210', '456 Le Loi, Ho Chi Minh', 0, 1),
(100, 'Agent', '$2b$10$72Ux6q4WA7r4gJsQKzbm9O/GZKs7Ned8p84YLnaF3u9HJahyL80LK', 'Agent', 'agent.jpg', '2023-12-01', '0123456789', '123 Nguyen Trai, Hanoi', 1, 1),
(101, '1', '$2b$10$72Ux6q4WA7r4gJsQKzbm9O/GZKs7Ned8p84YLnaF3u9HJahyL80LK', 'Test User', 'img_101_1711777742824.jpg', '2024-03-29', '1234567890', '123 Test Street', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `thongbao`
--

DROP TABLE IF EXISTS `thongbao`;
CREATE TABLE IF NOT EXISTS `thongbao` (
  `ma_thong_bao` int NOT NULL AUTO_INCREMENT,
  `ma_nguoi_dung` int NOT NULL,
  `ma_loai_thong_bao` int NOT NULL,
  `tieu_de` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `noi_dung` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `trang_thai_xem` tinyint(1) NOT NULL DEFAULT '0',
  `ngay_tao` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ma_thong_bao`),
  KEY `ma_nguoi_dung_idx` (`ma_nguoi_dung`),
  KEY `ma_loai_thong_bao_idx` (`ma_loai_thong_bao`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `thongbao`
--

INSERT INTO `thongbao` (`ma_thong_bao`, `ma_nguoi_dung`, `ma_loai_thong_bao`, `tieu_de`, `noi_dung`, `trang_thai_xem`, `ngay_tao`) VALUES
(1, 1, 1, 'Xác Nhận Đặt Xe', 'Đơn đặt xe của bạn cho ngày 15/04/2024 đã được xác nhận. Chi tiết đơn hàng...', 0, '2024-04-05 15:56:24'),
(2, 2, 2, 'Nhắc Nhở Thuê Xe', 'Chúng tôi muốn nhắc bạn về việc thuê xe vào ngày 20/04/2024. Vui lòng...', 0, '2024-04-05 15:56:24'),
(3, 101, 3, 'Khuyến Mãi Hè', 'Hè này, tận hưởng mức giá ưu đãi khi thuê xe từ ngày 01/06/2024 đến ngày 31/08/2024...', 0, '2024-04-05 15:56:24'),
(4, 1, 4, 'Yêu Cầu Phản Hồi', 'Chúng tôi rất mong nhận được phản hồi về trải nghiệm thuê xe của bạn...', 0, '2024-04-05 15:56:24'),
(5, 1, 5, 'sdf', 'sdfsdfd', 0, '2024-04-05 16:54:17'),
(6, 1, 5, 'sdf', 'sdfsdfd', 0, '2024-04-05 16:55:55'),
(7, 2, 2, 'sdf', 'sdfsdfd', 0, '2024-04-05 16:55:55'),
(8, 100, 2, 'sdf', 'sdfsdfd', 0, '2024-04-05 16:55:55'),
(9, 101, 2, 'sdf', 'sdfsdfd', 0, '2024-04-05 16:55:55'),
(10, 1, 4, 'asdfadsf', 'asddfasdfda', 0, '2024-04-05 16:56:14'),
(11, 2, 4, 'asdfadsf', 'asddfasdfda', 0, '2024-04-05 16:56:14'),
(12, 100, 4, 'asdfadsf', 'asddfasdfda', 0, '2024-04-05 16:56:14'),
(13, 101, 4, 'asdfadsf', 'asddfasdfda', 0, '2024-04-05 16:56:14');

-- --------------------------------------------------------

--
-- Table structure for table `thongtincobanxe`
--

DROP TABLE IF EXISTS `thongtincobanxe`;
CREATE TABLE IF NOT EXISTS `thongtincobanxe` (
  `ma_thong_tin_co_ban` int NOT NULL AUTO_INCREMENT,
  `ma_xe` int NOT NULL,
  `model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hang_sx` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `so_cho` int DEFAULT NULL,
  PRIMARY KEY (`ma_thong_tin_co_ban`),
  KEY `ttcbxe_fk_1` (`ma_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `thongtincobanxe`
--

INSERT INTO `thongtincobanxe` (`ma_thong_tin_co_ban`, `ma_xe`, `model`, `hang_sx`, `so_cho`) VALUES
(1, 1, 'Corolla 2018', 'Toyota', 5),
(2, 2, 'Golf 2019', 'Volkswagen', 5),
(3, 3, 'Focus 2018', 'Ford', 5),
(4, 4, 'Accord 2019', 'Honda', 5),
(5, 5, 'X3 2020', 'BMW', 5),
(6, 6, 'Q5 2021', 'Audi', 5),
(7, 7, 'A-Class 2019', 'Mercedes-Benz', 5),
(8, 8, 'Rogue 2020', 'Nissan', 5),
(9, 9, 'Elantra 2021', 'Hyundai', 5),
(10, 10, 'CX-3 2021', 'Mazda', 5),
(11, 11, 'Sorento 2019', 'Kia', 7),
(12, 12, 'Malibu 2018', 'Chevrolet', 5),
(13, 13, 'Forester 2020', 'Subaru', 5),
(14, 14, 'Cherokee 2021', 'Jeep', 5),
(15, 15, 'Model S 2020', 'Tesla', 5),
(16, 16, 'RX 2021', 'Lexus', 5),
(17, 17, 'XC60 2019', 'Volvo', 5),
(18, 18, '500 2018', 'Fiat', 4),
(19, 19, '10000 2018', 'Fiat', 4),
(20, 20, 'T2024', '', 5),
(21, 21, 'T2024', 'Honda', 5);

-- --------------------------------------------------------

--
-- Table structure for table `thongtinkythuatxe`
--

DROP TABLE IF EXISTS `thongtinkythuatxe`;
CREATE TABLE IF NOT EXISTS `thongtinkythuatxe` (
  `ma_thong_tin_ky_thuat` int NOT NULL AUTO_INCREMENT,
  `ma_xe` int NOT NULL,
  `nam_san_xuat` int DEFAULT NULL,
  `mau_sac` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quang_duong` int DEFAULT NULL,
  `mo_ta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `nhien_lieu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ma_thong_tin_ky_thuat`),
  KEY `ttktxe_fk_1` (`ma_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `thongtinkythuatxe`
--

INSERT INTO `thongtinkythuatxe` (`ma_thong_tin_ky_thuat`, `ma_xe`, `nam_san_xuat`, `mau_sac`, `quang_duong`, `mo_ta`, `nhien_lieu`) VALUES
(1, 1, 2018, 'Trắng', 50000, 'Tiết kiệm nhiên liệu, động cơ ổn định', 'Xăng'),
(2, 2, 2019, 'Đen', 30000, 'Thiết kế gọn nhẹ, tiện lợi trong thành phố', 'Xăng'),
(3, 3, 2018, 'Xám', 45000, 'Phù hợp cho gia đình, không gian rộng rãi', 'Xăng'),
(4, 19, 2018, 'Đỏ', 25000, 'Thiết kế thể thao, dễ dàng di chuyển trong thành phố', 'Xăng'),
(5, 4, 2019, 'Bạc', 30000, 'Rộng rãi, thoải mái cho cả gia đình', NULL),
(6, 5, 2020, 'Xanh dương', 20000, 'SUV sang trọng với nhiều tính năng cao cấp', NULL),
(7, 6, 2021, 'Đen', 15000, 'Thiết kế đẹp, hiệu suất mạnh mẽ', NULL),
(8, 7, 2019, 'Trắng', 25000, 'Xe compact sang trọng với nội thất cao cấp', NULL),
(9, 8, 2020, 'Đỏ', 20000, 'SUV gia đình với không gian rộng lớn', NULL),
(10, 9, 2021, 'Xanh lá', 10000, 'Tiết kiệm nhiên liệu, thích hợp cho việc sử dụng hàng ngày', NULL),
(11, 10, 2021, 'Vàng', 12000, 'Nhỏ gọn, linh hoạt, thích hợp di chuyển trong thành phố', NULL),
(12, 11, 2019, 'Nâu', 40000, 'SUV đa năng, phù hợp với mọi lối sống', NULL),
(13, 12, 2018, 'Xám', 50000, 'Sedan thoải mái, tiện nghi với giá cả phải chăng', NULL),
(14, 13, 2020, 'Trắng', 35000, 'SUV đáng tin cậy, phù hợp cho mọi chuyến phiêu lưu', NULL),
(15, 14, 2021, 'Đen', 25000, 'SUV sẵn sàng cho mọi cuộc phiêu lưu', NULL),
(16, 15, 2020, 'Bạc', 5000, 'Sedan điện sang trọng với khả năng tự lái', NULL),
(17, 16, 2021, 'Xanh dương', 15000, 'Crossover sang trọng với nhiều tính năng an toàn', NULL),
(18, 17, 2019, 'Xanh lá', 22000, 'SUV an toàn, thoải mái với thiết kế Scandinavia', NULL),
(19, 18, 2018, 'Đỏ', 30000, 'Chiếc city car biểu tượng với thiết kế độc đáo', NULL),
(20, 20, NULL, NULL, NULL, 'This is a dummy description for testing purposes.This is a dummy description for testing purposes.This is a dummy description for testing purposes.', NULL),
(21, 21, NULL, NULL, NULL, 'This is a dummy description for testing purposes.This is a dummy description for testing purposes.This is a dummy description for testing purposes.', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `voucher`
--

DROP TABLE IF EXISTS `voucher`;
CREATE TABLE IF NOT EXISTS `voucher` (
  `ma_voucher` int NOT NULL AUTO_INCREMENT,
  `ma_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mo_ta` text COLLATE utf8mb4_unicode_ci,
  `phan_tram_giam` decimal(5,2) DEFAULT NULL,
  `so_tien_giam` decimal(10,2) DEFAULT NULL,
  `ngay_bat_dau` datetime NOT NULL,
  `ngay_ket_thuc` datetime NOT NULL,
  `dieukien_apdung` text COLLATE utf8mb4_unicode_ci,
  `trang_thai` int DEFAULT '1',
  PRIMARY KEY (`ma_voucher`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `voucher`
--

INSERT INTO `voucher` (`ma_voucher`, `ma_code`, `mo_ta`, `phan_tram_giam`, `so_tien_giam`, `ngay_bat_dau`, `ngay_ket_thuc`, `dieukien_apdung`, `trang_thai`) VALUES
(1, 'GIAM10', 'Giảm 10% giá thuê xe cho đơn hàng trên 2.000.000đ', '10.00', NULL, '2024-01-01 00:00:00', '2024-12-31 23:59:59', 'Áp dụng cho đơn hàng từ 2.000.000đ', 1),
(2, 'GIAM500K', 'Giảm ngay 500.000đ cho mỗi đơn hàng', NULL, '500000.00', '2024-01-01 00:00:00', '2024-06-30 23:59:59', 'Không áp dụng cùng lúc với ưu đãi khác', 1),
(3, 'TET2024', 'Ưu đãi Tết Nguyên Đán: Giảm 15% cho tất cả các đơn đặt xe', '15.00', NULL, '2024-01-20 00:00:00', '2024-02-28 23:59:59', 'Áp dụng cho mọi đơn hàng trong dịp Tết Nguyên Đán', 1);

-- --------------------------------------------------------

--
-- Table structure for table `xe`
--

DROP TABLE IF EXISTS `xe`;
CREATE TABLE IF NOT EXISTS `xe` (
  `ma_xe` int NOT NULL AUTO_INCREMENT,
  `ten_xe` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `trang_thai` int DEFAULT '0',
  `chu_so_huu` int NOT NULL,
  `ma_loai_xe` int NOT NULL,
  `gia_thue` decimal(10,2) DEFAULT '0.00',
  `ma_dia_chi` int DEFAULT NULL,
  `da_xac_minh` int DEFAULT '0',
  PRIMARY KEY (`ma_xe`),
  KEY `chu_so_huu` (`chu_so_huu`),
  KEY `ma_loai_xe` (`ma_loai_xe`),
  KEY `ma_dia_chi` (`ma_dia_chi`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `xe`
--

INSERT INTO `xe` (`ma_xe`, `ten_xe`, `trang_thai`, `chu_so_huu`, `ma_loai_xe`, `gia_thue`, `ma_dia_chi`, `da_xac_minh`) VALUES
(1, 'Toyota Corolla', 0, 100, 1, '300000.00', 1, 1),
(2, 'Volkswagen Golf', 0, 100, 4, '350000.00', 2, 1),
(3, 'Ford Focus', 0, 100, 4, '320000.00', 3, 1),
(4, 'Honda Accord', 0, 100, 1, '400000.00', 4, 1),
(5, 'BMW X3', 0, 100, 2, '1200000.00', 5, 1),
(6, 'Audi Q5', 0, 100, 2, '1300000.00', 6, 1),
(7, 'Mercedes A-Class', 0, 100, 1, '1100000.00', 7, 1),
(8, 'Nissan Rogue', 0, 100, 2, '500000.00', 8, 1),
(9, 'Hyundai Elantra', 0, 100, 1, '300000.00', 9, 1),
(10, 'Mazda CX-3', 0, 100, 2, '450000.00', 10, 1),
(11, 'Kia Sorento', 0, 100, 2, '600000.00', 1, 1),
(12, 'Chevrolet Malibu', 0, 100, 1, '350000.00', 2, 1),
(13, 'Subaru Forester', 0, 100, 2, '700000.00', 3, 0),
(14, 'Jeep Cherokee', 0, 100, 2, '800000.00', 4, 0),
(15, 'Tesla Model S', 0, 100, 1, '2000000.00', 5, 0),
(16, 'Lexus RX', 0, 100, 2, '1400000.00', 6, 0),
(17, 'Volvo XC60', 0, 100, 2, '1300000.00', 7, 0),
(18, 'Fiat 500', 0, 100, 4, '250000.00', 8, 0),
(19, 'Fiat 10000', 0, 100, 4, '250000.00', 8, 0),
(20, 'TEST CAR 3123123', 0, 101, 1, '5000000.00', 11, 1),
(21, 'TEST CAR 3123123', 0, 101, 1, '5000000.00', 12, 0);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `danhgia`
--
ALTER TABLE `danhgia`
  ADD CONSTRAINT `danhgia_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`),
  ADD CONSTRAINT `danhgia_fk_2` FOREIGN KEY (`ma_nguoi_dung`) REFERENCES `nguoidung` (`ma_nguoi_dung`);

--
-- Constraints for table `datxe`
--
ALTER TABLE `datxe`
  ADD CONSTRAINT `datxe_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`),
  ADD CONSTRAINT `datxe_fk_2` FOREIGN KEY (`ma_nguoi_dat_xe`) REFERENCES `nguoidung` (`ma_nguoi_dung`),
  ADD CONSTRAINT `datxe_fk_3` FOREIGN KEY (`dia_chi_nhan_xe`) REFERENCES `diachi` (`ma_dia_chi`),
  ADD CONSTRAINT `fk_voucher_datxe` FOREIGN KEY (`ma_voucher`) REFERENCES `voucher` (`ma_voucher`);

--
-- Constraints for table `hinhanh`
--
ALTER TABLE `hinhanh`
  ADD CONSTRAINT `hinhanh_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`);

--
-- Constraints for table `lichsuthue`
--
ALTER TABLE `lichsuthue`
  ADD CONSTRAINT `lichsuthue_ibfk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`),
  ADD CONSTRAINT `lichsuthue_ibfk_2` FOREIGN KEY (`ma_nguoi_thue`) REFERENCES `nguoidung` (`ma_nguoi_dung`);

--
-- Constraints for table `thongbao`
--
ALTER TABLE `thongbao`
  ADD CONSTRAINT `fk_ma_loai_thong_bao` FOREIGN KEY (`ma_loai_thong_bao`) REFERENCES `loaithongbao` (`ma_loai_thong_bao`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ma_nguoi_dung` FOREIGN KEY (`ma_nguoi_dung`) REFERENCES `nguoidung` (`ma_nguoi_dung`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `thongtincobanxe`
--
ALTER TABLE `thongtincobanxe`
  ADD CONSTRAINT `ttcbxe_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`);

--
-- Constraints for table `thongtinkythuatxe`
--
ALTER TABLE `thongtinkythuatxe`
  ADD CONSTRAINT `ttktxe_fk_1` FOREIGN KEY (`ma_xe`) REFERENCES `xe` (`ma_xe`);

--
-- Constraints for table `xe`
--
ALTER TABLE `xe`
  ADD CONSTRAINT `xe_ibfk_1` FOREIGN KEY (`chu_so_huu`) REFERENCES `nguoidung` (`ma_nguoi_dung`),
  ADD CONSTRAINT `xe_ibfk_2` FOREIGN KEY (`ma_loai_xe`) REFERENCES `loaixe` (`ma_loai_xe`),
  ADD CONSTRAINT `xe_ibfk_3` FOREIGN KEY (`ma_dia_chi`) REFERENCES `diachi` (`ma_dia_chi`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
