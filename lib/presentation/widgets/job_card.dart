// lib/presentation/widgets/job_card.dart

import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class JobCard extends StatelessWidget {
  final Job job;
  const JobCard({super.key, required this.job});

  // para asignar el color segun el estado
  Color _getStateColor(String state) {
    if (state == 'En marcha') return Colors.blue.shade300;
    if (state == 'Buscando profesional') return Colors.orange.shade300;
    if (state == 'Finalizado') return Colors.green.shade300;
    return Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/jobDetail', extra: job); 
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        elevation: 1.5, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), 
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect( // Se utiliza para redondear el borde de las imagenes
                borderRadius: BorderRadius.circular(8.0),
                child: job.imageUrls.isNotEmpty
                    ? Image.network(
                        job.imageUrls.first, // Se usa la primera imagen
                        width: 70, height: 70, fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(width: 70, height: 70, color: Colors.grey.shade200, child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey)));
                        },
                      )
                    : Container(width: 70, height: 70, color: Colors.grey.shade200, child: const Icon(Icons.image_outlined, color: Colors.grey)),
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                    const SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getStateColor(job.status),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        job.status,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      DateFormat('dd/MM/yyyy').format(job.datePosted),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.access_alarm, size: 22, color: Color.fromARGB(255, 249, 158, 39)), 
                  const Icon(Icons.more_vert, size: 22, color: Colors.grey), 
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}