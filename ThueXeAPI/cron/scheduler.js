const cron = require('node-cron');
const db = require('./db'); // Import the database connection

// Function to cancel unconfirmed bookings
function cancelUnconfirmedBookings() {
    const query = `
        UPDATE datxe
        SET trang_thai_dat_xe = -1
        WHERE trang_thai_dat_xe = 0 AND TIMESTAMPDIFF(HOUR, NOW(), ngay_bat_dau) <= 24;
    `;

    db.query(query, (error, results) => {
        if (error) {
            return console.error('Error cancelling unconfirmed bookings:', error);
        }
        console.log(`Cancelled unconfirmed bookings. Rows affected: ${results.affectedRows}`);
    });
}

// Schedule the task to run once every hour
cron.schedule('0 * * * *', () => {
    console.log('Running scheduled task to cancel unconfirmed bookings');
    cancelUnconfirmedBookings();
});
