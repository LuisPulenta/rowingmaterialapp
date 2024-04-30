import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowingmaterialapp/models/models.dart';

class InstalacionNuevaScreen extends StatefulWidget {
  final User user;
  final Position positionUser;
  final String imei;

  const InstalacionNuevaScreen(
      {Key? key,
      required this.user,
      required this.positionUser,
      required this.imei})
      : super(key: key);

  @override
  State<InstalacionNuevaScreen> createState() => _InstalacionNuevaScreenState();
}

class _InstalacionNuevaScreenState extends State<InstalacionNuevaScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Instalación'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Nueva Instalación'),
      ),
    );
  }
}
