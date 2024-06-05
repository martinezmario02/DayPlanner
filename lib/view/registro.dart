import 'package:app_tdah/view/padre.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class RegistroUsuario extends StatefulWidget{
  const RegistroUsuario({super.key});

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<RegistroUsuario> {
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlCorreo = TextEditingController();
  TextEditingController controlFecha = TextEditingController();
  TextEditingController controlCiudad = TextEditingController();
  TextEditingController controlCentro = TextEditingController();
  TextEditingController controlContrasena = TextEditingController();
  TextEditingController controlContrasena2 = TextEditingController();

  DateTime fecha = DateTime.now();
  final formKey = GlobalKey<FormState>();
  bool correoCorrecto = false;
  final formatoCorreo = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  // Función para el calendario:
  Future<void> seleccionarFecha(BuildContext context) async{
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme.copyWith(primary: const Color.fromARGB(255, 255, 155, 97), onPrimary: Colors.white); // color para el calendario

    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context, 
      initialDate: fecha, 
      firstDate: DateTime(2024), 
      lastDate: DateTime(2050),
      locale: const Locale('es', 'ES'),
      // Para cambiar el color del calendario:
      builder: (BuildContext context, Widget? child){
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: colorScheme,
          ), 
          child: child!
        );
      }
    );

    if(fechaSeleccionada != null && fechaSeleccionada != fecha){
      setState(() {
        fecha = fechaSeleccionada;
        controlFecha.text = '${fecha.year}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> guardarUsuario() async{
    await controlUsuario.guardarUsuario(controlNombre.text, controlCorreo.text, controlFecha.text, controlCiudad.text, controlCentro.text, encriptarContrasena(controlContrasena.text));
  }

  Future<void> comprobarCorreo() async{
    var resultado = await controlUsuario.comprobarCorreo(controlCorreo.text);
    
    if(int.parse(resultado['']['count'].toString()) == 0){
      setState(() {
        correoCorrecto = true;
      }); 
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('REGISTRO DE USUARIO', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 118, 39)
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: controlNombre,
                      decoration: const InputDecoration(
                        labelText: 'Nombre', 
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      validator: (value){
                        if(controlNombre.text.isEmpty){
                          return 'Debes introducir tu nombre';
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: controlCorreo,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico', 
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),  
                      validator: (value){
                        if(controlCorreo.text.isEmpty){
                          return 'Debes introducir tu correo electrónico';
                        } else if(!formatoCorreo.hasMatch(controlCorreo.text)){
                          return 'El correo no tiene un formato adecuado';
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: controlFecha,
                      onTap: () => seleccionarFecha(context),
                      decoration: const InputDecoration(
                        labelText: 'Fecha',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      validator: (value){
                        if(controlFecha.text.isEmpty){
                          return 'Debes introducir tu fecha de nacimiento';
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
                          return 'Debes introducir la ciudad donde vives';
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: controlCentro,
                      decoration: const InputDecoration(
                        labelText: 'Centro educativo', 
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ), 
                      validator: (value){
                        if(controlCentro.text.isEmpty){
                          return 'Debes introducir el centro educativo';
                        }
                        return null;
                      } 
                    ),
                    const SizedBox(height: 20),
                    
                    TextFormField(
                      controller: controlContrasena,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña', 
                        border: OutlineInputBorder(), // para que se vean los bordes
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

                    TextFormField(
                      controller: controlContrasena2,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirmación de contraseña', 
                        border: OutlineInputBorder(), // para que se vean los bordes
                        fillColor: Colors.white,
                        filled: true,
                      ), 
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Debes confirmar la contraseña.';
                        } else if(controlContrasena.text != controlContrasena2.text){
                          return 'Las dos contraseñas deben ser iguales';
                        }
                        return null;
                      }  
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async{
                        if(formKey.currentState!.validate()){
                          await comprobarCorreo();
                          if(correoCorrecto){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Usuario registrado')),
                            );

                            guardarUsuario();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const Inicio()));
                          } else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('El correo ya está en uso')),
                            );
                          }
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
        )
      )
    );
  } 
}