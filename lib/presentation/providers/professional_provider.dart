import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/Domain/Professional/professional.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';


/// Provider para la instancia de FirebaseFirestore
final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// StateNotifierProvider para manejar el perfil del profesional cargado
final professionalProvider =
    StateNotifierProvider<ProfessionalNotifier, Professional?>(
  (ref) {
    final db = ref.watch(firebaseFirestoreProvider);
    return ProfessionalNotifier(db);
  },
);

/// StateNotifier que gestiona el estado del profesional
class ProfessionalNotifier extends StateNotifier<Professional?> {
  final FirebaseFirestore _db;

  ProfessionalNotifier(this._db) : super(null);

  /// Carga el perfil de un profesional por su ID
  Future<void> loadProfessionalProfile(String professionalId) async {
    try {
      final doc =
          await _db.collection('profesionales').doc(professionalId).get();
      if (doc.exists && doc.data() != null) {
        state = Professional.fromFirestore(doc.data()!);
      } else {
        state = null;
      }
    } catch (e) {
      // Puedes reemplazar print por un logger si querés
      print('Error al cargar perfil profesional: $e');
      state = null;
    }
  }
}
