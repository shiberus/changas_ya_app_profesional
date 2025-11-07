import 'package:flutter/material.dart';
import 'package:changas_ya_app/presentation/components/banner_widget.dart';
import 'package:changas_ya_app/core/Services/field_validation.dart';
import 'package:changas_ya_app/presentation/components/app_bar.dart';
import 'package:changas_ya_app/core/Services/user_auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:changas_ya_app/Domain/Auth_exception/auth_exception.dart';

class ChangePassword extends ConsumerWidget {
  static const String screenName = 'changePassword';

  const ChangePassword({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

  // Controllers for the text inputs and value storage attributes.
  late TextEditingController emailController = TextEditingController();
  late TextEditingController oldPasswordController = TextEditingController();
  late TextEditingController newPasswordController = TextEditingController();
  late TextEditingController confirmedNewPasswordController =
      TextEditingController();
  String inputEmail = '';
  String inputOldPassword = '';
  String inputNewPassword = '';

  // Intance for validation class.
  FieldValidation validation = FieldValidation();

  // Key to indentify the form.
  final changePasswordFormkey = GlobalKey<FormState>();

  // Instance for authentication.
  final UserAuthController auth = UserAuthController();

    void snackBarPopUp(String message, Color? background) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: background,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Validate the password change.
  Future<bool> validateChange() async {
    bool isPasswordChanged = false;
    String snackBarMessage = '';
    Color? snackBarColor = Colors.red[400];

    if (changePasswordFormkey.currentState!.validate()) {
      try {
        await auth.changeUserPassword(
          inputEmail,
          inputOldPassword,
          inputNewPassword,
        );
        snackBarMessage = '¡Se cambió la contraseña!';
        snackBarColor = Colors.green[400];
        isPasswordChanged = true;
      } on AuthException catch (e) {
        snackBarMessage = e.showErrorMessage();
      }
    } else {
      snackBarMessage = 'Ocurrió un problema...';
      snackBarColor = Colors.red[400];
    }

    snackBarPopUp(snackBarMessage, snackBarColor);
    return isPasswordChanged;
  }
  
    // Insets for text field alignment
    final EdgeInsets textFieldsInset = EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 20.0,
    );
    // Banner attributes.
    final String bannerImage = 'lib/images/change_password_banner.png';
    final String bannerTitle = 'Cambio de contraseña';
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
              imageAsset: bannerImage,
              titleStyle: titleStyle,
              titleToShow: bannerTitle,
            ),

            Form(
              key: changePasswordFormkey,
              child: Column(
                children: [
                  //Email text field
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

                  //Old password text field
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: oldPasswordController,
                      onChanged: (String passwordValue) {
                        if (oldPasswordController.text.isNotEmpty) {
                            inputOldPassword = oldPasswordController.text;
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña anterior',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? password) {
                        return validation.validatePassword(password);
                      },
                    ),
                  ),

                  //New password text field
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: newPasswordController,
                      onChanged: (String newPasswordValue) {
                        if (newPasswordController.text.isNotEmpty) {
                            inputNewPassword = newPasswordController.text;
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nueva contraseña',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? newPassword) {
                        return validation.validatePassword(newPassword);
                      },
                    ),
                  ),

                  //Confirm password
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: confirmedNewPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirmar nueva contraseña',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? confirmedNewPassword) {
                        if (inputNewPassword.isEmpty) {
                          return 'Primero ingrese una contraseña válida.';
                        }
                        return validation.confirmPassword(
                          inputNewPassword,
                          confirmedNewPassword,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20.0),

                  ElevatedButton(
                    onPressed: ()  async {
                      bool passwordChanged = await validateChange();
                    
                      if (passwordChanged && context.mounted){
                        context.push('/');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                    ),
                    child: Text(
                      'Cambiar contraseña',
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
