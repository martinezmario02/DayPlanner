import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../padre.dart';
import '../menu.dart';
import 'nuevo_examen.dart';

class Examenes extends StatefulWidget{
  const Examenes({super.key});

  @override
  _ExamenesState createState() => _ExamenesState();
}

class _ExamenesState extends State<Examenes> {
  var examenes = [];
  String variable = 'Dificultad'; 
  Color realizados = const Color.fromARGB(255, 240, 198, 144);
  Color pendientes = const Color.fromARGB(255, 243, 188, 117);
  late TextEditingController controlNota;

  Future<void> getExamenesPendientes() async{
    var e = await controlExamenes.examenesPendientes(idUsuario);
    
    setState(() {
      examenes = e;
      variable = 'Dificultad'; 
      realizados = const Color.fromARGB(255, 240, 198, 144);
      pendientes = const Color.fromARGB(255, 243, 188, 117);
    });
  }

  Future<void> getExamenesRealizados() async{
    var e = await controlExamenes.examenesRealizados(idUsuario);
    
    setState(() {
      examenes = e;
      variable = 'Nota'; 
      realizados = const Color.fromARGB(255, 243, 188, 117);
      pendientes = const Color.fromARGB(255, 240, 198, 144);
    });
  }

  Future<String> getDificultadExamen(int id) async{
    var resultado = await controlExamenes.getDificultadExamen(id); 
    String dificultad = resultado[0]['examenes']['dificultad'];

    return dificultad;
  }

  Future<void> guardarNota(int id) async{
    await controlExamenes.guardarNota(id, double.parse(controlNota.text));
    getExamenesRealizados();
  }

  @override
  void initState(){
    super.initState();
    getExamenesPendientes();
    controlNota = TextEditingController();
    controlNota.text = '';
  }

  @override
  Widget build(BuildContext context){
    double widthPantalla = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('EXÁMENES', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
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
        child: Center(
          child: Column(
            children: [
              // Menú superior:
              const SizedBox(height: 10),
              Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.45),
                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.45)
                },
                border: TableBorder.all(color: const Color.fromARGB(255, 255, 118, 39), width: 2.5),
                children: [
                  TableRow(
                    children: [
                      TableCell(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              getExamenesPendientes();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(pendientes),
                            ),
                            child: Center(child: Text('PENDIENTES', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.035, color: Colors.black))),
                          ),
                        )
                      ),
                      TableCell(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              getExamenesRealizados();
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(realizados),
                            ),
                            child: Center(child: Text('REALIZADOS', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.035, color: Colors.black))),
                          ),
                        )
                      ),
                    ]
                  )
                ],
              ),

              // Exámenes:
              const SizedBox(height: 20),
              Table(
                columnWidths: {
                  0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.30),
                  1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.30), 
                  2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.15), 
                  3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
                },
                children: [
                  TableRow(
                    children: [
                      Center(child: Text('Asignatura', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.035, color: Colors.black))),
                      Center(child: Text('Temario', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.035, color: Colors.black))),
                      Center(child: Text('Fecha', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.035, color: Colors.black))),
                      Center(child: Text(variable, style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.035, color: Colors.black)))
                    ]
                  )
                ],
              ),
              
              Expanded(
                child: ListView.builder(
                  itemCount: examenes.length,
                  itemBuilder: (BuildContext context, int index){
                    String fecha = examenes[index]['examenes']['fecha'].toString();
                    DateTime date = DateTime.parse(fecha);
                    fecha = DateFormat('dd/MM').format(date);

                    String nota = examenes[index]['examenes']['nota'].toString();
                    if(nota == 'null'){
                      if(variable=='Nota'){
                        nota = '+';
                      }
                      else{
                        nota = '';
                      }
                    }

                    return Column(
                      children: [
                        const SizedBox(height: 15),
                        Table(
                          border: TableBorder.all(),
                          columnWidths: {
                            0: FixedColumnWidth(MediaQuery.of(context).size.width * 0.30), 
                            1: FixedColumnWidth(MediaQuery.of(context).size.width * 0.30), 
                            2: FixedColumnWidth(MediaQuery.of(context).size.width * 0.15), 
                            3: FixedColumnWidth(MediaQuery.of(context).size.width * 0.16),
                          },
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    height: 50,
                                    color: Colors.white,
                                    child: Center(child: Text(examenes[index]['examenes']['asignatura'], style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black)))  
                                  )
                                ),
                                TableCell(
                                  child: Container(
                                    height: 50,
                                    color: Colors.white,
                                    child: Center(child: Text(examenes[index]['examenes']['temario'], style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black)))  
                                  )
                                ),
                                TableCell(
                                  child: Container(
                                    height: 50,
                                    color: Colors.white,
                                    child: Center(child: Text(fecha, style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04, color: Colors.black)))
                                  )
                                ),
                                TableCell(
                                  child: FutureBuilder<String>(
                                    future: getDificultadExamen(examenes[index]['examenes']['id']),
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

                                        return SizedBox(
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: (){
                                              if(variable=='Nota'){
                                                showDialog(
                                                  context: context, 
                                                  builder: (BuildContext context){
                                                    return AlertDialog(
                                                      title: const Text('Ingresa la nota del examen'),
                                                      content: TextFormField(
                                                        controller: controlNota,
                                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                                        ],
                                                        decoration: const InputDecoration(labelText: 'Nota del examen'),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop(); 
                                                            guardarNota(examenes[index]['examenes']['id']);

                                                          },
                                                          child: const Text('Aceptar'),
                                                        ),
                                                      ]
                                                    );
                                                  }
                                                );
                                              }
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.zero,
                                                ),
                                              ),
                                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                                              backgroundColor: MaterialStateProperty.all(fondo),
                                            ),
                                            child: Center(child: Text(nota, maxLines: 1, style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.035, color: Colors.black)))
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

              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NuevoExamen()));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                  child: const Text('AÑADIR EXAMEN', style: TextStyle(color: Colors.white))
                ),
              )
            ],
          )
        )
       )
    );
  } 
}