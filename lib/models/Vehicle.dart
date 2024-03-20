class Vehicle {
  int carId;
  String carName;
  int status;
  String model;
  String manufacturer;
  String address;
  String description;
  double rentalPrice;
  int seating;
  int ownerId;
  int categoryId;

  Vehicle(
      this.carId,
      this.carName,
      this.status,
      this.model,
      this.manufacturer,
      this.address,
      this.description,
      this.rentalPrice,
      this.seating,
      this.ownerId,
      this.categoryId,
      );

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      json['ma_xe'],
      json['ten_xe'],
      json['trang_thai'],
      json['model'],
      json['hang_sx'],
      json['dia_chi'],
      json['mo_ta'],
      json['gia_thue'].toDouble(),
      json['so_cho'],
      json['chu_so_huu'],
      json['ma_loai_xe'],
    );
  }

  @override
  String toString() {
    return 'Vehicle{carId: $carId, carName: $carName, status: $status, model: $model, manufacturer: $manufacturer, address: $address, description: $description, rentalPrice: $rentalPrice, seating: $seating, ownerName: $ownerId, categoryId: $categoryId}';
  }
}
