import 'package:app_tdah/view/menu.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'view/registro.dart';
import 'view/padre.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:async';

// Función para actualizar las estrellas del usuario:
void actualizarEstrellas() async{
  Workmanager().executeTask((task, inputData) async{
    List<Map<String, dynamic>> usuarios = await controlUsuario.getUsuarios();

    for(int i = 0; i < usuarios.length; i++){
      int id = usuarios[i]['usuarios']['id'];
      Pair<List<dynamic>, int> info = await calcularEstrellas(id);
      await controlUsuario.actualizarEstrellas(id, info.second);
    }
  
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(actualizarEstrellas);
  Workmanager().registerPeriodicTask(
    'task1',
    'simpleTask',
    frequency: Duration(days: 1), // Ejecutar cada día
    initialDelay: Duration(hours: 00, minutes: 00), // Iniciar a las 00:00
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'App',
      home: Inicio(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Español
      ],
    );
  }
}

class Inicio extends StatefulWidget{
  const Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio>{
  final keyForm = GlobalKey<FormState>();
  final controlCorreo = TextEditingController();
  final controlContrasena = TextEditingController();

  @override
  void initState() {
    super.initState();
    iniciarSesionAutomaticamente();
  }

  Future<int?> obtenerUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('idUsuario');
  }

  void iniciarSesionAutomaticamente() async {
    int? id = await obtenerUsuario();
    
    if (id != null) {
      idUsuario = id;
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPrincipal()));
    }
  }

  Future<bool> validado() async{
    if(keyForm.currentState!.validate()){
      int id = await controlUsuario.iniciarSesion(controlCorreo.text, encriptarContrasena(controlContrasena.text));
      if(id != -1){
        idUsuario = id;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('idUsuario', id);
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container( // contenedor para separar el color de los márgenes
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
            margin: const EdgeInsets.all(30.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    const Text('INICIO DE SESIÓN', style: TextStyle(fontFamily: 'Titulos', fontSize: 40, color: Color.fromARGB(255, 255, 118, 39))),
                    const SizedBox(height: 30),
                    
                    Form(
                      key: keyForm,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controlCorreo,
                            decoration: InputDecoration(
                              prefixIcon: Image.asset('assets/icons/user.png', width: 10, height: 10),
                              labelText: 'Correo electrónico', 
                              border: const OutlineInputBorder(), // para que se vean los bordes
                              fillColor: Colors.white,
                              filled: true,
                            ), 
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Debes introducir el correo electrónico.';
                              }
                              return null;
                            } 
                          ),
                          const SizedBox(height: 10),
                          
                          TextFormField(
                            controller: controlContrasena,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Image.asset('assets/icons/contrasena.png', width: 10, height: 10),
                              labelText: 'Contraseña', 
                              border: const OutlineInputBorder(), // para que se vean los bordes
                              fillColor: Colors.white,
                              filled: true,
                            ), 
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Debes introducir la contraseña.';
                              }
                              return null;
                            }  
                          ),
                          const SizedBox(height: 20),
                          
                          ElevatedButton(
                            onPressed: () async{
                              if(await validado()){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Se ha iniciado sesión correctamente')),
                                );

                                Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPrincipal()));
                              } else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('No se ha podido iniciar sesión')),
                                );
                              }
                              
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                            child: const Text('ACEPTAR', style: TextStyle(color: Colors.white))
                          ),
                        ],
                      )
                    ),
                    
                    const SizedBox(height: 40),
                    const Text('¿Aún no te has registrado?', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 18, color: Color.fromARGB(255, 255, 118, 39), fontWeight: FontWeight.bold)),
                    
                    const SizedBox(height: 5),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistroUsuario()));
                      }, 
                      child: const Text('Regístrate aquí', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 18, color: Color.fromARGB(255, 255, 118, 39)))
                    )
                  ],
                )
              )
            ),
        )
      ) 
    );
  }
}