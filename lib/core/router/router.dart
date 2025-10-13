import 'package:changas_ya_app/presentation/screens/jobs_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/jobs',
  routes: [
    GoRoute(
      path: '/jobs',
      name: JobsScreen.name,
      builder: (context, state) => const JobsScreen(),
    )
  ]
);