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
    deleteVehicle
} = require('../controllers/adminController');

router.post('/login', loginAdmin);

router.delete('/deleteVehicle/:ma_xe', authenticateToken, deleteVehicle);

router.get('/getAllUsers', authenticateToken, getAllUsers);

router.get('/getAllUnverifiedVehicles', authenticateToken, getAllUnverifiedVehicles);

router.get('/getAllVehicles', authenticateToken, getAllVehicles);

router.get('/:id', authenticateToken, getAdmin);

router.put('/approveVehicle/:ma_xe', authenticateToken, approveVehicle);

router.put('/denyVehicle/:ma_xe', authenticateToken, denyVehicle);

router.put('/activateUser/:ma_nguoi_dung', authenticateToken, activateUser);

router.put('/deactivateUser/:ma_nguoi_dung', authenticateToken, deactivateUser);

module.exports = router;
