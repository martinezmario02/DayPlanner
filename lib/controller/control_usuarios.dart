import '../model/db.dart';

DB db = DB();

class ControladorUsuarios{
  // Función que comprueba las credenciales:
  Future<int> iniciarSesion(String correo, String contrasena) async{
    return await db.iniciarSesion(correo, contrasena);
  }

  // Función que devuelve los datos de un usuario:
  Future<Map<String, dynamic>> getUsuario(int id) async{
    return await db.getUsuario(id);
  }

  // Función que devuelve los ids de todos los usuarios:
  Future<List<Map<String, dynamic>>> getUsuarios() async{
    return await db.getUsuarios();
  }

  // Función para modificar los datos del perfil de un usuario:
  Future<void> modificarPerfil(int id, String nombre, String ciudad, String colegio) async{
    return await db.modificarPerfil(id, nombre, ciudad, colegio);
  }

  // Función para modificar el avatar de un usuario:
  Future<void> modificarAvatar(int id, String nombre) async{
    return await db.modificarAvatar(id, nombre);
  }

  // Función para comprobar si el correo está ya registrado:
  Future<Map<String, dynamic>> comprobarCorreo(String correo) async{
    return await db.comprobarCorreo(correo);
  }

  // Función para registrar un usuario:
  Future<void> guardarUsuario(String nombre, String correo, String fecha, String ciudad, String centro, String contrasena) async{
    return await db.guardarUsuario(nombre, correo, fecha, ciudad, centro, contrasena);
  }

  // Función para actualizar el número de estrellas:
  Future<void> actualizarEstrellas(int id, int numero) async{
    return await db.actualizarEstrellas(id, numero);
  }
}