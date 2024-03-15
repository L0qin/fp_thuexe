class VehicleType {
  int typeId;
  String typeName;

  VehicleType(this.typeId, this.typeName);

  @override
  String toString() {
    return 'VehicleType{typeId: $typeId, typeName: $typeName}';
  }
}
