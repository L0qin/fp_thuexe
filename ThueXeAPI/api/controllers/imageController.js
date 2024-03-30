const db = require('../../config/db'); // Adjust according to your project structure
const path = require('path');
const fs = require('fs');

exports.getImageById = (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM hinhanh WHERE ma_hinh_anh = ?', [id], (err, result) => {
        if (err) {
            console.error(`Error fetching image with ID ${id}:`, err);
            return res.status(500).json({ message: 'Error fetching image' });
        }
        // Assuming the structure of the hinhanh table and its fields remain consistent with the expectations
        res.json(result[0]);
    });
};

exports.getMainImageByVehicleId = (req, res) => {
    const { id } = req.params;
    // Assuming the logic for determining a main image is based on loai_hinh or similar criteria
    db.query('SELECT * FROM hinhanh WHERE ma_xe = ? AND loai_hinh = 1', [id], (err, result) => {
        if (err) {
            console.error(`Error fetching main image for vehicle ID ${id}:`, err);
            return res.status(500).json({ message: 'Error fetching main image for vehicle' });
        }
        // Adjustments here should reflect any changes in how images are classified or stored
        res.json(result[0]);
    });
};


exports.getAllImagesByVehicleId = (req, res) => {

    const { id } = req.params;
    db.query('SELECT * FROM hinhanh WHERE ma_xe = ?', [id], (err, result) => {
        if (err) {
            console.error(`Error fetching all images for vehicle ID ${id}:`, err);
            return res.status(500).json({ message: 'Error fetching images for vehicle' });
        }
        console.log("=======");
        console.log(result);
        res.json(result);
    });
};

exports.serveImage = (req, res) => {
    const { imageName } = req.params;
    const imagePath = path.join(__dirname, '..', '..', 'images', imageName); // Adjust path as necessary

    fs.readFile(imagePath, (err, data) => {
        if (err) {
            console.error(`Error serving image ${imageName}:`, err);
            return res.status(404).send('Image not found');
        }
        res.writeHead(200, { 'Content-Type': 'image/jpeg' });
        res.end(data);
    });
};

exports.createImage = (req, res) => {
    const { loai_hinh, ma_xe } = req.body;
    const uniqueFilename = `${loai_hinh}${ma_xe}${Date.now()}`;
    const ext = path.extname(req.file.originalname);
    const hinh = `img${uniqueFilename}${ext}`;

    const tempPath = req.file.path;
    const targetPath = path.join(__dirname, '..', '..', 'images', hinh);

    fs.rename(tempPath, targetPath, (err) => {
        if (err) {
            console.error('Error moving file:', err);
            return res.status(500).json({ error: 'Failed to upload image' });
        }

        // Assuming hinhanh table's structure is unchanged or adequately modified
        db.query('INSERT INTO hinhanh (loai_hinh, hinh, ma_xe) VALUES (?, ?, ?)', [loai_hinh, hinh, ma_xe], (err, result) => {
            if (err) {
                console.error('Error inserting image into database:', err);
                return res.status(500).json({ error: 'Failed to create image' });
            }
            res.status(201).json({ message: 'Image created successfully', id: result.insertId });
        });
    });
};


exports.updateImage = (req, res) => {
    const { id } = req.params;
    const { loai_hinh, hinh, ma_xe } = req.body; // Assuming new image details are provided
    db.query('UPDATE hinhanh SET loai_hinh = ?, hinh = ?, ma_xe = ? WHERE ma_hinh_anh = ?', [loai_hinh, hinh, ma_xe, id], (err) => {
        if (err) {
            console.error(`Error updating image with ID ${id}:`, err);
            return res.status(500).json({ message: 'Error updating image' });
        }
        res.json({ message: 'Image updated successfully', id });
    });
};

exports.deleteImage = (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM hinhanh WHERE ma_hinh_anh = ?', [id], (err) => {
        if (err) {
            console.error(`Error deleting image with ID ${id}:`, err);
            return res.status(500).json({ message: 'Error deleting image' });
        }
        res.json({ message: 'Image deleted successfully', id });
    });
};

// // Update user image route
// router.post('/userimages', authenticateToken, upload.single('image'), imageController.uploadUserImage);
exports.uploadUserImage = (req, res) => {
    const { ma_nguoi_dung } = req.body;
    if (!req.file) {
        return res.status(400).json({ message: 'No image file provided.' });
    }
    
    const uniqueFilename = `${ma_nguoi_dung}_${Date.now()}`;
    const ext = path.extname(req.file.originalname);
    const hinhDaiDien = `img_${uniqueFilename}${ext}`;
    const newPath = path.join(__dirname, '../../images', hinhDaiDien);

    fs.rename(req.file.path, newPath, err => {
        if (err) {
            console.error('Error moving file:', err);
            return res.status(500).json({ error: 'Failed to upload image' });
        }

        // Ensure this query matches any new structure or columns in nguoidung
        const sql = 'UPDATE nguoidung SET hinh_dai_dien = ? WHERE ma_nguoi_dung = ?';
        db.query(sql, [hinhDaiDien, ma_nguoi_dung], (err, result) => {
            if (err) {
                console.error('Error updating user image:', err);
                return res.status(500).json({ error: 'Failed to update user image' });
            }
            res.status(200).json({ message: 'User image updated successfully', hinhDaiDien });
        });
    });
};
