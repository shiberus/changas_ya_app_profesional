import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

final currentUserIdProvider = Provider<String>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  
  return authState.maybeWhen(
    data: (user) => user?.uid ?? 'invitado', 
    orElse: () => 'invitado',
  );
});