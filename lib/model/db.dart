import 'package:path/path.dart';
import 'package:postgres/postgres.dart';
import 'usuario.dart';
import 'tarea.dart';

class DB{
  
  PostgreSQLConnection? conexion = PostgreSQLConnection('dumbo.db.elephantsql.com', 5432, 'ctvuzlir', username: 'ctvuzlir', password: '9JO_A6DbNzE91VzD7Qcsu7sSJjUh8uAa');

  conectar() async {
    if (conexion?.isClosed == true) await conexion?.open();
  }

  desconectar(){
    conexion?.close();
  }

  // Función para ejecuciones de sentencias bd:
  Future<List<Map<String, Map<String, dynamic>>>> ejecutar(String sentencia) async{
    List<Map<String, Map<String, dynamic>>> resultado = [];

    await conectar();

    try{
      resultado = await conexion!.mappedResultsQuery(sentencia);
      return resultado;
    } catch(e){
      print('ERROR: $e');
      return [];
    } 
  }

  // Devolver todas las tareas:
  Future<List<Map<String, dynamic>>> tareas() async{
    return await ejecutar("select * from tareas");
  }

  // Devolver todas las tareas de un día concreto:
  Future<List<Map<String, dynamic>>> tareasDia(String dia) async{
    return await ejecutar("select * from tareas where to_char(fecha,'yyyy-mm-dd') = '$dia'");
  }

  // Devolver todas las tareas de un tipo concreto:
  Future<List<Map<String, dynamic>>> tareasTipo(int tipo) async{
    if(tipo == 0) return await ejecutar("select * from tareascolegio");
    else if(tipo == 1) return await ejecutar("select * from tareasocio");
    else return await ejecutar("select * from tareashogar");
  }

  // Devolver todas las tareas de un tipo y un día concreto:
  Future<List<Map<String, dynamic>>> tareasTipoDia(int tipo, String dia) async{
    if(tipo == 0) return await ejecutar("select * from tareascolegio where to_char(fecha,'yyyy-mm-dd') = '$dia'");
    else if(tipo == 1) return await ejecutar("select * from tareasocio where to_char(fecha,'yyyy-mm-dd') = '$dia'");
    else return await ejecutar("select * from tareashogar where to_char(fecha,'yyyy-mm-dd') = '$dia'");
  }

  // Comprobaciones de tipo de la tarea:
  Future<List<Map<String, dynamic>>> esColegio(int id) async{
    return await ejecutar("select * from tareascolegio where id=$id");
  }

  Future<List<Map<String, dynamic>>> esOcio(int id) async{
    return await ejecutar("select * from tareasocio where id=$id");
  }

  // Devolver la dificultad de una tarea:
  Future<List<Map<String, dynamic>>> getDificultad(int id) async{
    return await ejecutar("select dificultad from tareas where id=$id");
  }

  // Devolver los pasos en función del tipo:
  Future<List<Map<String, dynamic>>> getPasosColegio(int id) async{
    var resultado = [];
    resultado = await ejecutar("select id_tarea from tareascolegio where id=$id");
    var idTarea = resultado[0]['tareascolegio']['id_tarea'];
    return await ejecutar("select * from pasoscolegio where id_tarea=$idTarea");
  } 

  Future<List<Map<String, dynamic>>> getPasosOcio(int id) async{
    var resultado = [];
    resultado = await ejecutar("select id_tarea from tareasocio where id=$id");
    var idTarea = resultado[0]['tareasocio']['id_tarea'];
    return await ejecutar("select * from pasosocio where id_tarea=$idTarea");
  } 

  Future<List<Map<String, dynamic>>> getPasosHogar(int id) async{
    var resultado = [];
    resultado = await ejecutar("select id_tarea from tareashogar where id=$id");
    var idTarea = resultado[0]['tareashogar']['id_tarea'];
    return await ejecutar("select * from pasoshogar where id_tarea=$idTarea");
  } 

  // Función para guardar el progreso de una tarea:
  Future<void> guardarProgreso(int id, double tiempo, int paso) async{
    await ejecutar("update tareas set tiempo_actual=$tiempo, paso_actual=$paso where id=$id");
  }

  Future<void> guardarEstado(int id) async{
    await ejecutar("update tareas set estado='realizada' where id=$id");
  }

  // Guardar tareas en la bd:
  // Future<void> guardarTareaColegio(String nombre, String asignatura, String fecha, double tiempo, String dificultad, String tipo, String descripcion, String objetivo) async{
  //   nombre = nombre.replaceAll("'", "''");
  //   asignatura = asignatura.replaceAll("'", "''");
  //   fecha = fecha.replaceAll("'", "''");
  //   dificultad = dificultad.replaceAll("'", "''");
  //   tipo = tipo.replaceAll("'", "''");
  //   descripcion = descripcion.replaceAll("'", "''");
  //   objetivo = objetivo.replaceAll("'", "''");
  //   await ejecutar("insert into tareascolegio (nombre, fecha, dificultad, tiempo, objetivo, descripcion, tipo_tarea, asignatura, tipo, id_usuario) values ('$nombre', TO_DATE('$fecha', 'YYYY-MM-DD'), '$dificultad', $tiempo, '$objetivo', '$descripcion', 'tareascolegio', '$asignatura', '$tipo', 1)");
  // }
  Future<void> guardarTareaColegio(Tarea tarea, String asignatura, String tipo, List<String> pasos) async{
    // Extraigo los valores:
    final nombre = tarea.nombre.replaceAll("'", "''");
    asignatura = asignatura.replaceAll("'", "''");
    final fecha = tarea.fecha.replaceAll("'", "''");
    final dificultad = tarea.dificultad.replaceAll("'", "''");
    final tiempo = tarea.tiempo;
    tipo = tipo.replaceAll("'", "''");
    final descripcion = tarea.descripcion.replaceAll("'", "''");
    final objetivo = tarea.objetivo.replaceAll("'", "''");

    // Añado la tarea:
    await ejecutar("insert into tareascolegio (nombre, fecha, dificultad, tiempo, objetivo, descripcion, tipo_tarea, asignatura, tipo, id_usuario) values ('$nombre', TO_DATE('$fecha', 'YYYY-MM-DD'), '$dificultad', '$tiempo', '$objetivo', '$descripcion', 'tareascolegio', '$asignatura', '$tipo', 1)");

    // Obtengo el id de la nueva tarea:
    var resultado = [];
    resultado = await ejecutar("select id_tarea from tareascolegio order by id desc limit 1");
    var id = resultado[0]['tareascolegio']['id_tarea'];

    // Añado los pasos:
    var contenido = '';
    for (int i = 1; i <= pasos.length; i++){
      contenido = pasos[i-1]; 
      await ejecutar("insert into pasoscolegio (id, id_tarea, descripcion) values ($i, $id, '$contenido')");
    }
  }
}