import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String texto1;
  final String texto2;
  const Labels({Key? key, required this.ruta, required this.texto1, required this.texto2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(
          texto1,
          style: TextStyle(color: Colors.black54, fontSize: size.width * 0.04, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: size.height * 0.02),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, ruta);
          },
          child: Text(
            texto2,
            style: TextStyle(color: Colors.blue[600], fontSize: size.width * 0.042, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
