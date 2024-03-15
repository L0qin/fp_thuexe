class Image {
  int imageId;
  int imageType;
  String imageUrl;
  int carId;

  Image(this.imageId, this.imageType, this.imageUrl, this.carId);

  @override
  String toString() {
    return 'Image{imageId: $imageId, imageType: $imageType, imageUrl: $imageUrl, carId: $carId}';
  }
}
