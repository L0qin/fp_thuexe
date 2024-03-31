const express = require('express');
const router = express.Router();
const {
    getAllVehicles,
    searchVehicles,
    getVehicleById,
    addVehicle,
    updateVehicle,
    deleteVehicle,
    addReview,
    getAllVehicleReviews
} = require('../controllers/vehicleController');


router.get('/', getAllVehicles);
router.get('/search/:keyword', searchVehicles);
router.get('/:id', getVehicleById);
router.post('/', addVehicle);
router.put('/:id', updateVehicle);
router.delete('/:id', deleteVehicle);
router.post('/addreview/', addReview);
router.get('/getAllVehicleReviews/:ma_xe', getAllVehicleReviews);



module.exports = router;
