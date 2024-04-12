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
    sendNotificationToAllUsers,
    activateVoucher,
    deactivateVoucher,
    editVoucher,
    createVoucher,
    getAllVouchers,
    getVoucherDetails
} = require('../controllers/adminController');

router.post('/login', loginAdmin);

router.get('/getAllVouchers', authenticateToken,getAllVouchers);

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

router.patch('/activateVoucher/:ma_voucher', authenticateToken, activateVoucher);

router.patch('/deactivateVoucher/:ma_voucher', authenticateToken, deactivateVoucher);

router.put('/editVoucher/:ma_voucher', authenticateToken, editVoucher);

router.post('/createVoucher', authenticateToken, createVoucher);

router.get('/getVoucher/:ma_voucher',authenticateToken,  getVoucherDetails);


module.exports = router;
