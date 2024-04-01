class ManageBooking {
  int bookingId;
  DateTime startDate;
  DateTime endDate;
  int bookingStatus;
  String address;
  double rentalCost;
  String notes;
  String renterName;
  String renterAddress;
  String vehicleName;
  String renterImage;

  ManageBooking({
    required this.bookingId,
    required this.startDate,
    required this.endDate,
    required this.bookingStatus,
    required this.address,
    required this.rentalCost,
    required this.notes,
    required this.renterName,
    required this.renterAddress,
    required this.vehicleName,
    required this.renterImage,
  });

  factory ManageBooking.fromJson(Map<String, dynamic> json) {
    return ManageBooking(
      bookingId: json['ma_dat_xe'],
      startDate: DateTime.parse(json['ngay_bat_dau']),
      endDate: DateTime.parse(json['ngay_ket_thuc']),
      bookingStatus: json['trang_thai_dat_xe'],
      address: json['dia_chi'],
      rentalCost: double.parse(json['tong_tien_thue'].toString()),
      notes: json['ghi_chu'] ?? '',
      renterName: json['renter_name'],
      renterAddress: json['renter_address'],
      vehicleName: json['ten_xe'],
      renterImage: json['renter_image'],
    );
  }
}