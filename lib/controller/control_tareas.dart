import '../model/db.dart';
import '../model/tarea.dart';
import '../model/usuario.dart';

DB db = DB();

class ControladorTareas{
  Future<List<Map<String, dynamic>>> tareas() async{
    return await db.tareas();
  }

  Future<List<Map<String, dynamic>>> tareasTipo(int tipo) async{
    return await db.tareasTipo(tipo);
  }

  Future<List<Map<String, dynamic>>> esColegio(int id){
    return db.esColegio(id);
  }

  Future<List<Map<String, dynamic>>> esOcio(int id){
    return db.esOcio(id);
  }

  Future<List<Map<String, dynamic>>> getDificultad(int id) async{
    return await db.getDificultad(id);
  }
}