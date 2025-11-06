class AuthException implements Exception {
  
  final String errorMessage;
  final String errorCode;

  AuthException({
    required this.errorCode,
    required this.errorMessage,
  });
  
  String showErrorMessage() {
    return errorMessage;
  }

  String getErrorCode() {
    return errorCode;
  }

  String showError(){
    return '$errorMessage (código de error: $errorCode)';
  }
}