const express = require('express');
const mysql = require('mysql');

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

// Routes for DatXe table
app.get('/datxe', (req, res) => {
  db.query('SELECT * FROM datxe', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Routes for Hinhanh table
app.get('/hinhanh', (req, res) => {
  db.query('SELECT * FROM hinhanh', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

// Add more routes for other tables (loaixe, nguoidung, xe) similarly...

// Start the server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
