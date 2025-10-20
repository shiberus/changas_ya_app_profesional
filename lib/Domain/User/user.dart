class User {
  String _name = '';
  String _email = ''; 
  String _password = '';

  User(String name, String email, String password){
    setName(name);
    setEmail(email);
    setPassword(password);
  }

  String getName(){
    return _name;
  }

  String getEmail(){
    return _email;
  }

  String getPassword(){
    return _password;
  }
  
  void setName(String newName){
    _name = newName;
  }

  void setEmail(String newEmail){
    _email = newEmail;
  }
  void setPassword(String newPassword){
    _password = newPassword;
  }
}