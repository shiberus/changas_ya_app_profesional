import 'package:changas_ya_app/Domain/Rating/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingRepository {
  final FirebaseFirestore _db;
  final String _collectionName = 'puntuaciones';

  RatingRepository(this._db);

  Future<void> submitRating(Rating rating) async {
    // Para asegurar de que haya un solo rating por reviewer de este job
    // setteamos manualmente el id
    final String ratingId = '${rating.jobId}_${rating.reviewerId}';

    try {
      await _db.collection(_collectionName)
      .doc(ratingId)
      .set(
        rating.toFirestore(),
        SetOptions(merge: true)
      );

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
      final ratings = await _db.collection(_collectionName)
        .where('reviewedId', isEqualTo: reviewedId)
        .get();

      if(ratings.docs.isEmpty) {
        return 0.0;
      }

      double scoreSum = 0.0;

      for (var doc in ratings.docs) {
        final score = doc.data()['score'];
        // me aseguro de que no haya basura
        if(score is num) {
          scoreSum += score.toDouble();
        }
      }

      final average = scoreSum / ratings.docs.length;

      return double.parse(average.toStringAsFixed(1)); // un solo decimal, convierte y convierte
    } on FirebaseException catch(e) {
      print("Error al calcular promedio");
      return 0.0;
    }

  }
}