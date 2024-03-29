const express = require('express');
const mysql = require('mysql');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');
const cors = require('cors'); 
const path = require('path'); 
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');
const multer = require('multer');

const app = express();
const port = 3000;

// MySQL Connection Configuration
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'thuexe'
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log('Connected to MySQL database');
});

// JWT Secret Key
const secretKey = '1';
// Increase the request size limit
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));



// Generate JWT token
function generateToken(user) {
  return jwt.sign({ userId: user.id }, secretKey, { expiresIn: '5h' });
}

app.use(cors());

// app.use((req, res, next) => {
//   console.log('Incoming Request:');
//   console.log('Method:', req.method);
//   console.log('URL:', req.url);
//   console.log('Headers:', req.headers);
//   console.log('Body:', req.body); // For JSON data
//   next();
// });

// Custom error handler middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
  
    // Set the status code based on the type of error
    const statusCode = err.status || 500;
  
    // Send a JSON response with the error message
    res.status(statusCode).json({
      message: err.message || 'Internal server error'
    });
  });
  
// Set up Multer storage configuration
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'images/') // Specify the directory where uploaded files will be stored
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname) // Use the original file name for the uploaded file
  }
});

// Create Multer instance with the configured storage
const upload = multer({ storage: storage });


// Middleware for authenticating JWT token
function authenticateToken(req, res, next) {
  const token = req.headers['authorization'];
  console.log(token);
  if (!token) {
    return res.status(401).json({ message: 'Unauthorized' });
  }

  jwt.verify(token, secretKey, (err, decoded) => {

    if (err) {
      console.log(err);
      return res.status(403).json({ message: 'Invalid token' });
    }

    req.userId = decoded.userId;
    console.log("Token verified for ["+req.userId+"]: "+token);
    next();
  });
}
// -------------------------------------------------------------------------------------------------------------------------------------------------------------------

app.use(bodyParser.json());
// Login route
app.post('/login', (req, res) => {
    const { username, password } = req.body;
    console.log(req.body);
  
    // Check if username and password are provided
    if (!username || !password) {
      return res.status(400).json({ message: 'Username and password are required' });
    }
  
    // Query the database to find the user
    db.query('SELECT * FROM nguoidung WHERE ten_nguoi_dung = ?', [username], (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ message: 'Internal server error' });
      }
  
      // Check if user exists
      if (results.length === 0) {
        return res.status(401).json({ message: 'Invalid username or password' });
      }
  
      const user = results[0];
  
      // Validate password
      if (password !== user.mat_khau_hash) {
        return res.status(401).json({ message: 'Invalid username or password' });
      }
  
      // If credentials are valid, generate JWT token
      const token = generateToken({
        id: user.ma_nguoi_dung,
        username: user.ten_nguoi_dung
      });
  
      // Send the token as a response
      res.json({ token , userId : user.ma_nguoi_dung});
    });

});
  
// Register route
app.post('/register', (req, res) => {
    const { username, password, fullName, phoneNumber, address } = req.body;
  
    // Check if username, password, full name, and phone number are provided
    if (!username || !password || !fullName || !phoneNumber) {
      return res.status(400).json({ message: 'Username, password, full name, and phone number are required' });
    }

    // Check if phone number is in valid format (e.g., numeric and 10 digits)
    const phoneRegex = /^\d{10}$/;
    if (!phoneRegex.test(phoneNumber)) {
      return res.status(400).json({ message: 'Invalid phone number format. Please enter a 10-digit numeric phone number' });
    }
  
    // Query the database to check if the username already exists
    db.query('SELECT * FROM nguoidung WHERE ten_nguoi_dung = ?', [username], (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ message: 'Internal server error' });
      }
  
      // Check if username already exists
      if (results.length > 0) {
        return res.status(409).json({ message: 'Username already exists' });
      }
  
      // Insert the new user into the database
      db.query('INSERT INTO nguoidung (ten_nguoi_dung, mat_khau_hash, ho_ten, so_dien_thoai, dia_chi_nguoi_dung) VALUES (?, ?, ?, ?, ?)',
        [username, password, fullName, phoneNumber, address],
        (err) => {
          if (err) {
            console.error(err);
            return res.status(500).json({ message: 'Failed to register user. Please try again later' });
          }
  
          // User successfully registered
          res.status(201).json({ message: 'User registered successfully' });
        });
    });

});
// -------------------------------------------------------------------------------------------------------------------------------------------------------------------

// CRUD operations for nguoidung table
// Get all users
app.get('/users', authenticateToken, (req, res) => {
  db.query('SELECT * FROM nguoidung', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Get a specific user by ID
app.get('/users/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  db.query('SELECT * FROM nguoidung WHERE ma_nguoi_dung = ?', [id], (err, result) => {
    if (err) throw err;
    res.json(result[0]);
  });
});

// Create a new user
app.post('/users', authenticateToken, (req, res) => {
  const { username, password, fullName, phoneNumber, address } = req.body;
  db.query('INSERT INTO nguoidung (ten_nguoi_dung, mat_khau_hash, ho_ten, so_dien_thoai, dia_chi_nguoi_dung) VALUES (?, ?, ?, ?, ?)',
    [username, password, fullName, phoneNumber, address],
    (err, result) => {
      if (err) throw err;
      res.status(201).json({ message: 'User created successfully', id: result.insertId });
    });
});

app.put('/users/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  // Use the logical OR operator to default to an empty string if the values are null or undefined
  const fullName = req.body.ho_ten || "";
  const phoneNumber = req.body.so_dien_thoai || "";
  const address = req.body.dia_chi_nguoi_dung || "";
  
  console.log(req.body); // Debugging: Log the body to ensure data is received correctly
  console.log(req.params); // Debugging: Log the params to ensure the id is received correctly

  db.query(
    'UPDATE nguoidung SET ho_ten = ?, so_dien_thoai = ?, dia_chi_nguoi_dung = ? WHERE ma_nguoi_dung = ?', 
    [fullName, phoneNumber, address, id], // Updated to ensure order and replace null values with empty strings
    (err, results) => {
      if (err) {
        console.error("Error updating user: ", err);
        return res.status(500).json({ message: 'Error updating user' });
      }

      if (results.affectedRows > 0) {
        res.json({ message: 'User updated successfully', id });
      } else {
        res.status(404).json({ message: 'User not found' });
      }
    }
  );
});


// Delete an existing user
app.delete('/users/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM nguoidung WHERE ma_nguoi_dung = ?', [id], (err) => {
    if (err) throw err;
    res.json({ message: 'User deleted successfully', id });
  });
});

app.post('/userimages', upload.single('image'), authenticateToken, (req, res) => {
  const { ma_nguoi_dung } = req.body;

  // Generate a unique filename
  const uniqueFilename = ma_nguoi_dung + Date.now();
  const ext = path.extname(req.file.originalname);
  const hinhDaiDien = "img" + uniqueFilename + ext;
  console.log(req.body);

  // Move the uploaded file to the desired directory with the unique filename
  fs.rename(req.file.path, 'images/' + hinhDaiDien, err => {
    if (err) {
      console.error('Error moving file:', err);
      return res.status(500).json({ error: 'Failed to upload image' });
    }

    // Update the user's profile picture in the database
    const sql = 'UPDATE nguoidung SET hinh_dai_dien = ? WHERE ma_nguoi_dung = ?';
    db.query(sql, [hinhDaiDien, ma_nguoi_dung], (err, result) => {
      if (err) {
        console.error('Error updating user image:', err);
        return res.status(500).json({ error: 'Failed to update user image' });
      }
      res.status(200).json({ message: 'User image updated successfully', hinhDaiDien });
    });
  });
});

// -------------------------------------------------------------------------------------------------------------------------------------------------------------------


// CRUD operations for datxe table
// Get all datxe
app.get('/datxe', authenticateToken, (req, res) => {
  db.query('SELECT * FROM datxe', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Get a specific datxe by ID
app.get('/datxe/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  db.query('SELECT * FROM datxe WHERE ma_dat_xe = ?', [id], (err, result) => {
    if (err) throw err;
    res.json(result[0]);
  });
});

app.post('/datxe', authenticateToken, (req, res) => {
  const { ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, so_ngay_thue, tong_tien_thue, ma_xe, ma_nguoi_dat_xe } = req.body;
  
  // First, insert the new booking into the datxe table
  db.query('INSERT INTO datxe (ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, so_ngay_thue, tong_tien_thue, ma_xe, ma_nguoi_dat_xe) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
    [ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, so_ngay_thue, tong_tien_thue, ma_xe, ma_nguoi_dat_xe],
    (err, result) => {
      if (err) {
        // Handle the error appropriately
        console.error(err);
        res.status(500).json({ message: 'Error creating Dat xe entry' });
        return;
      }

      // If the datxe insertion was successful, update the xe table to set trang_thai to 1 for the given ma_xe
      db.query('UPDATE xe SET trang_thai = 1 WHERE ma_xe = ?', [ma_xe], (updateErr, updateResult) => {
        if (updateErr) {
          // Handle the error appropriately
          console.error(updateErr);
          res.status(500).json({ message: 'Error updating vehicle status' });
          return;
        }

        // If everything went well, send a success response
        res.status(201).json({ message: 'Dat xe created and vehicle status updated successfully', id: result.insertId });
      });
    });
});

// Endpoint to close a booking
app.put('/datxe/close/:id', authenticateToken, (req, res) => {
  const { id } = req.params; // Booking ID
  // Update the datxe status to 1 (closed)
  db.query('UPDATE datxe SET trang_thai_dat_xe = 1 WHERE ma_dat_xe = ?', [id], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: 'Error updating booking status' });
    }

    // Assuming the ma_xe is sent in the body of the request for now
    const { ma_xe } = req.body;

    // Update the xe status to 0 (available)
    db.query('UPDATE xe SET trang_thai = 0 WHERE ma_xe = ?', [ma_xe], (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ message: 'Error updating vehicle status' });
      }
      res.json({ message: 'Booking closed and vehicle status updated successfully' });
    });
  });
});
// Retrieve all bookings for a specific user by ma_nguoi_dat_xe
app.get('/datxe/user/:ma_nguoi_dat_xe', authenticateToken, (req, res) => {
  const { ma_nguoi_dat_xe } = req.params;
  db.query('SELECT * FROM datxe WHERE ma_nguoi_dat_xe = ?', [ma_nguoi_dat_xe], (err, results) => {
    if (err) {
      console.error('Error fetching bookings:', err);
      return res.status(500).json({ message: 'Error fetching bookings for user' });
    }
    // Return the list of bookings
    res.json(results);
  });
});


// Update an existing datxe entry
app.put('/datxe/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  const { ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, so_ngay_thue, tong_tien_thue, ma_xe, ma_nguoi_dat_xe } = req.body;
  db.query('UPDATE datxe SET ngay_bat_dau = ?, ngay_ket_thuc = ?, trang_thai_dat_xe = ?, dia_chi_nhan_xe = ?, so_ngay_thue = ?, tong_tien_thue = ?, ma_xe = ?, ma_nguoi_dat_xe = ? WHERE ma_dat_xe = ?',
    [ngay_bat_dau, ngay_ket_thuc, trang_thai_dat_xe, dia_chi_nhan_xe, so_ngay_thue, tong_tien_thue, ma_xe, ma_nguoi_dat_xe, id],
    (err) => {
      if (err) throw err;
      res.json({ message: 'Dat xe updated successfully', id });
    });
});

// Delete an existing datxe entry
app.delete('/datxe/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM datxe WHERE ma_dat_xe = ?', [id], (err) => {
    if (err) throw err;
    res.json({ message: 'Dat xe deleted successfully', id });
  });
});

// -------------------------------------------------------------------------------------------------------------------------------------------------------------------


// Get a specific image by ID
app.get('/images/:id', (req, res) => {
  const { id } = req.params;
  db.query('SELECT * FROM hinhanh WHERE ma_hinh_anh = ?', [id], (err, result) => {
    if (err) throw err;
    res.json(result[0]);
  });
  console.log(res.body);
});

// Get images by vehicle ID where loai_hinh = 1
app.get('/images/mainimage/:id', (req, res) => {
  const { id } = req.params;
  db.query('SELECT * FROM hinhanh WHERE ma_xe = ? AND loai_hinh = 1', [id], (err, result) => {
    if (err) throw err;
    res.json(result[0]);
  });
});

// Get images by vehicle ID where loai_hinh = 1
app.get('/images/allimage/:id', (req, res) => {
  const { id } = req.params;
  db.query('SELECT * FROM hinhanh WHERE ma_xe = ? ', [id], (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Define route to serve images
app.get('/images/getimages/:imageName', (req, res) => {
  const imageName = req.params.imageName;
  const imagePath = path.join(__dirname, 'images', imageName);

  fs.readFile(imagePath, (err, data) => {
    if (err) {
      res.status(404).send('Image not found');
    } else {
      res.writeHead(200, { 'Content-Type': 'image/jpeg' }); 
      res.end(data);
    }
  });
});


// Create a new image
app.post('/images', upload.single('image'), authenticateToken, (req, res) => {
  const { loai_hinh, ma_xe } = req.body;

  // Generate a unique filename
  const uniqueFilename = loai_hinh+ma_xe+Date.now();
  const ext = path.extname(req.file.originalname);
  const hinh = "img"+uniqueFilename + ext;

  // Move the uploaded file to the desired directory with the unique filename
  fs.rename(req.file.path, 'images/' + hinh, (err) => {
    if (err) {
      console.error('Error moving file:', err);
      return res.status(500).json({ error: 'Failed to create image' });
    }

    // Insert the image information into the database
    db.query('INSERT INTO hinhanh (loai_hinh, hinh, ma_xe) VALUES (?, ?, ?)',
      [loai_hinh, hinh, ma_xe],
      (err, result) => {
        if (err) {
          console.error('Error inserting image:', err);
          return res.status(500).json({ error: 'Failed to create image' });
        }
        res.status(201).json({ message: 'Image created successfully', id: result.insertId });
      });
  });
});

// Update an existing image
app.put('/images/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  const { loai_hinh, hinh, ma_xe } = req.body;
  db.query('UPDATE hinhanh SET loai_hinh = ?, hinh = ?, ma_xe = ? WHERE ma_hinh_anh = ?',
    [loai_hinh, hinh, ma_xe, id],
    (err) => {
      if (err) throw err;
      res.json({ message: 'Image updated successfully', id });
    });
});

// Delete an existing image
app.delete('/images/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM hinhanh WHERE ma_hinh_anh = ?', [id], (err) => {
    if (err) throw err;
    res.json({ message: 'Image deleted successfully', id });
  });
});

// -------------------------------------------------------------------------------------------------------------------------------------------------------------------

// Get all vehicles
app.get('/vehicles', (req, res) => {
  db.query('SELECT * FROM xe WHERE trang_thai = 0', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Get a specific vehicle by ID
app.get('/vehicles/:id', (req, res) => {
  const { id } = req.params;
  db.query('SELECT * FROM xe WHERE ma_xe = ?', [id], (err, result) => {
    if (err) throw err;
    res.json(result[0]);
  });
});

// Search vehicles based on keyword
app.get('/vehicles/search/:keyword', (req, res) => {
  const { keyword } = req.params;
  const queryString = `SELECT * FROM xe WHERE 
                        ten_xe LIKE '%${keyword}%' OR 
                        model LIKE '%${keyword}%' OR 
                        hang_sx LIKE '%${keyword}%' OR 
                        dia_chi LIKE '%${keyword}%' OR 
                        mo_ta LIKE '%${keyword}%'`;
  db.query(queryString, (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Create a new vehicle
app.post('/vehicles', authenticateToken, (req, res) => {
  const { ten_xe, trang_thai, model, hang_sx, dia_chi, mo_ta, gia_thue, so_cho, chu_so_huu, ma_loai_xe } = req.body;
  db.query('INSERT INTO xe (ten_xe, trang_thai, model, hang_sx, dia_chi, mo_ta, gia_thue, so_cho, chu_so_huu, ma_loai_xe) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    [ten_xe, trang_thai, model, hang_sx, dia_chi, mo_ta, gia_thue, so_cho, chu_so_huu, ma_loai_xe],
    (err, result) => {
      if (err) throw err;
      res.status(201).json({ message: 'Đăng xe thành công.', id: result.insertId });
    });
});

// Update an existing vehicle
app.put('/vehicles/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  const { ten_xe, trang_thai, model, hang_sx, dia_chi, mo_ta, gia_thue, so_cho, chu_so_huu, ma_loai_xe } = req.body;
  db.query('UPDATE xe SET ten_xe = ?, trang_thai = ?, model = ?, hang_sx = ?, dia_chi = ?, mo_ta = ?, gia_thue = ?, so_cho = ?, chu_so_huu = ?, ma_loai_xe = ? WHERE ma_xe = ?',
    [ten_xe, trang_thai, model, hang_sx, dia_chi, mo_ta, gia_thue, so_cho, chu_so_huu, ma_loai_xe, id],
    (err) => {
      if (err) throw err;
      res.json({ message: 'Vehicle updated successfully', id });
    });
});

// Delete an existing vehicle
app.delete('/vehicles/:id', authenticateToken, (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM xe WHERE ma_xe = ?', [id], (err) => {
    if (err) throw err;
    res.json({ message: 'Vehicle deleted successfully', id });
  });
});




// Start the server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
