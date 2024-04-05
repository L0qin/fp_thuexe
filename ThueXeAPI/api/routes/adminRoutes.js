const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middleware/authenticate');

const { 
    loginAdmin,
    getAdmin,
    getAllUnverifiedVehicles,
    getAllVehicles,
    approveVehicle,
    denyVehicle,
    activateUser,
    deactivateUser,
    getAllUsers,
    deleteVehicle,
    getTerms,
    createTerm,
    deleteTerm,
    updateTerm,
    sendNotification,
    sendNotificationToAllUsers
} = require('../controllers/adminController');

router.post('/login', loginAdmin);

router.delete('/deleteVehicle/:ma_xe', authenticateToken, deleteVehicle);

router.get('/getAllTerms', authenticateToken, getTerms);

router.get('/getAllUsers', authenticateToken, getAllUsers);

router.get('/getAllUnverifiedVehicles', authenticateToken, getAllUnverifiedVehicles);

router.get('/getAllVehicles', authenticateToken, getAllVehicles);

router.get('/:id', authenticateToken, getAdmin);

router.put('/approveVehicle/:ma_xe', authenticateToken, approveVehicle);

router.put('/denyVehicle/:ma_xe', authenticateToken, denyVehicle);

router.put('/activateUser/:ma_nguoi_dung', authenticateToken, activateUser);

router.put('/deactivateUser/:ma_nguoi_dung', authenticateToken, deactivateUser);


router.post('/createTerm', authenticateToken, createTerm);

router.delete('/deleteTerm/:maDieuKhoan', authenticateToken, deleteTerm);

router.put('/updateTerm/:maDieuKhoan', authenticateToken, updateTerm);

router.post('/sendnotification', authenticateToken, sendNotification);

router.post('/sendnotificationtoallusers', authenticateToken, sendNotificationToAllUsers);

module.exports = router;
