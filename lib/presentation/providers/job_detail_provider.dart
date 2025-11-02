import 'package:flutter_riverpod/legacy.dart';

final paymentMethodProvider = StateProvider.family<String, String>((ref, jobId) => '');