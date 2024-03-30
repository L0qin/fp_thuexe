const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middleware/authenticate');


const { 
    registerUser, 
    loginUser,
    getUser,
    modifyUser
 } = require('../controllers/userController');

// Register route
router.post('/register', registerUser);

// Login route
router.post('/login', loginUser);

// Route to get a specific user by ID
router.get('/:id',authenticateToken, getUser);

// Route to modify a specific user
router.put('/:id',authenticateToken, modifyUser);


module.exports = router;
