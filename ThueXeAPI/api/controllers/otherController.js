const db = require('../../config/db');
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken');
const secretKey = process.env.SECRET_KEY;

exports.getTerm = (req, res) => {
    // Extract the id parameter from the request
    const termId = req.params.id;

    // SQL query to select the term from the database
    const query = 'SELECT * FROM dieukhoansudung WHERE ma_dieu_khoan = ?';

    db.query(query, [termId], (error, results) => {
        if (error) {
            // If there is an error with the database query, return an error response
            return res.status(500).json({
                message: 'Error fetching the term from the database',
                error: error
            });
        }

        if (results.length === 0) {
            // If no term is found with the given id, return a 404 Not Found response
            return res.status(404).json({
                message: 'No term found with the given ID'
            });
        }

        // If the term is found, return it in the response
        res.json({
            message: 'Term fetched successfully',
            term: results[0]
        });
    });
};


exports.getVouchers = (req, res) => {
    // Get the current date in the format compatible with your database
    const currentDate = new Date().toISOString().slice(0, 19).replace('T', ' ');

    // SQL query to select all active vouchers that are within the valid date range
    const query = `SELECT * FROM voucher WHERE trang_thai = 1 AND ngay_bat_dau <= ? AND ngay_ket_thuc >= ?`;

    db.query(query, [currentDate, currentDate], (error, results) => {
        if (error) {
            // If there is an error with the database query, return an error response
            return res.status(500).json({
                message: 'Error fetching vouchers from the database',
                error: error
            });
        }

        // If vouchers are found, return them in the response
        res.json({
            message: 'Vouchers fetched successfully',
            vouchers: results
        });
    });
};



