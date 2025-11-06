import 'package:changas_ya_app/Domain/Bid/bid.dart';
import 'package:changas_ya_app/presentation/providers/bid_provider.dart';
import 'package:changas_ya_app/presentation/widgets/bid_card.dart';
import 'package:changas_ya_app/presentation/widgets/bid_details_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BidsScreen extends ConsumerWidget {
  final String jobId;
  
  const BidsScreen({super.key, required this.jobId});

  void _showBidDetailsModal(BuildContext context, Bid bid) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BidDetailsModal(bid: bid); 
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bidsAsync = ref.watch(bidsStreamProvider(jobId));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Postulaciones"),
      ),
      body: bidsAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Buscando postulaciones..."),
            ],
          ),
        ),

        error: (e, s) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Error al cargar postulaciones: $e',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),

        data: (bids) {
          // Si esta vacia, pongo un mensaje
          if (bids.isEmpty) {
            return const Center(
              child: Text(
                'Aún no hay profesionales postulados para este trabajo.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: bids.length,
            itemBuilder: (context, index) {
              final bid = bids[index];
              return BidCard(bid: bid, onTap: () => {_showBidDetailsModal(context, bid)},); 
            },
          );
        }
      )
    );
  }
}