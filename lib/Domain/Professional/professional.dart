class Professional {
  final String id;
  final String nombre;
  final String email;
  final String fotoUrl;
  final String descripcion;
  final List<String> oficios;
  final int trabajosRealizados;
  final String telefono;
  final double calificacionPromedio;
  final List<Opinion> opiniones;

  Professional({
    required this.id,
    required this.nombre,
    required this.email,
    required this.fotoUrl,
    required this.descripcion,
    required this.oficios,
    required this.trabajosRealizados,
    required this.telefono,
    required this.calificacionPromedio,
    required this.opiniones,
  });

  factory Professional.fromFirestore(Map<String, dynamic> data) {
    return Professional(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      email: data['email'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      descripcion: data['descripcion'] ?? '',
      oficios: List<String>.from(data['oficios'] ?? []),
      trabajosRealizados: data['trabajosRealizados'] ?? 0,
      telefono: data['telefono'] ?? '',
      calificacionPromedio: (data['calificacionPromedio'] ?? 0).toDouble(),
      opiniones: (data['opiniones'] as List<dynamic>? ?? [])
          .map((o) => Opinion.fromMap(o))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'fotoUrl': fotoUrl,
      'descripcion': descripcion,
      'oficios': oficios,
      'trabajosRealizados': trabajosRealizados,
      'telefono': telefono,
      'calificacionPromedio': calificacionPromedio,
      'opiniones': opiniones.map((o) => o.toMap()).toList(),
    };
  }
}

class Opinion {
  final String nombreCliente;
  final String comentario;
  final double calificacion;

  Opinion({
    required this.nombreCliente,
    required this.comentario,
    required this.calificacion,
  });

  factory Opinion.fromMap(Map<String, dynamic> map) {
    return Opinion(
      nombreCliente: map['nombreCliente'] ?? '',
      comentario: map['comentario'] ?? '',
      calificacion: (map['calificacion'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombreCliente': nombreCliente,
      'comentario': comentario,
      'calificacion': calificacion,
    };
  }
}
