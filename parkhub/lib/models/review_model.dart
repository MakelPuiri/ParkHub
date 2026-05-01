class ReviewModel {
  final String id; 
  final String parkingId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.parkingId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}