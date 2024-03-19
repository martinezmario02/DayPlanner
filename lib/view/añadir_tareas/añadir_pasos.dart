import 'package:app_tdah/view/a%C3%B1adir_tareas/a%C3%B1adir_tareas.dart';
import 'package:flutter/material.dart';
import '../../model/tarea.dart';
import '../padre.dart';

class AnadirPaso extends StatefulWidget{
  final Tarea tarea;
  final String asignatura;
  final String tipo;

  const AnadirPaso({super.key, required this.tarea, required this.asignatura, required this.tipo});

  @override
  _AnadirPasoState createState() => _AnadirPasoState();
}

class _AnadirPasoState extends State<AnadirPaso> {
  late Tarea tarea;
  late String asignatura;
  late String tipo;
  List<TextEditingController> controlPaso = [];
  int numPasos = 0;

  @override
  void initState(){
    super.initState();
    tarea = widget.tarea;
    asignatura = widget.asignatura;
    tipo = widget.tipo;
  }

  void anadirPaso(){
    setState(() {
      numPasos++;
      controlPaso.add(TextEditingController());
    });
  }

  // Función para guardar la tarea en la bd:
  Future<void> guardarTarea() async{
    List<String> pasos = [];
    for(int i = 0; i < controlPaso.length; i++){
      pasos.add(controlPaso[i].text);
    }

    if(tarea.tipo_tarea == 'tareascolegio'){
      controlTareas.guardarTareaColegio(tarea, asignatura, tipo, pasos);
    }else{
      controlTareas.guardarTareaOcioHogar(tarea, tipo, pasos);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('AÑADIR PASOS', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 155, 97)
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Añade, paso a paso, como harías la tarea.', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20)),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: numPasos,
                    itemBuilder: (BuildContext context, int index){
                      int paso = index+1;
                      return Column(
                        children: [
                          TextField(
                            controller: controlPaso[index],
                            decoration: InputDecoration(
                              labelText: 'Paso $paso', 
                              border: const OutlineInputBorder(),
                              fillColor: Colors.white,
                              filled: true,
                            ), 
                          ),
                          const SizedBox(height: 15)
                        ]
                      );
                    },
                  ),  
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: anadirPaso,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                      child: const Text('AÑADIR PASO', style: TextStyle(color: Colors.white))
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: (){
                        guardarTarea();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AnadirTarea()));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                      child: const Text('GUARDAR', style: TextStyle(color: Colors.white))
                    ),
                  ],
                )
              ]
            )
          )
        )
      )
    );
  } 
}