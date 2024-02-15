import 'package:app_tdah/controller/control_tareas.dart';
import 'package:app_tdah/view/a%C3%B1adir_tareas/nueva_tarea.dart';
import 'package:app_tdah/view/organizacion/organizar_semana.dart';
import 'package:flutter/material.dart';
import '../consultas_tareas.dart';
import '../../model/tarea.dart';

class SeleccionarTarea extends StatefulWidget{
  final DateTime dia;
  const SeleccionarTarea({super.key, required this.dia});

  @override
  _SeleccionarTareaState createState() => _SeleccionarTareaState();
}

class _SeleccionarTareaState extends State<SeleccionarTarea> {
  late DateTime dia = widget.dia;
  final controlTareas = ControladorTareas();
  var tareas = [];
  String tipoT = '';

  Future<void> getTareas() async{
    var t = await controlTareas.tareasSinPlanificar();
    
    setState(() {
      tareas = t;
      tipoT = 'tareas';
    });
  }

  @override
  void initState(){
    super.initState();
    getTareas();
  }

  Future<void> anadirFecha(int id) async{
    await controlTareas.anadirFecha(id, dia);
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
                      tareas[index][tipoT]['organizacion'].toString(),
                      tareas[index][tipoT]['prioridad'],
                      tareas[index][tipoT]['id_usuario']
                    );

                    // Plazo de entrega:
                    DateTime fecha = DateTime.parse(tarea.fecha);
                    Duration dur = fecha.difference(DateTime.now());
                    String plazo;
                    String dias;
                    if(dur.inDays == 0){
                      plazo = 'Hoy';
                    } else if(dur.inDays.isNegative){
                      plazo = 'Tarde';
                    } else{
                      dias = dur.inDays.toString();
                      plazo = '$dias días';
                    }

                    // Duración:
                    String duracion;
                    String valor;
                    if(tarea.tiempo >= 60.0){
                      valor = (tarea.tiempo/60.0).toStringAsFixed(0);
                      duracion = '$valor h';
                    } else if(tarea.tiempo < 1){
                      valor = (tarea.tiempo*60.0).toStringAsFixed(0);
                      duracion = '$valor s';
                    } else{
                      valor = tarea.tiempo.toStringAsFixed(0);
                      duracion = '$valor m';
                    }

                    // Estado:
                    String estado = tarea.estado;
                    
                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: (){
                            anadirFecha(tarea.id);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrganizarSemana()));
                          },
                          child: Table(
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
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(tarea.nombre, style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)),
                                            Text('Estado: $estado', style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 15, color: Colors.black))
                                          ],
                                        )
                                      
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
                        )
                      ],
                    );
                  },
                )
              )
            ],
          )
        )
       )
    );
  } 
}