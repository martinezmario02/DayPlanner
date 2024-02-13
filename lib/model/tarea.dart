// ignore_for_file: non_constant_identifier_names

class Tarea{
  int id;
  String nombre;
  String fecha;
  String dificultad;
  double tiempo;
  String objetivo;
  String descripcion;
  String tipo_tarea;
  String estado;
  double tiempo_actual;
  int paso_actual;
  int id_usuario;

  Tarea(
    this.id, 
    this.nombre, 
    this.fecha, 
    this.dificultad, 
    this.tiempo,
    this.objetivo,
    this.descripcion,
    this.tipo_tarea,
    this.estado,
    this.tiempo_actual,
    this.paso_actual,
    this.id_usuario
  );

  factory Tarea.fromMap(Map<String, dynamic> map){
    return Tarea(
      map['id'], 
      map['nombre'], 
      map['fecha'], 
      map['dificultad'], 
      map['tiempo'],
      map['objetivo'],
      map['descripcion'],
      map['tipo_tarea'],
      map['estado'],
      map['tiempo_actual'],
      map['paso_actual'],
      map['id_usuario']
    );
  }
}

class Paso{
  int id;
  int idTarea;
  String descripcion;

  Paso(this.id, this.idTarea, this.descripcion);
}

class TareaColegio extends Tarea{
  String asignatura;
  String tipo;

  TareaColegio(
    int id, 
    String nombre, 
    String fecha, 
    String dificultad, 
    double tiempo,
    String objetivo,
    String descripcion,
    String tipo_tarea,
    String estado,
    double tiempo_actual,
    int paso_actual,
    int id_usuario,
    this.asignatura,
    this.tipo,
  ) : super(id, nombre, fecha, dificultad, tiempo, objetivo, descripcion, tipo_tarea, estado, tiempo_actual, paso_actual, id_usuario);
}

class TareaOcio extends Tarea{
  String tipo;

  TareaOcio(
    int id, 
    String nombre, 
    String fecha, 
    String dificultad, 
    double tiempo,
    String objetivo,
    String descripcion,
    String tipo_tarea,
    String estado,
    double tiempo_actual,
    int paso_actual,
    int id_usuario,
    this.tipo
  ) : super(id, nombre, fecha, dificultad, tiempo, objetivo, descripcion, tipo_tarea, estado, tiempo_actual, paso_actual, id_usuario);
}

class TareaHogar extends Tarea{
  String tipo;

  TareaHogar(
    int id, 
    String nombre, 
    String fecha, 
    String dificultad, 
    double tiempo,
    String objetivo,
    String descripcion,
    String tipo_tarea,
    String estado,
    double tiempo_actual,
    int paso_actual,
    int id_usuario,
    this.tipo
  ) : super(id, nombre, fecha, dificultad, tiempo, objetivo, descripcion, tipo_tarea, estado, tiempo_actual, paso_actual, id_usuario);
}