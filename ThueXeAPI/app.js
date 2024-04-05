const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


const authenticateToken = require('./middleware/authenticate');
const errorHandler = require('./middleware/errorHandler');
const { authorize } = require('./middleware/authorize');

const userRoutes = require('./api/routes/userRoutes');
const vehicleRoutes = require('./api/routes/vehicleRoutes');
const bookingRoutes = require('./api/routes/bookingRoutes');
const imageRoutes = require('./api/routes/imageRoutes');
const adminsRoutes = require('./api/routes/adminRoutes');
const otherRoutes = require('./api/routes/otherRoutes');
// Use the authentication middleware for protected routes
app.use('/api/protected', authenticateToken);

// Use the error handling middleware last, after all other middleware and routes
app.use(errorHandler);

app.use(cors({
  origin: '/admin',
  credentials: true
}));

app.use('/admin', express.static(path.join(__dirname, 'admin')));

// Use API routes
app.use('/api/users', userRoutes);
app.use('/api/vehicles', vehicleRoutes);
app.use('/api/bookings', bookingRoutes);
app.use('/api/images', imageRoutes);
app.use('/api/others', otherRoutes);
app.use('/api/admins', adminsRoutes);


// Start the server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
