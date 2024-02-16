import 'package:flutter/material.dart';
import 'tarea_paso.dart';
import '../../model/tarea.dart';

class TareaTiempo extends StatefulWidget{
  final List<dynamic> pasos;
  final Tarea tarea;
  const TareaTiempo({super.key, required this.pasos, required this.tarea});

  @override
  _TareaTiempoState createState() => _TareaTiempoState();
}

class _TareaTiempoState extends State<TareaTiempo> {
  final TextEditingController controlTF = TextEditingController(); // para que salga un valor en el TextField
  late List<dynamic> pasos;
  late Tarea tarea;

  @override
  void initState(){
    super.initState();
    pasos = widget.pasos;
    tarea = widget.tarea;
  } 

  @override
  Widget build(BuildContext context){
    double fraccion = double.parse((tarea.tiempo/pasos.length).toStringAsFixed(1)); // redondea a un decimal
    controlTF.text = fraccion.toString(); // se establece el valor inicial

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
              Expanded(
                child: ListView.builder(
                  itemCount: pasos.length,
                  itemBuilder: (context, index){
                    final paso = pasos[index]['id'].toString();
                    final descripcion = pasos[index]['descripcion'];
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Paso $paso: $descripcion', style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Tiempo (minutos):', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)),
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
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Botón para empezar:
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TareaPaso(pasos: pasos, tarea: tarea)));
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