const db = require('../../config/db');

// Get all vehicles
exports.getAllVehicles = (req, res) => {
    const query = `
    SELECT xe.ma_xe, xe.ten_xe, xe.trang_thai, ThongTinCoBanXe.model, ThongTinCoBanXe.hang_sx, ThongTinKyThuatXe.mo_ta, DiaChi.dia_chi, xe.gia_thue, ThongTinCoBanXe.so_cho, xe.chu_so_huu, xe.ma_loai_xe
    FROM xe
    INNER JOIN ThongTinCoBanXe ON xe.ma_xe = ThongTinCoBanXe.ma_xe
    INNER JOIN ThongTinKyThuatXe ON xe.ma_xe = ThongTinKyThuatXe.ma_xe
    LEFT JOIN DiaChi ON xe.ma_dia_chi = DiaChi.ma_dia_chi
    WHERE xe.da_xac_minh = 1 AND xe.trang_thai = 0`;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching vehicles:', err);
            return res.status(500).json({ message: 'Error fetching vehicles' });
        }
        // Transforming the results to match the expected Vehicle structure with mo_ta included
        const vehicles = results.map(vehicleJson => {
            return {
                ma_xe: vehicleJson.ma_xe,
                ten_xe: vehicleJson.ten_xe,
                trang_thai: vehicleJson.trang_thai,
                model: vehicleJson.model,
                hang_sx: vehicleJson.hang_sx,
                mo_ta: vehicleJson.mo_ta, // Include mo_ta in the response
                dia_chi: vehicleJson.dia_chi,
                gia_thue: vehicleJson.gia_thue,
                so_cho: vehicleJson.so_cho,
                chu_so_huu: vehicleJson.chu_so_huu,
                ma_loai_xe: vehicleJson.ma_loai_xe
            };
        });
        res.json(vehicles);
    });
};

// Search vehicles
exports.searchVehicles = (req, res) => {
    // Extract the search query parameter
    const { keyword } = req.params;

    const query = `
    SELECT xe.ma_xe, xe.ten_xe, xe.trang_thai, ThongTinCoBanXe.model, ThongTinCoBanXe.hang_sx, ThongTinKyThuatXe.mo_ta, DiaChi.dia_chi, xe.gia_thue, ThongTinCoBanXe.so_cho, xe.chu_so_huu, xe.ma_loai_xe
    FROM xe
    INNER JOIN ThongTinCoBanXe ON xe.ma_xe = ThongTinCoBanXe.ma_xe
    INNER JOIN ThongTinKyThuatXe ON xe.ma_xe = ThongTinKyThuatXe.ma_xe
    LEFT JOIN DiaChi ON xe.ma_dia_chi = DiaChi.ma_dia_chi
    WHERE (xe.ten_xe LIKE ? OR ThongTinCoBanXe.model LIKE ? OR ThongTinCoBanXe.hang_sx LIKE ?) AND xe.trang_thai = 0 AND xe.da_xac_minh = 1`;

    // Use '%' wildcards to search for any text containing the search term
    const searchTerm = `%${keyword}%`;

    db.query(query, [searchTerm, searchTerm, searchTerm], (err, results) => {
        if (err) {
            console.error('Error searching for vehicles:', err);
            return res.status(500).json({ message: 'Error searching for vehicles' });
        }
        // Transforming the results to include only available vehicles
        const vehicles = results.map(vehicleJson => {
            return {
                ma_xe: vehicleJson.ma_xe,
                ten_xe: vehicleJson.ten_xe,
                trang_thai: vehicleJson.trang_thai, // This should always be 0 due to the query filter
                model: vehicleJson.model,
                hang_sx: vehicleJson.hang_sx,
                mo_ta: vehicleJson.mo_ta,
                dia_chi: vehicleJson.dia_chi,
                gia_thue: vehicleJson.gia_thue,
                so_cho: vehicleJson.so_cho,
                chu_so_huu: vehicleJson.chu_so_huu,
                ma_loai_xe: vehicleJson.ma_loai_xe
            };
        });
        res.json(vehicles);
    });
};

// Get a specific vehicle by ID with detailed information
exports.getVehicleById = (req, res) => {
    const { id } = req.params;
    const query = `
    SELECT xe.ma_xe, xe.ten_xe, xe.trang_thai, ThongTinCoBanXe.model, ThongTinCoBanXe.hang_sx, ThongTinKyThuatXe.mo_ta, DiaChi.dia_chi, xe.gia_thue, ThongTinCoBanXe.so_cho, xe.chu_so_huu, xe.ma_loai_xe
    FROM xe
    INNER JOIN ThongTinCoBanXe ON xe.ma_xe = ThongTinCoBanXe.ma_xe
    INNER JOIN ThongTinKyThuatXe ON xe.ma_xe = ThongTinKyThuatXe.ma_xe
    LEFT JOIN DiaChi ON xe.ma_dia_chi = DiaChi.ma_dia_chi
    WHERE xe.ma_xe = ? and xe.da_xac_minh = 1`;

    db.query(query, [id], (err, result) => {
        if (err || result.length === 0) {
            console.error('Error fetching vehicle:', err);
            return res.status(404).json({ message: 'Vehicle not found' });
        }
        // Assuming the result contains exactly one row for the specified vehicle ID
        const vehicle = {
            ma_xe: result[0].ma_xe,
            ten_xe: result[0].ten_xe,
            trang_thai: result[0].trang_thai,
            model: result[0].model,
            hang_sx: result[0].hang_sx,
            mo_ta: result[0].mo_ta, // Include mo_ta from ThongTinKyThuatXe
            dia_chi: result[0].dia_chi,
            gia_thue: result[0].gia_thue,
            so_cho: result[0].so_cho,
            chu_so_huu: result[0].chu_so_huu,
            ma_loai_xe: result[0].ma_loai_xe
        };
        res.json(vehicle);
    });
};

// Add a new vehicle along with its basic and technical information
exports.addVehicle = (req, res) => {
    const { ten_xe, trang_thai, model, hang_sx, dia_chi, mo_ta, gia_thue, so_cho, chu_so_huu, ma_loai_xe, nam_san_xuat, mau_sac, quang_duong, nhien_lieu, thanh_pho, quoc_gia, zip_code } = req.body;

    // Start transaction
    db.beginTransaction(err => {
        if (err) {
            console.error('Transaction Start Error:', err);
            return res.status(500).json({ message: 'Error starting transaction' });
        }

        // Insert into DiaChi table first
        const diaChiInsertQuery = 'INSERT INTO DiaChi (dia_chi, thanh_pho, quoc_gia, zip_code) VALUES (?, ?, ?, ?)';
        db.query(diaChiInsertQuery, [dia_chi, thanh_pho, quoc_gia, zip_code], (err, diaChiResult) => {
            if (err) {
                return db.rollback(() => {
                    console.error('Error inserting into DiaChi:', err);
                    res.status(500).json({ message: 'Error adding address' });
                });
            }

            const ma_dia_chi = diaChiResult.insertId;

            // Insert into xe table
            const xeInsertQuery = 'INSERT INTO xe (ten_xe, trang_thai, chu_so_huu, ma_loai_xe, gia_thue, ma_dia_chi) VALUES (?, ?, ?, ?, ?, ?)';
            db.query(xeInsertQuery, [ten_xe, trang_thai, chu_so_huu, ma_loai_xe, gia_thue, ma_dia_chi], (err, xeResult) => {
                if (err) {
                    return db.rollback(() => {
                        console.error('Error inserting into xe:', err);
                        res.status(500).json({ message: 'Error adding vehicle' });
                    });
                }

                const ma_xe = xeResult.insertId;

                // Insert into ThongTinCoBanXe
                const ttcbInsertQuery = 'INSERT INTO ThongTinCoBanXe (ma_xe, model, hang_sx, so_cho) VALUES (?, ?, ?, ?)';
                db.query(ttcbInsertQuery, [ma_xe, model, hang_sx, so_cho], (err, ttcbResult) => {
                    if (err) {
                        return db.rollback(() => {
                            console.error('Error inserting into ThongTinCoBanXe:', err);
                            res.status(500).json({ message: 'Error adding vehicle basic info' });
                        });
                    }

                    // Insert into ThongTinKyThuatXe
                    const ttktxInsertQuery = 'INSERT INTO ThongTinKyThuatXe (ma_xe, nam_san_xuat, mau_sac, quang_duong, mo_ta, nhien_lieu) VALUES (?, ?, ?, ?, ?, ?)';
                    db.query(ttktxInsertQuery, [ma_xe, nam_san_xuat, mau_sac, quang_duong, mo_ta, nhien_lieu], (err, ttktxResult) => {
                        if (err) {
                            return db.rollback(() => {
                                console.error('Error inserting into ThongTinKyThuatXe:', err);
                                res.status(500).json({ message: 'Error adding vehicle technical info' });
                            });
                        }

                        // If everything is successful, commit the transaction
                        db.commit(err => {
                            if (err) {
                                return db.rollback(() => {
                                    console.error('Transaction Commit Error:', err);
                                    res.status(500).json({ message: 'Error during transaction commit' });
                                });
                            }
                            res.status(201).json({ message: 'Vehicle added successfully', id: ma_xe });
                        });
                    });
                });
            });
        });
    });
};


// Update an existing vehicle along with its basic and technical information
exports.updateVehicle = (req, res) => {
    const { id } = req.params;
    const { ten_xe, trang_thai, model, hang_sx, gia_thue, so_cho, nam_san_xuat, mau_sac, quang_duong, mo_ta, nhien_lieu, dia_chi } = req.body;

    // Start transaction
    db.beginTransaction(err => {
        if (err) {
            console.error('Transaction Start Error:', err);
            return res.status(500).json({ message: 'Error starting transaction' });
        }

        // Update xe table
        const xeUpdateQuery = 'UPDATE xe SET ten_xe = ?, trang_thai = ?, gia_thue = ?, ma_dia_chi = (SELECT ma_dia_chi FROM DiaChi WHERE dia_chi = ? LIMIT 1) WHERE ma_xe = ?';
        db.query(xeUpdateQuery, [ten_xe, trang_thai, gia_thue, dia_chi, id], (err, xeResult) => {
            if (err) {
                return db.rollback(() => {
                    console.error('Error updating xe:', err);
                    res.status(500).json({ message: 'Error updating vehicle' });
                });
            }

            // Check if vehicle exists
            if (xeResult.affectedRows === 0) {
                return db.rollback(() => {
                    res.status(404).json({ message: 'Vehicle not found' });
                });
            }

            // Update ThongTinCoBanXe
            const ttcbUpdateQuery = 'UPDATE ThongTinCoBanXe SET model = ?, hang_sx = ?, so_cho = ? WHERE ma_xe = ?';
            db.query(ttcbUpdateQuery, [model, hang_sx, so_cho, id], (err, ttcbResult) => {
                if (err) {
                    return db.rollback(() => {
                        console.error('Error updating ThongTinCoBanXe:', err);
                        res.status(500).json({ message: 'Error updating vehicle' });
                    });
                }

                // Update ThongTinKyThuatXe
                const ttktxUpdateQuery = 'UPDATE ThongTinKyThuatXe SET nam_san_xuat = ?, mau_sac = ?, quang_duong = ?, mo_ta = ?, nhien_lieu = ? WHERE ma_xe = ?';
                db.query(ttktxUpdateQuery, [nam_san_xuat, mau_sac, quang_duong, mo_ta, nhien_lieu, id], (err, ttktxResult) => {
                    if (err) {
                        return db.rollback(() => {
                            console.error('Error updating ThongTinKyThuatXe:', err);
                            res.status(500).json({ message: 'Error updating vehicle' });
                        });
                    }

                    // If everything is successful, commit the transaction
                    db.commit(err => {
                        if (err) {
                            return db.rollback(() => {
                                console.error('Transaction Commit Error:', err);
                                res.status(500).json({ message: 'Error during transaction commit' });
                            });
                        }
                        res.json({ message: 'Vehicle updated successfully' });
                    });
                });
            });
        });
    });
};

// Delete an existing vehicle and related information
exports.deleteVehicle = (req, res) => {
    const { id } = req.params;

    // Start transaction
    db.beginTransaction(err => {
        if (err) {
            console.error('Transaction Start Error:', err);
            return res.status(500).json({ message: 'Error starting transaction' });
        }

        // Here we directly attempt to delete the vehicle, assuming cascade deletion is set up
        // If manual deletion of related records is needed, perform those queries before this one
        const deleteQuery = 'DELETE FROM xe WHERE ma_xe = ?';
        db.query(deleteQuery, [id], (err, result) => {
            if (err) {
                return db.rollback(() => {
                    console.error('Error deleting vehicle:', err);
                    res.status(500).json({ message: 'Error deleting vehicle' });
                });
            }

            if (result.affectedRows === 0) {
                return db.rollback(() => {
                    res.status(404).json({ message: 'Vehicle not found' });
                });
            }

            // If the deletion was successful, commit the transaction
            db.commit(err => {
                if (err) {
                    return db.rollback(() => {
                        console.error('Transaction Commit Error:', err);
                        res.status(500).json({ message: 'Error during transaction commit' });
                    });
                }
                res.json({ message: 'Vehicle deleted successfully' });
            });
        });
    });
};

exports.addReview = (req, res) => {
    const { ma_xe, ma_nguoi_dung, so_sao, binh_luan } = req.body;

    // SQL query to insert a new comment
    const query = `
        INSERT INTO danhgia (ma_xe, ma_nguoi_dung, so_sao, binh_luan)
        VALUES (?, ?, ?, ?)
    `;

    // Assuming 'db' is your database connection object
    db.query(query, [ma_xe, ma_nguoi_dung, so_sao, binh_luan], (error, results) => {
        if (error) {
            console.error('Error adding comment:', error);
            return res.status(500).send({ message: 'Error adding comment' });
        }
        res.status(201).send({ message: 'Comment added successfully', commentId: results.insertId });
    });
};

exports.getAllVehicleReviews = (req, res) => {
    const { ma_xe } = req.params;

    // SQL query to select all comments for a given vehicle
    const query = `
        SELECT * FROM danhgia WHERE ma_xe = ?
    `;

    // Assuming 'db' is your database connection object
    db.query(query, [ma_xe], (error, results) => {
        if (error) {
            console.error('Error fetching comments:', error);
            return res.status(500).send({ message: 'Error fetching comments' });
        }
        res.status(200).send(results);
    });
};
