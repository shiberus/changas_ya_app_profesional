import 'package:changas_ya_app/presentation/providers/rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RatingChip extends ConsumerWidget {
  final String profileId;

  const RatingChip({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final averageRatingAsync = ref.watch(averageRatingProvider(profileId));
    return averageRatingAsync.when(
      loading: () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text("...")],
      ),

      error: (e, s) => Text(
        'Cal. Error',
        style: const TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 252, 183, 193),
        ),
      ),
      data: (rating) {
        return Chip(
          label: Text(
            'Cal. ${rating.toStringAsFixed(1)}',
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          backgroundColor: Colors.green.shade500,
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      },
    );
  }
}
