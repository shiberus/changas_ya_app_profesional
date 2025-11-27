import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Estado del formulario de calificación
class RatingFormState {
  final int score;
  final String comment;
  final bool isSubmitting;

  const RatingFormState({
    this.score = 0,
    this.comment = '',
    this.isSubmitting = false,
  });

  RatingFormState copyWith({
    int? score,
    String? comment,
    bool? isSubmitting,
  }) {
    return RatingFormState(
      score: score ?? this.score,
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class RatingFormNotifier extends StateNotifier<RatingFormState> {
  RatingFormNotifier() : super(const RatingFormState());

  void setScore(int score) {
    state = state.copyWith(score: score);
  }

  void setComment(String comment) {
    state = state.copyWith(comment: comment);
  }

  void setSubmitting(bool value) {
    state = state.copyWith(isSubmitting: value);
  }

  void reset() {
    state = const RatingFormState();
  }
}

final ratingFormProvider =
    StateNotifierProvider<RatingFormNotifier, RatingFormState>(
  (ref) => RatingFormNotifier(),
);
