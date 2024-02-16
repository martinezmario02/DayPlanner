import 'package:app_tdah/view/organizacion/seleccionar_tarea.dart';
import 'package:flutter/material.dart';
import '../padre.dart';
import '../../model/tarea.dart';

class OrganizarSemana extends StatefulWidget{
  const OrganizarSemana({super.key});

  @override
  _OrganizarSemanaState createState() => _OrganizarSemanaState();
}

class _OrganizarSemanaState extends State<OrganizarSemana> {
  TextEditingController controlDia = TextEditingController();
  var tareas = [];
  String tipoT = '';
  String imagenT = '';
  DateTime dia = DateTime.now();

  Future<void> getTareas() async{
    String year = dia.year.toString();
    String month = dia.month.toString().padLeft(2, '0'); // padLeft introduce un 0 en caso de tener un solo dígito
    String day = dia.day.toString().padLeft(2, '0');
    String fecha = '$year-$month-$day';
    var t = await controlTareas.tareasDia(fecha);
    
    setState(() {
      tareas = t;
      tipoT = 'tareas';
    });
  }

  Future<void> getTareasTipo(int tipo) async{ // 0-colegio, 1-ocio, 2-hogar
    String year = dia.year.toString();
    String month = dia.month.toString().padLeft(2, '0'); // padLeft introduce un 0 en caso de tener un solo dígito
    String day = dia.day.toString().padLeft(2, '0');
    String fecha = '$year-$month-$day';
    var t = await controlTareas.tareasTipoDia(tipo, fecha);
    
    setState(() {
      tareas = t;

      if(tipo == 0){ 
        tipoT = 'tareascolegio';
      } else if(tipo == 1){ 
        tipoT = 'tareasocio';
      }else{
        tipoT = 'tareashogar';
      }
    });
  }

  Future<List<dynamic>> getPasos(String tipo, int id) async{
    var resultado;
    if(tipo == 'tareascolegio'){
      resultado = await controlTareas.getPasosColegio(id); 
    }else if(tipo == 'tareasocio'){
      resultado = await controlTareas.getPasosOcio(id);
    }else{
      resultado = await controlTareas.getPasosHogar(id);
    }

    List<dynamic> pasos = [];
    for(var paso in resultado){
      for(var valor in paso.values){
        pasos.add(valor);
      }
    }
    
    return pasos;
  }

  void actualizarDia(DateTime diaNuevo){
    switch(diaNuevo.weekday){
      case DateTime.monday: controlDia.text = 'LUNES'; break;
      case DateTime.tuesday: controlDia.text = 'MARTES'; break;
      case DateTime.wednesday: controlDia.text = 'MIÉRCOLES'; break;
      case DateTime.thursday: controlDia.text = 'JUEVES'; break;
      case DateTime.friday: controlDia.text = 'VIERNES'; break;
      case DateTime.saturday: controlDia.text = 'SÁBADO'; break;
      case DateTime.sunday: controlDia.text = 'DOMINGO'; break;
    }
    dia = diaNuevo;
    getTareas();
  }

  @override
  void initState(){
    super.initState();
    getTareas();
    actualizarDia(dia);
  }

  Future<void> ordenarTareas(int posicion, int nuevaPosicion) async{
    await controlTareas.ordenarTareas(tareas[posicion][tipoT]['id'], posicion+1, nuevaPosicion+1, dia);
    getTareas();
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
              // Información:
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      dia = dia.subtract((const Duration(days: 1)));
                      actualizarDia(dia);
                    },
                    icon: const Icon(Icons.arrow_back)
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
                      dia = dia.add((const Duration(days: 1)));
                      actualizarDia(dia);
                    },
                    icon: const Icon(Icons.arrow_forward)
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Información de las tareas:
              Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.07), 
                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12),
                  2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.45),
                  3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12), 
                  4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12),
                },
                children: [
                  const TableRow(
                    children: [
                      Center(child: Text('Nº', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 17, color: Colors.black))),
                      Center(child: Text('Tipo', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 17, color: Colors.black))),
                      Center(child: Text('Nombre', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 17, color: Colors.black))),
                      Center(child: Text('Tiempo', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 17, color: Colors.black))),
                      Center(child: Text('Iniciar', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 17, color: Colors.black)))
                    ]
                  )
                ],
              ),
              
              // Tareas a realizar:
              Expanded(
                child: ReorderableListView.builder(
                  onReorder: ordenarTareas,
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
                    
                    return  GestureDetector(
                      key: ValueKey(tarea.id),
                      child: Container(
                        color: const Color.fromARGB(255, 240, 198, 144), 
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Table(
                                border: TableBorder.all(),
                                columnWidths: {
                                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.07), 
                                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12), 
                                  2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.45), 
                                  3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12),
                                  4: FixedColumnWidth(MediaQuery.of(context).size.width * 0.12),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      TableCell(
                                        child: Container(
                                          height: 70,
                                          color: Colors.white,
                                          child: Center(child: Text(tarea.prioridad.toString(), style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
                                        )
                                      ),
                                      FutureBuilder<String>(
                                        future: getImagen(tareas[index][tipoT]['id']),
                                        builder: (context, snapshot){
                                          if(snapshot.connectionState == ConnectionState.done){
                                            final imagen = snapshot.data!;
                                            
                                            return Container(
                                              height: 70,
                                              color: Colors.white,
                                              child: Center(child: Image.asset(imagen,  width: 35, height: 35))
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
                              ),
                            ],
                          )
                        )
                      )
                    );
                  },
                )
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SeleccionarTarea(dia: dia)));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                  child: const Text('AÑADIR')
                ),
              )
            ],
          )
        )
       )
    );
  } 
}