import 'package:app_tdah/view/a%C3%B1adir_tareas/a%C3%B1adir_tareas.dart';
import 'package:app_tdah/view/examenes/examenes.dart';
import 'package:flutter/material.dart';
import 'agenda/agenda.dart';
import 'organizacion/organizar_semana.dart';
import '../main.dart';

class MenuPrincipal extends StatefulWidget{
  const MenuPrincipal({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuPrincipal> {
  @override
  Widget build(BuildContext context){
    double widthPantalla = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('MENÚ PRINCIPAL', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Inicio()));
          },  
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: widthPantalla*0.45,
                    width: widthPantalla*0.45,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Agenda()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/organizacion_tareas.png',  width: widthPantalla*0.17, height: widthPantalla*0.17),
                          Text('Agenda', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.07, color: Colors.white))
                        ]
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 10),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: widthPantalla*0.2,
                        width: widthPantalla*0.45,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AnadirTarea()));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
                              backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/icons/tareas_pendientes.png',  width: widthPantalla*0.1, height: widthPantalla*0.1),
                                const SizedBox(width: 5),
                                Text('Añadir tareas', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.05, color: Colors.white))
                              ]
                            ),
                          ),
                        )
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        height: widthPantalla*0.2,
                        width: widthPantalla*0.45,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const OrganizarSemana()));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                              backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/icons/calendario.png',  width: widthPantalla*0.12, height: widthPantalla*0.12),
                                const SizedBox(width: 5),
                                Text('Organizar semana', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.05, color: Colors.white))
                              ]
                            ),
                          ),
                        )
                      )
                    ]
                  )
                ]
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: widthPantalla*0.2,
                        width: widthPantalla*0.45,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ElevatedButton(
                            onPressed: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => const AnadirTarea()));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                              backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/icons/evaluacion.png',  width: widthPantalla*0.1, height: widthPantalla*0.1),
                                const SizedBox(width: 5),
                                Text('Evaluación', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.05, color: Colors.white))
                              ]
                            ),
                          ),
                        )
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        height: widthPantalla*0.2,
                        width: widthPantalla*0.45,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: ElevatedButton(
                            onPressed: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => const OrganizarSemana()));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                              backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                            ),
                            child: Row(
                              children: [
                                Image.asset('assets/icons/perfil.png',  width: widthPantalla*0.12, height: widthPantalla*0.12),
                                const SizedBox(width: 5),
                                Text('Perfil', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.05, color: Colors.white))
                              ]
                            ),
                          ),
                        )
                      )
                    ]
                  ),

                  const SizedBox(width: 10),

                  SizedBox(
                    height: widthPantalla*0.45,
                    width: widthPantalla*0.45,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Examenes()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/exam.png',  width: widthPantalla*0.17, height: widthPantalla*0.17),
                          Text('Exámenes', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.07, color: Colors.white))
                        ]
                      ),
                    ),
                  )
                ]
              ),
            ]
          )
        )
      )
    );
  } 
}