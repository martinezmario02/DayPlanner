import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'usuario.dart';
import 'tarea.dart';

class DB{
  static final DB instancia = DB._init();
  static Database? _database;

  DB._init();

  Future<Database> get database async{
    if(_database == null) _database = await _initDB('~/TFG/app_tdah/lib/mydb.db');
    
    return _database!;
  }

  Future<Database> _initDB(String dbpath) async{
    return openDatabase(
      join(await getDatabasesPath(), dbpath),
      onCreate: (db, version){
        // Tabla de usuarios:
        db.execute('CREATE TABLE usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(50))');
        // Tablas de las tareas:
        db.execute('CREATE TABLE tareas (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(50), fecha DATE, dificultad VARCHAR(10), tiempo NUMBER, objetivo VARCHAR(50)');
        db.execute('CREATE TABLE paso (id INTEGER, idTarea INTEGER REFERENCES tareas(id) ON DELETE CASCADE, descripcion VARCHAR(100), PRIMARY KEY(id, idTarea))');
        db.execute('CREATE TABLE tareascolegio (id INTEGER PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(50), fecha DATE, dificultad VARCHAR(10), tiempo NUMBER, objetivo VARCHAR(50), asignatura VARCHAR(20), tipo VARCHAR(20), temario VARCHAR(50), FOREIGN KEY (id, nombre, fecha, dificultad, tiempo, objetivo) REFERENCES tareas(id, nombre, fecha, dificultad, tiempo, objetivo) ON DELETE CASCADE)');
        // ------resto de tablas---------
      }
    );

  }

  // Operaciones con la tabla Usuarios:
  Future<void> insertarUsuario(String nombre) async{
    Database db = await database;
    await db.insert(
      'usuarios', 
      {'nombre' : nombre}
    );
  }

  Future<List<Map<String, dynamic>>> usuarios() async{
    Database db = await database;
    return await db.query('usuarios');
  }

  // Operaciones con la tabla Tarea:
  Future<List<Map<String, dynamic>>> tareas() async{
    Database db = await database;
    return await db.query('tareas');
  }
}