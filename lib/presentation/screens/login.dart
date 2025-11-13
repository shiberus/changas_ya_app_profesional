import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:changas_ya_app/Domain/User/user.dart' as app_user;
import 'package:changas_ya_app/core/Services/field_validation.dart';
import 'package:changas_ya_app/presentation/components/app_bar.dart';
import 'package:changas_ya_app/core/Services/user_auth_controller.dart';
import 'package:changas_ya_app/Domain/Auth_exception/auth_exception.dart';
import 'package:changas_ya_app/presentation/providers/auth_provider.dart';

class AppLogin extends ConsumerWidget {
  static const String name = 'login';
  const AppLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAuthenticated = ref.watch(authStateChangesProvider);

    late TextEditingController emailController = TextEditingController();
    late TextEditingController passwordController = TextEditingController();
    String inputEmail = '';
    String inputPassword = '';
    final textStyle = Theme.of(context).textTheme;

    FieldValidation validation = FieldValidation();
    final UserAuthController auth = UserAuthController();

    final logInFormkey = GlobalKey<FormState>();

    void snackBarPopUp(String message, Color? background) {
      SnackBar snackBar = SnackBar(
        content: Text(message),
        backgroundColor: background,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    //Validate the usser credentials using the auth controller.
    Future<bool> validateUserCredentials(app_user.User user) async {
      bool isAuthenticated = false;
      String snackBarMessage = '';
      Color? snackBarColor = Colors.red[400];

      if (logInFormkey.currentState!.validate()) {
        try {
          await auth.userLogIn(user.getEmail(), user.getPassword());

          isAuthenticated = true;
          snackBarMessage = '¡Sesión inciada! ';
          snackBarColor = Colors.green[400];
        } on AuthException catch (e) {
          snackBarMessage = e.showErrorMessage();
        }
      } else {
        snackBarMessage = 'Ocurrió un problema, verifique los campos.';
      }

      snackBarPopUp(snackBarMessage, snackBarColor);
      return isAuthenticated;
    }


    return userAuthenticated.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: AlertDialog(
            icon: Icon(Icons.warning_amber_rounded, color: Colors.amber),
            title: Text("Sesión invalida"),
            content: Text("Ocurrió un error al carga la sesión anterior"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  auth.userLogOut();
                  Navigator.popAndPushNamed(context, "/login");
                },
                child: Text("Ok"),
              ),
            ],
          ),
        ),
      ),
      data: (user) {
        if (user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => context.go("/"));
        }
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(),
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Form(
              key: logInFormkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0),
                    width: double.infinity,
                    height: 200,
                    child: Image.asset(
                      'lib/images/login_banner.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                    child: Text(
                      '> Ingrese a la aplicación <',
                      style: textStyle.titleLarge,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      controller: emailController,
                      onChanged: (String nameValue) {
                        if (emailController.text.isNotEmpty) {
                          inputEmail = emailController.text;
                        }
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-Mail',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? text) {
                        return validation.validateEmail(text);
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      controller: passwordController,
                      onChanged: (String passwordValue) {
                        if (passwordController.text.isNotEmpty) {
                          inputPassword = passwordController.text;
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                      ),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      context.push('/changePassword');
                    },
                    child: Text(
                      "¿Cambiar contraseña?",
                      style: textStyle.labelMedium,
                    ),
                  ),

                  SizedBox(height: 10.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          app_user.User userToAuthenticate = app_user.User(
                            '',
                            inputEmail,
                            inputPassword,
                          );
                          if (await validateUserCredentials(
                                userToAuthenticate,
                              ) &&
                              context.mounted) {
                            context.go('/');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400],
                        ),
                        child: Text(
                          'Iniciar sesión',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      SizedBox(width: 10.0),
                      Text("ó"),
                      SizedBox(width: 10.0),

                      ElevatedButton(
                        onPressed: () {
                          context.push('/signup');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[100],
                        ),
                        child: Text(
                          'Registarse',
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Instituto Tecnológico ORT - 2025',
                        style: textStyle.labelMedium,
                      ),
                      //TextButton(onPressed: () => { context.push(/nosotros)}, child: Text("Nosotros", style: textStyle.labelMedium)),
                      TextButton(
                        onPressed: () {
                          context.push('/nosotros');
                        },
                        child: Text("Nosotros", style: textStyle.labelMedium),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
