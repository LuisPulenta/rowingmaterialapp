import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:convert';

class InstalacionVerFotoScreen extends StatefulWidget {
  final String foto;
  const InstalacionVerFotoScreen({Key? key, required this.foto})
      : super(key: key);

  @override
  State<InstalacionVerFotoScreen> createState() =>
      _InstalacionVerFotoScreenState();
}

class _InstalacionVerFotoScreenState extends State<InstalacionVerFotoScreen> {
  final GlobalKey<ExtendedImageEditorState> _imageeditorKey =
      GlobalKey<ExtendedImageEditorState>();
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
              Expanded(
                child: ExtendedImage.network(
                  widget.foto,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  extendedImageEditorKey: _imageeditorKey,
                  initEditorConfigHandler: (state) {
                    return EditorConfig(
                      maxScale: 7.0,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: const Color(0xffF7F2F9),
                      ),
                      child: Wrap(
                        children: const [
                          Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF781f1e),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _imageeditorKey.currentState?.rotate(right: false),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: const Color(0xffF7F2F9),
                      ),
                      child: Wrap(
                        children: const [
                          Icon(
                            Icons.rotate_left,
                            color: Color(0xFF781f1e),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _imageeditorKey.currentState?.reset(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: const Color(0xffF7F2F9),
                      ),
                      child: Wrap(
                        children: const [
                          Icon(
                            Icons.panorama_vertical,
                            color: Color(0xFF781f1e),
                            // size: 24.0,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _imageeditorKey.currentState?.rotate(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        backgroundColor: const Color(0xffF7F2F9),
                      ),
                      child: Wrap(
                        children: const [
                          Icon(
                            Icons.rotate_right,
                            color: Color(0xFF781f1e),
                            // size: 24.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 2,
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
