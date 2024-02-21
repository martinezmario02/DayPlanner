import 'package:flutter/material.dart';
import '../../model/tarea.dart';
import 'tarea_inicio.dart';
import '../padre.dart';

class Agenda extends StatefulWidget{
  const Agenda({super.key});

  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
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
    var t = await controlTareas.tareasDia(fecha, idUsuario);
    
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
    var t = await controlTareas.tareasTipoDia(tipo, fecha, idUsuario);
    
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

  @override
  Widget build(BuildContext context){
    double widthPantalla = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('AGENDA', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 118, 39)
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

              // Tareas a realizar:
              Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14), // se aplica al 14% de la pantalla
                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.50), // se aplica al 54% de la pantalla
                  2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14), 
                  3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.14),
                },
                children: [
                  TableRow(
                    children: [
                      Center(child: Text('Tipo', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black))),
                      Center(child: Text('Nombre', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black))),
                      Center(child: Text('Tiempo', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black))),
                      Center(child: Text('Iniciar', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black)))
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
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(tarea.nombre, style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.05, color: Colors.black)),
                                          Text('Estado: $estado', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.035, color: Colors.black))
                                        ],
                                      )
                                    
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
                                TableCell(
                                child: FutureBuilder<List<dynamic>>(
                                    future: getPasos(tarea.tipo_tarea, tarea.id),
                                    builder: (context, snapshot){
                                      if(snapshot.connectionState == ConnectionState.done){
                                        var pasos = snapshot.data!;

                                        return SizedBox(
                                          height: 70,
                                          child: ElevatedButton(
                                            onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => TareaInicio(tarea: tarea, pasos: pasos)));
                                            },
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                            child: Center(child: Image.asset('assets/icons/play.png',  width: 60, height: 60)),
                                          ),
                                        );
                                      } else {
                                        return const CircularProgressIndicator(color: Color.fromARGB(255, 255, 118, 39));
                                      }
                                    }
                                  )
                                )
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
                                      Center(child: Image.asset('assets/icons/casa.png',  width: widthPantalla*0.07, height: widthPantalla*0.07)),
                                      const SizedBox(width: 5),
                                      Center(child: Image.asset('assets/icons/libro.png',  width: widthPantalla*0.07, height: widthPantalla*0.07))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Image.asset('assets/icons/pelota.png',  width: widthPantalla*0.07, height: widthPantalla*0.07)),
                                      const SizedBox(width: 5),
                                      Center(child: Image.asset('assets/icons/cumple.png',  width: widthPantalla*0.07, height: widthPantalla*0.07))
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
                              child: Center(child: Image.asset('assets/icons/casa.png',  width: widthPantalla*0.1, height: widthPantalla*0.1))
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
                              child: Center(child: Image.asset('assets/icons/libro.png',  width: widthPantalla*0.1, height: widthPantalla*0.1))
                            ),
                          )
                        ),
                        TableCell(
                          child: SizedBox(
                            height: 70,
                            child: ElevatedButton(
                              onPressed: (){
                                getTareasTipo(1);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 240, 198, 144)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(child: Image.asset('assets/icons/pelota.png',  width: widthPantalla*0.07, height: widthPantalla*0.07)),
                                  const SizedBox(width: 5),
                                  Center(child: Image.asset('assets/icons/cumple.png',  width: widthPantalla*0.07, height: widthPantalla*0.07))
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