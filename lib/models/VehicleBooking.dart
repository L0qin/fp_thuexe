class Booking {
  int? id;
  DateTime startDate;
  DateTime endDate;
  int status;
  int? pickupAddressId;
  double? totalRental;
  int? carId;
  int userId;
  int ownerId;
  String? notes;
  int? discount;

  Booking({
    this.id,
    required this.startDate,
    required this.endDate,
    this.status = 0, // Assuming default status is 0 for new booking
    this.pickupAddressId,
    this.totalRental,
    this.carId,
    required this.userId,
    required this.ownerId,
    this.notes,
    this.discount,
  });

  // Convert a Booking object into a map object
  Map<String, dynamic> toJson() {
    return {
      'ma_dat_xe': id,
      'ngay_bat_dau': startDate.toIso8601String(),
      'ngay_ket_thuc': endDate.toIso8601String(),
      'trang_thai_dat_xe': status,
      'dia_chi_nhan_xe': pickupAddressId,
      'tong_tien_thue': totalRental,
      'ma_xe': carId,
      'ma_nguoi_dat_xe': userId,
      'ghi_chu': notes,
      'giam_gia': discount,
    };
  }

  // Create a Booking object from a map (used when parsing the response from the API)
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['ma_dat_xe'],
      startDate: DateTime.parse(json['ngay_bat_dau']),
      endDate: DateTime.parse(json['ngay_ket_thuc']),
      status: json['trang_thai_dat_xe'],
      pickupAddressId: json['dia_chi_nhan_xe'],
      totalRental: json['tong_tien_thue'] != null ? double.tryParse(json['tong_tien_thue'].toString()) : null,
      carId: json['ma_xe'],
      userId: json['ma_nguoi_dat_xe'],
      ownerId: json['ma_nguoi_dat_xe'],
      notes: json['ghi_chu'],
      discount: json['giam_gia'],
    );
  }
}
