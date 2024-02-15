import 'package:app_tdah/controller/control_tareas.dart';
import 'package:app_tdah/view/menu.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../model/tarea.dart';

class TareaPaso extends StatefulWidget{
  final List<dynamic> pasos;
  final Tarea tarea;
  const TareaPaso({super.key, required this.pasos, required this.tarea});

  @override
  _TareaPasoState createState() => _TareaPasoState();
}

class _TareaPasoState extends State<TareaPaso> {
  final controlTareas = ControladorTareas();
  late List<dynamic> pasos;
  late Tarea tarea;
  // Atributos para la barra de tiempo:
  double valorActual = 0.0;
  double valorFinal = 0.0;
  late Timer temporizador;
  // Atributos para la barra de pasos:
  int pasoActual = 0;
  int totalPasos = 0;

  // Funciones para la barra de tiempo:
  @override
  void initState(){
    super.initState();
    pasos = widget.pasos;
    tarea = widget.tarea;
    valorActual = tarea.tiempo_actual/tarea.tiempo;
    valorFinal = tarea.tiempo*60.0;
    pasoActual = tarea.paso_actual;
    totalPasos = pasos.length;

    temporizador = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        valorActual += 1.0 / valorFinal;
      });

      if(valorActual >= valorFinal) temporizador.cancel(); // lo detiene si alcanza el total
    });
  }

  @override
  void dispose(){
    temporizador.cancel(); // lo detiene si se destruye el widget
    super.dispose();
  }

  // Función para la barra de pasos:
  void siguientePaso(){
    setState(() {
      pasoActual++;
    });
  }

  // Función para guardar valores:
  Future<void> guardarProgreso() async{
    temporizador.cancel();
    double tiempoMin = valorActual*valorFinal/60.0;
    await controlTareas.guardarProgreso(tarea.id, tiempoMin, pasoActual);
  }

  Future<void> finalizarTarea() async{
    await guardarProgreso();
    await controlTareas.actualizarEstado(tarea.id);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Temporizador:
              Row(
                children: [
                  Image.asset('assets/icons/reloj.png', width: 30, height: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: valorActual,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 118, 39)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),

              // Pasos:
              Row(
                children: [
                  Image.asset('assets/icons/paso.png', width: 30, height: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (pasoActual)/totalPasos,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 118, 39)),
                    )
                  )
                ],
              ),

              // Información del paso:
              const SizedBox(height: 60),
              Text('PASO $pasoActual', style: const TextStyle(fontFamily: 'Titulos', fontSize: 50, color: Color.fromARGB(255, 255, 118, 39))),
              const SizedBox(height: 40),
              Text(pasos[pasoActual-1]['descripcion'], style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 30, color: Colors.black)),
              const SizedBox(height: 60),

              // Botones:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      guardarProgreso();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPrincipal()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                    child: const Text('DESCANSAR')
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: (){
                      if(pasoActual < totalPasos){
                        siguientePaso();
                      } else{
                        finalizarTarea();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPrincipal())); 
                      } 
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                    child: const Text('CONTINUAR')
                  ),
                ],
              ),
            ],
          )
        ),
      )
    );
  } 
}