import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  static const String screenName = 'profileScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(user.getFotoUrl()),
            ),
            const SizedBox(height: 10),
            Text(user.getName(), style: textStyle.titleLarge),
            const SizedBox(height: 5),
            Text(user.getEmail()),
            Text(user.getDireccion()),
            Text(user.getTelefono()),
            const SizedBox(height: 20),
            Text(
              'Opiniones:',
              style: textStyle.titleMedium,
            ),
            const SizedBox(height: 10),
            ...user.getOpiniones().map(
              (opinion) => Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(opinion.comentario),
                  trailing: Text(
                    '${opinion.calificacion} ⭐',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
