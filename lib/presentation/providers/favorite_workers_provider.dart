import 'package:changas_ya_app/Domain/Professional/professional.dart';
import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:changas_ya_app/presentation/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StreamProvider que escucha en tiempo real los trabajadores favoritos
final favoriteWorkersProvider = StreamProvider<List<Profile>>((ref) async* {
  final db = FirebaseFirestore.instance;
  final userId = ref.watch(currentUserIdProvider);
  if (userId == 'invitado') {
    yield [];
    return;
  }

  // Escuchamos el documento del usuario
  await for (final userSnap in db.collection('usuarios').doc(userId).snapshots()) {
    final data = userSnap.data();
    if (data == null) {
      yield [];
      continue;
    }

    final List<dynamic> favoriteIds = data['favoritos'] ?? [];
    if (favoriteIds.isEmpty) {
      yield [];
      continue;
    }

    // Obtenemos los documentos de los profesionales favoritos
    final querySnapshot = await db
        .collection('usuarios')
        .where(FieldPath.documentId, whereIn: favoriteIds)
        .get();

    final clients = querySnapshot.docs
        .where((doc) => doc.data()['isWorker'] == true)
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Profile.fromFirestore(data, doc.id);
        })
        .toList();

    yield clients;
  }
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
