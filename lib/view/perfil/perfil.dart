import 'package:app_tdah/view/padre.dart';
import 'package:app_tdah/view/perfil/modificar_avatar.dart';
import 'package:app_tdah/view/perfil/modificar_perfil.dart';
import 'package:flutter/material.dart';
import '../menu.dart';

class Perfil extends StatefulWidget{
  const Perfil({super.key});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Map<String, dynamic> usuario = {};
  int edad = -1;
  bool cargado = false;

  @override
  void initState(){
    super.initState();
    getUsuario();
  }

  Future<void> getUsuario() async{
    await Future.delayed(const Duration(milliseconds: 10));
    usuario = await controlUsuario.getUsuario(idUsuario);

    setState(() {
      final hoy = DateTime.now();
      final fecha = DateTime.parse(usuario['usuarios']['nacimiento'].toString());
      edad = hoy.year - fecha.year;

      if(hoy.month < fecha.month || (hoy.month == fecha.month && hoy.day < fecha.day)){
        edad--;
      }
      cargado = true;
    });
  }

  @override
  Widget build(BuildContext context){
    double widthPantalla = MediaQuery.of(context).size.width;

    if(!cargado){
      return Scaffold(
        body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
          child:
            const Center(child: CircularProgressIndicator())
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('PERFIL', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 118, 39),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuPrincipal()));
          },  
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
          margin: const EdgeInsets.all(15.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.asset('assets/avatares/${usuario['usuarios']['foto']}', width: widthPantalla*0.3, height: widthPantalla*0.3, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 10),
                      Text('ESTRELLAS: ${usuario['usuarios']['estrellas']}', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.04)),
                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ModificarAvatar(estrellas: usuario['usuarios']['estrellas'])));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                        child: Text('CAMBIAR AVATAR', style: TextStyle(color: Colors.white, fontSize: widthPantalla*0.035))
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ModificarPerfil(nombre: usuario['usuarios']['nombre'], ciudad: usuario['usuarios']['direccion'], colegio: usuario['usuarios']['colegio'])));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 118, 39)),
                        child: Text('CAMBIAR DATOS', style: TextStyle(color: Colors.white, fontSize: widthPantalla*0.035))
                      ),
                      
                    ]
                  )
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ME LLAMO:', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.05)),
                      const SizedBox(height: 10),
                      Text(usuario['usuarios']['nombre'].toString(), style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04)),
                      const SizedBox(height: 20),
      
                      Text('¿QUÉ EDAD TENGO?', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.05)),
                      const SizedBox(height: 10),
                      Text('$edad años', style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04)),
                      const SizedBox(height: 20),

                      Text('VIVO EN:', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.05)),
                      const SizedBox(height: 10),
                      Text(usuario['usuarios']['direccion'].toString(), style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04)),
                      const SizedBox(height: 20),

                      Text('MI COLEGIO ES:', style: TextStyle(fontFamily: 'Titulos', fontSize: widthPantalla*0.05)),
                      const SizedBox(height: 10),
                      Text(usuario['usuarios']['colegio'].toString(), style: TextStyle(fontFamily: 'Cuerpo', fontSize: widthPantalla*0.04)),
                      const SizedBox(height: 20),
                    ]
                  ),
                )
              ]
            )
          )
        )
      )
    );
  } 
}