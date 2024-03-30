const errorHandler = (err, req, res, next) => {
    console.error(err.stack);
    const statusCode = err.status || 500;
    res.status(statusCode).json({ message: err.message || 'Internal server error' });
};

module.exports = errorHandler;
