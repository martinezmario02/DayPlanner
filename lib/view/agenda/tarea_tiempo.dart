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
  final List<TextEditingController> controlTF = []; // para que salga un valor en el TextField
  late List<dynamic> pasos;
  late Tarea tarea;
  String alerta = '';

  @override
  void initState(){
    super.initState();
    pasos = widget.pasos;
    tarea = widget.tarea;
    double fraccion = double.parse((tarea.tiempo/pasos.length).toStringAsFixed(1)); // redondea a un decimal

    for(int i = 0; i < pasos.length; i++){
      controlTF.add(TextEditingController());
      controlTF[i].text = fraccion.toString();
    }
  } 

  @override
  Widget build(BuildContext context){
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
              // Mensaje de error:
              Text(alerta, style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.red)),
              const SizedBox(height: 20),

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
                                controller: controlTF[index],
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
                  var tiempos = [];
                  double total = 0;
                  for(int i = 0; i < controlTF.length; i++){
                    total += double.parse(controlTF[i].text);
                    tiempos.add(total);
                  }
                  String t = total.toStringAsFixed(2);

                  if(double.parse(t) == tarea.tiempo){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TareaPaso(pasos: pasos, tarea: tarea, tiempos: tiempos)));
                  }else{
                    setState(() {
                      alerta = "La suma de los tiempos es incorrecta.";
                    });
                  }
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