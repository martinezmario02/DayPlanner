import 'package:app_tdah/controller/control_tareas.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/tarea.dart';
import 'tarea_inicio.dart';
import '../consultas_tareas.dart';

class Agenda extends StatefulWidget{
  const Agenda({super.key});

  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  final controlTareas = ControladorTareas();
  TextEditingController controlDia = TextEditingController();
  var tareas = [];
  String tipoT = '';
  String imagenT = '';
  DateTime dia = DateTime.now();

  Future<void> getTareas() async{
    var t = await controlTareas.tareas();
    
    setState(() {
      tareas = t;
      tipoT = 'tareas';
    });
  }

  Future<void> getTareasTipo(int tipo) async{ // 0-colegio, 1-ocio, 2-hogar
    var t = await controlTareas.tareasTipo(tipo);
    
    setState(() {
      tareas = t;

      if(tipo == 0) tipoT = 'tareascolegio';
      else if(tipo == 1) tipoT = 'tareasocio';
      else tipoT = 'tareashogar';
    });
  }

  void actualizarDia(DateTime dia){
    switch(dia.weekday){
      case DateTime.monday: controlDia.text = 'LUNES'; break;
      case DateTime.tuesday: controlDia.text = 'MARTES'; break;
      case DateTime.wednesday: controlDia.text = 'MIÉRCOLES'; break;
      case DateTime.thursday: controlDia.text = 'JUEVES'; break;
      case DateTime.friday: controlDia.text = 'VIERNES'; break;
      case DateTime.saturday: controlDia.text = 'SÁBADO'; break;
      case DateTime.sunday: controlDia.text = 'DOMINGO'; break;
    }
  }

  @override
  void initState(){
    super.initState();
    getTareas();
    actualizarDia(dia);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          flexibleSpace: const Center(child: Text('AGENDA', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
          backgroundColor: const Color.fromARGB(255, 255, 118, 39)
        )
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Center(
          child: Column(
            children: [
              // Indicador del día:
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      dia = dia.subtract((Duration(days: 1)));
                      actualizarDia(dia);
                    },
                    icon: Icon(Icons.arrow_back)
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextField(
                      controller: controlDia,
                      readOnly: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: (){
                      dia = dia.add((Duration(days: 1)));
                      actualizarDia(dia);
                    },
                    icon: Icon(Icons.arrow_forward)
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Tareas a realizar:
              Expanded(
                child: ListView.builder(
                  itemCount: tareas.length,
                  itemBuilder: (BuildContext context, int index){
                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        Table(
                          border: TableBorder.all(),
                          columnWidths: {
                            0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14), // se aplica al 14% de la pantalla
                            1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.50), // se aplica al 54% de la pantalla
                            2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14), 
                            3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14),
                          },
                          children: [
                            TableRow(
                              children: [
                                FutureBuilder<String>(
                                  future: getImagen(tareas[index][tipoT]['id']),
                                  builder: (context, snapshot){
                                    if(snapshot.connectionState == ConnectionState.done){
                                      final imagen = snapshot.data!;
                                      
                                      return Container(
                                        height: 70,
                                        color: Colors.white,
                                        child: Center(child: Image.asset(imagen,  width: 40, height: 40))
                                      );
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  }
                                ),
                                TableCell(
                                  child: Container(
                                    height: 70,
                                    color: Colors.white,
                                    child: Center(child: Text(tareas[index][tipoT]['nombre'], style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
                                  )
                                ),
                                TableCell(
                                  child: FutureBuilder<String>(
                                    future: getDificultad(tareas[index][tipoT]['id']),
                                    builder: (context, snapshot){
                                      if(snapshot.connectionState == ConnectionState.done){
                                        final dif = snapshot.data!;
                                        Color fondo;
                                        if(dif=='alta') fondo = Colors.red;
                                        else if(dif=='media') fondo = Colors.orange;
                                        else fondo = Colors.green;

                                        return Container(
                                          height: 70,
                                          color: fondo,
                                          child: Center(child: Text(tareas[index][tipoT]['tiempo'], style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    }
                                  )
                                ),
                                TableCell(
                                  child: Container(
                                    height: 70,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TareaInicio(descripcion: tareas[index]['tareas']['nombre'])));
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                      child: Center(child: Image.asset('assets/icons/play.png',  width: 40, height: 40)),
                                    ),
                                  )
                                ),
                              ]
                            )
                          ],
                        )
                      ],
                    );
                    
                  },
                )
              ),
              
              // Menú inferior:
              Align(
                alignment:  Alignment.bottomCenter,
                child: Table(
                  border: TableBorder.all(color: const Color.fromARGB(255, 255, 118, 39), width: 2.5),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            height: 70,
                            color: const Color.fromARGB(255, 240, 198, 144),
                            child: ElevatedButton(
                              onPressed: (){
                                getTareas();
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 240, 198, 144)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Image.asset('assets/icons/casa.png',  width: 30, height: 30)),
                                      const SizedBox(width: 5),
                                      Center(child: Image.asset('assets/icons/libro.png',  width: 30, height: 30))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Image.asset('assets/icons/pelota.png',  width: 30, height: 30)),
                                      const SizedBox(width: 5),
                                      Center(child: Image.asset('assets/icons/cumple.png',  width: 30, height: 30))
                                    ],
                                  )
                                ],
                              ) 
                            ),
                          )
                        ),
                        TableCell(
                          child: Container(
                            height: 70,
                            color: const Color.fromARGB(255, 240, 198, 144),
                            child: ElevatedButton(
                              onPressed: (){
                                getTareasTipo(2);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 240, 198, 144)),
                              child: Center(child: Image.asset('assets/icons/casa.png',  width: 40, height: 40))
                            ),
                          )
                        ),
                        TableCell(
                          child: Container(
                            height: 70,
                            color: const Color.fromARGB(255, 240, 198, 144),
                            child: ElevatedButton(
                              onPressed: (){
                                getTareasTipo(0);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 240, 198, 144)),
                              child: Center(child: Image.asset('assets/icons/libro.png',  width: 40, height: 40))
                            ),
                          )
                        ),
                        TableCell(
                          child: Container(
                            height: 70,
                            child: ElevatedButton(
                              onPressed: (){
                                getTareasTipo(1);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 240, 198, 144)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(child: Image.asset('assets/icons/pelota.png',  width: 40, height: 40)),
                                  const SizedBox(width: 5),
                                  Center(child: Image.asset('assets/icons/cumple.png',  width: 40, height: 40))
                                ],
                              )
                            ),
                          )
                        ),
                      ]
                    )
                  ],
                )
              )
            ],
          )
        )
       )
    );
  } 
}