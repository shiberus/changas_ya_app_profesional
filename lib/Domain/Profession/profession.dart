import 'package:cloud_firestore/cloud_firestore.dart';

class Profession {
  final String id;
  final String nombre;

  Profession({required this.id, required this.nombre});

  factory Profession.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Profession(
      id: doc.id,
      nombre: data['name'] ?? '',
    );
  }
}
