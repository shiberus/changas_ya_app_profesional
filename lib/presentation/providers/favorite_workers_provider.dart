import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:changas_ya_app/presentation/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteWorkersProvider = StreamProvider<List<Profile>>((ref) {
  final db = FirebaseFirestore.instance;
  final userId = ref.watch(currentUserIdProvider);

  if (userId == 'invitado') {
    return Stream.value([]);
  }

  // Escuchamos el documento del usuario
  return db.collection('usuarios').doc(userId).snapshots().asyncExpand((userSnap) {
    final data = userSnap.data();
    if (data == null) return Stream.value([]);

    final List<dynamic> favoriteIds = data['favoritos'] ?? [];
    if (favoriteIds.isEmpty) return Stream.value([]);

    // Ahora escuchamos los workers favoritos en tiempo real
    return db.collection('usuarios')
        .where(FieldPath.documentId, whereIn: favoriteIds)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs
              .where((doc) => (doc.data()['isWorker'] ?? false) == true)
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return Profile.fromFirestore(data, doc.id);
              })
              .toList();
        });
  });
});



final favoriteWorkersActionsProvider = Provider((ref) {
  final db = FirebaseFirestore.instance;
  final userId = ref.watch(currentUserIdProvider);

  Future<void> toggleFavorite(String workerId, bool isFavorite) async {
    final userRef = db.collection('usuarios').doc(userId);

    if (isFavorite) {
      await userRef.update({
        'favoritos': FieldValue.arrayRemove([workerId]),
      });
    } else {
      await userRef.update({
        'favoritos': FieldValue.arrayUnion([workerId]),
      });
    }

    // 👇 Forzar recarga del provider después del cambio
    ref.invalidate(favoriteWorkersProvider);
  }

  return FavoriteWorkersActions(toggleFavorite: toggleFavorite);
});

class FavoriteWorkersActions {
  final Future<void> Function(String workerId, bool isFavorite) toggleFavorite;
  const FavoriteWorkersActions({required this.toggleFavorite});
}
