import '../model/db.dart';

DB db = DB();

class ControladorUsuarios{
  // Función que comprueba las credenciales:
  Future<int> iniciarSesion(String correo, String contrasena) async{
    return await db.iniciarSesion(correo, contrasena);
  }
}