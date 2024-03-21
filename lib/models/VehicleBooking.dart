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

  Booking({
    required this.bookingId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.receivingAddress,
    required this.rentalDays,
    required this.totalRentalCost,
    required this.carId,
    required this.customerId,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['ma_dat_xe'],
      startDate: DateTime.parse(json['ngay_bat_dau']),
      endDate: DateTime.parse(json['ngay_ket_thuc']),
      status: json['trang_thai_dat_xe'],
      receivingAddress: json['dia_chi_nhan_xe'] ?? '', // Assuming it can be null
      rentalDays: json['so_ngay_thue'] ?? 0, // Assuming it can be null
      totalRentalCost: json['tong_tien_thue'] ?? 0, // Assuming it can be null
      carId: json['ma_xe'] ?? 0, // Assuming it can be null
      customerId: json['ma_nguoi_dat_xe'],
    );
  }
}
