import 'package:changas_ya_app/Domain/Bid/bid.dart';
import 'package:changas_ya_app/presentation/providers/profile_provider.dart';
import 'package:changas_ya_app/presentation/widgets/profile_card.dart';
import 'package:changas_ya_app/presentation/widgets/simple_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BidCard extends StatelessWidget {
  final Bid bid;
  final VoidCallback onTap;

  const BidCard({super.key, required this.bid, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.00),
        child: Padding(
          padding: EdgeInsets.all(16.00),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SimpleProfile(
                workerId: bid.workerId, 
                budgetTotal: bid.budgetTotal, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
