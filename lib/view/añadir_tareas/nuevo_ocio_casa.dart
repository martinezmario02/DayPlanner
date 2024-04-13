import 'package:app_tdah/view/a%C3%B1adir_tareas/a%C3%B1adir_pasos.dart';
import 'package:app_tdah/view/padre.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/tarea.dart';

class NuevoOcioCasa extends StatefulWidget{
  final String tipo;
  const NuevoOcioCasa({super.key, required this.tipo});

  @override
  _NuevoOcioCasaState createState() => _NuevoOcioCasaState();
}

class _NuevoOcioCasaState extends State<NuevoOcioCasa> {
  // Controladores:
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlAsignatura = TextEditingController();
  TextEditingController controlFecha = TextEditingController();
  TextEditingController controlMinutos = TextEditingController();
  TextEditingController controlHoras = TextEditingController();
  TextEditingController controlDescripcion = TextEditingController();
  TextEditingController controlObjetivo = TextEditingController();

  // Otros atributos:
  DateTime fecha = DateTime.now();
  List<String> opcionesDificultad = ['alta', 'media', 'baja'];
  String? dificultad;
  List<String> opcionesTarea = [];
  String? tipoTarea;
  final formKey = GlobalKey<FormState>();
  late String tipo;

  @override
  void initState() {
    super.initState();
    tipo = widget.tipo;
    if(tipo == 'tareasocio'){
      opcionesTarea = ['jugar', 'deporte', 'otro'];
    }else{
      opcionesTarea = ['limpiar', 'ordenar', 'otro'];
    }
  }

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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('NUEVA TAREA', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 155, 97)
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
                          return 'Debes introducir la fecha';
                        }
                        return null;
                      } 
                    ),
                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Tiempo de realización:', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 18)),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            controller: controlHoras,
                            keyboardType: TextInputType.number, // teclado numérico
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // para que solo admita números
                            decoration: const InputDecoration(
                              labelText: 'Horas',
                              border: OutlineInputBorder(),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            validator: (value){
                              if(controlHoras.text.isEmpty && controlMinutos.text.isEmpty){
                                return 'Debes introducir un tiempo de realización';
                              }
                              return null;
                            }
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('horas', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 15)),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            controller: controlMinutos,
                            keyboardType: TextInputType.number, // teclado numérico
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // para que solo admita números
                            decoration: const InputDecoration(
                              labelText: 'Minutos',
                              border: OutlineInputBorder(),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('minutos', style: TextStyle(fontFamily: 'Cuerpo', fontSize: 15)),

                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Dificultad',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            isDense: true,
                            value: dificultad,
                            items: opcionesDificultad.map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e.substring(0,1).toUpperCase() + e.substring(1).toLowerCase(), overflow: TextOverflow.visible,),
                            )).toList(),
                            onChanged: (e) => setState(() {
                              dificultad = e;
                            }),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    
                    Container(
                      height: 52,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tipo de tarea',
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            isDense: true,
                            value: tipoTarea,
                            items: opcionesTarea.map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e.substring(0,1).toUpperCase() + e.substring(1).toLowerCase(), overflow: TextOverflow.visible,)
                            )).toList(),
                            onChanged: (e) => setState(() {
                              tipoTarea = e;
                            }),
                          )
                        )
                      ),
                    ),
                    const SizedBox(height: 20),

                    RawKeyboardListener(
                      focusNode: FocusNode(),
                      onKey: (RawKeyEvent event) {
                        if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
                          // Oculta el teclado cuando se presiona Enter
                          FocusScope.of(context).unfocus();
                        }
                      },
                      child: TextFormField(
                        controller: controlDescripcion,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Descripción de la tarea', 
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        validator: (value){
                          if(controlFecha.text.isEmpty){
                            return 'Debes introducir una descipción';
                          }
                          return null;
                        }
                      ),
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: (){
                        if(formKey.currentState!.validate()){
                          DateTime fecha = DateTime.parse(controlFecha.text);
                          if(fecha.isBefore(DateTime.now())){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('La fecha deber ser posterior a hoy')),
                            );
                          } else if((tipoTarea?.isEmpty ?? true) || (dificultad?.isEmpty ?? true)){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Debes rellenar todos los campos')),
                            );
                          } else{
                            // Calculo el tiempo:
                            double realizacion = 0;
                            if(controlHoras.text.isNotEmpty){
                              realizacion += double.parse(controlHoras.text)*60;
                            }
                            if(controlMinutos.text.isNotEmpty){
                              realizacion += double.parse(controlMinutos.text);
                            }

                            Tarea tarea = Tarea(
                              0, 
                              controlNombre.text, 
                              controlFecha.text, 
                              dificultad.toString(),
                              realizacion,
                              controlObjetivo.text,
                              controlDescripcion.text,
                              'tareascolegio',
                              'pendiente',
                              0,
                              1,
                              '',
                              0,
                              idUsuario
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Información guardada')),
                            );

                            Navigator.push(context, MaterialPageRoute(builder: (context) => AnadirPaso(tarea: tarea, asignatura: controlAsignatura.text, tipo: tipoTarea.toString())));
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