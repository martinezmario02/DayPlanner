import 'dart:io';
import 'package:app_tdah/view/padre.dart';
import 'package:flutter/material.dart';
import './perfil.dart';
import 'package:path_provider/path_provider.dart';  
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';


class ModificarAvatar extends StatefulWidget{
  final int estrellas;
  const ModificarAvatar({super.key, required this.estrellas});

  @override
  _ModificarAvatarState createState() => _ModificarAvatarState();
}

class _ModificarAvatarState extends State<ModificarAvatar> {
  late List<File> imagenes = [];
  late int estrellas;

  Future<void> cargarImagenes() async {
    List<File> listaImagenes = [];
    List<String> rutas = [
      'assets/avatares/0_pingu.jpg',
      'assets/avatares/1_gato.jpg',
      'assets/avatares/2_tigre.jpg',
      'assets/avatares/3_lobo.jpg',
      'assets/avatares/4_dragon.jpg',
    ];

    for (String ruta in rutas) {
      final ByteData data = await rootBundle.load(ruta);
      final buffer = data.buffer;
      final tempDir = await getTemporaryDirectory();
      final File imagen = File('${tempDir.path}/${ruta.split('/').last}');
      await imagen.writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
      listaImagenes.add(imagen);
    }

    setState(() {
      imagenes = listaImagenes;
    });
  }


  Future<void> modificarAvatar(String nombre) async{
    await controlUsuario.modificarAvatar(idUsuario, nombre);
  }

  @override
  void initState() {
    super.initState();
    estrellas = widget.estrellas;
    cargarImagenes();
  }

  @override
  Widget build(BuildContext context){
    double widthPantalla = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const Center(child: Text('MODIFICACIÓN DEL AVATAR', style: TextStyle(fontFamily: 'Titulos', fontSize: 30, color: Colors.white))),
        backgroundColor: const Color.fromARGB(255, 255, 155, 97)
      ),
      body: Container(
        color: const Color.fromARGB(255, 240, 198, 144),
        child: Container(
          margin: const EdgeInsets.all(30.0),
          child: ListView.builder(
            itemCount: imagenes.length,
            itemBuilder: (context, index){
              final imagen = imagenes[index];
              if(estrellas >= index*10){
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Avatar modificado')),
                    );
                    
                    modificarAvatar(imagen.path.split('/').last);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Perfil()));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Image.file(imagen, width: widthPantalla*0.3, height: widthPantalla*0.3)
                  )
                );
              } else{
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.file(imagen, width: widthPantalla*0.3, height: widthPantalla*0.3),
                      Container(color: Colors.black.withOpacity(0.5), width: widthPantalla*0.3, height: widthPantalla*0.3, child: const Icon(Icons.lock))
                    ],
                  )
                );
              }   
            }
          )
        )
      )
    );
  } 
}