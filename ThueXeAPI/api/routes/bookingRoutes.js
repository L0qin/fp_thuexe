const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middleware/authenticate');

const {
    getAllBookings,
    getBookingById,
    createBooking,
    closeBooking,
    updateBooking,
    deleteBooking,
    getBookingsByUserId
} = require('../controllers/bookingController');

// Route to get all bookings
router.get('/', authenticateToken, getAllBookings);

// Route to get a specific booking by ID
router.get('/:id', authenticateToken, getBookingById);

// Route to create a new booking
router.post('/create', authenticateToken, createBooking);

// Route to close a booking
router.put('/close/:id', authenticateToken, closeBooking);

// Route to update a specific booking
router.put('/:id', authenticateToken, updateBooking);

// Route to delete a booking
router.delete('/:id', authenticateToken, deleteBooking);

// Route to get bookings for a specific user by their ID
router.get('/all/:ma_nguoi_dat_xe', authenticateToken, getBookingsByUserId);

module.exports = router;