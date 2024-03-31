const db = require('../../config/db');

exports.createBooking = async (req, res) => {
    const { ngay_bat_dau, ngay_ket_thuc, dia_chi_nhan_xe, tong_tien_thue, ma_xe, ma_nguoi_dat_xe,ma_chu_xe, ghi_chu, giam_gia } = req.body;
    const trang_thai_dat_xe = 0;
  
    try {
      const query = `
        INSERT INTO datxe (ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, tong_tien_thue, ma_xe, ma_nguoi_dat_xe, ma_chu_xe, ghi_chu, giam_gia)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `;
      const values = [ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, tong_tien_thue, ma_xe, ma_nguoi_dat_xe,ma_chu_xe, ghi_chu, giam_gia];
  
      // Use db.query instead of db.execute
      db.query(query, values, (error, results, fields) => {
        if (error) {
          console.log(error.message);
          res.status(500).json({ message: "Error creating booking", error: error.message });
          return;
        }
  
        // Assuming your MySQL version returns an insertId on successful insertion
        res.status(201).json({ message: "Booking created successfully", bookingId: results.insertId });
  
        // Schedule a task to cancel the booking if not confirmed after 24 hours
        const bookingId = results.insertId;
        scheduleCancellationTask(bookingId);
      });
    } catch (error) {
      res.status(500).json({ message: "Error creating booking", error: error.message });
    }
  };

function scheduleCancellationTask(bookingId) {
    // Calculate when 24 hours from now will be in terms of a cron schedule
    let oneDayLater = new Date(new Date().getTime() + 24 * 60 * 60 * 1000);
    let minute = oneDayLater.getMinutes();
    let hour = oneDayLater.getHours();
    let dayOfMonth = oneDayLater.getDate();
    let month = oneDayLater.getMonth() + 1; // +1 because months are 0-indexed
    let dayOfWeek = "*"; // Every day of the week
  
    let cronSchedule = `${minute} ${hour} ${dayOfMonth} ${month} ${dayOfWeek}`;
  
    require('node-cron').schedule(cronSchedule, () => {
      console.log(`Checking booking ID ${bookingId} for cancellation.`);
      checkBookingAndCancelIfUnconfirmed(bookingId);
    }, {
      scheduled: true,
      timezone: "Asia/Ho_Chi_Minh"
    });
  }
  
  function checkBookingAndCancelIfUnconfirmed(bookingId) {
    const query = `
      SELECT trang_thai_dat_xe FROM datxe
      WHERE id = ? AND trang_thai_dat_xe = 0;
    `;
  
    db.query(query, [bookingId], (error, results) => {
      if (error) {
        return console.error('Error checking booking status:', error);
      }
  
      if (results.length > 0) {
        // The booking exists and is unconfirmed, so cancel it
        const updateQuery = `
          UPDATE datxe
          SET trang_thai_dat_xe = -1
          WHERE id = ?;
        `;
  
        db.query(updateQuery, [bookingId], (updateError, updateResults) => {
          if (updateError) {
            return console.error('Error cancelling booking:', updateError);
          }
  
          console.log(`Booking ID ${bookingId} has been cancelled.`);
        });
      } else {
        console.log(`Booking ID ${bookingId} is either confirmed or does not exist.`);
      }
    });
  }

  exports.confirmBooking = async (req, res) => {
    const { ma_dat_xe } = req.body;
    const trang_thai_dat_xe = 1;
  
    try {
      // First, update the booking status
      const updateBookingQuery = `
        UPDATE datxe
        SET trang_thai_dat_xe = ?
        WHERE ma_dat_xe = ?
      `;
      const [bookingResult] = await db.query(updateBookingQuery, [trang_thai_dat_xe, ma_dat_xe]);
  
      if (bookingResult.affectedRows === 0) {
        return res.status(404).json({ message: "Booking not found" });
      }
  
      // Then, update the vehicle status
      const updateVehicleQuery = `
        UPDATE xe
        SET trang_thai = 1
        WHERE ma_xe = (SELECT ma_xe FROM datxe WHERE ma_dat_xe = ?)
      `;
      await db.query(updateVehicleQuery, [ma_dat_xe]);
  
      res.json({ message: "Booking confirmed successfully" });
    } catch (error) {
      res.status(500).json({ message: "Error confirming booking", error: error.message });
    }
  };
  
  exports.completeBooking = async (req, res) => {
    const { ma_dat_xe } = req.body;
    const trang_thai_dat_xe = 2; // Assuming "2" indicates completed
  
    try {
      // First, update the booking status
      const updateBookingQuery = `
        UPDATE datxe
        SET trang_thai_dat_xe = ?
        WHERE ma_dat_xe = ?
      `;
      const [bookingResult] = await db.query(updateBookingQuery, [trang_thai_dat_xe, ma_dat_xe]);
  
      if (bookingResult.affectedRows === 0) {
        return res.status(404).json({ message: "Booking not found" });
      }
  
      // Then, update the vehicle status
      const updateVehicleQuery = `
        UPDATE xe
        SET trang_thai = 0
        WHERE ma_xe = (SELECT ma_xe FROM datxe WHERE ma_dat_xe = ?)
      `;
      await db.query(updateVehicleQuery, [ma_dat_xe]);
  
      res.json({ message: "Booking completed successfully" });
    } catch (error) {
      res.status(500).json({ message: "Error completing booking", error: error.message });
    }
  };
  
  exports.cancelBooking = async (req, res) => {
    const { ma_dat_xe } = req.body;
    const trang_thai_dat_xe = -1;
  
    try {
      // First, update the booking status
      const updateBookingQuery = `
        UPDATE datxe
        SET trang_thai_dat_xe = ?
        WHERE ma_dat_xe = ?
      `;
      const [bookingResult] = await db.query(updateBookingQuery, [trang_thai_dat_xe, ma_dat_xe]);
  
      if (bookingResult.affectedRows === 0) {
        return res.status(404).json({ message: "Booking not found" });
      }
  
      // Then, update the vehicle status
      const updateVehicleQuery = `
        UPDATE xe
        SET trang_thai = 0
        WHERE ma_xe = (SELECT ma_xe FROM datxe WHERE ma_dat_xe = ?)
      `;
      await db.query(updateVehicleQuery, [ma_dat_xe]);
  
      res.json({ message: "Booking canceled successfully" });
    } catch (error) {
      res.status(500).json({ message: "Error canceling booking", error: error.message });
    }
  };
  
  exports.getBookingsByUserId = async (req, res) => {
    const { ma_nguoi_dat_xe } = req.params; // Assuming the user ID is sent as a URL parameter
  
    try {
      const query = `
        SELECT * FROM datxe
        WHERE ma_nguoi_dat_xe = ?
      `;
      // Use db.query with a callback instead of awaiting db.execute
      db.query(query, [ma_nguoi_dat_xe], (error, bookings, fields) => {
        if (error) {
          return res.status(500).json({ message: "Error retrieving bookings", error: error.message });
        }
  
        if (bookings.length === 0) {
          return res.status(404).json({ message: "No bookings found for this user" });
        }
  
        res.json({ bookings });
      });
    } catch (error) {
      // This catch block may not be necessary since db.query uses a callback and won't throw an exception here.
      // However, if there's additional asynchronous code that might throw, it can be kept.
      res.status(500).json({ message: "Error retrieving bookings", error: error.message });
    }
  };
  
  exports.checkBookable = async (req, res) => {
    const { ma_nguoi_dat_xe } = req.query; // Assuming the user ID is passed as a query parameter
  
    const query = `
      SELECT COUNT(*) AS bookingCount
      FROM datxe
      WHERE ma_nguoi_dat_xe = ? AND trang_thai_dat_xe = 1
    `;
  
    db.query(query, [ma_nguoi_dat_xe], (error, results) => {
      if (error) {
        return res.status(500).json({ message: "Error checking bookability", error: error.message });
      }
  
      const isBookable = results[0].bookingCount === 0; // true if no active bookings, false otherwise
      res.json({ isBookable });
    });
  };
  
  exports.getManageBooking = async (req, res) => {


  };
  
  /*
  Write endpoint, the endpoint receive ma_chu_xe param, that function getall the datxe where ma_chu_xe = ma_chu_xe, and some related info from other table i list below:
  exports.getManageBooking = async (req, res) => {
    What i need: 
         ngay_bat_dau
        ngay_ket_thuc
        trang_thai_dat_xe
        dia_chi
        tong_tien_thue
        ghi_chu
        ho_ten AS renter_name
        dia_chi AS renter_address
        ten_xe
        hinh AS vehicle_image


  };
  
  database:
CREATE TABLE IF NOT EXISTS `datxe` (
  `ma_dat_xe` int NOT NULL AUTO_INCREMENT,
  `ngay_bat_dau` date NOT NULL,
  `ngay_ket_thuc` date NOT NULL,
  `trang_thai_dat_xe` int DEFAULT 0,
  `dia_chi_nhan_xe` int DEFAULT NULL,
  `tong_tien_thue` decimal(10,2) DEFAULT NULL,
  `ma_xe` int DEFAULT NULL,
  `ma_nguoi_dat_xe` int NOT NULL,
  `ma_chu_xe` int NOT NULL,
  `ghi_chu` text NULL,
  `giam_gia` int NULL,
  PRIMARY KEY (`ma_dat_xe`),
  KEY `datxe_fk_1` (`ma_xe`),
  KEY `datxe_fk_2` (`ma_nguoi_dat_xe`),
  KEY `datxe_fk_3` (`dia_chi_nhan_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `diachi` (
  `ma_dia_chi` int NOT NULL AUTO_INCREMENT,
  `dia_chi` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `thanh_pho` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quoc_gia` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `zip_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ma_dia_chi`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `hinhanh` (
  `ma_hinh_anh` int NOT NULL AUTO_INCREMENT,
  `loai_hinh` int NOT NULL,
  `hinh` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ma_xe` int NOT NULL,
  PRIMARY KEY (`ma_hinh_anh`),
  KEY `hinhanh_fk_1` (`ma_xe`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `nguoidung` (
  `ma_nguoi_dung` int NOT NULL AUTO_INCREMENT,
  `ten_nguoi_dung` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mat_khau_hash` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ho_ten` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hinh_dai_dien` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '',
  `ngay_dang_ky` date NOT NULL,
  `so_dien_thoai` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dia_chi_nguoi_dung` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `loai_nguoi_dung` int DEFAULT '0',
  `trang_thai` int DEFAULT '1',
  PRIMARY KEY (`ma_nguoi_dung`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
DROP TABLE IF EXISTS `xe`;
CREATE TABLE IF NOT EXISTS `xe` (
  `ma_xe` int NOT NULL AUTO_INCREMENT,
  `ten_xe` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `trang_thai` int DEFAULT 0,
  `chu_so_huu` int NOT NULL,
  `ma_loai_xe` int NOT NULL,
  `gia_thue` decimal(10,2) DEFAULT 0,
  `ma_dia_chi` int DEFAULT NULL,
  `da_xac_minh` int DEFAULT '0',
  PRIMARY KEY (`ma_xe`),
  KEY `chu_so_huu` (`chu_so_huu`),
  KEY `ma_loai_xe` (`ma_loai_xe`),
  KEY `ma_dia_chi` (`ma_dia_chi`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
  */
  