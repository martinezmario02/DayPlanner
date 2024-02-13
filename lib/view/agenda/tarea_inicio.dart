import 'package:flutter/material.dart';
import '../../model/tarea.dart';
import 'tarea_tiempo.dart';

class TareaInicio extends StatefulWidget{
  final Tarea tarea;
  final List<dynamic> pasos;
  const TareaInicio({super.key, required this.tarea, required this.pasos});
  
  @override
  _TareaInicioState createState() => _TareaInicioState();
}

class _TareaInicioState extends State<TareaInicio> {
  late Tarea tarea;
  late List<dynamic> pasos;

  @override
  void initState(){
    super.initState();
    tarea = widget.tarea;
    pasos = widget.pasos;
  } 

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          flexibleSpace: const Center(child: Text('TAREA A COMENZAR', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
          backgroundColor: const Color.fromARGB(255, 255, 155, 97)
        )
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Información sobre la tarea:
              Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.3),
                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.62),
                },
                children: [
                  // Descripción de la tarea:
                  TableRow(
                    children: [
                      const SizedBox(
                        height: 70,
                        child: Center(child: Text('Descripción:', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
                      ),
                      Container(
                        height: 70,
                        color: Colors.white,
                        child: Center(child: Text(tarea.descripcion, style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
                      ),
                    ]
                  ),
                  // Pasos de la tarea:
                  TableRow(
                    children: [
                      const SizedBox(
                        height: 70,
                        child: Center(child: Text('Pasos:', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))    
                      ),
                      Container(
                        height: 200,
                        color: Colors.white,
                        child: ListView.builder(
                          itemCount: pasos.length,
                          itemBuilder: (context, index){
                            final paso = pasos[index]['id'].toString();
                            final descripcion = pasos[index]['descripcion'];
                            return ListTile(title: Text('Paso $paso: $descripcion', style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)));
                          },
                        )
                      ),
                    ]
                  )
                ],
              ),
              const SizedBox(height: 30),

              // Botón para empezar:
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TareaTiempo(pasos: pasos, tarea: tarea)));
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