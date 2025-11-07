import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:changas_ya_app/core/data/profile_repository.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:changas_ya_app/Domain/Profile/profile.dart';

/// Provider para la instancia de FirebaseFirestore
final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// Provider para inyectar el repositorio
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final db = ref.watch(firebaseFirestoreProvider);
  return ProfileRepository(db);
});

/// StateNotifierProvider para manejar el perfil cargado
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, Profile?>(
  (ref) {
    final repository = ref.watch(profileRepositoryProvider);
    return ProfileNotifier(repository);
  },
);

/// StateNotifier que gestiona el estado del perfil
class ProfileNotifier extends StateNotifier<Profile?> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(null);

  /// Carga el perfil por ID usando el repositorio
  Future<void> loadProfile(String profileId) async {
    try {
      state = await _repository.fetchProfileById(profileId);
    } catch (e) {
      print('Error al cargar perfil: $e');
      state = null;
    }
  }

  /// Actualiza el perfil usando el repositorio
  Future<void> updateProfile(Profile profile) async {
    try {
      await _repository.updateProfile(profile);
      // Recargar el estado con la versión actualizada
      state = await _repository.fetchProfileById(profile.uid);
    } catch (e) {
      print('Error al actualizar perfil: $e');
    }
  }
}