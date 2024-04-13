import 'package:app_tdah/view/evaluacion/evaluacion.dart';
import 'package:flutter/material.dart';
import '../../model/tarea.dart';
import '../padre.dart';

class TareasPendientes extends StatefulWidget{
  const TareasPendientes({super.key});

  @override
  _TareasPendientesState createState() => _TareasPendientesState();
}

class _TareasPendientesState extends State<TareasPendientes> {
  var tareas = [];
  String tipoT = '';
  String imagenT = '';
  DateTime dia = DateTime.now();

  Future<void> getTareas() async{
    String year = dia.year.toString();
    String month = dia.month.toString().padLeft(2, '0'); // padLeft introduce un 0 en caso de tener un solo dígito
    String day = dia.day.toString().padLeft(2, '0');
    String fecha = '$year-$month-$day';
    var t = await controlTareas.tareasPendientes(idUsuario, fecha);
    
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

  @override
  Widget build(BuildContext context){
    double widthPantalla = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('TAREAS SIN REALIZAR', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Evaluacion()));
          },  
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Center(
          child: Column(
            children: [
              // Tareas a realizar:
              const SizedBox(height: 20),
              Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14), 
                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.64), 
                  2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14),
                },
                children: [
                  TableRow(
                    children: [
                      Center(child: Text('Tipo', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black))),
                      Center(child: Text('Tarea', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black))),
                      Center(child: Text('Tiempo', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black))),
                    ]
                  )
                ],
              ),
              
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
                      tareas[index][tipoT]['objetivo'].toString(),
                      tareas[index][tipoT]['descripcion'],
                      tareas[index][tipoT]['tipo_tarea'],
                      tareas[index][tipoT]['estado'],
                      double.parse(tareas[index][tipoT]['tiempo_actual']),
                      tareas[index][tipoT]['paso_actual'],
                      tareas[index][tipoT]['organizacion'].toString(),
                      tareas[index][tipoT]['prioridad'],
                      tareas[index][tipoT]['id_usuario']
                    );

                    // Duración:
                    String duracion;
                    int valor;
                    int valor2;
                    if(tarea.tiempo >= 60.0){
                      valor = int.parse((tarea.tiempo/60.0).toStringAsFixed(0));
                      valor2 = int.parse((tarea.tiempo%60.0).toStringAsFixed(0));

                      if(valor2 != 0){
                        duracion = '$valor h $valor2 min';
                      } else{
                        duracion = '$valor h';
                      }
                      
                    } else if(tarea.tiempo < 1){
                      valor = int.parse((tarea.tiempo*60.0).toStringAsFixed(0));
                      duracion = '$valor s';
                    } else{
                      valor = int.parse(tarea.tiempo.toStringAsFixed(0));
                      duracion = '$valor m';
                    }

                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        Table(
                          border: TableBorder.all(),
                          columnWidths: {
                            0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14), 
                            1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.64),
                            2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14),
                          },
                          children: [
                            TableRow(
                              children: [
                                FutureBuilder<String>(
                                  future: getImagen(tarea.id),
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
                                    child: Center( child: Text(tarea.nombre, style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.05, color: Colors.black))),
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
                                          child: Center(child: Text(duracion, style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black)))
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
            ],
          )
        )
       )
    );
  } 
}