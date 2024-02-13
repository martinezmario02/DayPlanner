import '../model/db.dart';
import '../model/tarea.dart';
import '../model/usuario.dart';

DB db = DB();

class ControladorTareas{
  // Devolver todas las tareas:
  Future<List<Map<String, dynamic>>> tareas() async{
    return await db.tareas();
  }

  // Devolver todas las tareas de un día concreto:
  Future<List<Map<String, dynamic>>> tareasDia(String dia) async{
    return await db.tareasDia(dia);
  }

  // Devolver todas las tareas de un tipo concreto:
  Future<List<Map<String, dynamic>>> tareasTipo(int tipo) async{
    return await db.tareasTipo(tipo);
  }

  // Devolver todas las tareas de un tipo y un día concreto:
  Future<List<Map<String, dynamic>>> tareasTipoDia(int tipo, String dia) async{
    return await db.tareasTipoDia(tipo, dia);
  }

  // Comprobaciones de tipo de la tarea:
  Future<List<Map<String, dynamic>>> esColegio(int id){
    return db.esColegio(id);
  }

  Future<List<Map<String, dynamic>>> esOcio(int id){
    return db.esOcio(id);
  }

  // Devolver la dificultad de una tarea:
  Future<List<Map<String, dynamic>>> getDificultad(int id) async{
    return await db.getDificultad(id);
  }

  // Devolver los pasos en función del tipo:
  Future<List<Map<String, dynamic>>> getPasosColegio(int id) async{
    return await db.getPasosColegio(id);
  }

  Future<List<Map<String, dynamic>>> getPasosOcio(int id) async{
    return await db.getPasosOcio(id);
  }

  Future<List<Map<String, dynamic>>> getPasosHogar(int id) async{
    return await db.getPasosHogar(id);
  }

  // Función para guardar el progreso de una tarea:
  Future<void> guardarProgreso(int id, double tiempo, int paso) async{
    return await db.guardarProgreso(id, tiempo, paso);
  }

  Future<void> actualizarEstado(int id) async{
    return await db.guardarEstado(id);
  }

  // Guardar tareas en la bd:
  // Future<void> guardarTareaColegio(String nombre, String asignatura, String fecha, double tiempo, String dificultad, String tipo, String descripcion, String objetivo) async{
  //   return await db.guardarTareaColegio(nombre, asignatura, fecha, tiempo, dificultad, tipo, descripcion, objetivo);
  // }
  Future<void> guardarTareaColegio(Tarea tarea, String asignatura, String tipo, List<String> pasos) async{
    return await db.guardarTareaColegio(tarea, asignatura, tipo, pasos);
  }
}