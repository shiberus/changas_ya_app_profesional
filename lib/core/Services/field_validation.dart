class FieldValidation {

  String? validateName(String? name){
    if (name == null){
      return 'Ingrese un nombre.';
    }
    if (name.length > 50){
      return 'Nombre demasiado largo.';
    }
    return null;
  }

  String? validateEmail(String? text){
  if (text == null || !text.contains('@') || !text.contains('.com')) {
    return 'Email invalido';
  }
  return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'La contraseña no puede estar vacía.';
    }

    if (password.length < 9) {
      return 'Debe tener al menos 9 caracteres.';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Debe contener al menos una letra mayúscula.';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Debe contener al menos una letra minúscula.';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Debe contener al menos un número.';
    }

    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Debe contener al menos un símbolo (ej.: !@#\$).';
    }

    return null;
  }

  String? confirmPassword(String? password, String? confirmation){
    
    if (confirmation == null || confirmation.isEmpty){
      return 'Ingrese la confirmación.';
    }
    if (confirmation != password){
      return 'La contraseña ingresada es distinta.';
    }
    return null;
  }

}