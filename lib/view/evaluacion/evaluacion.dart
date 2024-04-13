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
  List<String> recomendaciones = [];
  List<String> dificultades = [];
  List<int> numPasos = [];
  int estrellas = 0;
  Color e1 = Colors.black;
  Color e2 = Colors.black;
  Color e3 = Colors.black;
  bool cargado = false;

  Future<void> obtenerInformacion() async{
    final realizadas = await controlTareas.numeroRealizadas(idUsuario);
    final pendientes = await controlTareas.numeroPendientes(idUsuario);
    final empleado = await controlTareas.tiempoEmpleado(idUsuario);
    final estimado = await controlTareas.tiempoEstimado(idUsuario);

    String year = dia.year.toString();
    String month = dia.month.toString().padLeft(2, '0'); // padLeft introduce un 0 en caso de tener un solo dígito
    String day = dia.day.toString().padLeft(2, '0');
    String fecha = '$year-$month-$day';
    var tareas = await controlTareas.tareasDia(fecha, idUsuario);

    for(var tarea in tareas){
      int id = tarea['tareas']['id'];
      String tipo = tarea['tareas']['tipo_tarea'];
      String dificultad = (await controlTareas.getDificultad(id))[0]['tareas']['dificultad'];
      var resultado;
      if(tipo == 'tareascolegio'){
        resultado = await controlTareas.getNumPasosColegio(id); 
      }else if(tipo == 'tareasocio'){
        resultado = await controlTareas.getNumPasosOcio(id);
      }else{
        resultado = await controlTareas.getNumPasosHogar(id);
      }
      int pasos = resultado[0]['']['count'];

      dificultades.add(dificultad);
      numPasos.add(pasos);
    }

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

      // Información sobre las recomendaciones:
      if(numPendientes > 0){
        recomendaciones.add("- Debes poner un número de tareas que puedas realizar.");
      }

      if(t2-t1 > t2*0.2){
        recomendaciones.add("- Debes indicar un tiempo realista, ni mucho ni poco.");
      }

      int contador = 0;
      for(int paso in numPasos){
        if(paso == 1){
          contador++;
        }
      }

      if(contador >= (numPendientes+numRealizadas)*0.5){
        recomendaciones.add("- Debes dividir las tareas en más de un paso.");
      }

      contador = 0;
      for(int paso in numPasos){
        if(paso >= 5){
          contador++;
        }
      }

      if(contador >= (numPendientes+numRealizadas)*0.5){
        recomendaciones.add("- No debes poner demasiados pasos en las tareas.");
      }

      int dificil = 0;
      int facil = 0;
      for(String dificultad in dificultades){
        if(dificultad == 'alta'){
          dificil++;
        } else if(dificultad == 'baja'){
          facil++;
        }
      }

      if(dificil >= (numPendientes+numRealizadas)*0.5){
        recomendaciones.add("- No debes poner demasiadas tareas difíciles el mismo día.");
      }

      if(facil >= (numPendientes+numRealizadas)*0.8){
        recomendaciones.add("- No debes poner solo tareas fáciles en un día.");
      }

      if(recomendaciones.isEmpty){
        recomendaciones.add("No hay ninguna recomendación actualmente.");
      }

      // Recuento de estrellas:
      if(numPendientes < numRealizadas){
        estrellas++;
      }

      if(numPendientes == 0 && numRealizadas > 0){
        estrellas++;
      }

      if(recomendaciones.isEmpty){
        estrellas++;
      }

      if(estrellas > 0){
        e1 = const Color.fromARGB(255, 255, 118, 39);
      }
      
      if(estrellas > 1){
        e2 = const Color.fromARGB(255, 255, 118, 39);
      }

      if(estrellas > 3){
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
                              child: Text('${t2-t1}m', style: const TextStyle(color: Colors.white),
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