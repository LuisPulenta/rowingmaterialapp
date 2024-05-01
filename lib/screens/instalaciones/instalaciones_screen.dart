import 'package:flutter/material.dart';
import 'package:rowingmaterialapp/models/models.dart';
import 'package:rowingmaterialapp/screens/screens.dart';

class InstalacionesScreen extends StatefulWidget {
  final User user;
  final String imei;

  const InstalacionesScreen({Key? key, required this.user, required this.imei})
      : super(key: key);

  @override
  State<InstalacionesScreen> createState() => _InstalacionesScreenState();
}

class _InstalacionesScreenState extends State<InstalacionesScreen> {
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
        title: const Text('Instalaciones'),
        centerTitle: true,
      ),
      body: _getBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 38,
        ),
        backgroundColor: const Color(0xFF781f1e),
        onPressed: () => _addInstalacion(),
      ),
    );
  }

//---------------------------------------------------------------
//----------------------- _getBody ------------------------------
//---------------------------------------------------------------

  Widget _getBody() {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF484848),
              Color(0xFF484848),
            ],
          ),
        ),
        child: Column(
          children: [],
        ));
  }

//-----------------------------------------------------------------
//--------------------- _addInstalacion -------------------------
//-----------------------------------------------------------------

  void _addInstalacion() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstalacionNuevaScreen(
          user: widget.user,
          imei: widget.imei,
          // imei: widget.imei,
        ),
      ),
    );
    if (result == 'yes') {
      //_getInstalacione();
    }
  }
}
