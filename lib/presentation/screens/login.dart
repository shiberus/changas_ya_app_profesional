import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:changas_ya_app/Domain/User/user.dart';
import 'package:changas_ya_app/core/Services/validate_users.dart';
import 'package:changas_ya_app/core/Services/field_validation.dart';
import 'package:changas_ya_app/presentation/components/app_bar.dart';
import 'package:changas_ya_app/core/Services/user_auth_controller.dart';

class AppLogin extends StatefulWidget {
  static const String name = 'login';
  const AppLogin({super.key});

  @override
  State<AppLogin> createState() => _AppLoginState();
}

class _AppLoginState extends State<AppLogin> {
  // Agregar instancia de objeto usuario.

  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  String _inputEmail = '';
  String _inputPassword = '';

  FieldValidation validation = FieldValidation();
  final UserAuthController _auth = UserAuthController();

  final _logInFormkey = GlobalKey<FormState>();

  //Validate the usser credentials using the auth controller.
  Future<bool> _validateUserCredentials(User user) async {

      bool isAuthenticated = false;
      String snackBarMessage = '';
      Color? snackBarColor = Colors.black;

      if (_logInFormkey.currentState!.validate()){
        try{
          
          await _auth.userLogIn(user.getEmail(), user.getPassword());
          
          isAuthenticated = true;
          snackBarMessage = '¡Sesión inciada! ';
          snackBarColor = Colors.green[400];
        } on Exception catch (e){
          snackBarMessage = e.toString();
          snackBarColor = Colors.red[400];
        }
      } else {
        snackBarMessage = 'Ocurrió un problema...';
        snackBarColor = Colors.red[400];
      }

      snackBarPopUp(snackBarMessage, snackBarColor);
      return isAuthenticated;
  }

  void snackBarPopUp (String message, Color? background){
    SnackBar snackBar = SnackBar(
          content: Text(message),
          backgroundColor: background,
          );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Test validation
  bool validateData(User userData) {
    ValidateUsers authenticate = ValidateUsers();
    return authenticate.dummyValidation(userData);
    //return authenticate.validateUser(userData);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Form(
          key: _logInFormkey,
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
                      setState(() {
                        _inputEmail = emailController.text;
                      });
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
                      setState(() {
                        _inputPassword = passwordController.text;
                      });
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (String? password) {
                    return validation.validatePassword(password);
                  },
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
                    onPressed: ()async {
                      User userToAuthenticate = User('', _inputEmail, _inputPassword);
                      if (await _validateUserCredentials(userToAuthenticate) && context.mounted){
                        context.push('/');
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
                    onPressed: () {},
                    child: Text("Nosotros", style: textStyle.labelMedium),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}