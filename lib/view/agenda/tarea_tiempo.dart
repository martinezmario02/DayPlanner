import 'package:app_tdah/controller/control_tareas.dart';
import 'package:flutter/material.dart';
import 'tarea_paso.dart';

class TareaTiempo extends StatefulWidget{
  const TareaTiempo({super.key});

  @override
  _TareaTiempoState createState() => _TareaTiempoState();
}

class _TareaTiempoState extends State<TareaTiempo> {
  final TextEditingController controlTF = TextEditingController(); // para que salga un valor en el TextField
  final controlTareas = ControladorTareas();

  @override
  Widget build(BuildContext context){
    controlTF.text = "30"; // se establece el valor inicial

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          flexibleSpace: const Center(child: Text('REPARTO DE TIEMPO', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
          backgroundColor: const Color.fromARGB(255, 255, 155, 97)
        )
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              // Información sobre el paso:
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Paso 1. ...:', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('Tiempo:', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), // para que se vean los bordes
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      controller: controlTF,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Botón para empezar:
              ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TareaPaso()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                    child: const Text('EMPEZAR')
                  ),
            ],
          )
        ),
      )
    );
  } 
}