import 'package:changas_ya_app/Domain/Profession/profession.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfessionRepository {
  final FirebaseFirestore _db;
  final String _collectionName = 'profesiones';

  ProfessionRepository(this._db);

  Future<List<Profession>> getAllProfessions() async {
    try {
      final snapshot = await _db.collection(_collectionName).get();

      return snapshot.docs.map((doc) => Profession.fromDoc(doc)).toList();
    } catch (e) {
      print('Error al obtener profesiones: $e');
      return [];
    }
  }
}
