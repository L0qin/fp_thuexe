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

router.put('/confirmBooking/:ma_dat_xe', authenticateToken, confirmBooking);

router.put('/completeBooking/:ma_dat_xe', authenticateToken, completeBooking);

router.put('/cancelBooking/:ma_dat_xe', authenticateToken, cancelBooking);

router.get('/allUserBookings/:ma_nguoi_dat_xe', authenticateToken, getBookingsByUserId);

router.get('/checkBookable/:ma_nguoi_dat_xe', authenticateToken, checkBookable);

router.get('/getManageBooking/:ma_chu_xe', authenticateToken, getManageBooking);

module.exports = router;