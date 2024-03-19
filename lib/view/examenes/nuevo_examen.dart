import 'package:app_tdah/view/padre.dart';
import 'package:flutter/material.dart';
import 'examenes.dart';

class NuevoExamen extends StatefulWidget{
  const NuevoExamen({super.key});

  @override
  _NuevoExamenState createState() => _NuevoExamenState();
}

class _NuevoExamenState extends State<NuevoExamen> {
  // Controladores:
  TextEditingController controlAsignatura = TextEditingController();
  TextEditingController controlFecha = TextEditingController();
  TextEditingController controlTemario = TextEditingController();

  // Otros atributos:
  DateTime fecha = DateTime.now();
  List<String> opcionesDificultad = ['alta', 'media', 'baja'];
  String? dificultad;
  String alerta ='';

  @override
  void initState() {
    super.initState();
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

  Future<void> guardarExamen() async{
    await controlExamenes.guardarExamen(controlAsignatura.text, controlTemario.text, controlFecha.text, dificultad!, idUsuario);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('NUEVO EXAMEN', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
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
                    controller: controlAsignatura,
                    decoration: const InputDecoration(
                      labelText: 'Asignatura', 
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: controlTemario,
                    decoration: const InputDecoration(
                      labelText: 'Temario', 
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
          
                  ElevatedButton(
                    onPressed: (){
                      DateTime fecha = DateTime.parse(controlFecha.text);
                      if(controlAsignatura.text.isEmpty || controlFecha.text.isEmpty || controlTemario.text.isEmpty){
                        setState(() {
                          alerta = 'Debe rellenar todos los campos.';
                        });
                      } else if(fecha.isBefore(DateTime.now())){
                        setState(() {
                          alerta = 'La fecha desbe ser posterior a hoy.';
                        });
                      } else{
                        guardarExamen();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Examenes()));
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