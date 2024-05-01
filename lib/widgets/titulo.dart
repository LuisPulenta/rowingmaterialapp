import 'package:flutter/material.dart';

class Titulo extends StatelessWidget {
  final String texto;
  final Color color;

  const Titulo({super.key, required this.texto, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      width: ancho * 0.95,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: Colors.black,
          )),
      child: Align(
        alignment: Alignment.center,
        child: Text(texto,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
