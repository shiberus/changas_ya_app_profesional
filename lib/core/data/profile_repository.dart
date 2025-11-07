import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:changas_ya_app/Domain/Auth_exception/auth_exception.dart';

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

  Future<void> registerUserProfile(Profile data, String? uuid) async {
    final String dbCollection = "usuarios";
    final String userId = uuid ?? _db.collection(dbCollection).doc().id;
    final userData = <String, dynamic>{
      "email": data.email,
      "name": data.name,
      "isWorker": data.isWorker,
    };

    await _db
        .collection(dbCollection)
        .doc(userId)
        .set(userData)
        .onError(
          (e, _) => throw AuthException(
            errorCode: "error de carga",
            errorMessage: e.toString(),
          ),
        );
  }
}