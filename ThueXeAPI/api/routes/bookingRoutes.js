const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middleware/authenticate');

const {
    createBooking,
    confirmBooking,
    completeBooking,
    cancelBooking,
    getBookingsByUserId,
    checkBookable,
    getManageBooking
} = require('../controllers/bookingController');

router.post('/create/', authenticateToken, createBooking);

router.put('/confirmBooking/:id', authenticateToken, confirmBooking);

router.put('/completeBooking/:id', authenticateToken, completeBooking);

router.put('/cancelBooking/:id', authenticateToken, cancelBooking);

router.get('/allUserBookings/:ma_nguoi_dat_xe', authenticateToken, getBookingsByUserId);

router.get('/checkBookable/:ma_nguoi_dat_xe', authenticateToken, checkBookable);

router.get('/getManageBooking/:ma_chu_xe', authenticateToken, getManageBooking);

module.exports = router;