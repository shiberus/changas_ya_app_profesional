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
  }

  Widget build(BuildContext context) {
    final String clientId = ref.watch(currentUserIdProvider); 
    final List<Job> jobs = ref.watch(jobProvider);

    final bool isLoading = jobs.isEmpty && clientId == 'invitado'; 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajos'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : jobs.isEmpty
              ? const Center(child: Text('Aún no has publicado ningún trabajo.'))
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