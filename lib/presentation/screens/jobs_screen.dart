import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:changas_ya_app/presentation/providers/job_provider.dart';
import 'package:changas_ya_app/presentation/widgets/job_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobsScreen extends ConsumerStatefulWidget {
  static const String name = 'jobs';
  const JobsScreen({super.key});
  
  @override
  ConsumerState<JobsScreen> createState() => _JobScreenState();
}

class _JobScreenState extends ConsumerState<JobsScreen> {

  @override
  void initState() {
    super.initState();
    ref.read(jobProvider.notifier).getPublishedJobsByClient();
  }

  @override
  Widget build(BuildContext context) {
    final List<Job> jobs = ref.watch(jobProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajos'),
        centerTitle: true,
      ),
      body: jobs.isEmpty
          ? const Center(child: CircularProgressIndicator()) 
          : _JobsView(jobs: jobs),
    );
  }
}

class _JobsView extends StatelessWidget {
  final List<Job> jobs;
  const _JobsView({required this.jobs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return JobCard(job: job);
      },
    );
  }
}