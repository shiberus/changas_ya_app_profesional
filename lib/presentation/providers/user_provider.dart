import 'package:flutter_riverpod/legacy.dart';
import '../../Domain/User/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    final fbUser = fb.FirebaseAuth.instance.currentUser;

    if (fbUser == null) {
      state = null;
      return;
    }

    final uid = fbUser.uid;

    // Buscamos el doc en Firestore
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();

    if (!doc.exists) {
      state = null;
      return;
    }

    final data = doc.data()!;

    final user = User(
      data['name'] ?? fbUser.displayName ?? '',
      fbUser.email ?? '',
      '',
    );

    user.setTelefono(data['phone'] ?? '');
    user.setDireccion(data['address'] ?? '');
    user.setFotoUrl(data['photoUrl'] ?? '');

    state = user;
  }
}