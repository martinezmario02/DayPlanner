import '../model/db.dart';

DB db = DB();

class ControladorExamenes{
  // Devolver los exámenes pendientes:
  Future<List<Map<String, dynamic>>> examenesPendientes(int id) async{
    return await db.examenesPendientes(id);
  }

  // Devolver los exámenes realizados:
  Future<List<Map<String, dynamic>>> examenesRealizados(int id) async{
    return await db.examenesRealizados(id);
  }

  // Devolver la dificultad de un examen:
  Future<List<Map<String, dynamic>>> getDificultadExamen(int id) async{
    return await db.getDificultadExamen(id);
  }

  // Guardar la nota de un examen:
  Future<void> guardarNota(int id, double nota) async{
    return await db.guardarNota(id, nota);
  }

  // Guardar la nota de un examen:
  Future<void> guardarExamen(String asignatura, String temario, String fecha, String dificultad, int idUsuario) async{
    return await db.guardarExamen(asignatura, temario, fecha, dificultad, idUsuario);
  }
}