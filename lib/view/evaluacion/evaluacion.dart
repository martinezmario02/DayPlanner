import 'package:app_tdah/view/evaluacion/tareas_listado.dart';
import 'package:app_tdah/view/evaluacion/tareas_pendientes.dart';
import 'package:app_tdah/view/evaluacion/tareas_realizadas.dart';
import 'package:app_tdah/view/menu.dart';
import 'package:app_tdah/view/padre.dart';
import 'package:flutter/material.dart';

class Evaluacion extends StatefulWidget{
  const Evaluacion({super.key});

  @override
  _EvaluacionState createState() => _EvaluacionState();
}

class _EvaluacionState extends State<Evaluacion> {
  DateTime dia = DateTime.now();
  int numRealizadas = 0;
  int numPendientes = 0;
  double t1 = 0.0;
  double t2 = 0.0;
  Color c1 = const Color.fromRGBO(194, 225, 194, 1.0);
  Color c2 = const Color.fromRGBO(128, 236, 128, 1);
  double porcentajeTareas = 0.0;
  double porcentajeTiempo = 0.0;
  List<dynamic> recomendaciones = [];
  Color e1 = Colors.black;
  Color e2 = Colors.black;
  Color e3 = Colors.black;
  bool cargado = false;

  Future<void> obtenerInformacion() async{
    final realizadas = await controlTareas.numeroRealizadas(idUsuario);
    final pendientes = await controlTareas.numeroPendientes(idUsuario);
    final empleado = await controlTareas.tiempoEmpleado(idUsuario);
    final estimado = await controlTareas.tiempoEstimado(idUsuario);
    Pair<List<dynamic>, int> infoEstrellas = await calcularEstrellas(idUsuario);

    setState(() {
      // Información sobre las tareas:
      numRealizadas = realizadas;
      numPendientes = pendientes;
      porcentajeTareas = (realizadas/((pendientes+realizadas)*1.0)).clamp(0.0, 1.0);
      
      // Información sobre el tiempo:
      if(empleado > estimado){
        t1 = estimado;
        t2 = empleado;
        
        c1 = c2;
        c2 = const Color.fromARGB(255, 255, 109, 109);
      } else{
        t2 = estimado;
        t1= empleado;
      }
      porcentajeTiempo = (t1/t2).clamp(0.0, 1.0);

      recomendaciones = infoEstrellas.first;
      if(recomendaciones.isEmpty){
        recomendaciones.add("No has planificado ninguna tarea para hoy");
      }

      if(infoEstrellas.second > 0){
        e1 = const Color.fromARGB(255, 255, 118, 39);
      }
      
      if(infoEstrellas.second > 1){
        e2 = const Color.fromARGB(255, 255, 118, 39);
      }

      if(infoEstrellas.second > 3){
        e3 = const Color.fromARGB(255, 255, 118, 39);
      }

      cargado = true;
    });
  }

  @override
  void initState(){
    super.initState();
    obtenerInformacion();
  }

  @override
  Widget build(BuildContext context){
    double widthPantalla = MediaQuery.of(context).size.width;

    if(!cargado){
      return Scaffold(
        body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
          child:
            const Center(child: CircularProgressIndicator())
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('EVALUACIÓN', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPrincipal()));
          },  
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('RESUMEN DIARIO', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: const Color.fromARGB(255, 255, 118, 39))),
                  const SizedBox(height: 10),

                  // Información de las tareas:
                  Align(alignment: Alignment.centerLeft, child:Text('Tareas realizadas:', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.045))),  
                  const SizedBox(height: 10),              
                  SizedBox(
                    height: 20.0,
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 118, 39),
                                Color.fromARGB(255, 255, 165, 113),
                              ],
                              stops: [porcentajeTareas, porcentajeTareas],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              '${(porcentajeTareas * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 20),

                  Align(alignment: Alignment.centerLeft, child: Text('Tiempo tardado:', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.045))),  
                  const SizedBox(height: 10),              
                  SizedBox(
                    height: 20.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                          colors: [c1, c2],
                          stops: [porcentajeTiempo, porcentajeTiempo],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              alignment: Alignment.centerLeft,
                              child: Text('${t1}m', style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              alignment: Alignment.centerLeft,
                              child: Text('${(t2-t1).toStringAsFixed(1)}m', style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ]
                      )
                    ),
                  ),
                  const SizedBox(height: 30),  

                  // Listados:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TareasRealizadas()));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                        child: const Text('REALIZADAS', style: TextStyle(color: Colors.white))
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TareasPendientes()));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                        child: const Text('NO REALIZADAS', style: TextStyle(color: Colors.white))
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TareasListado()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                    child: const Text('LISTADO COMPLETO', style: TextStyle(color: Colors.white))
                  ),
                  const SizedBox(height: 20), 

                  // Recomendaciones:
                  const Align(alignment: Alignment.centerLeft, child:Text('Recomendaciones', style: TextStyle(fontFamily: 'Titulos', fontSize: 25, color: Color.fromARGB(255, 255, 118, 39)))),
                  for(var texto in recomendaciones)
                    Text(texto, style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.045)),
                  const SizedBox(height: 10),

                  // Estrellas:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: e1, size: widthPantalla*0.2),
                      Icon(Icons.star, color: e2, size: widthPantalla*0.2),
                      Icon(Icons.star, color: e3, size: widthPantalla*0.2)
                    ]
                  )   
                ]
              )
            )
          )
        )
      )
    );
  } 
}