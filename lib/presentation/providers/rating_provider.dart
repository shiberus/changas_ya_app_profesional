import 'package:changas_ya_app/Domain/Rating/rating.dart';
import 'package:changas_ya_app/core/data/rating_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final ratingRepositoryProvider = Provider((ref) {
  final db = ref.read(firebaseFirestoreProvider);
  return RatingRepository(db);
});


final averageRatingProvider = FutureProvider.family<double, String>((ref, reviewedId) async {
  final repo = ref.watch(ratingRepositoryProvider);
  return repo.getAverageRating(reviewedId);
});

final ratingSubmitProvider = Provider((ref) {
  final repo = ref.read(ratingRepositoryProvider);

  return (Rating rating) async {
    await repo.submitRating(rating);
    ref.invalidate(averageRatingProvider(rating.reviewedId));
    return true;
  };
});