import '../../models/models.dart';
import '../contracts/review_repository.dart';
import '../local/local_persistence_repository.dart';

class FakeReviewRepository implements ReviewRepository {
  final LocalPersistenceRepository local;

  const FakeReviewRepository({required this.local});

  @override
  Future<List<ReviewItem>> loadReviewItems(String userId) async {
    return local
        .loadReviewItems()
        .where((item) => item.userId == userId || item.userId == 'user_roy')
        .toList();
  }

  @override
  Future<void> saveReviewItems(String userId, List<ReviewItem> items) {
    return local.saveReviewItems([
      for (final item in items) item.copyWith(userId: userId),
    ]);
  }

  @override
  Future<void> saveReviewItem(String userId, ReviewItem item) {
    final next = item.copyWith(userId: userId);
    final reviews = [
      next,
      for (final existing in local.loadReviewItems())
        if (existing.id != next.id) existing,
    ];
    return local.saveReviewItems(reviews);
  }

  @override
  Future<void> markReviewed(String userId, String reviewItemId) {
    return local.saveReviewItems([
      for (final item in local.loadReviewItems())
        item.id == reviewItemId
            ? item.copyWith(
                userId: userId,
                reviewedCount: item.reviewedCount + 1,
              )
            : item,
    ]);
  }

  @override
  Future<void> toggleMastered(String userId, String reviewItemId) {
    return local.saveReviewItems([
      for (final item in local.loadReviewItems())
        item.id == reviewItemId
            ? item.copyWith(userId: userId, isMastered: !item.isMastered)
            : item,
    ]);
  }

  @override
  Future<void> toggleSavedPhrase(String userId, String reviewItemId) {
    return local.saveReviewItems([
      for (final item in local.loadReviewItems())
        item.id == reviewItemId
            ? item.copyWith(userId: userId, isSavedPhrase: !item.isSavedPhrase)
            : item,
    ]);
  }
}
