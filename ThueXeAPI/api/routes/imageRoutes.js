const express = require('express');
const router = express.Router();
const imageController = require('../controllers/imageController');
const authenticateToken = require('../../middleware/authenticate'); // Adjust the path as needed
const multer = require('multer');

const upload = multer({ dest: '../../images/' }); // Configure multer as per your requirements

// Get a specific image by ID
router.get('/:id', imageController.getImageById);

// Get main image by vehicle ID
router.get('/mainimage/:id', imageController.getMainImageByVehicleId);

// Get all images by vehicle ID
router.get('/allimage/:id', imageController.getAllImagesByVehicleId);

// Serve an image file
router.get('/getimages/:imageName' ,imageController.serveImage);

// Create a new image
router.post('/', authenticateToken, upload.single('image'), imageController.createImage);

// Update an existing image
router.put('/:id', authenticateToken, imageController.updateImage);

// Delete an existing image
router.delete('/:id', authenticateToken, imageController.deleteImage);

// Update user image
router.post('/userimages', upload.single('image'), authenticateToken, imageController.uploadUserImage);

module.exports = router;
