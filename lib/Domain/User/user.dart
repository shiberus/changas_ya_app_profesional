class Opinion {
  final String comentario;
  final int calificacion;

  Opinion(this.comentario, this.calificacion);
}

class User {
  String _name = '';
  String _email = '';
  String _password = '';
  String _telefono = '';
  String _direccion = '';
  String _fotoUrl = '';
  List<Opinion> _opiniones = [];

  User(String name, String email, String password) {
    _name = name;
    _email = email;
    _password = password;
  }

  String getName() => _name;
  String getEmail() => _email;
  String getPassword() => _password;
  String getTelefono() => _telefono;
  String getDireccion() => _direccion;
  String getFotoUrl() => _fotoUrl;
  List<Opinion> getOpiniones() => _opiniones;

  void setName(String name) => _name = name;
  void setEmail(String email) => _email = email;
  void setPassword(String password) => _password = password;
  void setTelefono(String tel) => _telefono = tel;
  void setDireccion(String dir) => _direccion = dir;
  void setFotoUrl(String url) => _fotoUrl = url;
  void setOpiniones(List<Opinion> opiniones) => _opiniones = opiniones;
}
