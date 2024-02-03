import '../model/db.dart';
import '../model/tarea.dart';
import '../model/usuario.dart';

class ControladorTareas{
  Future<List<Map<String, dynamic>>> tareas() async{
    return await DB.instancia.tareas();
  }
}