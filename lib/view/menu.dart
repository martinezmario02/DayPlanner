import 'package:app_tdah/view/a%C3%B1adir_tareas/a%C3%B1adir_tareas.dart';
import 'package:flutter/material.dart';
import 'agenda/agenda.dart';

class MenuPrincipal extends StatefulWidget{
  const MenuPrincipal({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuPrincipal> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          flexibleSpace: const Center(child: Text('MENÚ PRINCIPAL', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
          backgroundColor: const Color.fromARGB(255, 255, 118, 39)
        )
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 230,
                width: 230,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Agenda()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/organizacion_tareas.png',  width: 100, height: 100),
                      const Text('Agenda', style: TextStyle(fontFamily: 'Titulos', fontSize: 30))
                    ]
                  ),
                ),
              ),
              
              const SizedBox(width: 10),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 70,
                    width: 230,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AnadirTarea()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/icons/tareas_pendientes.png',  width: 50, height: 50),
                          const SizedBox(width: 5),
                          const Text('Añadir tareas', style: TextStyle(fontFamily: 'Titulos', fontSize: 20))
                        ]
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: 70,
                    width: 230,
                    child: ElevatedButton(
                      onPressed: (){

                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/icons/calendario.png',  width: 50, height: 50),
                          const SizedBox(width: 5),
                          const Text('Organizar semana', style: TextStyle(fontFamily: 'Titulos', fontSize: 20))
                        ]
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  SizedBox(
                    height: 70,
                    width: 230,
                    child: ElevatedButton(
                      onPressed: (){

                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/icons/ordenar.png',  width: 50, height: 50),
                          const SizedBox(width: 5),
                          const Text('Organizar día', style: TextStyle(fontFamily: 'Titulos', fontSize: 20))
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