import 'package:changas_ya_app/Domain/Auth_exception/auth_exception.dart';
import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:changas_ya_app/core/data/profile_repository.dart';

class UserAuthController {

  final FirebaseAuth _auth;
  final ProfileRepository _profileRepository;
  
  
  UserAuthController({FirebaseAuth? auth, ProfileRepository? profileRepository }): //<--
    _auth = auth ?? FirebaseAuth.instance,
    _profileRepository = profileRepository ?? ProfileRepository(FirebaseFirestore.instance);

  /// Función asíncrona para el registro de usuario en Firebase.
  ///
  /// [email]: Correo electrónico del usuario.
  /// [password] Contraseña ingresada por el usuario.
  ///
  /// @returns: (bool, String)
  //Firma original del método.
  //Future<void> registerUser(String email, String password) async {
  Future<void> registerUser(Profile newUser, String userPassword) async {
    String errorCode = '';
    String errorMessage = '';
    String? userUuid;
    try {
      await _auth.createUserWithEmailAndPassword(
        email: newUser.email,
        password: userPassword,
      );

      userUuid = getuserUid();
            

      await _profileRepository.registerUserProfile(newUser, userUuid);

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



}
