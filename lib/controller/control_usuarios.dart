import '../model/db.dart';

DB db = DB();

class ControladorUsuarios{
  // Función que comprueba las credenciales:
  Future<int> iniciarSesion(String correo, String contrasena) async{
    return await db.iniciarSesion(correo, contrasena);
  }

  Future<Map<String, dynamic>> getUsuario(int id) async{
    return await db.getUsuario(id);
  }

  Future<void> modificarPerfil(int id, String nombre, String ciudad, String colegio) async{
    return await db.modificarPerfil(id, nombre, ciudad, colegio);
  }

  Future<void> modificarAvatar(int id, String nombre) async{
    return await db.modificarAvatar(id, nombre);
  }
}