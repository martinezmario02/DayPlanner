import 'package:app_tdah/controller/control_tareas.dart';
import 'package:app_tdah/controller/control_usuarios.dart';
import 'package:app_tdah/controller/control_examenes.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Controladores:
final controlTareas = ControladorTareas();
final controlUsuario = ControladorUsuarios();
final controlExamenes = ControladorExamenes();

// Atributos comunes:
int idUsuario = -1;

// Funciones comunes:
Future<String> getImagen(int id) async{
  var resultado = await controlTareas.esColegio(id);
  var resultado2 = await controlTareas.esOcio(id);
  
  if(resultado.isNotEmpty){
    return 'assets/icons/libro.png';
  }else if(resultado2.isNotEmpty){
    return 'assets/icons/pelota.png';
  }else{
    return 'assets/icons/casa.png';
  }
}

Future<String> getDificultad(int id) async{
  var resultado = await controlTareas.getDificultad(id); 
  String dificultad = resultado[0]['tareas']['dificultad'];

  return dificultad;
}

String encriptarContrasena(String contrasena) {
  var bytes = utf8.encode(contrasena);
  var digest = sha256.convert(bytes);
  return digest.toString().substring(0, 20);
}