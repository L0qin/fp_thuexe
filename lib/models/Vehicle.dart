class Car {
  int carId;
  String carName;
  int status;
  String model;
  String manufacturer;
  String address;
  String description;
  double rentalPrice;
  int seating;
  int ownerName;
  int categoryId;

  Car(
      this.carId,
      this.carName,
      this.status,
      this.model,
      this.manufacturer,
      this.address,
      this.description,
      this.rentalPrice,
      this.seating,
      this.ownerName,
      this.categoryId);

  @override
  String toString() {
    return 'Car{carId: $carId, carName: $carName, status: $status, model: $model, manufacturer: $manufacturer, address: $address, description: $description, rentalPrice: $rentalPrice, seatingCapacity: $seating, ownerName: $ownerName, categoryId: $categoryId}';
  }
}
