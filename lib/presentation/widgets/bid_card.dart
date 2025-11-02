import 'package:changas_ya_app/Domain/Bid/bid.dart';
import 'package:changas_ya_app/presentation/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BidCard extends ConsumerWidget {
  final Bid bid;

  const BidCard({super.key, required this.bid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.00),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileCard(profileId: bid.workerId),

            const Divider(height: 24, thickness: 1),

            Text("Mano de obra: ${bid.budgetManpower}"),
            Text("Repuestos: ${bid.budgetSpares}"),
            Text("Total: ${bid.budgetTotal}"),

            const Divider(height: 24, thickness: 1),

            Text("Mensaje: "),
            Text(bid.message)
          ],
        ),
      ),
    );
  }
}
