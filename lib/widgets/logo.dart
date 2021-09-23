import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String texto;
  const Logo({Key? key, required this.texto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.all(size.height * 0.06),
        width: size.width * 0.5,
        child: Column(
          children: [
            const Image(
              image: AssetImage('assets/tag-logo.png'),
            ),
            SizedBox(height: size.height * 0.03),
            Text(
              texto,
              style: TextStyle(fontSize: size.width * 0.07),
            )
          ],
        ),
      ),
    );
  }
}
