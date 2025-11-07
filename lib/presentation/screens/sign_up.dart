import 'package:changas_ya_app/Domain/Auth_exception/auth_exception.dart';
import 'package:changas_ya_app/Domain/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:changas_ya_app/core/Services/field_validation.dart';
import 'package:changas_ya_app/presentation/components/banner_widget.dart';
import 'package:changas_ya_app/presentation/components/app_bar.dart';
import 'package:changas_ya_app/core/Services/user_auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUp extends ConsumerWidget {
  static const String name = 'signup';

  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Instance for validation
    FieldValidation validation = FieldValidation();

    late TextEditingController nameController = TextEditingController();
    late TextEditingController emailController = TextEditingController();
    late TextEditingController passwordController = TextEditingController();
    late TextEditingController confirmedPassController =
        TextEditingController();
    String inputName = '';
    String inputEmail = '';
    String inputPassword = '';
    //String inputConfirmedPassword = '';

    // Key to identify the form.
    final formkey = GlobalKey<FormState>();
    final UserAuthController auth = UserAuthController();

    void snackBarPopUp(String message, Color? background) {
      SnackBar snackBar = SnackBar(
        content: Text(message),
        backgroundColor: background,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // Use the form data, validate it and submmit it to the data base.
    Future<bool> submitRegister() async {
      String snackBarMessage = '';
      Color? snackBarColor = Colors.red[400];
      bool userIsWorker = false;
      bool registerSucced = false;
      String emptyUserId = '';

      if (formkey.currentState!.validate()) {
        Profile newUser = Profile(
          uid: emptyUserId, 
          name: inputName, 
          email: inputEmail, 
          isWorker: userIsWorker);

        try {
          await auth.registerUser(newUser, inputPassword);

          registerSucced = true;
          snackBarMessage = '¡Usuario registraso con exito!';
          snackBarColor = Colors.green[400];
        } on AuthException catch (e) {
          snackBarMessage = e.showErrorMessage();
        }
      } else {
        snackBarMessage = 'Verifique los valores ingresados en el formulario.';
      }

      snackBarPopUp(snackBarMessage, snackBarColor);
      return registerSucced;
    }

    final EdgeInsets textFieldsInset = EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 20.0,
    );
    final String titleImage = 'lib/images/signup_banner.png';
    final String screenTitle = 'Registro de ususrio';
    final textStyle = Theme.of(context).textTheme;
    final TextStyle titleStyle = TextStyle(
      fontSize: textStyle.titleLarge?.fontSize ?? 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.2,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Bannerwidget(
              imageAsset: titleImage,
              titleStyle: titleStyle,
              titleToShow: screenTitle,
            ),

            //Form for user register.
            Form(
              key: formkey,
              child: Column(
                children: [
                  // User name
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: nameController,
                      onChanged: (String nameValue) {
                        if (nameController.text.isNotEmpty) {
                          inputName = nameController.text;
                        }
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre de usuario',
                      ),
                    ),
                  ),

                  //Email
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: emailController,
                      onChanged: (String mailValue) {
                        if (emailController.text.isNotEmpty) {
                          inputEmail = emailController.text;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-Mail',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? email) {
                        return validation.validateEmail(email);
                      },
                    ),
                  ),

                  //Password
                  Container(
                    margin: textFieldsInset,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? password) {
                        return validation.validatePassword(password);
                      },
                    ),
                  ),

                  //Confirm password
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: confirmedPassController,
                      onChanged: (String confirmedPasswordValue) {
                        // if (confirmedPassController.text.isNotEmpty) {
                        //     _inputConfirmedPassword =
                        //         confirmedPassController.text;
                        // }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirmar contraseña',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? confirmedPassword) {
                        if (inputPassword.isEmpty) {
                          return 'Primero ingrese una contraseña válida.';
                        }
                        return validation.confirmPassword(
                          inputPassword,
                          confirmedPassword,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20.0),

                  ElevatedButton(
                    onPressed: () async {
                      bool isRegitered = await submitRegister();
                      if (isRegitered && context.mounted){
                        context.go("/login");
                      } 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                    ),
                    child: Text(
                      'Registrarse',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
