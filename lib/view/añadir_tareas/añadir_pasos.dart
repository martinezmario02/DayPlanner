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
  final ScrollController controlScroll = ScrollController();

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
      scrollBoton();
    });
  }

  void borrarPaso(){
    setState(() {
      numPasos--;
      controlPaso.removeLast();
      scrollBoton();
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

  // Función para mostrar siempre el último form:
  void scrollBoton() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final double posicion = controlScroll.position.maxScrollExtent;
      controlScroll.jumpTo(posicion);
    });
  
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Añade, paso a paso, como harías la tarea.', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20)),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    controller: controlScroll,
                    itemCount: numPasos,
                    itemBuilder: (BuildContext context, int index){
                      int paso = index+1;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child:TextField(
                                  controller: controlPaso[index],
                                  decoration: InputDecoration(
                                    labelText: 'Paso $paso', 
                                    border: const OutlineInputBorder(),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ), 
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: borrarPaso
                              ),

                            ],
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
                        if(controlPaso.isNotEmpty && controlPaso[0].text != ''){
                          guardarTarea();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tarea guardada')),
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AnadirTarea()));
                        } else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Debes añadir algún paso')),
                          );
                        }
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