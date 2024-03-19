import 'package:app_tdah/view/a%C3%B1adir_tareas/nuevo_colegio.dart';
import 'package:app_tdah/view/a%C3%B1adir_tareas/nuevo_ocio_casa.dart';
import 'package:flutter/material.dart';

class NuevaTarea extends StatefulWidget{
  const NuevaTarea({super.key});

  @override
  _NuevaTareaState createState() => _NuevaTareaState();
}

class _NuevaTareaState extends State<NuevaTarea> {
  @override
  Widget build(BuildContext context){
    double widthPantalla = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('NUEVA TAREA', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 155, 97)
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: widthPantalla*0.4,
                    width: widthPantalla*0.4,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NuevoColegio()));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 255, 155, 97),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Column(
                        children: [
                          Image.asset('assets/icons/libro.png',  width: 100, height: 100),
                          const Text('COLEGIO', style: TextStyle(fontFamily: 'Titulos', fontSize:25, color: Colors.white))
                        ],
                      )
                      
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: widthPantalla*0.4,
                    width: widthPantalla*0.4,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NuevoOcioCasa(tipo: 'tareashogar')));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 255, 155, 97),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Column(
                        children: [
                          Image.asset('assets/icons/casa.png',  width: 100, height: 100),
                          const Text('HOGAR', style: TextStyle(fontFamily: 'Titulos', fontSize:25, color: Colors.white))
                        ],
                      )
                      
                    ),
                  ),
                ]
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: widthPantalla*0.4,
                    width: widthPantalla*0.4,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NuevoOcioCasa(tipo: 'tareasocio')));
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                        backgroundColor: const Color.fromARGB(255, 255, 155, 97),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                      ),
                      child: Column(
                        children: [
                          Image.asset('assets/icons/pelota.png',  width: 100, height: 100),
                          const Text('OCIO', style: TextStyle(fontFamily: 'Titulos', fontSize:25, color: Colors.white))
                        ],
                      )
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: widthPantalla*0.4,
                    width: widthPantalla*0.4,
                    // child: ElevatedButton(
                    //   onPressed: (){
                    //     //Navigator.push(context, MaterialPageRoute(builder: (context) => AnadirTarea()));
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
                    //     backgroundColor: const Color.fromARGB(255, 255, 155, 97),
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                    //   ),
                    //   child: Image.asset('assets/icons/cumple.png',  width: 100, height: 100)
                    // ),
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