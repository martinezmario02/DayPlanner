import 'package:app_tdah/view/padre.dart';

import './perfil.dart';
import 'package:flutter/material.dart';

class ModificarPerfil extends StatefulWidget{
  final String nombre;
  final String ciudad;
  final String colegio;
  const ModificarPerfil({super.key, required this.nombre, required this.ciudad, required this.colegio});

  @override
  _ModificarPerfilState createState() => _ModificarPerfilState();
}

class _ModificarPerfilState extends State<ModificarPerfil> {
  // Controladores:
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlCiudad = TextEditingController();
  TextEditingController controlColegio = TextEditingController();

  final formKey = GlobalKey<FormState>();
  var datos = [];

  @override
  void initState() {
    super.initState();
    controlNombre.text = widget.nombre;
    controlCiudad.text = widget.ciudad;
    controlColegio.text = widget.colegio;
  }

  Future<void> modificarPerfil() async{
    await controlUsuario.modificarPerfil(idUsuario, controlNombre.text, controlCiudad.text, controlColegio.text);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('MODIFICACIÓN DE DATOS', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 155, 97)
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                TextFormField(
                  controller: controlNombre,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la tarea', 
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value){
                    if(controlNombre.text.isEmpty){
                      return 'Debes introducir el nombre';
                    }
                    return null;
                  }
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: controlCiudad,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad', 
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value){
                    if(controlCiudad.text.isEmpty){
                      return 'Debes introducir la ciudad';
                    }
                    return null;
                  }
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: controlColegio,
                  decoration: const InputDecoration(
                    labelText: 'Colegio',
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (value){
                    if(controlColegio.text.isEmpty){
                      return 'Debes introducir el colegio';
                    }
                    return null;
                  }
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: (){
                    if(formKey.currentState!.validate()){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Perfil modificado')),
                      );

                      modificarPerfil();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                  child: const Text('GUARDAR', style: TextStyle(color: Colors.white))
                )
              ]
            )
          )
        )
      )
    );
  } 
}