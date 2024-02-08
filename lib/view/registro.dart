import 'package:flutter/material.dart';

class RegistroUsuario extends StatefulWidget{
  const RegistroUsuario({super.key});

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<RegistroUsuario> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          flexibleSpace: const Center(child: Text('REGISTRO DE USUARIO', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
          backgroundColor: const Color.fromARGB(255, 255, 118, 39)
        )
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Center(
          child: const Text('a')
        ),
      )
    );
  } 
}