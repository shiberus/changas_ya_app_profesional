import 'package:changas_ya_app/Domain/Job/job.dart';
import 'package:changas_ya_app/presentation/screens/home_screen.dart';
import 'package:changas_ya_app/presentation/screens/job_detail.dart';
import 'package:changas_ya_app/presentation/screens/jobs_screen.dart';
import 'package:changas_ya_app/presentation/screens/login.dart';
import 'package:changas_ya_app/presentation/screens/sign_up.dart';
import 'package:changas_ya_app/presentation/screens/change_password.dart';
import 'package:changas_ya_app/presentation/screens/profile_screen.dart'; 
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: AppLogin.name,
      builder: (context, state) => const AppLogin(),
    ),
    GoRoute(
      path: '/signup',
      name: SignUp.name,
      builder: (context, state) => const SignUp(),
    ),
    GoRoute(
      path: '/changePassword',
      name: ChangePassword.screenName,
      builder: (context, state) => const ChangePassword(),
    ),
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'jobs', 
          name: JobsScreen.name,
          builder: (context, state) => const JobsScreen(),
        ),
        GoRoute(
          path: 'perfil', 
          name: ProfileScreen.screenName,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/jobDetail',
      name: JobDetail.name,
      builder: (context, state){
        return JobDetail(job: state.extra as Job);
      }
    )
  ],
);
