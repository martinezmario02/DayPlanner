import 'package:app_tdah/controller/control_tareas.dart';
import 'package:flutter/material.dart';
import '../model/tarea.dart';

class Agenda extends StatefulWidget{
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  final controlTareas = ControladorTareas();
  var tareas = [];

  Future<void> getTareas() async{
    tareas = await controlTareas.tareas();
  }

  @override
  Widget build(BuildContext context){
    getTareas();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          flexibleSpace: Center(child: Text('AGENDA', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
          backgroundColor: Color.fromARGB(255, 255, 118, 39)
        )
      ),
      body: Container(
        color: Color.fromARGB(255, 240, 198, 144),
        child: Center(
          // child: Column(
          //   children: [
          //     SizedBox(height: 10),
          //     Table(
          //       border: TableBorder.all(),
          //       columnWidths: {
          //         0: FixedColumnWidth(70.0),
          //         1: FixedColumnWidth(270.0),
          //         2: FixedColumnWidth(70.0), 
          //         3: FixedColumnWidth(70.0),
          //       },
          //       children: [
          //         TableRow(
          //           children: [
          //             TableCell(
          //               child: Container(
          //                 height: 70,
          //                 color: Colors.white,
          //                 child: Center(child: Image.asset('../assets/icons/libro.png',  width: 40, height: 40))
          //               )
          //             ),
          //             TableCell(
          //               child: Container(
          //                 height: 70,
          //                 color: Colors.white,
          //                 child: Center(child: Text('Deberes Lengua', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
          //               )
          //             ),
          //             TableCell(
          //               child: Container(
          //                 height: 70,
          //                 color: Colors.white,
          //                 child: Center(child: Text('1h', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
          //               )
          //             ),
          //             TableCell(
          //               child: Container(
          //                 height: 70,
          //                 color: Colors.white,
          //                 child: Center(child: Image.asset('../assets/icons/play.png',  width: 40, height: 40))
          //               )
          //             ),
          //           ]
          //         )
          //       ],
          //     )
          //   ],
          // )
          child: ListView.builder(
            itemCount: tareas.length,
            itemBuilder: (BuildContext context, int index){
              return ListTile(title: Text('a'));
            },
            // children: [
            //   SizedBox(height: 10),
            //   Table(
            //     border: TableBorder.all(),
            //     columnWidths: {
            //       0: FixedColumnWidth(70.0),
            //       1: FixedColumnWidth(270.0),
            //       2: FixedColumnWidth(70.0), 
            //       3: FixedColumnWidth(70.0),
            //     },
            //     children: [
            //       TableRow(
            //         children: [
            //           TableCell(
            //             child: Container(
            //               height: 70,
            //               color: Colors.white,
            //               child: Center(child: Image.asset('../assets/icons/libro.png',  width: 40, height: 40))
            //             )
            //           ),
            //           TableCell(
            //             child: Container(
            //               height: 70,
            //               color: Colors.white,
            //               child: Center(child: Text('Deberes Lengua', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
            //             )
            //           ),
            //           TableCell(
            //             child: Container(
            //               height: 70,
            //               color: Colors.white,
            //               child: Center(child: Text('1h', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.black)))
            //             )
            //           ),
            //           TableCell(
            //             child: Container(
            //               height: 70,
            //               color: Colors.white,
            //               child: Center(child: Image.asset('../assets/icons/play.png',  width: 40, height: 40))
            //             )
            //           ),
            //         ]
            //       )
            //     ],
            //   )
            // ],
          )
        ),
      )
    );
  } 
}