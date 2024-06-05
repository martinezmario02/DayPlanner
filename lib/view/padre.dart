import 'package:app_tdah/controller/control_tareas.dart';
import 'package:app_tdah/controller/control_usuarios.dart';
import 'package:app_tdah/controller/control_examenes.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class Pair<A, B> {
  final A first;
  final B second;

  Pair(this.first, this.second);
}

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

Future<Pair<List<dynamic>, int>> calcularEstrellas(int id) async{
  DateTime dia = DateTime.now();
  List<String> recomendaciones = [];
  List<String> dificultades = [];
  List<int> numPasos = [];
  int estrellas = 0;
  double t1 = 0.0;
  double t2 = 0.0;
  final realizadas = await controlTareas.numeroRealizadas(idUsuario);
  final pendientes = await controlTareas.numeroPendientes(idUsuario);
  final empleado = await controlTareas.tiempoEmpleado(idUsuario);
  final estimado = await controlTareas.tiempoEstimado(idUsuario);
  if(empleado > estimado){
    t1 = estimado;
    t2 = empleado;
  } else{
    t2 = estimado;
    t1= empleado;
  }

  String year = dia.year.toString();
  String month = dia.month.toString().padLeft(2, '0'); // padLeft introduce un 0 en caso de tener un solo dígito
  String day = dia.day.toString().padLeft(2, '0');
  String fecha = '$year-$month-$day';
  var tareas = await controlTareas.tareasDia(fecha, idUsuario);

  for(var tarea in tareas){
    int id = tarea['tareas']['id'];
    String tipo = tarea['tareas']['tipo_tarea'];
    String dificultad = (await controlTareas.getDificultad(id))[0]['tareas']['dificultad'];
    var resultado;
    if(tipo == 'tareascolegio'){
      resultado = await controlTareas.getNumPasosColegio(id); 
    }else if(tipo == 'tareasocio'){
      resultado = await controlTareas.getNumPasosOcio(id);
    }else{
      resultado = await controlTareas.getNumPasosHogar(id);
    }
    int pasos = resultado[0]['']['count'];

    dificultades.add(dificultad);
    numPasos.add(pasos);
  }

  // Información sobre las recomendaciones:
  if(realizadas != 0 || pendientes != 0){
    if(pendientes > 0){
      recomendaciones.add("- Debes poner un número de tareas que puedas realizar.");
    }

    if(t2-t1 > t2*0.2){
      recomendaciones.add("- Debes indicar un tiempo realista, ni mucho ni poco.");
    }

    int contador = 0;
    for(int paso in numPasos){
      if(paso == 1){
        contador++;
      }
    }

    if(contador >= (pendientes+realizadas)*0.5){
      recomendaciones.add("- Debes dividir las tareas en más de un paso.");
    }

    contador = 0;
    for(int paso in numPasos){
      if(paso >= 5){
        contador++;
      }
    }

    if(contador >= (pendientes+realizadas)*0.5){
      recomendaciones.add("- No debes poner demasiados pasos en las tareas.");
    }

    int dificil = 0;
    int facil = 0;
    for(String dificultad in dificultades){
      if(dificultad == 'alta'){
        dificil++;
      } else if(dificultad == 'baja'){
        facil++;
      }
    }

    if(dificil >= (pendientes+realizadas)*0.5){
      recomendaciones.add("- No debes poner demasiadas tareas difíciles el mismo día.");
    }

    if(facil >= (pendientes+realizadas)*0.8){
      recomendaciones.add("- No debes poner solo tareas fáciles en un día.");
    }

    if(recomendaciones.isEmpty){
      recomendaciones.add("No hay ninguna recomendación actualmente.");
    }
  }

  // Recuento de estrellas:
  if(pendientes < realizadas){
    estrellas++;
  }

  if(pendientes == 0 && realizadas > 0){
    estrellas++;
  }

  if(recomendaciones.isEmpty && (realizadas != 0 || pendientes != 0)){
    estrellas++;
  }

  return Pair(recomendaciones, estrellas);
}