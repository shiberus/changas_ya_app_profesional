import 'package:firebase_auth/firebase_auth.dart';
//import 'package:changas_ya_app/Domain/User/user.dart';

class UserAuthController {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Función asíncrona para el registro de usuario en Firebase.
  ///
  /// [email]: Correo electrónico del usuario.
  ///
  /// [password] Contraseña ingresada por el usuario.
  ///
  /// @returns: (bool, String)
  Future<void> registerUser(String email, String password) async {
    try {

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        throw Exception('La contraseña es demasiado débil.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Ya existe una cuenta con ese correo electrónico.');
      }

    } catch (e) {
      throw Exception("Error desconocido: $e");
    }
  }

  Future<void> userLogIn(String email, String password) async{
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
        );
    } on FirebaseAuthException catch(e) {
        String exceptionMessage = '';

        if (e.code == 'invalid-email' || e.code == 'wrong-password' || e.code == 'invalid-credential'){
          exceptionMessage = 'Credenciales ingresadas, invalidas.';
        } else if (e.code == 'user-disabled') {
          exceptionMessage = 'El usuario se encuentra desahabilitado.';
        } else if (e.code == 'user-not-found') {
          exceptionMessage = 'Usuario no registrado.';
        }
        throw Exception(exceptionMessage);
    } catch (e) {
      String errorMessage = e.toString();

      throw Exception("Error desconocido: $errorMessage");
    }
  }

  Future<void> userLogOut() async {
    try{
      await _auth.signOut();
    } catch (e){
      throw Exception('Ocurrió un error al cerrar sesión.');
    }
  }

  Future<void> changeUserPassword(String email, String oldPassword, String newPassword) async {

    if (_isUserAuthenticated()){
      try {
        await userLogIn(email, oldPassword);
      } catch (e){
        throw Exception('Ocurrió un error durante la autenticación.');
      }
    }

    User? user = _auth.currentUser;

    try {
      await _changePassword(user, newPassword);
    } catch (e){
      throw Exception(e.toString());
    }
  }

  bool _isUserAuthenticated(){
    return _auth.currentUser != null;
  }

  Future<void> _changePassword(User? user, String newPassword) async {
    try {
      // Use the null check operator on 'user' for the update.
      await user!.updatePassword(newPassword);

    } on FirebaseException catch (e){
      if (e.code == 'weak-password'){
        throw Exception('Contraseña débil.');
      } else if (e.code == 'requires-recent-login'){
        throw Exception('Debe volver a inciar sesión');
      }
    } catch (e) {
      String errorMessage = e.toString();
      throw Exception('Error desconocido: $errorMessage');
    }
    
  }
}