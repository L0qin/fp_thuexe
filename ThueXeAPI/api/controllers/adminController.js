const db = require('../../config/db');
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken');
const secretKey = process.env.JWT_SECRET;

exports.loginAdmin = (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ message: 'Username and password are required' });
    }

    db.query('SELECT * FROM nguoidung WHERE ten_nguoi_dung = ? and loai_nguoi_dung = 1', [username], async (err, results) => {
        if (err) {
            console.error('Error querying the database', err);
            return res.status(500).json({ message: 'Database query error' });
        }
        
        if (results.length === 0) {
            return res.status(401).json({ message: 'Invalid username or password' });
        }
        
        const user = results[0];

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

exports.getAdmin = (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM nguoidung WHERE ma_nguoi_dung = ? and loai_nguoi_dung = 1', [id], (err, result) => {
        if (err) {
            console.error("Error fetching user: ", err);
            return res.status(500).json({ message: 'Error fetching user' });
        }
        if (result.length === 0) {
            return res.status(404).json({ message: 'Admin not found' });
        }
        // Optionally, filter out sensitive information before sending it back
        const user = {
            ...result[0]
        };
        res.json(user);
    });
};

exports.getAllUnverifiedVehicles = (req, res) => {
    const query = `
        SELECT 
            xe.ma_xe, xe.ten_xe, xe.trang_thai, xe.gia_thue, xe.chu_so_huu, xe.ma_loai_xe,
            nguoidung.ho_ten AS owner_name, nguoidung.hinh_dai_dien AS owner_avatar,
            ThongTinCoBanXe.model, ThongTinCoBanXe.hang_sx, ThongTinKyThuatXe.mo_ta, ThongTinCoBanXe.so_cho,
            DiaChi.dia_chi, DiaChi.thanh_pho, DiaChi.quoc_gia, DiaChi.zip_code,
            GROUP_CONCAT(DISTINCT CASE WHEN hinhanh.loai_hinh != 3 THEN hinhanh.hinh END SEPARATOR ',') AS vehicle_images,
            GROUP_CONCAT(DISTINCT CASE WHEN hinhanh.loai_hinh = 3 THEN hinhanh.hinh END SEPARATOR ',') AS paper_images
        FROM xe
        INNER JOIN ThongTinCoBanXe ON xe.ma_xe = ThongTinCoBanXe.ma_xe
        INNER JOIN ThongTinKyThuatXe ON xe.ma_xe = ThongTinKyThuatXe.ma_xe
        LEFT JOIN DiaChi ON xe.ma_dia_chi = DiaChi.ma_dia_chi
        LEFT JOIN nguoidung ON xe.chu_so_huu = nguoidung.ma_nguoi_dung
        LEFT JOIN hinhanh ON xe.ma_xe = hinhanh.ma_xe
        WHERE xe.da_xac_minh = 0
        GROUP BY xe.ma_xe`;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching vehicles:', err);
            return res.status(500).json({ message: 'Error fetching vehicles' });
        }

        const vehicles = results.map(vehicleJson => {
            // Splitting the vehicle images and paper images into separate arrays
            const vehicleImages = vehicleJson.vehicle_images ? vehicleJson.vehicle_images.split(',') : [];
            const paperImages = vehicleJson.paper_images ? vehicleJson.paper_images.split(',') : [];
            return {
                vehicleId: vehicleJson.ma_xe,
                vehicleName: vehicleJson.ten_xe,
                status: vehicleJson.trang_thai,
                model: vehicleJson.model,
                manufacturer: vehicleJson.hang_sx,
                description: vehicleJson.mo_ta,
                address: {
                    streetAddress: vehicleJson.dia_chi,
                    city: vehicleJson.thanh_pho,
                    country: vehicleJson.quoc_gia,
                    zipCode: vehicleJson.zip_code,
                },
                rentalPrice: vehicleJson.gia_thue,
                seats: vehicleJson.so_cho,
                ownerId: vehicleJson.chu_so_huu,
                vehicleTypeId: vehicleJson.ma_loai_xe,
                owner: {
                    name: vehicleJson.owner_name,
                    avatar: vehicleJson.owner_avatar,
                },
                images: vehicleImages,
                mainImage: vehicleImages.length > 0 ? vehicleImages[0] : null,
                paperImages: paperImages, // Added field for paper images
            };
        });
        res.json(vehicles);
    });
};


exports.getAllVehicles = (req, res) => {
    // Modified query to fetch paper images in a separate row grouping
    const query = `
        SELECT 
            xe.ma_xe, xe.ten_xe, xe.trang_thai, xe.gia_thue, xe.chu_so_huu, xe.ma_loai_xe, xe.da_xac_minh,
            nguoidung.ho_ten AS owner_name, nguoidung.hinh_dai_dien AS owner_avatar,
            ThongTinCoBanXe.model, ThongTinCoBanXe.hang_sx, ThongTinKyThuatXe.mo_ta, ThongTinCoBanXe.so_cho,
            DiaChi.dia_chi, DiaChi.thanh_pho, DiaChi.quoc_gia, DiaChi.zip_code,
            GROUP_CONCAT(DISTINCT CASE WHEN hinhanh.loai_hinh != 3 THEN hinhanh.hinh END SEPARATOR ',') AS vehicle_images,
            GROUP_CONCAT(DISTINCT CASE WHEN hinhanh.loai_hinh = 3 THEN hinhanh.hinh END SEPARATOR ',') AS paper_images
        FROM xe
        INNER JOIN ThongTinCoBanXe ON xe.ma_xe = ThongTinCoBanXe.ma_xe
        INNER JOIN ThongTinKyThuatXe ON xe.ma_xe = ThongTinKyThuatXe.ma_xe
        LEFT JOIN DiaChi ON xe.ma_dia_chi = DiaChi.ma_dia_chi
        LEFT JOIN nguoidung ON xe.chu_so_huu = nguoidung.ma_nguoi_dung
        LEFT JOIN hinhanh ON xe.ma_xe = hinhanh.ma_xe
        GROUP BY xe.ma_xe`;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching vehicles:', err);
            return res.status(500).json({ message: 'Error fetching vehicles' });
        }

        const vehicles = results.map(vehicleJson => {
            const vehicleImages = vehicleJson.vehicle_images ? vehicleJson.vehicle_images.split(',') : [];
            const paperImages = vehicleJson.paper_images ? vehicleJson.paper_images.split(',') : [];
            return {
                vehicleId: vehicleJson.ma_xe,
                vehicleName: vehicleJson.ten_xe,
                status: vehicleJson.trang_thai,
                verification: vehicleJson.da_xac_minh,
                model: vehicleJson.model,
                manufacturer: vehicleJson.hang_sx,
                description: vehicleJson.mo_ta,
                address: {
                    streetAddress: vehicleJson.dia_chi,
                    city: vehicleJson.thanh_pho,
                    country: vehicleJson.quoc_gia,
                    zipCode: vehicleJson.zip_code,
                },
                rentalPrice: vehicleJson.gia_thue,
                seats: vehicleJson.so_cho,
                ownerId: vehicleJson.chu_so_huu,
                vehicleTypeId: vehicleJson.ma_loai_xe,
                owner: {
                    name: vehicleJson.owner_name,
                    avatar: vehicleJson.owner_avatar,
                },
                images: vehicleImages,
                mainImage: vehicleImages.length > 0 ? vehicleImages[0] : null,
                paperImages: paperImages, // Added field for paper images
            };
        });

        res.json(vehicles);
    });
};



// Function to approve a vehicle
exports.approveVehicle = (req, res) => {
    const { ma_xe } = req.params; // Assuming you're passing vehicle ID as a route parameter

    const sql = 'UPDATE xe SET da_xac_minh = 1 WHERE ma_xe = ?';

    db.query(sql, [ma_xe], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Vehicle not found' });
        }
        res.json({ message: 'Vehicle approved successfully' });
    });
};

// Function to deny a vehicle
exports.denyVehicle = (req, res) => {
    const { ma_xe } = req.params; // Again, assuming vehicle ID is a route parameter

    const sql = 'UPDATE xe SET da_xac_minh = -1 WHERE ma_xe = ?';

    db.query(sql, [ma_xe], (err, result) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Vehicle not found' });
        }
        res.json({ message: 'Vehicle denied successfully' });
    });
};

exports.deleteVehicle = (req, res) => {
    const { ma_xe } = req.params; // Extracting vehicle ID from the request parameters

    
    db.beginTransaction(err => {
        if (err) {
            return res.status(500).json({ error: 'Failed to start transaction', details: err });
        }

        // Delete operations in the right order
        const queries = [
            'DELETE FROM thongtinkythuatxe WHERE ma_xe = ?',
            'DELETE FROM thongtincobanxe WHERE ma_xe = ?',
            'DELETE FROM lichsuthue WHERE ma_xe = ?',
            'DELETE FROM hinhanh WHERE ma_xe = ?',
            'DELETE FROM datxe WHERE ma_xe = ?',
            'DELETE FROM danhgia WHERE ma_xe = ?',
            'DELETE FROM xe WHERE ma_xe = ?'
        ];

        // Execute each query in sequence
        (function executeQuery(index) {
            if (index < queries.length) {
                db.query(queries[index], [ma_xe], (err, result) => {
                    if (err) {
                        return db.rollback(() => {
                            return res.status(500).json({ error: 'Failed to delete data', details: err });
                        });
                    }
                    executeQuery(index + 1); // Proceed to the next query
                });
            } else {
                // All queries executed successfully, commit the transaction
                db.commit(err => {
                    if (err) {
                        return db.rollback(() => {
                            return res.status(500).json({ error: 'Failed to commit transaction', details: err });
                        });
                    }
                    return res.json({ message: 'Vehicle and related data successfully deleted' });
                });
            }
        })(0); // Start executing from the first query
    });
};

exports.getAllUsers = (req, res) => {

    // Assuming 'db' is your database connection object
    const query = `SELECT ma_nguoi_dung, ten_nguoi_dung, ho_ten, hinh_dai_dien, ngay_dang_ky, so_dien_thoai, dia_chi_nguoi_dung, loai_nguoi_dung,trang_thai FROM nguoidung`;

    db.query(query, (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        // Transform the results into the desired structure
        const users = results.map(user => ({
            userId: user.ma_nguoi_dung,
            username: user.ten_nguoi_dung,
            fullName: user.ho_ten,
            avatar: user.hinh_dai_dien,
            registrationDate: user.ngay_dang_ky,
            phoneNumber: user.so_dien_thoai,
            address: user.dia_chi_nguoi_dung, // Assuming the address is a single string; modify as needed
            userType: user.loai_nguoi_dung, // This could be mapped to more descriptive text based on your application logic
            status: user.trang_thai, // This could be mapped to more descriptive text based on your application logic
        }));
        res.json(users);
    });
};

exports.activateUser = (req, res) => {
    const { ma_nguoi_dung } = req.params; // Extract user ID from request parameters
    // Start a transaction
    db.beginTransaction(err => {
        if (err) {
            return res.status(500).json({ error: 'Failed to start transaction', details: err });
        }

        // Update user's status in nguoidung table to active
        const updateUserStatusQuery = 'UPDATE nguoidung SET trang_thai = 1 WHERE ma_nguoi_dung = ?';
        db.query(updateUserStatusQuery, [ma_nguoi_dung], (err, result) => {
            if (err) {
                return db.rollback(() => {
                    res.status(500).json({ error: 'Failed to update user status', details: err });
                });
            }

            // Check if the user was found and updated
            if (result.affectedRows === 0) {
                return db.rollback(() => {
                    res.status(404).json({ message: 'User not found.' });
                });
            }

            // Update vehicles' status owned by the user to available
            const updateVehiclesStatusQuery = 'UPDATE xe SET trang_thai = 0 WHERE chu_so_huu = ?';
            db.query(updateVehiclesStatusQuery, [ma_nguoi_dung], (err, result) => {
                if (err) {
                    return db.rollback(() => {
                        res.status(500).json({ error: 'Failed to update vehicles status', details: err });
                    });
                }

                // Commit the transaction
                db.commit(err => {
                    if (err) {
                        return db.rollback(() => {
                            res.status(500).json({ error: 'Failed to commit transaction', details: err });
                        });
                    }
                    res.json({ message: 'Đã kích hoạt lại người dùng và tất cả xe liên quan..' });
                });
            });
        });
    });
};


exports.deactivateUser = (req, res) => {
    const { ma_nguoi_dung } = req.params; // Extract user ID from request parameters
    
    // Check if the user is of a type that shouldn't be deactivated
    const checkUserTypeQuery = 'SELECT loai_nguoi_dung FROM nguoidung WHERE ma_nguoi_dung = ?';
    db.query(checkUserTypeQuery, [ma_nguoi_dung], (err, results) => {
        if (err) {
            return res.status(500).json({ error: 'Failed to retrieve user type', details: err });
        }

        if (results.length === 0) {
            return res.status(404).json({ message: 'User not found.' });
        }

        const userType = results[0].loai_nguoi_dung;
        if (userType === 1) {
            return res.json({ message: 'Không thể vô hiệu hoá Quản trị viên.' });
        }

        // Start a transaction for deactivation process
        db.beginTransaction(err => {
            if (err) {
                return res.status(500).json({ error: 'Failed to start transaction', details: err });
            }

            // Update user's status in nguoidung table
            const updateUserStatusQuery = 'UPDATE nguoidung SET trang_thai = -1 WHERE ma_nguoi_dung = ?';
            db.query(updateUserStatusQuery, [ma_nguoi_dung], (err, result) => {
                if (err) {
                    return db.rollback(() => {
                        res.status(500).json({ error: 'Failed to update user status', details: err });
                    });
                }

                // Check if the user was found and updated
                if (result.affectedRows === 0) {
                    return db.rollback(() => {
                        res.status(404).json({ message: 'User not found.' });
                    });
                }

                // Update vehicles' status owned by the user
                const updateVehiclesStatusQuery = 'UPDATE xe SET trang_thai = -1 WHERE chu_so_huu = ?';
                db.query(updateVehiclesStatusQuery, [ma_nguoi_dung], (err, result) => {
                    if (err) {
                        return db.rollback(() => {
                            res.status(500).json({ error: 'Failed to update vehicles status', details: err });
                        });
                    }

                    // Commit the transaction
                    db.commit(err => {
                        if (err) {
                            return db.rollback(() => {
                                res.status(500).json({ error: 'Failed to commit transaction', details: err });
                            });
                        }
                        res.json({ message: 'Người dùng và toàn bộ xe đã bị vô hiệu hoá.' });
                    });
                });
            });
        });
    });
};

exports.getTerms = (req, res) => {
    const query = `SELECT ma_dieu_khoan, phien_ban, tieu_de, noi_dung, ngay_hieu_luc, ngay_tao, ngay_cap_nhat_cuoi, trang_thai FROM dieukhoansudung`;

    db.query(query, (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        const terms = results.map(term => ({
            termId: term.ma_dieu_khoan,
            version: term.phien_ban,
            title: term.tieu_de,
            content: term.noi_dung,
            effectiveDate: term.ngay_hieu_luc,
            creationDate: term.ngay_tao,
            lastUpdateDate: term.ngay_cap_nhat_cuoi,
            status: term.trang_thai,
        }));
        res.json(terms);
    });
};


exports.createTerm = (req, res) => {
    const { phienBan, tieuDe, noiDung, ngayHieuLuc, trangThai } = req.body;

    const query = `INSERT INTO dieukhoansudung (phien_ban, tieu_de, noi_dung, ngay_hieu_luc, trang_thai) VALUES (?, ?, ?, ?, ?)`;

    db.query(query, [phienBan, tieuDe, noiDung, ngayHieuLuc, trangThai], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json({ message: "Điều khoản sử dụng đã được tạo thành công", maDieuKhoan: results.insertId });
    });
};

exports.deleteTerm = (req, res) => {
    const { maDieuKhoan } = req.params;

    const query = `DELETE FROM dieukhoansudung WHERE ma_dieu_khoan = ?`;

    db.query(query, [maDieuKhoan], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if (results.affectedRows == 0) {
            return res.status(404).json({ message: "Không tìm thấy điều khoản sử dụng với mã cung cấp" });
        }
        res.json({ message: "Điều khoản sử dụng đã được xoá thành công" });
    });
};

exports.updateTerm = (req, res) => {
    const { maDieuKhoan } = req.params;
    const { phienBan, tieuDe, noiDung, ngayHieuLuc, trangThai } = req.body;

    const query = `UPDATE dieukhoansudung SET phien_ban = ?, tieu_de = ?, noi_dung = ?, ngay_hieu_luc = ?, trang_thai = ? WHERE ma_dieu_khoan = ?`;

    db.query(query, [phienBan, tieuDe, noiDung, ngayHieuLuc, trangThai, maDieuKhoan], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        if (results.affectedRows == 0) {
            return res.status(404).json({ message: "Không tìm thấy điều khoản sử dụng với mã cung cấp" });
        }
        res.json({ message: "Điều khoản sử dụng đã được cập nhật thành công" });
    });
};

exports.sendNotification = (req, res) => {
    // Assuming req.body contains the notification details: ma_nguoi_dung, ma_loai_thong_bao, tieu_de, noi_dung
    const { ma_nguoi_dung, ma_loai_thong_bao, tieu_de, noi_dung } = req.body;

    // Validate the input
    if (!ma_nguoi_dung || !ma_loai_thong_bao || !tieu_de || !noi_dung) {
        return res.status(400).json({ message: "Missing required fields" });
    }

    // Prepare the SQL query
    const query = `
        INSERT INTO thongbao (ma_nguoi_dung, ma_loai_thong_bao, tieu_de, noi_dung, trang_thai_xem, ngay_tao)
        VALUES (?, ?, ?, ?, 0, NOW())
    `;

    // Assuming `db` is your database connection object
    db.query(query, [ma_nguoi_dung, ma_loai_thong_bao, tieu_de, noi_dung], (err, results) => {
        if (err) {
            console.error("Error inserting notification:", err);
            return res.status(500).json({ error: "Database error", detail: err.message });
        }

        // Successful insertion
        res.json({ message: "Notification sent successfully", notificationId: results.insertId });
    });
};

exports.sendNotificationToAllUsers = (req, res) => {
    // Assuming req.body contains the notification details: ma_loai_thong_bao, tieu_de, noi_dung
    const { ma_loai_thong_bao, tieu_de, noi_dung } = req.body;

    // Validate the input
    if (!ma_loai_thong_bao || !tieu_de || !noi_dung) {
        return res.status(400).json({ message: "Missing required fields" });
    }

    // Retrieve all user IDs from the nguoidung table
    const userQuery = `SELECT ma_nguoi_dung FROM nguoidung`;

    db.query(userQuery, (err, users) => {
        if (err) {
            console.error("Error retrieving users:", err);
            return res.status(500).json({ error: "Database error", detail: err.message });
        }

        // Prepare the SQL query for inserting notifications
        // This assumes that your SQL database supports bulk insertion syntax or you're okay with inserting one by one in a loop for simplicity
        const insertQuery = `
            INSERT INTO thongbao (ma_nguoi_dung, ma_loai_thong_bao, tieu_de, noi_dung, trang_thai_xem, ngay_tao)
            VALUES ?;
        `;

        // Create an array of values to insert
        const values = users.map(user => [user.ma_nguoi_dung, ma_loai_thong_bao, tieu_de, noi_dung, 0, new Date()]);

        // Execute the bulk insertion
        db.query(insertQuery, [values], (insertErr, results) => {
            if (insertErr) {
                console.error("Error inserting notifications:", insertErr);
                return res.status(500).json({ error: "Database error during notification insertion", detail: insertErr.message });
            }

            res.json({ message: `Notifications sent successfully to ${users.length} users` });
        });
    });
};