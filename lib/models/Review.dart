class Review {
  int reviewId;
  int carId;
  int userId;
  int stars;
  String comment;
  DateTime dateTime;

  Review(
      this.reviewId,
      this.carId,
      this.userId,
      this.stars,
      this.comment,
      this.dateTime,
      );

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      json['ma_danh_gia'] as int,
      json['ma_xe'] as int,
      json['ma_nguoi_dung'] as int,
      json['so_sao'] as int,
      json['binh_luan'] as String,
      DateTime.parse(json['thoi_gian'] as String),
    );
  }

  @override
  String toString() {
    return 'Review{reviewId: $reviewId, carId: $carId, userId: $userId, stars: $stars, comment: $comment, dateTime: $dateTime}';
  }
}
