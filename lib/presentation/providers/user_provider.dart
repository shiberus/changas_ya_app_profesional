import 'package:flutter_riverpod/legacy.dart';
import '../../Domain/User/user.dart';

// Provider legacy
final userProvider = StateNotifierProvider<UserNotifier, User?>(
  (ref) => UserNotifier(),
);

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    loadUserData();
  }

  void loadUserData() {
    // Simula la carga de datos (más adelante reemplazar por Firebase)
    state = getMockUser();
  }
}

// Función que devuelve un usuario mock
User getMockUser() {
  User user = User('Juan Pérez', 'juanperez@gmail.com', '123456');
  user.setTelefono('+54 9 11 1234-5678');
  user.setDireccion('Av. Siempre Viva 742');
  user.setFotoUrl('lib/images/profile_placeholder.png');
  user.setOpiniones([
    Opinion('Excelente servicio', 5),
    Opinion('Muy cumplidor', 4),
  ]);                                        
  return user;                     
}