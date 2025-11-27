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

    dynamic profileImage = AssetImage("lib/image/profile_avatar_anonymous_user.png");
    final userImage = user.getFotoUrl();
    if (userImage.isNotEmpty){
      if (userImage.contains('://')){
        profileImage = NetworkImage(userImage);
      } else {
        profileImage = AssetImage(userImage);
      }
    }

    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: profileImage,
            ),

            const SizedBox(height: 20),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      user.getName(),
                      style: textStyle.titleLarge,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.email, size: 18),
                        const SizedBox(width: 6),
                        Text(user.getEmail(), textAlign: TextAlign.center),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 6),
                        Text(user.getDireccion(), textAlign: TextAlign.center),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone, size: 18),
                        const SizedBox(width: 6),
                        Text(user.getTelefono(), textAlign: TextAlign.center),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
