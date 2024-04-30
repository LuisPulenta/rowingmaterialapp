import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Boton extends StatelessWidget {
  final IconData icon;
  final String texto;
  final Color color1;
  final Color color2;

  const Boton(
      {this.icon = FontAwesomeIcons.plus,
      required this.texto,
      this.color1 = const Color(0xff6989f5),
      this.color2 = const Color(0xff906ef5)});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _BotonGordoBackground(
          icon: icon,
          color1: color1,
          color2: color2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 120, width: 30),
            FaIcon(
              icon,
              size: 25,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                texto,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 40,
            ),
          ],
        ),
      ],
    );
  }
}

class _BotonGordoBackground extends StatelessWidget {
  final IconData icon;
  final Color color1;
  final Color color2;

  const _BotonGordoBackground({
    this.icon = FontAwesomeIcons.plus,
    this.color1 = const Color(0xff6989f5),
    this.color2 = const Color(0xff906ef5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.red,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            offset: const Offset(4, 6),
            blurRadius: 10,
          ),
        ],
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(colors: [
          color1,
          color2,
        ]),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(children: [
          Positioned(
            right: -10,
            top: -0,
            child: FaIcon(
              icon,
              size: 100,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
        ]),
      ),
    );
  }
}
