import 'package:flutter/material.dart';
import 'agenda.dart';

class MenuPrincipal extends StatefulWidget{
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuPrincipal> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          flexibleSpace: Center(child: Text('MENÚ PRINCIPAL', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
          backgroundColor: Color.fromARGB(255, 255, 118, 39)
        )
      ),
      body: Container(
        color: Color.fromARGB(255, 240, 198, 144),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 230,
                width: 230,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Agenda()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    backgroundColor: Color.fromARGB(255, 255, 118, 39),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('../assets/icons/organizacion_tareas.png',  width: 100, height: 100),
                      Text('Agenda', style: TextStyle(fontFamily: 'Titulos', fontSize: 30))
                    ]
                  ),
                ),
              ),
              
              SizedBox(width: 10),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 230,
                    child: ElevatedButton(
                      onPressed: (){

                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                        backgroundColor: Color.fromARGB(255, 255, 118, 39),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Row(
                        children: [
                          Image.asset('../assets/icons/tareas_pendientes.png',  width: 50, height: 50),
                          SizedBox(width: 5),
                          Text('Añadir tareas', style: TextStyle(fontFamily: 'Titulos', fontSize: 20))
                        ]
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Container(
                    height: 70,
                    width: 230,
                    child: ElevatedButton(
                      onPressed: (){

                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                        backgroundColor: Color.fromARGB(255, 255, 118, 39),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Row(
                        children: [
                          Image.asset('../assets/icons/calendario.png',  width: 50, height: 50),
                          SizedBox(width: 5),
                          Text('Organizar semana', style: TextStyle(fontFamily: 'Titulos', fontSize: 20))
                        ]
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  Container(
                    height: 70,
                    width: 230,
                    child: ElevatedButton(
                      onPressed: (){

                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                        backgroundColor: Color.fromARGB(255, 255, 118, 39),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Row(
                        children: [
                          Image.asset('../assets/icons/ordenar.png',  width: 50, height: 50),
                          SizedBox(width: 5),
                          Text('Organizar día', style: TextStyle(fontFamily: 'Titulos', fontSize: 20))
                        ]
                      ),
                    ),
                  ),
                ]
              )
            ]
          ),
        )
      )
    );
  } 
}