const db = require('../config/db');

const authorize = (roles = []) => {
    if (typeof roles === 'string') {
        roles = [roles];
    }

    return (req, res, next) => {
        const userId = req.userId;
        db.query('SELECT role FROM nguoidung WHERE ma_nguoi_dung = ?', [userId], (err, results) => {
            if (err || results.length === 0 || !roles.includes(results[0].role)) {
                return res.status(403).json({ message: 'Unauthorized' });
            }

            next();
        });
    };
};

module.exports = authorize;
