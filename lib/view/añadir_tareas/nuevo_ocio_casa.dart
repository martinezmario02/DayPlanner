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
  TextEditingController controlTiempo = TextEditingController();
  TextEditingController controlDescripcion = TextEditingController();
  TextEditingController controlObjetivo = TextEditingController();

  // Otros atributos:
  DateTime fecha = DateTime.now();
  List<String> opcionesDificultad = ['alta', 'media', 'baja'];
  String? dificultad;
  List<String> opcionesTarea = [];
  String? tipoTarea;
  String alerta ='';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(alerta, style: const TextStyle(fontFamily: 'Cuerpo', fontSize: 20, color: Colors.red)),
                  const SizedBox(height: 20),

                  TextField(
                    controller: controlNombre,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la tarea', 
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),  
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: controlFecha,
                    onTap: () => seleccionarFecha(context),
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: controlTiempo,
                    keyboardType: TextInputType.number, // teclado numérico
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly], // para que solo admita números
                    decoration: const InputDecoration(
                      labelText: 'Tiempo de realización (minutos)',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    height: 52,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
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
                            child: Text(e.substring(0,1).toUpperCase() + e.substring(1).toLowerCase(), overflow: TextOverflow.visible,)
                          )).toList(),
                          onChanged: (e) => setState(() {
                            dificultad = e;
                          }),
                        )
                      )
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
                    child: TextField(
                      controller: controlDescripcion,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descripción de la tarea', 
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
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
                    child: TextField(
                      controller: controlObjetivo,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Objetivo de la tarea', 
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: (){
                      DateTime fecha = DateTime.parse(controlFecha.text);
                      if(controlNombre.text.isEmpty || controlFecha.text.isEmpty || controlTiempo.text.isEmpty || controlDescripcion.text.isEmpty){
                        setState(() {
                          alerta = 'Debe rellenar todos los campos.';
                        });
                      } else if(fecha.isBefore(DateTime.now())){
                        setState(() {
                          alerta = 'La fecha desbe ser posterior a hoy.';
                        });
                      } else{
                        Tarea tarea = Tarea(
                          0, 
                          controlNombre.text, 
                          controlFecha.text, 
                          dificultad.toString(),
                          double.parse(controlTiempo.text),
                          controlObjetivo.text,
                          controlDescripcion.text,
                          tipo,
                          'pendiente',
                          0,
                          1,
                          '',
                          0,
                          idUsuario
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AnadirPaso(tarea: tarea, asignatura: controlAsignatura.text, tipo: tipoTarea.toString())));
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
    );
  } 
}