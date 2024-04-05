const db = require('../../config/db');
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken');
const secretKey = process.env.SECRET_KEY;


exports.registerUser = async (req, res) => {
    const { username, password, fullName, phoneNumber, address, userType = 0 } = req.body; // userType is set to 0 by default

    if (!username || !password || !fullName || !phoneNumber) {
        return res.status(400).json({ message: 'All fields are required' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    
    // Current date for ngay_dang_ky
    const currentDate = new Date().toISOString().slice(0, 10);

    // Check if the user already exists
    db.query('SELECT * FROM nguoidung WHERE ten_nguoi_dung = ?', [username], (err, results) => {
        if (err) {
            console.error('Error querying the database', err);
            return res.status(500).json({ message: 'Database query error' });
        }
        
        if (results.length > 0) {
            return res.status(409).json({ message: 'Username already exists' });
        } else {
            // Insert the new user into the database, adjusting for the new schema
            const query = 'INSERT INTO nguoidung (ten_nguoi_dung, mat_khau_hash, ho_ten, so_dien_thoai, dia_chi_nguoi_dung, ngay_dang_ky, loai_nguoi_dung) VALUES (?, ?, ?, ?, ?, ?, ?)';
            db.query(query, [username, hashedPassword, fullName, phoneNumber, address, currentDate, userType], (err, result) => {
                if (err) {
                    console.error('Error inserting user into database', err);
                    return res.status(500).json({ message: 'Database insertion error' });
                }
                res.status(201).json({ message: 'User registered successfully' });
            });
        }
    });
};

exports.loginUser = (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ message: 'Username and password are required' });
    }

    db.query('SELECT * FROM nguoidung WHERE ten_nguoi_dung = ?', [username], async (err, results) => {
        if (err) {
            console.error('Error querying the database', err);
            return res.status(500).json({ message: 'Database query error' });
        }
        
        if (results.length === 0) {
            return res.status(401).json({ message: 'Invalid username or password' });
        }
        
        const user = results[0];

        // Check if user is deactivated (trang_thai of -1)
        if (user.trang_thai === -1) {
            return res.status(403).json({ message: 'This account has been deactivated' });
        }

        // Compare the hashed password
        const match = await bcrypt.compare(password, user.mat_khau_hash);
        if (!match) {
            return res.status(401).json({ message: 'Invalid username or password' });
        }
        
        // Generate a token
        const token = jwt.sign({ userId: user.ma_nguoi_dung }, process.env.SECRET_KEY, { expiresIn: '100h' });
        res.json({ token, userId: user.ma_nguoi_dung });
    });
};


exports.getUser = (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM nguoidung WHERE ma_nguoi_dung = ?', [id], (err, result) => {
        if (err) {
            console.error("Error fetching user: ", err);
            return res.status(500).json({ message: 'Error fetching user' });
        }
        if (result.length === 0) {
            return res.status(404).json({ message: 'User not found' });
        }
        // Optionally, filter out sensitive information before sending it back
        const user = {
            ...result[0],
            mat_khau_hash: undefined, // Hide password hash
        };
        res.json(user);
    });
};

exports.modifyUser = (req, res) => {
    const { id } = req.params;
    const { fullName, phoneNumber, address } = req.body;
    let queryParts = [];
    let queryParams = [];

    // Check and append each field if it's provided
    if (fullName !== undefined) {
        queryParts.push("ho_ten = ?");
        queryParams.push(fullName);
    }
    if (phoneNumber !== undefined) {
        queryParts.push("so_dien_thoai = ?");
        queryParams.push(phoneNumber);
    }
    if (address !== undefined) {
        queryParts.push("dia_chi_nguoi_dung = ?");
        queryParams.push(address);
    }

    // If no fields provided, return an error
    if (queryParts.length === 0) {
        return res.status(400).json({ message: 'No fields provided for update' });
    }

    // Combine query parts and add the WHERE clause
    let query = `UPDATE nguoidung SET ${queryParts.join(', ')} WHERE ma_nguoi_dung = ?`;
    queryParams.push(id);

    // Execute the update
    db.query(query, queryParams, (err, results) => {
        if (err) {
            console.error("Error updating user: ", err);
            return res.status(500).json({ message: 'Error updating user' });
        }

        if (results.affectedRows > 0) {
            res.json({ message: 'User updated successfully', id });
        } else {
            res.status(404).json({ message: 'User not found' });
        }
    });
};

exports.getUserNotification = (req, res) => {
    const userId = req.params.id;

    const query = `
        SELECT tb.ma_thong_bao, tb.ma_nguoi_dung, tb.tieu_de, tb.noi_dung, tb.trang_thai_xem, tb.ngay_tao, lt.ten_loai, lt.mo_ta 
        FROM thongbao tb
        JOIN loaithongbao lt ON tb.ma_loai_thong_bao = lt.ma_loai_thong_bao
        WHERE tb.ma_nguoi_dung = ?
        ORDER BY tb.ngay_tao DESC
    `;

    db.query(query, [userId], (error, results) => {
        if (error) {
            console.error('Failed to retrieve user notifications:', error);
            return res.status(500).json({
                success: false,
                message: 'Internal server error'
            });
        }
        console.log(results);
        res.json(results);
    });
};

exports.getUserNewNotificationNumber = (req, res) => {
    const userId = req.params.id;

    const query = `
        SELECT COUNT(*) AS newNotificationsCount
        FROM thongbao
        WHERE ma_nguoi_dung = ? AND trang_thai_xem = 0 AND ma_loai_thong_bao = 5
    `;

    db.query(query, [userId], (error, results) => {
        if (error) {
            console.error('Failed to retrieve user new notification count:', error);
            return res.status(500).json({
                success: false,
                message: 'Internal server error'
            });
        }
        
        // Assuming the results array is not empty, results[0] will have our count
        const count = results[0].newNotificationsCount;
        res.json({
            success: true,
            newNotificationsCount: count
        });
    });
};

