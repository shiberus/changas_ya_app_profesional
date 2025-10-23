import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:changas_ya_app/Domain/User/user.dart';
import 'package:changas_ya_app/core/Services/validate_users.dart';
import 'package:changas_ya_app/core/Services/field_validation.dart';
import 'package:changas_ya_app/presentation/components/app_bar.dart';

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
              child: Text("¿Cambiar contraseña?", style: textStyle.labelMedium),
            ),

            SizedBox(height: 10.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    User newUser = User('', _inputEmail, _inputPassword);
                    if (validateData(newUser)) {
                      context.go('/', extra: {newUser.getName()});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400]
                  ),
                  child: Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
                ),

                SizedBox(width: 10.0),
                Text("ó"),
                SizedBox(width: 10.0),

                ElevatedButton(
                  onPressed: () {
                    context.push('/signup');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[100]
                  ),
                  child: Text('Registarse', style: TextStyle(color: Colors.grey[800])),
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
                  child: Text("Nosotros", style: textStyle.labelMedium,)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
