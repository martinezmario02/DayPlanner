import 'package:app_tdah/controller/control_tareas.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TareaPaso extends StatefulWidget{
  const TareaPaso({super.key});

  @override
  _TareaPasoState createState() => _TareaPasoState();
}

class _TareaPasoState extends State<TareaPaso> {
  final controlTareas = ControladorTareas();
  // Atributos para la barra de tiempo:
  double valorActual = 0.0;
  final double valorFinal = 30.0; // tiempo en segundos
  late Timer temporizador;
  // Atributos para la barra de pasos:
  int pasoActual = 0;
  final int totalPasos = 4;

  // Funciones para la barra de tiempo:
  @override
  void initState(){
    super.initState();

    temporizador = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        valorActual += 1.0 / valorFinal;
      });

      if(valorActual >= 1.0) temporizador.cancel(); // lo detiene si alcanza el total
    });
  }

  @override
  void dispose(){
    temporizador.cancel(); // lo detiene si se destruye el widget
    super.dispose();
  }

  // Funciones para la barra de pasos:
  void siguientePaso(){
    setState(() {
      if(pasoActual < totalPasos) pasoActual++;
    });
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
                      value: (pasoActual+1)/totalPasos,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 118, 39)),
                    )
                  )
                ],
              ),

              // Información del paso:


              // Botones:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      //
                      //
                      //
                      // implementar descansos
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                    child: const Text('DESCANSAR')
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: (){
                      siguientePaso();
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