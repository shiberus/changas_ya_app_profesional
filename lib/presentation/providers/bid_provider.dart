import 'package:changas_ya_app/Domain/Bid/bid.dart';
import 'package:changas_ya_app/core/data/bid_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseFirestoreProvider = Provider((ref) => FirebaseFirestore.instance);

// Ess para la inyeccion de BidRepository
final bidRepositoryProvider = Provider<BidRepository>((ref) {
  final db = ref.watch(firebaseFirestoreProvider);
  return BidRepository(db);
});

final bidsStreamProvider = StreamProvider.family<List<Bid>, String>((ref, jobId) {
  final repository = ref.watch(bidRepositoryProvider);
  return repository.streamBidsForJob(jobId);
});

// Provider para crear ofertas
final createBidProvider = Provider((ref) {
  final repository = ref.read(bidRepositoryProvider);

  return (String jobId, Bid bid) async {
    await repository.createBid(jobId, bid);
  };
});