import 'package:changas_ya_app/presentation/providers/navigation_provider.dart';
import 'package:changas_ya_app/presentation/screens/jobs_explore_screen.dart';
import 'package:changas_ya_app/presentation/screens/favorite_workers.dart';
import 'package:changas_ya_app/presentation/screens/jobs_screen.dart';
import 'package:changas_ya_app/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changas_ya_app/presentation/screens/nosotros_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:changas_ya_app/presentation/widgets/log_out_alert.dart';
import 'package:flutter_riverpod/legacy.dart';

final jobsScreenRefreshProvider = StateProvider<Future<void> Function()?>(
  (ref) => null,
);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabIndexProvider);
    


    final List<Widget> screens = [
      const JobsScreen(),
      const JobsExplorerScreen(),
      const Center(child: Text("Pantalla de Favoritos (Pendiente)")),
      const ProfileScreen(),
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
            // Item de prueba
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('editar perfil'),
              onTap: () {
                context.push("/editProfile");
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context); // <-- cierra el drawer menu.
                showDialog(
                  context: context,
                  builder: (context) => LogOutAlert(),
                );
                //context.push("/logout");
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) async {
          final notifier = ref.read(selectedTabIndexProvider.notifier);

          if (index == selectedIndex && index == 0) {
            final state = ref.read(jobsScreenRefreshProvider.notifier).state;

            if (state != null) state();
          } else {
            notifier.state = index;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Trabajos',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Explorar',
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
