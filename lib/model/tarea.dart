enum Dificultad{
  alta, media, baja
}

enum TipoColegio{
  estudio, deberes
}

enum TipoOcio{
  jugar, deporte
}

enum TipoHogar{
  limpiar, ordenar
}

class Tarea{
  int id;
  String nombre;
  String fecha;
  Dificultad dificultad;
  double tiempo;
  String objetivo;
  List<String> pasos = [];

  Tarea(
    this.id, 
    this.nombre, 
    this.fecha, 
    this.dificultad, 
    this.tiempo,
    this.objetivo,
    this.pasos
  );
}

class TareaColegio extends Tarea{
  String asignatura;
  TipoColegio tipo;
  String temario;

  TareaColegio(
    int id, 
    String nombre, 
    String fecha, 
    Dificultad dificultad, 
    double tiempo,
    String objetivo,
    List<String> pasos,
    this.asignatura,
    this.tipo,
    this.temario
  ) : super(id, nombre, fecha, dificultad, tiempo, objetivo, pasos);
}

class TareaOcio extends Tarea{
  String descripcion;
  TipoOcio tipo;

  TareaOcio(
    int id, 
    String nombre, 
    String fecha, 
    Dificultad dificultad, 
    double tiempo,
    String objetivo,
    List<String> pasos,
    this.descripcion,
    this.tipo
  ) : super(id, nombre, fecha, dificultad, tiempo, objetivo, pasos);
}

class TareaHogar extends Tarea{
  String descripcion;
  TipoHogar tipo;

  TareaHogar(
    int id, 
    String nombre, 
    String fecha, 
    Dificultad dificultad, 
    double tiempo,
    String objetivo,
    List<String> pasos,
    this.descripcion,
    this.tipo
  ) : super(id, nombre, fecha, dificultad, tiempo, objetivo, pasos);
}