const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middleware/authenticate');

const { 
    loginAdmin,
    getAdmin,
    getAllUnverifiedVehicles
} = require('../controllers/adminController');

// Login route
router.post('/login', loginAdmin);

// Route to get all unverified vehicles - Moved up to be before the more general /:id route
router.get('/getAllUnverifiedVehicles', authenticateToken, getAllUnverifiedVehicles);

// Route to get a specific admin by ID - Moved after specific routes
router.get('/:id', authenticateToken, getAdmin);

module.exports = router;
