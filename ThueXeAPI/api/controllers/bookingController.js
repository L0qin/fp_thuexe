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

  exports.confirmBooking = (req, res) => {
    const { ma_dat_xe } = req.params;
    const trang_thai_dat_xe = 1;
  
    // First, update the booking status
    const updateBookingQuery = `
      UPDATE datxe
      SET trang_thai_dat_xe = ?
      WHERE ma_dat_xe = ?
    `;
    db.query(updateBookingQuery, [trang_thai_dat_xe, ma_dat_xe], (error, bookingResult) => {
        if (error) {
            console.log(error.message);
            return res.status(500).json({ message: "Error confirming booking", error: error.message });
        }
        
        console.log(bookingResult.affectedRows);
        if (bookingResult.affectedRows === 0) {
            return res.status(404).json({ message: "Booking not found" });
        }

        // Then, update the vehicle status
        const updateVehicleQuery = `
          UPDATE xe
          SET trang_thai = 1
          WHERE ma_xe = (SELECT ma_xe FROM datxe WHERE ma_dat_xe = ?)
        `;
        db.query(updateVehicleQuery, [ma_dat_xe], (error) => {
            if (error) {
                console.log(error.message);
                return res.status(500).json({ message: "Error confirming booking", error: error.message });
            }
            res.json({ message: "Booking confirmed successfully" });
        });
    });
};

exports.completeBooking = (req, res) => {
  const { ma_dat_xe } = req.params;
  const trang_thai_dat_xe = 2; // Assuming "2" indicates completed

  // First, update the booking status
  const updateBookingQuery = `
      UPDATE datxe
      SET trang_thai_dat_xe = ?
      WHERE ma_dat_xe = ?
  `;
  db.query(updateBookingQuery, [trang_thai_dat_xe, ma_dat_xe], (error, bookingResult) => {
      if (error) {
          return res.status(500).json({ message: "Error completing booking", error: error.message });
      }

      if (bookingResult.affectedRows === 0) {
          return res.status(404).json({ message: "Booking not found" });
      }

      // Then, update the vehicle status
      const updateVehicleQuery = `
          UPDATE xe
          SET trang_thai = 0
          WHERE ma_xe = (SELECT ma_xe FROM datxe WHERE ma_dat_xe = ?)
      `;
      db.query(updateVehicleQuery, [ma_dat_xe], (error) => {
          if (error) {
              return res.status(500).json({ message: "Error completing booking", error: error.message });
          }
          res.json({ message: "Booking completed successfully" });
      });
  });
};

exports.cancelBooking = (req, res) => {
  const { ma_dat_xe } = req.params;
  const trang_thai_dat_xe = -1; // Assuming "-1" indicates canceled

  // First, update the booking status
  const updateBookingQuery = `
      UPDATE datxe
      SET trang_thai_dat_xe = ?
      WHERE ma_dat_xe = ?
  `;
  db.query(updateBookingQuery, [trang_thai_dat_xe, ma_dat_xe], (error, bookingResult) => {
      if (error) {
          return res.status(500).json({ message: "Error canceling booking", error: error.message });
      }

      if (bookingResult.affectedRows === 0) {
          return res.status(404).json({ message: "Booking not found" });
      }

      // Then, update the vehicle status
      const updateVehicleQuery = `
          UPDATE xe
          SET trang_thai = 0
          WHERE ma_xe = (SELECT ma_xe FROM datxe WHERE ma_dat_xe = ?)
      `;
      db.query(updateVehicleQuery, [ma_dat_xe], (error) => {
          if (error) {
              return res.status(500).json({ message: "Error canceling booking", error: error.message });
          }
          res.json({ message: "Booking canceled successfully" });
      });
  });
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
  
  exports.getManageBooking = (req, res) => {
    const { ma_chu_xe } = req.params;

    const query = `
        SELECT 
            dx.ma_dat_xe,
            dx.ngay_bat_dau,
            dx.ngay_ket_thuc,
            dx.trang_thai_dat_xe,
            dc.dia_chi,
            dx.tong_tien_thue,
            dx.ghi_chu,
            nd.ho_ten AS renter_name,
            nd.dia_chi_nguoi_dung AS renter_address,
            x.ten_xe,
            nd.hinh_dai_dien AS renter_image
        FROM datxe dx
        JOIN xe x ON dx.ma_xe = x.ma_xe
        JOIN diachi dc ON x.ma_dia_chi = dc.ma_dia_chi
        JOIN nguoidung nd ON dx.ma_nguoi_dat_xe = nd.ma_nguoi_dung
        LEFT JOIN hinhanh ha ON x.ma_xe = ha.ma_xe
        WHERE dx.ma_chu_xe = ?
        GROUP BY dx.ma_dat_xe
        ORDER BY dx.ngay_bat_dau DESC
    `;

    db.query(query, [ma_chu_xe], (error, results) => {
        if (error) {
            return res.status(500).json({ message: "Error fetching booking data", error: error.message });
        }

        if (results.length > 0) {
            res.json({ success: true, data: results });
        } else {
            res.status(404).json({ success: false, message: 'No bookings found for this owner.' });
        }
    });
};


