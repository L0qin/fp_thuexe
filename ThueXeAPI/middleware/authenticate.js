const jwt = require('jsonwebtoken');
const secretKey = process.env.JWT_SECRET;

const authenticateToken = (req, res, next) => {
    const token = req.headers['authorization'];

    if (!token) return res.status(401).json({ message: 'Unauthorized' });
    console.log(token);
    jwt.verify(token, secretKey, (err, decoded) => {
        if (err) return res.status(403).json({ message: 'Invalid token' });

        req.userId = decoded.userId;
        next();
    });
};

module.exports = authenticateToken;
