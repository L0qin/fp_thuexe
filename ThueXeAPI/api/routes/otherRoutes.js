const express = require('express');
const router = express.Router();
const authenticateToken = require('../../middleware/authenticate');


const { 
    getTerm,
    getVouchers,
 } = require('../controllers/otherController');

router.get('/getTerm/:id', getTerm);

router.get('/getVouchers', getVouchers);




module.exports = router;
