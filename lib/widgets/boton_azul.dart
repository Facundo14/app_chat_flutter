import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String texto;
  final Color color;
  final Function() onPressed;

  const BotonAzul({
    Key? key,
    required this.texto,
    this.color = Colors.blue,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        onPrimary: color,
        shape: const StadiumBorder(),
      ),
      onPressed: onPressed,
      child: SizedBox(
        width: double.infinity,
        height: size.height * 0.06,
        child: Center(
          child: Text(
            texto,
            style: TextStyle(color: Colors.white, fontSize: size.width * 0.04),
          ),
        ),
      ),
    );
  }
}
