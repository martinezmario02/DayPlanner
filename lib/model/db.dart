import 'package:postgres/postgres.dart';
import 'tarea.dart';

class DB{
  
  PostgreSQLConnection? conexion = PostgreSQLConnection('dumbo.db.elephantsql.com', 5432, 'ctvuzlir', username: 'ctvuzlir', password: '9JO_A6DbNzE91VzD7Qcsu7sSJjUh8uAa');

  conectar() async {
    if (conexion?.isClosed == true) await conexion?.open();
  }

  desconectar(){
    conexion?.close();
  }

  /////////////////////////////////////////////////////////////////
  ///                                                           ///
  ///     FUNCIONES PARA LAS TAREAS                             ///
  ///                                                           ///
  /////////////////////////////////////////////////////////////////
  
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
  Future<List<Map<String, dynamic>>> tareas(int usuario) async{
    return await ejecutar("select * from tareas where id_usuario=$usuario");
  }

  // Devolver todas las tareas de un día concreto:
  Future<List<Map<String, dynamic>>> tareasDia(String dia, int usuario) async{
    return await ejecutar("select * from tareas where to_char(organizacion,'yyyy-mm-dd') = '$dia' and id_usuario=$usuario order by prioridad asc");
  }

  // Devolver todas las tareas de un tipo concreto:
  Future<List<Map<String, dynamic>>> tareasTipo(int tipo, int usuario) async{
    if(tipo == 0){
      return await ejecutar("select * from tareascolegio where id_usuario=$usuario");
    }else if(tipo == 1){
      return await ejecutar("select * from tareasocio where id_usuario=$usuario");
    }else{
      return await ejecutar("select * from tareashogar where id_usuario=$usuario");
    }
  }

  // Devolver todas las tareas de un tipo y un día concreto:
  Future<List<Map<String, dynamic>>> tareasTipoDia(int tipo, String dia, int usuario) async{
    if(tipo == 0){
      return await ejecutar("select * from tareascolegio where to_char(organizacion,'yyyy-mm-dd') = '$dia' and id_usuario=$usuario order by prioridad asc");
    }else if(tipo == 1){
      return await ejecutar("select * from tareasocio where to_char(organizacion,'yyyy-mm-dd') = '$dia' and id_usuario=$usuario order by prioridad asc");
    }else{
      return await ejecutar("select * from tareashogar where to_char(organizacion,'yyyy-mm-dd') = '$dia' and id_usuario=$usuario order by prioridad asc");
    }
  }

  // Devolver todas las tareas sin planificar:
  Future<List<Map<String, dynamic>>> tareasSinPlanificar(int usuario) async{
    return await ejecutar("select * from tareas where organizacion is null and id_usuario=$usuario");
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
    await ejecutar("update tareas set tiempo_actual=$tiempo, paso_actual=$paso, estado='iniciada' where id=$id");
  }

  Future<void> guardarEstado(int id) async{
    await ejecutar("update tareas set estado='realizada' where id=$id");
  }

  // Guardar tareas en la bd:
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
    final usuario = tarea.id_usuario;

    // Añado la tarea:
    await ejecutar("insert into tareascolegio (nombre, fecha, dificultad, tiempo, objetivo, descripcion, tipo_tarea, asignatura, tipo, id_usuario) values ('$nombre', TO_DATE('$fecha', 'YYYY-MM-DD'), '$dificultad', '$tiempo', '$objetivo', '$descripcion', 'tareascolegio', '$asignatura', '$tipo', $usuario)");

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

  // Guardar la fecha de la tarea:
  Future<void> anadirFecha(int id, DateTime dia) async{
    await ejecutar("update tareas set organizacion=to_date('$dia', 'yyyy-mm-dd'), prioridad=coalesce((select max(prioridad) from tareas where organizacion=to_date('$dia', 'yyyy-mm-dd')),0)+1 where id=$id");
  }

  // Ordenar las tareas en función de la prioridad:
  Future<void> ordenarTareas(int id, int prioridadAntigua, int prioridad, DateTime fecha) async{
    await ejecutar("update tareas set prioridad=$prioridad where id=$id");
    await ejecutar("update tareas set prioridad=case when prioridad = $prioridad then $prioridadAntigua when $prioridadAntigua < $prioridad and prioridad > $prioridadAntigua then prioridad-1 when $prioridadAntigua > $prioridad and prioridad < $prioridadAntigua then prioridad+1 else prioridad end where id<>$id and organizacion=to_date('$fecha', 'yyyy-mm-dd')");
  }

  /////////////////////////////////////////////////////////////////
  ///                                                           ///
  ///     FUNCIONES PARA LOS USUARIOS                           ///
  ///                                                           ///
  /////////////////////////////////////////////////////////////////
  
  // Función que comprueba las credenciales:
  Future<int> iniciarSesion(String correo, String contrasena) async{
    var resultado = [];
    resultado = await ejecutar("select id from usuarios where correo='$correo' and contrasena='$contrasena'");
    if(resultado.isEmpty){
      return -1;
    }else{
      return resultado[0]['usuarios']['id'];
    }
  }

  // Quitar una tarea de organizada:
  Future<void> borrarTarea(int id) async{
    await ejecutar("update tareas set prioridad=prioridad-1 where prioridad > (select prioridad from tareas where id=$id)");
    await ejecutar("update tareas set organizacion=null, prioridad=0 where id=$id");
  }
}