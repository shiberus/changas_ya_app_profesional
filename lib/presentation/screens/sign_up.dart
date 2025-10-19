import 'package:changas_ya_app/Domain/User/user.dart';
import 'package:flutter/material.dart';
import 'package:changas_ya_app/core/Services/field_validation.dart';

class SignUp extends StatefulWidget {
  static const String  name = 'signup';
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _AppSignUp();
}


class _AppSignUp extends State<SignUp> {

  //Instance for validation
  FieldValidation validation = FieldValidation();

  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController confirmedPassController = TextEditingController();
  String _inputName = '';
  String _inputEmail = '';
  String _inputPassword = '';
  String _inputConfirmedPassword = '';
  


  final _formkey = GlobalKey<FormState>();

  void _submitRegister(){
    
    String snackBarMessage = '';
    

    if (!_formkey.currentState!.validate()){ 
      snackBarMessage = 'No se pudo registrar el usuario'; 
    } else {
      snackBarMessage = '¡Usuario registrado!';
    }
    SnackBar snackBar = SnackBar(content: Text(snackBarMessage));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {

    
    
    final EdgeInsets textFieldsInset = EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0);
    
    final textStyle = Theme.of(context).textTheme;
    final TextStyle titleStyle = TextStyle(
      fontSize: textStyle.titleLarge?.fontSize ?? 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
      letterSpacing: 0.2,
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text('Changas Ya'),
        backgroundColor: Colors.blue,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RegisterTitleWidget(titleStyle: titleStyle),
            
            Form(
              key: _formkey,
              child: Column(
                children: [
                
                  // User name
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: nameController,
                      onChanged: (String nameValue) {
                        if (nameController.text.isNotEmpty){
                          setState(() {
                            _inputName = nameController.text;
                          });
                        }                
                      },
                      obscureText: false,
                      decoration: InputDecoration(border: OutlineInputBorder(), 
                                                  labelText: 'Nombre de usuario'), 
                    ),
                  ),
                
                  //Email
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: emailController,
                      onChanged: (String mailValue) {
                        if (emailController.text.isNotEmpty){
                          setState(() {
                            _inputEmail = emailController.text;
                          });
                        }                
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), 
                        labelText: 'E-Mail',
                        ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? email) { return validation.validateEmail(email); },
                    ),
                  ),
                
                  //Password
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: passwordController,
                      onChanged: (String passwordValue) {
                        if (passwordController.text.isNotEmpty){
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
                      validator: (String? password) { return validation.validatePassword(password); },
                    ),
                  ),
                
                  //Confirm password
                  Container(
                    margin: textFieldsInset,
                    child: TextFormField(
                      controller: confirmedPassController,
                      onChanged: (String confirmedPasswordValue) {
                        if (confirmedPassController.text.isNotEmpty){
                          setState(() {
                            _inputConfirmedPassword = confirmedPassController.text;
                          });
                        }                
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(), 
                        labelText: 'Confirmar contraseña',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? confirmedPassword) { 
                        if (_inputPassword.isEmpty){
                          return 'Primero ingrese una contraseña válida.';
                        }
                        return validation.confirmPassword(_inputPassword, confirmedPassword); 
                      },
                    ),
                  ),
                
                  SizedBox(height: 20.0),
                
                  ElevatedButton(
                    onPressed: (){ _submitRegister(); }, 
                    style: ElevatedButton.styleFrom( backgroundColor: Colors.blue[400]),
                    child: Text('Registrarse', style: TextStyle(color: Colors.white),),
                  ),
                    
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}

class _RegisterTitleWidget extends StatelessWidget {
  const _RegisterTitleWidget({
    super.key,
    required this.titleStyle,
  });

  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 43, 171, 245),
        borderRadius: BorderRadius.all(Radius.circular(15.0))
      ),
      child: Column(
        children: [
          Column(
    
            children: [
            Image.asset('lib/images/signup_banner.png',fit: BoxFit.contain, scale: 5.0,),
          ]),
    
          Column(
            children: [
              Center(child: Text('Registro de usuario', style: titleStyle)),
            ],
          )
        ],
      ),
    );
  }
}
