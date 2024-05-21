import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowingmaterialapp/components/loader_component.dart';
import 'package:rowingmaterialapp/helpers/helpers.dart';
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

  List<Instalacion> _instalaciones = [];
  bool _showLoader = false;
//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getInstalaciones();
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF484848),
      appBar: AppBar(
        title: const Text('Instalaciones'),
        centerTitle: true,
      ),
      body: Center(
        child: _showLoader
            ? const LoaderComponent(text: 'Por favor espere...')
            : _getContent(),
      ),
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

//-----------------------------------------------------------------
//--------------------- _getContent -------------------------------
//-----------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        _showInstalacionesCount(),
        Expanded(
          child: _instalaciones.isEmpty ? _noContent() : _getListView(),
        )
      ],
    );
  }

//-----------------------------------------------------------------
//--------------------- _noContent --------------------------------
//-----------------------------------------------------------------

  Widget _noContent() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: const Center(
        child: Text(
          'No hay Instalaciones registradas',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showInstalacionesCount -------------------
//-----------------------------------------------------------------

  Widget _showInstalacionesCount() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      child: Row(
        children: [
          const Text("Cantidad de Instalaciones: ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          Text(_instalaciones.length.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _getListView ------------------------------
//-----------------------------------------------------------------

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getInstalaciones,
      child: ListView(
        children: _instalaciones.map((e) {
          return Card(
            color: const Color(0xFFC7C7C8),
            shadowColor: Colors.white,
            elevation: 10,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
            child: InkWell(
              onTap: () {
                _goInfoInstalacion(e);
              },
              child: Container(
                height: 180,
                margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text("Id Inst: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text("Fecha: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text("N° Obra: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text("Cliente: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text("Documento: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text("Domicilio: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text("Entrecalles: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text("Tipo Instalación: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text("Fecha Instalación: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                Row(
                                  children: const [
                                    Text("Pedido: ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF781f1e),
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Text(e.idRegistro.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(e.fecha!)),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.nroObra.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            e.nombreCliente +
                                                ' ' +
                                                e.apellidoCliente,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.documento,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.domicilioInstalacion,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.entreCalles,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.tipoInstalacion,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                    e.fechaInstalacion!)),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(e.pedido,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (e.auditado == 0)
                            ? IconButton(
                                icon: const CircleAvatar(
                                  backgroundColor: Color(0xFF781f1e),
                                  child: Icon(Icons.edit,
                                      size: 24, color: Colors.white),
                                ),
                                onPressed: () async {
                                  _editInstalacion(e);
                                },
                              )
                            : Container(),
                        (e.auditado == 0)
                            ? IconButton(
                                icon: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.delete,
                                      size: 24, color: Colors.red),
                                ),
                                onPressed: () async {
                                  await _borrarInstalacion(e);
                                },
                              )
                            : Container(),
                        IconButton(
                          icon: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(Icons.arrow_forward_ios,
                                size: 24, color: Colors.white),
                          ),
                          onPressed: () async {
                            _goInfoInstalacion(e);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
          editMode: false,
          instalacion: Instalacion(
              idRegistro: 0,
              nroObra: 0,
              idUsuario: 0,
              imei: '',
              fecha: '',
              latitud: '',
              longitud: '',
              fechaInstalacion: '',
              grupo: '',
              causante: '',
              pedido: '',
              nombreCliente: '',
              apellidoCliente: '',
              documento: '',
              domicilioInstalacion: '',
              entreCalles: '',
              firmacliente: '',
              nombreApellidoFirmante: '',
              tipoInstalacion: '',
              esAveria: '',
              auditado: 0,
              firmaclienteImageFullPath: ''),
        ),
      ),
    );
    if (result == 'yes') {
      _getInstalaciones();
    }
  }

//-----------------------------------------------------------------
//--------------------- _getInstalaciones -------------------------
//-----------------------------------------------------------------

  Future<void> _getInstalaciones() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getInstalaciones(widget.user.idUsuario);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _instalaciones = response.result;
      _instalaciones.sort((a, b) {
        return a.idRegistro
            .toString()
            .toLowerCase()
            .compareTo(b.idRegistro.toString().toLowerCase());
      });
    });
  }

//-----------------------------------------------------------------
//--------------------- _goInfoInstalacion ------------------------
//-----------------------------------------------------------------

  void _goInfoInstalacion(Instalacion e) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstalacionDetalleScreen(
          user: widget.user,
          imei: widget.imei,
          editMode: true,
          instalacion: e,
        ),
      ),
    );
  }

//-----------------------------------------------------------------
//-------------------- _borrarInstalacion -------------------------
//-----------------------------------------------------------------

  _borrarInstalacion(Instalacion e) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text(''),
            content:
                Column(mainAxisSize: MainAxisSize.min, children: const <Widget>[
              Text('¿Está seguro de borrar esta Instalación?'),
              SizedBox(
                height: 10,
              ),
            ]),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('NO')),
              TextButton(
                  onPressed: () async {
                    Response response = await ApiHelper.delete(
                        '/api/AppInstalacionesEquipo/',
                        e.idRegistro.toString());

                    _getInstalaciones();

                    setState(() {});
                    Navigator.of(context).pop();
                  },
                  child: const Text('SI')),
            ],
          );
        });
  }

//---------------------------------------------------------------
//----------------- _editInstalacion ----------------------------
//---------------------------------------------------------------

  void _editInstalacion(Instalacion e) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => InstalacionNuevaScreen(
                  user: widget.user,
                  imei: widget.imei,
                  editMode: true,
                  instalacion: e,
                )));
    if (result == 'yes' || result != 'yes') {
      _getInstalaciones();
      setState(() {});
    }
  }
}
