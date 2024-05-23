import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'dart:convert';
import 'dart:typed_data';

class InstalacionVerFotoScreen extends StatefulWidget {
  final String foto;
  const InstalacionVerFotoScreen({Key? key, required this.foto})
      : super(key: key);

  @override
  State<InstalacionVerFotoScreen> createState() =>
      _InstalacionVerFotoScreenState();
}

class _InstalacionVerFotoScreenState extends State<InstalacionVerFotoScreen> {
  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Ver Foto'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: widget.foto.contains('http') == true
                    ? CachedNetworkImage(
                        imageUrl: widget.foto,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                        width: ancho,
                        placeholder: (context, url) => Image(
                          image: const AssetImage('assets/loading.gif'),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.memory(
                        width: ancho,
                        scale: 0.5,
                        const Base64Decoder().convert(widget.foto),
                      ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF781f1e),
                  minimumSize: Size(ancho * 0.8, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Volver'),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
}
