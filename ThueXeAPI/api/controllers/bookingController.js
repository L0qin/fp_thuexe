const { json } = require('body-parser');
const db = require('../../config/db');

exports.getAllBookings = (req, res) => {
    db.query('SELECT * FROM datxe', (err, result) => {
        if (err) {
            console.error('Error fetching all bookings:', err);
            return res.status(500).json({ message: 'Error fetching all bookings' });
        }
        res.json(result);
    });
};


exports.getBookingById = (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM datxe WHERE ma_dat_xe = ?', [id], (err, result) => {
        if (err) {
            console.error(`Error fetching booking with ID ${id}:`, err);
            return res.status(500).json({ message: 'Error fetching booking' });
        }
        res.json(result[0]);
    });
};

exports.createBooking = (req, res) => {
    // Assuming dia_chi_nhan_xe is now an integer referencing DiaChi.ma_dia_chi
    const { ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, tong_tien_thue, ma_xe, ma_nguoi_dat_xe } = req.body;
    
    db.query('INSERT INTO datxe (ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, tong_tien_thue, ma_xe, ma_nguoi_dat_xe) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, tong_tien_thue, ma_xe, ma_nguoi_dat_xe],
        (err, result) => {
            if (err) {
                console.error('Error creating booking:', err);
                return res.status(500).json({ message: 'Error creating booking' });
            }
            res.status(201).json({ message: 'Booking created successfully', id: result.insertId });
        }
    );
};


exports.closeBooking = (req, res) => {
    const { id } = req.params;
    db.query('UPDATE datxe SET trang_thai_dat_xe = 1 WHERE ma_dat_xe = ?', [id], (err, result) => {
        if (err) {
            console.error(`Error closing booking with ID ${id}:`, err);
            return res.status(500).json({ message: 'Error closing booking' });
        }
        res.json({ message: 'Booking closed successfully' });
    });
};


exports.updateBooking = (req, res) => {
    const { id } = req.params;
    const { ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, tong_tien_thue, ma_xe, ma_nguoi_dat_xe } = req.body;
    
    db.query('UPDATE datxe SET ngay_bat_dau = ?, ngay_ket_thuc = ?, trang_thai_dat_xe = ?, dia_chi_nhan_xe = ?, tong_tien_thue = ?, ma_xe = ?, ma_nguoi_dat_xe = ? WHERE ma_dat_xe = ?',
        [ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, tong_tien_thue, ma_xe, ma_nguoi_dat_xe, id],
        (err) => {
            if (err) {
                console.error(`Error updating booking with ID ${id}:`, err);
                return res.status(500).json({ message: 'Error updating booking' });
            }
            res.json({ message: 'Booking updated successfully', id });
        }
    );
};

exports.deleteBooking = (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM datxe WHERE ma_dat_xe = ?', [id], (err) => {
        if (err) {
            console.error(`Error deleting booking with ID ${id}:`, err);
            return res.status(500).json({ message: 'Error deleting booking' });
        }
        res.json({ message: 'Booking deleted successfully', id });
    });
};

exports.getBookingsByUserId = (req, res) => {
    const { ma_nguoi_dat_xe } = req.params;
    db.query('SELECT * FROM datxe WHERE ma_nguoi_dat_xe = ?', [ma_nguoi_dat_xe], (err, results) => {
        if (err) {
            console.error(`Error fetching bookings for user ID ${ma_nguoi_dat_xe}:`, err);
            return res.status(500).json({ message: 'Error fetching bookings for user' });
        }
        res.json(results);
    });
};
