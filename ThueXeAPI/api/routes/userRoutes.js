const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middleware/authenticate');


const { 
    registerUser, 
    loginUser,
    getUser,
    modifyUser,
    getUserNotification,
    getUserNewNotificationNumber,
    deleteNotification,
    markNotificationAsRead,
    getUserUnreadNotification,
    readAllBookingNotifications
 } = require('../controllers/userController');

// Register route
router.post('/register', registerUser);

// Login route
router.post('/login', loginUser);

// Route to get a specific user by ID
router.get('/:id',authenticateToken, getUser);

// Route to modify a specific user
router.put('/:id',authenticateToken, modifyUser);

router.get('/getUserNotification/:id', authenticateToken, getUserNotification);

router.get('/getUserUnreadNotification/:id', authenticateToken, getUserUnreadNotification);

router.get('/getUserNewNotificationNumber/:id', authenticateToken, getUserNewNotificationNumber);

router.put('/deleteNotification/:notificationId', authenticateToken, deleteNotification);

router.put('/markNotificationAsRead/:notificationId', authenticateToken, markNotificationAsRead);

router.put('/readAllBookingNotifications/:id', authenticateToken, readAllBookingNotifications);

module.exports = router;
