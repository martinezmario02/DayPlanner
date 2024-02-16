import 'package:app_tdah/controller/control_tareas.dart';

// Controladores:
final controlTareas = ControladorTareas();

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
