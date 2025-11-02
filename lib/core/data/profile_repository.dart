import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRepository {
  final FirebaseFirestore _db;
  final String _collectionName = 'usuarios';

  ProfileRepository(this._db);

  Future<Profile?> fetchProfileById(String id) async {
    try {
      final usersCollection = _db.collection(_collectionName).withConverter<Profile>(
        fromFirestore: (snapshot, _) => Profile.fromFirestore(snapshot.data()!, snapshot.id),
        toFirestore: (Profile profile, _) => profile.toFirestore(),
      );

      final docSnapshot = await usersCollection.doc(id).get();
      return docSnapshot.data();
      
    } catch (e) {
      print('Error en UserRepository.fetchUserById: $e');
      throw Exception('Fallo al obtener el usuario.'); 
    }
  }

  Future<void> updateProfile(Profile profile) async {
      final profilesCollection = _db.collection(_collectionName).withConverter<Profile>(
        fromFirestore: (snapshot, _) => Profile.fromFirestore(snapshot.data()!, snapshot.id),
        toFirestore: (Profile profile, _) => profile.toFirestore(),
      );
      
      final profileRef = profilesCollection.doc(profile.uid);
      await profileRef.set(profile, SetOptions(merge: true)); // El merge true es para que mergee los cambios y no reemplace
  }
}