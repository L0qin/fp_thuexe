const db = require('../../config/db');
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken');
const secretKey = process.env.JWT_SECRET;

exports.loginAdmin = (req, res) => {
    const { username, password } = req.body;
    console.log(req.body);

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
    console.log(req.body);
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
            GROUP_CONCAT(hinhanh.hinh SEPARATOR ',') AS vehicle_images
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
            const vehicleImages = vehicleJson.vehicle_images ? vehicleJson.vehicle_images.split(',') : [];
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
            };
        });

        console.log(vehicles);
        res.json(vehicles);
    });
};
