import '../models/review_model.dart';

class ReviewService {
  static final List<ReviewModel> _reviews = [
    ReviewModel(
      id: '1', 
      parkingId: '1',
      userName: 'Alice',
      rating: 4.5,
      comment: 'Great location and affordable rates!',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ), 
    ReviewModel(
      id: '2', 
      parkingId: '1',
      userName: 'Bob',
      rating: 3.0,
      comment: 'Decent spot but can get crowded during peak hours.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    )
  ];
  static List<ReviewModel> getReviewsForParking(String parkingId){
    return _reviews.where((r) => r.parkingId == parkingId).toList();
  }

  static double getAverageRating(String parkingId){
    final reviews = getReviewsForParking(parkingId);
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold(0.0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }
  static int getReviewCount(String parkingId){
    return getReviewsForParking(parkingId).length;
  }
  static void addReview(ReviewModel review){
  _reviews.add(review);
  }
}