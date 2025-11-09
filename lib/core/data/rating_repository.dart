import 'package:changas_ya_app/Domain/Rating/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RatingRepository {
  final FirebaseFirestore _db;
  final String _collectionName = 'puntuaciones';
  final String _collectionProfileName = 'usuarios';

  RatingRepository(this._db);

  Future<void> submitRating(Rating rating) async {
    // Para asegurar de que haya un solo rating por reviewer de este job
    // setteamos manualmente el id
    final String ratingId = '${rating.jobId}_${rating.reviewerId}';

    final ratingRef = _db.collection(_collectionName).doc(ratingId);
    final profileRef = _db.collection(_collectionProfileName).doc(rating.reviewedId);

    try {
      await _db.runTransaction((transaction) async {
        final profileSnapshot = await transaction.get(profileRef);
        final ratingSnapshot = await transaction.get(ratingRef);

        // En los dos casos puede ser null la data, y despues puede que no tenga opiniones entonces
        // le pongo el ? y el ternario para que sea 0 sino
        double actualSum = (profileSnapshot.data()?['ratingSum'] as num?)?.toDouble() ?? 0.0;
        int actualCount = profileSnapshot.data()?['ratingCount'] as int? ?? 0;

        double oldScore = 0.0;
        int countChange = 0;

        if(ratingSnapshot.exists) {
          // Cuando existe un rating anterior tengo que restarlo de la cuenta total por eso setteo el oldScore
          oldScore = (ratingSnapshot.data()?['score'] as num).toDouble();
        } else {
          oldScore = 0.0;
          countChange = 1;
        }

        final double scoreChange = rating.score - oldScore;
        final double finalSum = actualSum + scoreChange;
        final int finalCount = actualCount + countChange;

        final double average = finalCount / finalSum;

        transaction.set(
          ratingRef,
          rating.toFirestore(),
          SetOptions(merge: true),
        );

        transaction.update(profileRef, {
          'ratingSum': finalSum,
          'ratingCount': finalCount,
          'ratingAvg': average,
        });
      });

    } on FirebaseException catch(e) {
      throw Exception('Fallo al subir nuevo rating');
    }
  }

  Future<double?> getExistingRatingScore(String jobId, String reviewerId) async {
    // Genero el mismo id de la funcion submit 
    final String ratingId = '${jobId}_${reviewerId}';
    
    final doc = await _db.collection(_collectionName).doc(ratingId).get();

    if (doc.exists) {
      return doc.data()?['score'] as double?;
    }
    return null;
  }

  Future<double> getAverageRating(String reviewedId) async {
    try {
      final doc = await _db.collection(_collectionProfileName).doc(reviewedId).get();
      if (doc.exists) {
        final double? average = (doc.data()?['averageRating'] as num?)?.toDouble();
        return average ?? 0; // average o 0 si no existe el average
      }
      return 0.0; // doc no existe
    } on FirebaseException catch(e) {
      print("Error al calcular promedio");
      return 0.0;
    }
  }
}