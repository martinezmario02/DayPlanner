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

  // Operaciones con la tabla Tarea:
  Future<List<Map<String, dynamic>>> tareas() async{
    return await ejecutar("select * from tareas");
  }

  Future<List<Map<String, dynamic>>> tareasDia(String dia) async{
    print(dia);
    return await ejecutar("select * from tareas where to_char(fecha,'yyyy-mm-dd') = '$dia'");
  }

  Future<List<Map<String, dynamic>>> tareasTipo(int tipo) async{
    if(tipo == 0) return await ejecutar("select * from tareascolegio");
    else if(tipo == 1) return await ejecutar("select * from tareasocio");
    else return await ejecutar("select * from tareashogar");
  }

  Future<List<Map<String, dynamic>>> esColegio(int id) async{
    return await ejecutar("select * from tareascolegio where id=$id");
  }

  Future<List<Map<String, dynamic>>> esOcio(int id) async{
    return await ejecutar("select * from tareasocio where id=$id");
  }

  Future<List<Map<String, dynamic>>> getDificultad(int id) async{
    return await ejecutar("select dificultad from tareas where id=$id");
  }

  // Future<Database> _initDB(String dbpath) async{
  //   return openDatabase(
  //     join(await getDatabasesPath(), dbpath),
  //     onCreate: (db, version){
  //       // Tabla de usuarios:
  //       db.execute('CREATE TABLE usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(50))');
  //       // Tablas de las tareas:
  //       db.execute('CREATE TABLE tareas (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(50), fecha DATE, dificultad VARCHAR(10), tiempo NUMBER, objetivo VARCHAR(50)');
  //       db.execute('CREATE TABLE paso (id INTEGER, idTarea INTEGER REFERENCES tareas(id) ON DELETE CASCADE, descripcion VARCHAR(100), PRIMARY KEY(id, idTarea))');
  //       db.execute('CREATE TABLE tareascolegio (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(50), fecha DATE, dificultad VARCHAR(10), tiempo NUMBER, objetivo VARCHAR(50), asignatura VARCHAR(20), tipo VARCHAR(20), temario VARCHAR(50), FOREIGN KEY (id, nombre, fecha, dificultad, tiempo, objetivo) REFERENCES tareas(id, nombre, fecha, dificultad, tiempo, objetivo) ON DELETE CASCADE)');
  //       // ------resto de tablas---------
  //     }
  //   );

  // }

  // // Operaciones con la tabla Usuarios:
  // Future<void> insertarUsuario(String nombre) async{
  //   Database db = await database;
  //   await db.insert(
  //     'usuarios', 
  //     {'nombre' : nombre}
  //   );
  // }

  // Future<List<Map<String, dynamic>>> usuarios() async{
  //   Database db = await database;
  //   return await db.query('usuarios');
  // }

  // // Operaciones con la tabla Tarea:
  // Future<List<Map<String, dynamic>>> tareas() async{
  //   Database db = await database;
  //   return await db.query('tareas');
  // }
}