import 'package:app_tdah/controller/control_tareas.dart';
import 'package:app_tdah/view/a%C3%B1adir_tareas/nueva_tarea.dart';
import 'package:flutter/material.dart';
import '../agenda/tarea_inicio.dart';
import '../consultas_tareas.dart';
import '../../model/tarea.dart';

class AnadirTarea extends StatefulWidget{
  const AnadirTarea({super.key});

  @override
  _AnadirTareaState createState() => _AnadirTareaState();
}

class _AnadirTareaState extends State<AnadirTarea> {
  final controlTareas = ControladorTareas();
  var tareas = [];
  String tipoT = '';

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

      if(tipo == 0){
        tipoT = 'tareascolegio';
      }else if(tipo == 1){
        tipoT = 'tareasocio';
      }else{
        tipoT = 'tareashogar';
      }
    });
  }

  @override
  void initState(){
    super.initState();
    getTareas();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          flexibleSpace: const Center(child: Text('AÑADIR TAREAS', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
          backgroundColor: const Color.fromARGB(255, 255, 118, 39)
        )
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Center(
          child: Column(
            children: [
              // Información:
              const SizedBox(height: 20),
              Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14), // se aplica al 14% de la pantalla
                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.50), // se aplica al 54% de la pantalla
                  2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14), 
                  3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14),
                },
                children: [
                  const TableRow(
                    children: [
                      Center(child: Text('Tipo', style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black))),
                      Center(child: Text('Nombre', style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black))),
                      Center(child: Text('Plazo', style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black))),
                      Center(child: Text('Tiempo', style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
                    ]
                  )
                ],
              ),
              
              // Tareas a realizar:
              Expanded(
                child: ListView.builder(
                  itemCount: tareas.length,
                  itemBuilder: (BuildContext context, int index){
                    // Información de la tarea:
                    Tarea tarea = Tarea(
                      tareas[index][tipoT]['id'], 
                      tareas[index][tipoT]['nombre'], 
                      tareas[index][tipoT]['fecha'].toString(), 
                      tareas[index][tipoT]['dificultad'],
                      double.parse(tareas[index][tipoT]['tiempo']),
                      tareas[index][tipoT]['objetivo'],
                      tareas[index][tipoT]['descripcion'],
                      tareas[index][tipoT]['tipo_tarea'],
                      tareas[index][tipoT]['estado'],
                      double.parse(tareas[index][tipoT]['tiempo_actual']),
                      tareas[index][tipoT]['paso_actual'],
                      tareas[index][tipoT]['id_usuario']
                    );

                    // Plazo de entrega:
                    DateTime fecha = DateTime.parse(tarea.fecha);
                    Duration dur = fecha.difference(DateTime.now());
                    String plazo;
                    if(dur.inDays == 0){
                      plazo = 'Hoy';
                    } else if(dur.inDays.isNegative){
                      plazo = 'Tarde';
                    } else{
                      plazo = dur.inDays.toString()+' días';
                    }

                    // Duración:
                    String duracion;
                    if(tarea.tiempo >= 60.0){
                      duracion = (tarea.tiempo/60.0).toStringAsFixed(0) + 'h';
                    } else if(tarea.tiempo < 1){
                      duracion = (tarea.tiempo*60.0).toStringAsFixed(0) + 's';
                    } else{
                      duracion = tarea.tiempo.toStringAsFixed(0) + 'm';
                    }
                    
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
                                      return const CircularProgressIndicator(color: Color.fromARGB(255, 255, 118, 39));
                                    }
                                  }
                                ),
                                TableCell(
                                  child: Container(
                                    height: 70,
                                    color: Colors.white,
                                    child: Center(child: Text(tarea.nombre, style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
                                  )
                                ),
                                TableCell(
                                  child: Container(
                                    height: 70,
                                    color: Colors.white,
                                    child: Center(child: Text(plazo, style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
                                  )
                                ),
                                TableCell(
                                  child: FutureBuilder<String>(
                                    future: getDificultad(tarea.id),
                                    builder: (context, snapshot){
                                      if(snapshot.connectionState == ConnectionState.done){
                                        final dif = snapshot.data!;
                                        Color fondo;
                                        if(dif=='alta'){
                                          fondo = Colors.red;
                                        }else if(dif=='media'){
                                          fondo = Colors.orange;
                                        }else{
                                          fondo = Colors.green;
                                        }

                                        return Container(
                                          height: 70,
                                          color: fondo,
                                          child: Center(child: Text(duracion, style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
                                        );
                                      } else {
                                        return const CircularProgressIndicator(color: Color.fromARGB(255, 255, 118, 39));
                                      }
                                    }
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
                                  Center(child: Image.asset('assets/icons/pelota.png',  width: 30, height: 30)),
                                  const SizedBox(width: 5),
                                  Center(child: Image.asset('assets/icons/cumple.png',  width: 30, height: 30))
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NuevaTarea()));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 240, 198, 144)),
                              child: Center(child: Text("+", style: TextStyle(fontFamily: 'Titulos', fontSize: 60, color: Colors.black)))
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