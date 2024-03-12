import 'dart:io';
class Booking {
  int bookingId;
  DateTime startDate;
  DateTime endDate;
  int status;
  String receivingAddress;
  int rentalDays;
  int totalRentalCost;
  int carId;
  int customerId;

  Booking(
      this.bookingId,
      this.startDate,
      this.endDate,
      this.status,
      this.receivingAddress,
      this.rentalDays,
      this.totalRentalCost,
      this.carId,
      this.customerId);

  @override
  String toString() {
    return 'Booking{bookingId: $bookingId, startDate: $startDate, endDate: $endDate, status: $status, receivingAddress: $receivingAddress, rentalDays: $rentalDays, totalRentalCost: $totalRentalCost, carId: $carId, customerId: $customerId}';
  }


}