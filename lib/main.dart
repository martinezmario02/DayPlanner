import 'package:app_tdah/view/menu.dart';
import 'package:flutter/material.dart';
import 'view/registro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'App',
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget{
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container( // contenedor para separar el color de los márgenes
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
            margin: const EdgeInsets.all(30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('INICIO DE SESIÓN', style: TextStyle(fontFamily: 'Titulos', fontSize: 40, color: Color.fromARGB(255, 255, 118, 39))),
                  const SizedBox(height: 30),
                  
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Image.asset('assets/icons/user.png', width: 10, height: 10),
                      labelText: 'Correo electrónico', 
                      border: const OutlineInputBorder(), // para que se vean los bordes
                      fillColor: Colors.white,
                      filled: true,
                    ),  
                  ),
                  const SizedBox(height: 10),
                  
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Image.asset('assets/icons/contrasena.png', width: 10, height: 10),
                      labelText: 'Contraseña', 
                      border: const OutlineInputBorder(), // para que se vean los bordes
                      fillColor: Colors.white,
                      filled: true,
                    ),  
                  ),
                  const SizedBox(height: 20),
                  
                  ElevatedButton(
                    onPressed: (){
                      // lógica de comprobación
                      //
                      //
                      //
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPrincipal()));
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                    child: const Text('ACEPTAR')
                  ),
                  
                  const SizedBox(height: 40),
                  const Text('¿Aún no te has registrado?', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 18, color: Color.fromARGB(255, 255, 118, 39), fontWeight: FontWeight.bold)),
                  
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistroUsuario()));
                    }, 
                    child: const Text('Regístrate aquí', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 18, color: Color.fromARGB(255, 255, 118, 39), decoration: TextDecoration.underline))
                  )
                ],
              )
            ),
        )
        
      ) 
      
    );
  }
}