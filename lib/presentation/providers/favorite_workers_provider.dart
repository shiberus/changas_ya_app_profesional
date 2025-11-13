import 'package:changas_ya_app/Domain/Professional/professional.dart';
import 'package:changas_ya_app/presentation/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StreamProvider que escucha en tiempo real los trabajadores favoritos
final favoriteWorkersProvider = StreamProvider<List<Professional>>((ref) async* {
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

    final professionals = querySnapshot.docs
        .where((doc) => doc.data()['isWorker'] == true)
        .map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return Professional.fromFirestore(data);
        })
        .toList();

    yield professionals;
  }
});

/// Provider para manejar acciones sobre favoritos
final favoriteWorkersActionsProvider = Provider((ref) {
  final db = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> removeFromFavorites(String workerId) async {
    if (userId == null) return;
    await db.collection('usuarios').doc(userId).update({
      'favoritos': FieldValue.arrayRemove([workerId]),
    });
  }

  return FavoriteWorkersActions(removeFromFavorites: removeFromFavorites);
});

class FavoriteWorkersActions {
  final Future<void> Function(String workerId) removeFromFavorites;
  const FavoriteWorkersActions({required this.removeFromFavorites});
}