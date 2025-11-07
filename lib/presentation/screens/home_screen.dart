import 'package:changas_ya_app/Domain/Auth_exception/auth_exception.dart';
import 'package:changas_ya_app/presentation/providers/navigation_provider.dart';
import 'package:changas_ya_app/presentation/screens/jobs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/presentation/screens/profile_screen.dart';
import 'package:changas_ya_app/core/Services/user_auth_controller.dart';
import 'package:changas_ya_app/presentation/screens/nosotros_screen.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);
    final UserAuthController authController = UserAuthController();

    void snackBarPopUp(String message, Color? background) {
      SnackBar snackBar = SnackBar(
        content: Text(message),
        backgroundColor: background,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Future<bool> userLogOut() async {
      String snackBarMessage = '';
      Color? snackBarColor = Colors.red[400];
      bool isLogedOut = false;

      try {
        await authController.userLogOut();
        isLogedOut = true;
        snackBarMessage = "Sesión cerrada.";
        snackBarColor = Colors.green[400];
      } on AuthException catch (e) {
        snackBarMessage = e.showError();
      }

      snackBarPopUp(snackBarMessage, snackBarColor);
      return isLogedOut;
    }

    final List<Widget> screens = [
      const JobsScreen(),
      const Center(child: Text("Pantalla de Crear (Pendiente)")),
      const Center(child: Text("Pantalla de Favoritos (Pendiente)")),
      const Center(child: Text("Pantalla de Perfil (Pendiente)")),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Changas Ya!')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Nosotros'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NosotrosScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                bool isSessionClosed = await userLogOut();
                if (isSessionClosed && context.mounted) {
                  Navigator.pop(context); // <-- cierra el drawner menu.
                  context.go("/login");
                }
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(selectedTabIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Trabajos',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_outlined),
            selectedIcon: Icon(Icons.add),
            label: 'Crear',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
