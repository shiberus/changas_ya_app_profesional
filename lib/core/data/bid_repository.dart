import 'package:changas_ya_app/Domain/Bid/bid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BidRepository {
  final FirebaseFirestore _db;
  final String _collectionName = 'postulaciones';

  BidRepository(this._db);

  // Metodo para escucchar las bids
  Stream<List<Bid>> streamBidsForJob(String jobId) {
    final bidsCollectionRef = _db
        .collection(_collectionName); 

    final jobFilteredQuery = bidsCollectionRef
        .where('jobId', isEqualTo: jobId) 
        //.orderBy('createdDate', descending: true);
        ;

    return jobFilteredQuery.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Bid.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Metodo para crear un bid: Tener en cuenta que el user lo tenemos que
  // sacar del modludo de
  Future<void> createBid(String jobId, Bid bid) async {
    final bidData = bid.toFirestore();
    
    await _db
        .collection(_collectionName)
        .add(bidData); 
  }


}