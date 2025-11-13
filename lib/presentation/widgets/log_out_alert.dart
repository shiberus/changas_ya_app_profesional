import 'package:flutter/material.dart';
import 'package:changas_ya_app/core/Services/user_auth_controller.dart';
import 'package:changas_ya_app/Domain/Auth_exception/auth_exception.dart';
import 'package:go_router/go_router.dart';

class LogOutAlert extends StatelessWidget {
  LogOutAlert({super.key});
  final UserAuthController authController = UserAuthController();

  @override
  Widget build(BuildContext context) {

    void snackBarPopUp(String message, Color? background) {
      SnackBar snackBar = SnackBar(
        content: Text(message),
        backgroundColor: background,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Future<bool> userLogOut(BuildContext context) async {
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

    return AlertDialog.adaptive(
        title: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              const SizedBox(width: 5.0),
              const Flexible(
                child: Text(
                  'Cerrar sesión',
                ),
              ),
            ],
          ),
        ),
        content: Align(
          alignment: Alignment.center, 
          heightFactor: 1.0,
          child: const Text("¿Desea cerrar la sesión actual?")
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              bool isClosed = await userLogOut(context);
              if (context.mounted && isClosed) {
                Navigator.pop(context);
                context.go("/login");
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[500]),
            child: Text("Cerrar", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'No'),
            child: Text("No"),
          ),
        ],
      );
  }
}
