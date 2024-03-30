const express = require('express');
const router = express.Router();
const {
    getAllVehicles,
    searchVehicles,
    getVehicleById,
    addVehicle,
    updateVehicle,
    deleteVehicle
} = require('../controllers/vehicleController');


router.get('/', getAllVehicles);
router.get('/search/:keyword', searchVehicles);
router.get('/:id', getVehicleById);
router.post('/', addVehicle);
router.put('/:id', updateVehicle);
router.delete('/:id', deleteVehicle);

module.exports = router;
