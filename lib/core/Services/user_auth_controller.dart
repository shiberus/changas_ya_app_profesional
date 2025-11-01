import 'package:changas_ya_app/Domain/Auth_exception/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Cambiar por Profile.dart en cuanto se reciban los cambios.
// Se ustiliza un alias para evitar conflictos.
import 'package:changas_ya_app/Domain/User/user.dart' as app_user;
//import 'package:changas_ya_app/Domain/User/user.dart';

class UserAuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Función asíncrona para el registro de usuario en Firebase.
  ///
  /// [email]: Correo electrónico del usuario.
  /// [password] Contraseña ingresada por el usuario.
  ///
  /// @returns: (bool, String)
  //Firma original del método.
  //Future<void> registerUser(String email, String password) async {
  Future<void> registerUser(app_user.User newUser) async {
    String errorCode = '';
    String errorMessage = '';
    try {
      await _auth.createUserWithEmailAndPassword(
        email: newUser.getEmail(),
        password: newUser.getPassword(),
      );

      // TODO: Cambiar método por el que se va a utilizar en el repository de Firebase.
      // También se puede crear un perfil en Firestore/RealtimeDB desde aquí
      // usando los datos de `newUser`.
      await registerUserProfile(newUser);
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'La contraseña es demasiado débil.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Ya existe una cuenta con ese correo electrónico.';
          break;
        case 'invalid-email':
          errorMessage = 'El E-mail ingresado es invalido.';
          break;
        case 'operatrion-not-allowed':
          errorMessage =
              'Operación no permitida. Utilice otro método de Inicio de sesión.';
          break;
      }
      throw AuthException(errorCode: errorCode, errorMessage: errorMessage);
    } catch (e) {
      errorCode = 'Desconocido';
      errorMessage = "$e";
      throw AuthException(errorCode: errorCode, errorMessage: errorMessage);
    }
  }

  Future<void> userLogIn(String email, String password) async {
    String errorCode = '';
    String errorMessage = '';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // Utilizo un mensaje genérico para los siguientes códigos de excepción:
      // - invalid-email
      // - wrong-password
      // - invalid-credential
      errorCode = e.code;
      errorMessage = 'Las credenciales ingresadas son invalidas.';

      // Con un Switch manejo el resto de los errores.
      switch (e.code) {
        case 'user-disabled':
          errorMessage = 'El usuario se encuentra desahabilitado.';
          break;
        case 'user-not-found':
          errorMessage = 'Usuario no registrado.';
          break;
      }

      throw AuthException(errorCode: errorCode, errorMessage: errorMessage);
    } catch (e) {
      errorCode = 'Desconocido';
      errorMessage = "$e";
      throw AuthException(errorCode: errorCode, errorMessage: errorMessage);
    }
  }

  Future<void> userLogOut() async {
    try {
      await _auth.signOut();
    } on Exception catch (e) {
      String errorCode = 'Error';
      String errorMessage = "$e";
      throw AuthException(errorCode: errorCode, errorMessage: errorMessage);
    }
  }

  Future<void> changeUserPassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    //Función de prueba
    await userLogOut();

    if (!_isUserAuthenticated()) {
      try {
        await userLogIn(email, oldPassword);
      } on AuthException catch (e) {
        throw AuthException(
          errorCode: e.getErrorCode(),
          errorMessage: e.showErrorMessage(),
        );
      }
    }

    User? user = _auth.currentUser;

    try {
      await _changePassword(user, newPassword);
    } on AuthException catch (e) {
      throw AuthException(
        errorCode: e.getErrorCode(),
        errorMessage: e.showErrorMessage(),
      );
    }
  }

  bool _isUserAuthenticated() {
    return _auth.currentUser != null;
  }

  Future<void> _changePassword(User? user, String newPassword) async {
    String errorCode;
    String errorMessage = '';
    try {
      // Use the null check operator on 'user' for the update.
      await user!.updatePassword(newPassword);
    } on FirebaseException catch (e) {
      errorCode = e.code;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Contraseña débil.';
          break;
        case 'requires-recent-login':
          errorMessage = 'Debe inciar sesión antes de realizar el cambio';
          break;
      }
      throw AuthException(errorCode: errorCode, errorMessage: errorMessage);
    } catch (e) {
      String errorCode = 'Error';
      String errorMessage = "$e";
      throw AuthException(errorCode: errorCode, errorMessage: errorMessage);
    }
  }

  String? getuserUid() {
    if (_isUserAuthenticated()) return _auth.currentUser?.uid;
    return null;
  }


  // Esta fucnión está acá por motivos de prueba para el flujo de registro.
  Future<void> registerUserProfile(app_user.User data) async {
    final String dbCollection = "usuarios";
    final String userId = getuserUid() ?? _db.collection(dbCollection).doc().id;
    final userData = <String, String>{
      "email": data.getEmail(),
      "name": data.getName(),
    };

    await _db
        .collection(dbCollection)
        .doc(userId)
        .set(userData)
        .onError(
          (e, _) => throw AuthException(
            errorCode: "error de carga",
            errorMessage: e.toString(),
          ),
        );
  }
}
