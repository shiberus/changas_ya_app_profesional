import 'package:flutter_riverpod/legacy.dart';

final assignedJobsPageProvider = StateProvider<int>((ref) => 0);
final assignedJobsTotalProvider = StateProvider<int?>((ref) => null);

final exploreJobsPageProvider = StateProvider<int>((ref) => 0);
final exploreJobsTotalProvider = StateProvider<int?>((ref) => null);