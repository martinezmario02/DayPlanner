import '../model/db.dart';
import '../model/tarea.dart';

DB db = DB();

class ControladorTareas{
  // Devolver todas las tareas:
  Future<List<Map<String, dynamic>>> tareas(int usuario) async{
    return await db.tareas(usuario);
  }

  // Devolver todas las tareas de un día concreto:
  Future<List<Map<String, dynamic>>> tareasDia(String dia, int usuario) async{
    return await db.tareasDia(dia, usuario);
  }

  // Devolver todas las tareas de un tipo concreto:
  Future<List<Map<String, dynamic>>> tareasTipo(int tipo, int usuario) async{
    return await db.tareasTipo(tipo, usuario);
  }

  // Devolver todas las tareas de un tipo y un día concreto:
  Future<List<Map<String, dynamic>>> tareasTipoDia(int tipo, String dia, int usuario) async{
    return await db.tareasTipoDia(tipo, dia, usuario);
  }

  // Devolver todas las tareas sin planificar:
  Future<List<Map<String, dynamic>>> tareasSinPlanificar(int usuario) async{
    return await db.tareasSinPlanificar(usuario);
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
  Future<void> guardarTareaColegio(Tarea tarea, String asignatura, String tipo, List<String> pasos) async{
    return await db.guardarTareaColegio(tarea, asignatura, tipo, pasos);
  }

  // Guardar la fecha de la tarea:
  Future<void> anadirFecha(int id, DateTime dia) async{
    await db.anadirFecha(id, dia);
  }

  // Ordenar las tareas en función de la prioridad:
  Future<void> ordenarTareas(int id, int prioridadAntigua, int prioridad, DateTime fecha) async{
    await db.ordenarTareas(id, prioridadAntigua, prioridad, fecha);
  }

  // Quitar una tarea de organizada:
  Future<void> borrarTarea(int id) async{
    await db.borrarTarea(id);
  }
}