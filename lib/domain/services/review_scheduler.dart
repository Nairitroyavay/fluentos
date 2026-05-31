class ReviewScheduler {
  const ReviewScheduler();

  DateTime nextReviewAt({
    required DateTime from,
    required int reviewedCount,
    required bool isMastered,
  }) {
    if (isMastered) {
      return from.add(const Duration(days: 30));
    }
    final intervals = [1, 2, 4, 7, 14];
    final index = reviewedCount.clamp(0, intervals.length - 1);
    return from.add(Duration(days: intervals[index]));
  }
}
