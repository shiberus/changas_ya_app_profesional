import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:changas_ya_app/presentation/providers/job_provider.dart';
import 'package:changas_ya_app/presentation/providers/pagination_providers.dart';
import 'package:changas_ya_app/presentation/providers/profile_provider.dart';
import 'package:changas_ya_app/presentation/widgets/job_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobsExplorerScreen extends ConsumerStatefulWidget {
  static const String name = 'jobs';
  const JobsExplorerScreen({super.key});
  
  
  @override
  ConsumerState<JobsExplorerScreen> createState() => _JobScreenState();
}

class _JobScreenState extends ConsumerState<JobsExplorerScreen> {
  bool _isLoading = false;
  final List<DocumentSnapshot?> _pageCursors = []; // Rastrea el último documento de cada página visitada
  final ScrollController _scrollController = ScrollController();
  Profile? _profile;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    _profile ??= await ref.read(professionalFutureProvider(user!.uid).future);

    
    final notifier = ref.read(availableJobsProvider.notifier);
    final count = await notifier.countAvailableJobsForWorkers(_profile!.trades);
    ref.read(exploreJobsTotalProvider.notifier).state = count;
    ref.read(exploreJobsPageProvider.notifier).state = 0;
    
    _pageCursors.clear();

    await notifier.getAvailableJobsForWorkers(professionIds: _profile!.trades);
    
    // Almacena el último snapshot de documento de la primera página
    _pageCursors.add(notifier.lastDocumentSnapshot);
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadNextPage() async {
    final currentPage = ref.read(exploreJobsPageProvider);
    final lastDoc = _pageCursors[currentPage];
    if (lastDoc == null) return;
    
    setState(() => _isLoading = true);
    
    await ref.read(availableJobsProvider.notifier).getAvailableJobsForWorkers(
      startAfterDoc: lastDoc,
      professionIds: _profile!.trades
    );
    
    // Almacena el último snapshot de documento de la nueva página
    final notifier = ref.read(availableJobsProvider.notifier);
    _pageCursors.add(notifier.lastDocumentSnapshot);
    ref.read(exploreJobsPageProvider.notifier).state = currentPage + 1;
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadPreviousPage() async {
    final currentPage = ref.read(exploreJobsPageProvider);
    if (currentPage <= 0) return;
    
    setState(() => _isLoading = true);
    
    // Usa el cursor de la página anterior a la previa
    // (el cursor en el índice currentPage - 2 apunta al final de la página currentPage - 2,
    //  que es donde comienza la página currentPage - 1)
    DocumentSnapshot? cursor;
    if (currentPage >= 2) {
      cursor = _pageCursors[currentPage - 2];
    }
    
    final notifier = ref.read(availableJobsProvider.notifier);
    await notifier.getAvailableJobsForWorkers(startAfterDoc: cursor, professionIds: _profile!.trades);
    
    // Elimina el cursor de la página actual ya que estamos retrocediendo
    _pageCursors.removeLast();
    ref.read(exploreJobsPageProvider.notifier).state = currentPage - 1;
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _goToPreviousPage() {
    final currentPage = ref.read(exploreJobsPageProvider);
    if (currentPage > 0) {
      _loadPreviousPage();
    }
  }

  void _goToNextPage() {
    final currentPage = ref.read(exploreJobsPageProvider);
    final totalCount = ref.read(exploreJobsTotalProvider);
    final totalPages = totalCount != null 
        ? (totalCount / JobNotifier.pageSize).ceil() 
        : null;
    
    if (totalPages == null || currentPage < totalPages - 1) {
      _loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Job> jobs = ref.watch(availableJobsProvider);
    final currentPage = ref.watch(exploreJobsPageProvider);
    final totalCount = ref.watch(exploreJobsTotalProvider);
    final totalPages = totalCount != null 
        ? (totalCount / JobNotifier.pageSize).ceil() 
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajos Disponibles'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? const Center(
                  child: Text(
                    'No hay trabajos disponibles',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadInitialData,
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            return JobCard(job: job);
                          },
                        ),
                      ),
                    ),
                    // Barra de navegación de páginas
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: currentPage > 0 ? _goToPreviousPage : null,
                            tooltip: 'Página anterior',
                          ),
                          const SizedBox(width: 16),
                          Text(
                            totalPages != null
                                ? 'Página ${currentPage + 1} de $totalPages'
                                : 'Página ${currentPage + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: (totalPages == null || currentPage < totalPages - 1)
                                ? _goToNextPage
                                : null,
                            tooltip: 'Página siguiente',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
