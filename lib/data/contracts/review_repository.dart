import '../../models/models.dart';

abstract class ReviewRepository {
  Future<List<ReviewItem>> loadReviewItems(String userId);
  Future<void> saveReviewItem(String userId, ReviewItem item);
  Future<void> markReviewed(String userId, String reviewItemId);
  Future<void> toggleMastered(String userId, String reviewItemId);
  Future<void> toggleSavedPhrase(String userId, String reviewItemId);
}
