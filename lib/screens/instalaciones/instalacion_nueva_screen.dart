import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowingmaterialapp/components/loader_component.dart';
import 'package:rowingmaterialapp/helpers/helpers.dart';
import 'package:rowingmaterialapp/models/models.dart';
import 'package:rowingmaterialapp/screens/screens.dart';
import 'package:geocoding/geocoding.dart';
import 'package:rowingmaterialapp/widgets/widgets.dart';
import 'package:camera/camera.dart';

class InstalacionNuevaScreen extends StatefulWidget {
  final User user;
  final String imei;
  final bool editMode;
  final AppInstalacionesEquipo instalacion;

  const InstalacionNuevaScreen(
      {Key? key,
      required this.user,
      required this.imei,
      required this.editMode,
      required this.instalacion})
      : super(key: key);

  @override
  State<InstalacionNuevaScreen> createState() => _InstalacionNuevaScreenState();
}

class _InstalacionNuevaScreenState extends State<InstalacionNuevaScreen>
    with SingleTickerProviderStateMixin {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  TabController? _tabController;

  final String _cantidadError = '';
  final bool _cantidadShowError = false;
  final TextEditingController _cantidadController = TextEditingController();

  String _cantidad = '';

  bool _showLoader = false;
  final String _textComponent = 'Por favor espere...';
  bool _signatureChanged = false;
  late ByteData? _signature;

  bool _photoChanged = false;
  late XFile _image;

  bool _coincideFirmante = false;
  int _tipoPedido = 0;

  bool isValidSerie = false;
  bool existeSerie = false;
  List<SerieSinUsar> _serieSinUsar = [];
  List<SerieSinUsar> _series = [];
  List<Producto> _productos = [];
  List<Producto> _materiales = [];
  SerieSinUsar _serieConDatos = SerieSinUsar(
      nroregistro: 0,
      nrolotecab: 0,
      grupoh: '',
      causanteh: '',
      nroseriesalida: '',
      codigosiag: '',
      codigosap: '',
      denominacion: '',
      foto: '',
      familia: '');

  AppInstalacionesEquipo appInstalacionesEquipo = AppInstalacionesEquipo(
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
      firmaclienteImageFullPath: '',
      documentoFirmante: '',
      mismoFirmante: 0,
      tipoPedido: '');

  final SerieSinUsar _serieConDatosVacia = SerieSinUsar(
      nroregistro: 0,
      nrolotecab: 0,
      grupoh: '',
      causanteh: '',
      nroseriesalida: '',
      codigosiag: '',
      codigosap: '',
      denominacion: '',
      foto: '',
      familia: '');

  String _serie = '';

  String _latitud = '';
  String _longitud = '';

  String _document = '';
  String _documentError = '';
  bool _documentShowError = false;
  TextEditingController _documentController = TextEditingController();

  String _firstname = '';
  String _firstnameError = '';
  bool _firstnameShowError = false;
  TextEditingController _firstnameController = TextEditingController();

  String _lastname = '';
  String _lastnameError = '';
  bool _lastnameShowError = false;
  TextEditingController _lastnameController = TextEditingController();

  String _address = '';
  String _addressError = '';
  bool _addressShowError = false;
  TextEditingController _addressController = TextEditingController();

  String _signname = '';
  String _signnameError = '';
  bool _signnameShowError = false;
  TextEditingController _signnameController = TextEditingController();

  String _signdocument = '';
  String _signdocumentError = '';
  bool _signdocumentShowError = false;
  TextEditingController _signdocumentController = TextEditingController();

  DateTime? fechaInstalacion;

  String _tipoinstalacion = 'Elija un tipo de instalación...';
  String _tipoinstalacionError = '';
  bool _tipoinstalacionShowError = false;

  String _tipoequipo = 'Elija un tipo de equipo...';
  String _tipoequipoError = '';
  bool _tipoequipoShowError = false;

  List<TipoInstalacion> _tiposinstalacion = [];
  List<TipoInstalacion> _tiposequipo = [];

  String _pedido = '';
  String _pedidoError = '';
  bool _pedidoShowError = false;
  TextEditingController _pedidoController = TextEditingController();

  String _entrecalles = '';
  String _entrecallesError = '';
  bool _entrecallesShowError = false;
  TextEditingController _entrecallesController = TextEditingController();

  bool _esAveria = false;

  String _serieError = '';
  bool _serieShowError = false;
  TextEditingController _serieController = TextEditingController();

  Position _positionUser = const Position(
      longitude: 0,
      latitude: 0,
      timestamp: null,
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
      speedAccuracy: 0);

  String direccion = '';

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _signature = null;
    _loadData();
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 225, 225),
      appBar: AppBar(
        title: (widget.editMode)
            ? const Text('Editar Instalación')
            : const Text('Nueva Instalación'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF781f1e),
        child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.yellow,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 10,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelPadding: const EdgeInsets.all(10),
            tabs: <Widget>[
              Tab(
                child: Column(
                  children: const [
                    Icon(Icons.cable),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Instalación",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: const [
                    Icon(Icons.category),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Materiales",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ]),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        dragStartBehavior: DragStartBehavior.start,
        children: <Widget>[
//-------------------------------------------------------------------------
//-------------------------- 1° TABBAR ------------------------------------
//-------------------------------------------------------------------------

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Titulo(
                      texto: "DATOS CLIENTE",
                      color: Color.fromARGB(255, 10, 226, 250),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                _showDocument(),
                _showFirstName(),
                _showLastName(),
                _showAddress(),
                _showLatLong(),
                _showEntrecalles(),
                const Divider(
                  color: Colors.black,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Titulo(
                      texto: "DATOS INSTALACION",
                      color: Color.fromARGB(255, 10, 226, 250),
                    ),
                  ],
                ),
                _showTiposInstalacion(),
                _showFechaInstalacion(),
                _showTipoPedido(),
                _showPedido(),
                _showAveria(),
                const Divider(
                  color: Colors.black,
                ),
                !widget.editMode
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Titulo(
                            texto: "EQUIPOS INSTALADOS",
                            color: Color.fromARGB(255, 10, 226, 250),
                          ),
                        ],
                      )
                    : Container(),
                ((!widget.editMode) && (_series.isNotEmpty))
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                            "Cant. de Equipos instalados: ${_series.length}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      )
                    : Container(),
                ((!widget.editMode) && (_series.isEmpty))
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'No hay Equipos registrados',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : SizedBox(
                        height: _series.length * 54, child: _showSeries()),
                !widget.editMode ? _showSerie() : Container(),
                !widget.editMode
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Divider(
                            color: Colors.black,
                          ),
                          Titulo(
                            texto: "MATERIALES DESCARGADOS",
                            color: Color.fromARGB(255, 10, 226, 250),
                          ),
                        ],
                      )
                    : Container(),
                !widget.editMode
                    ? (_materiales.isNotEmpty)
                        ? SizedBox(
                            height: _materiales.length * 24,
                            child: _showMateriales())
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              'No hay Materiales descargados',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                    : Container(),
                !widget.editMode
                    ? const Divider(
                        color: Colors.black,
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Titulo(
                      texto: "CONFORMIDAD CLIENTE",
                      color: Color.fromARGB(255, 10, 226, 250),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text("Firma Cliente",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                _showButtonsFirma(ancho),
                _showCoinncideFirmante(),
                _showSignDocument(),
                _showSignName(),
                const Divider(
                  color: Colors.black,
                ),
                _showButton(),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: _showLoader
                      ? LoaderComponent(text: _textComponent)
                      : Container(),
                ),
              ],
            ),
          ),

//-------------------------------------------------------------------------
//-------------------------- 2° TABBAR ------------------------------------
//-------------------------------------------------------------------------

          Center(
            child: Stack(
              children: [
                !widget.editMode
                    ? _getContent()
                    : const Center(
                        child: Text("No habilitado en modo edición"),
                      ),
                _showLoader
                    ? const LoaderComponent(
                        text: 'Grabando...',
                      )
                    : Container(),
              ],
            ),
          ),

//-------------------------------------------------------------------------
//-------------------------- FINAL del TABBAR -----------------------------
//-------------------------------------------------------------------------
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _getContent -------------------------------
//-----------------------------------------------------------------

  Widget _getContent() {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text(
              "Material         ",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "   ",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "Cantidad                 ",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        Expanded(
          child: _getListView(),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  //-----------------------------------------------------------------
//--------------------- _getListView ------------------------------
//-----------------------------------------------------------------

  Widget _getListView() {
    return ListView(
      children: _productos.map((e) {
        return Card(
          color: const Color(0xFFC7C7C8),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                        '${e.codigoSAP} - ${e.denominacion}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(e.cantidad.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        _cantidadController.text =
                                            e.cantidad == 0.0
                                                ? ''
                                                : e.cantidad.toString();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Colors.grey[300],
                                                title: const Text(
                                                    "Ingrese la cantidad"),
                                                content: TextField(
                                                  autofocus: true,
                                                  controller:
                                                      _cantidadController,
                                                  decoration: InputDecoration(
                                                      fillColor: Colors.white,
                                                      filled: true,
                                                      hintText: '',
                                                      labelText: '',
                                                      errorText:
                                                          _cantidadShowError
                                                              ? _cantidadError
                                                              : null,
                                                      prefixIcon:
                                                          const Icon(Icons.tag),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  onChanged: (value) {
                                                    _cantidad = value;
                                                  },
                                                ),
                                                actions: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: const [
                                                              Icon(
                                                                  Icons.cancel),
                                                              Text('Cancelar'),
                                                            ],
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFFB4161B),
                                                            minimumSize:
                                                                const Size(
                                                                    double
                                                                        .infinity,
                                                                    50),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: const [
                                                              Icon(Icons.save),
                                                              Text('Aceptar'),
                                                            ],
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xFF120E43),
                                                            minimumSize:
                                                                const Size(
                                                                    double
                                                                        .infinity,
                                                                    50),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            for (Producto producto
                                                                in _productos) {
                                                              if (producto
                                                                      .codigoSAP ==
                                                                  e.codProducto) {
                                                                producto.cantidad =
                                                                    double.parse(
                                                                        _cantidad);
                                                              }
                                                            }

                                                            _materiales = [];
                                                            for (var producto
                                                                in _productos) {
                                                              if (producto
                                                                      .cantidad! >
                                                                  0) {
                                                                _materiales.add(
                                                                    producto);
                                                              }
                                                            }
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              );
                                            },
                                            barrierDismissible: false);
                                      },
                                      icon: const Icon(Icons.loop,
                                          color: Colors.blue)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showSeries ---------------------
//--------------------------------------------------------------

  Widget _showSeries() {
    return ListView(
      children: _series.map((e) {
        return Card(
          color: const Color.fromARGB(255, 142, 210, 237),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          child: Container(
            height: 50,
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      e.nroseriesalida,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    "${e.denominacion}-${e.familia}".length > 22
                        ? Text(
                            "${e.denominacion}-${e.familia}".substring(0, 22),
                          )
                        : Text(
                            "${e.denominacion}-${e.familia}",
                          ),
                    const Spacer(),
                    e.foto == null
                        ? IconButton(
                            onPressed: () async {
                              e.foto = await _takePicture();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Color(0xFF781f1e),
                            ),
                          )
                        : IconButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          InstalacionVerFotoScreen(
                                              foto: e.foto!)));
                            },
                            icon: const Icon(
                              Icons.photo_camera,
                              color: Color.fromARGB(255, 58, 204, 39),
                            ),
                          ),
                    IconButton(
                      onPressed: () {
                        _series.remove(e);
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

//--------------------------------------------------------------
//------------------------- _showMateriales --------------------
//--------------------------------------------------------------

  Widget _showMateriales() {
    return ListView(
      children: _materiales.map((e) {
        return Card(
          color: const Color.fromARGB(255, 142, 210, 237),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          child: Container(
            height: 22,
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      e.codigoSAP,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    e.denominacion.length > 22
                        ? Text(
                            e.denominacion.substring(0, 22),
                          )
                        : Text(
                            e.denominacion,
                          ),
                    const Spacer(),
                    Text(
                      e.cantidad.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showDocument ---------------------
//--------------------------------------------------------------

  Widget _showDocument() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _documentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  fillColor:
                      _document == "" ? Colors.yellow[200] : Colors.white,
                  filled: true,
                  enabled: true,
                  isDense: true,
                  hintText: 'Ingresa documento...',
                  labelText: 'Documento',
                  errorText: _documentShowError ? _documentError : null,
                  suffixIcon: const Icon(Icons.assignment_ind),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _document = value;
              },
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(50, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                String barcodeScanRes;
                try {
                  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                      '#3D8BEF', 'Cancelar', false, ScanMode.DEFAULT);
                } on PlatformException {
                  barcodeScanRes = 'Error';
                }
                if (barcodeScanRes == '-1') {
                  return;
                }

                int cantArrobas = 0;
                int arroba1 = 0;
                int arroba2 = 0;
                int arroba3 = 0;
                int arroba4 = 0;
                int arroba5 = 0;

                for (int c = 0; c <= barcodeScanRes.length - 1; c++) {
                  if (barcodeScanRes[c] == "@") {
                    cantArrobas++;

                    if (arroba4 != 0 && arroba5 == 0) {
                      arroba5 = c;
                    }
                    if (arroba3 != 0 && arroba4 == 0) {
                      arroba4 = c;
                    }
                    if (arroba2 != 0 && arroba3 == 0) {
                      arroba3 = c;
                    }

                    if (arroba1 != 0 && arroba2 == 0) {
                      arroba2 = c;
                    }
                    if (arroba1 == 0) {
                      arroba1 = c;
                    }
                  }
                }

                if (cantArrobas < 6) {
                  _documentController.text = "";
                  _firstnameController.text = "";
                } else {
                  _documentController.text =
                      barcodeScanRes.substring(arroba4 + 1, arroba5);

                  _document = barcodeScanRes.substring(arroba4 + 1, arroba5);

                  _firstnameController.text =
                      barcodeScanRes.substring(arroba1 + 1, arroba2);

                  _firstname = barcodeScanRes.substring(arroba1 + 1, arroba2);

                  _lastnameController.text =
                      barcodeScanRes.substring(arroba2 + 1, arroba3);

                  _lastname = barcodeScanRes.substring(arroba2 + 1, arroba3);

                  _signnameController.text =
                      '${barcodeScanRes.substring(arroba1 + 1, arroba2)} ${barcodeScanRes.substring(arroba2 + 1, arroba3)}';

                  _signname =
                      '${barcodeScanRes.substring(arroba1 + 1, arroba2)} ${barcodeScanRes.substring(arroba2 + 1, arroba3)}';
                }
              },
              child: const Icon(Icons.qr_code_2)),
        ],
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showFirstName --------------------
//--------------------------------------------------------------

  Widget _showFirstName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _firstnameController,
        decoration: InputDecoration(
            fillColor: _firstname == "" ? Colors.yellow[200] : Colors.white,
            filled: true,
            isDense: true,
            hintText: 'Ingrese nombre...',
            labelText: 'Nombre',
            errorText: _firstnameShowError ? _firstnameError : null,
            suffixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _firstname = value;
        },
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showLastName ---------------------
//--------------------------------------------------------------

  Widget _showLastName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _lastnameController,
        decoration: InputDecoration(
            fillColor: _firstname == "" ? Colors.yellow[200] : Colors.white,
            filled: true,
            isDense: true,
            hintText: 'Ingrese apellido...',
            labelText: 'Apellido',
            errorText: _lastnameShowError ? _lastnameError : null,
            suffixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _lastname = value;
        },
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showAddress ----------------------
//--------------------------------------------------------------

  Widget _showAddress() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _addressController,
              decoration: InputDecoration(
                  fillColor: _address == "" ? Colors.yellow[200] : Colors.white,
                  filled: true,
                  isDense: true,
                  enabled: true,
                  hintText: 'Ingresa domicilio...',
                  labelText: 'Domicilio',
                  errorText: _addressShowError ? _addressError : null,
                  suffixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _address = value;
              },
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(50, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                await _getPosition();
              },
              child: const Icon(Icons.travel_explore)),
        ],
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showLatLong ----------------------
//--------------------------------------------------------------

  Widget _showLatLong() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: _latitud != ''
          ? Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Lat-Long: $_latitud / $_longitud",
              ),
            )
          : Container(),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showFechaInstalacion ---------------------
//-----------------------------------------------------------------

  Widget _showFechaInstalacion() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      color: const Color(0xFF781f1e),
                      width: 140,
                      height: 30,
                      child: const Text(
                        '  Fecha Instalación:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.center,
                        color: const Color(0xFF781f1e).withOpacity(0.2),
                        width: 140,
                        height: 30,
                        child: Text(
                          fechaInstalacion != null
                              ? "    ${fechaInstalacion!.day}/${fechaInstalacion!.month}/${fechaInstalacion!.year}"
                              : "",
                          style: const TextStyle(color: Color(0xFF781f1e)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781f1e),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _fechaInstalacion(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _fechaInstalacion -------------------------
//-----------------------------------------------------------------

  _fechaInstalacion() async {
    FocusScope.of(context).unfocus();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -5)),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != fechaInstalacion) {
      setState(() {
        fechaInstalacion = selected;
      });
    }
  }

//--------------------------------------------------------------
//-------------------------- _showTipoPedido -------------------
//--------------------------------------------------------------

  Widget _showTipoPedido() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: RadioListTile(
              selected: _tipoPedido == 1,
              activeColor: const Color(0xFF781f1e),
              title: const Text('OMS'),
              value: 0,
              groupValue: _tipoPedido,
              onChanged: (value) {
                setState(() {
                  _tipoPedido = value!;
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile(
              selected: _tipoPedido == 0,
              activeColor: const Color(0xFF781f1e),
              title: const Text('SOM'),
              value: 1,
              groupValue: _tipoPedido,
              onChanged: (value) {
                setState(() {
                  _tipoPedido = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showPedido -----------------------
//--------------------------------------------------------------

  Widget _showPedido() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _pedidoController,
        decoration: InputDecoration(
            fillColor: _pedido == "" ? Colors.yellow[200] : Colors.white,
            filled: true,
            isDense: true,
            hintText: 'Ingrese pedido...',
            labelText: 'Pedido',
            errorText: _pedidoShowError ? _pedidoError : null,
            suffixIcon: const Icon(Icons.grade),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _pedido = value;
        },
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showEntrecalles ------------------
//--------------------------------------------------------------

  Widget _showEntrecalles() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _entrecallesController,
        decoration: InputDecoration(
            fillColor: _entrecalles == "" ? Colors.yellow[200] : Colors.white,
            filled: true,
            isDense: true,
            hintText: 'Ingrese entre calles...',
            labelText: 'Entre calles',
            errorText: _entrecallesShowError ? _entrecallesError : null,
            suffixIcon: const Icon(Icons.signpost),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _entrecalles = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showAveria -------------------------------
//-----------------------------------------------------------------

  Widget _showAveria() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 10),
      child: Row(
        children: [
          const Text("Es avería: ",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              )),
          Checkbox(
            value: _esAveria,
            onChanged: (value) {
              _esAveria = !_esAveria;
              value = _esAveria;
              setState(() {});
            },
            checkColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            activeColor: const Color(0xFF781f1e),
          ),
        ],
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showSerie ------------------------
//--------------------------------------------------------------

  Widget _showSerie() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(40, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      _serieController.text = '';
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AlertDialog(
                              backgroundColor: Colors.grey[300],
                              title: const Text("Ingrese o escanee el código"),
                              content: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          autofocus: true,
                                          controller: _serieController,
                                          decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              hintText: '',
                                              labelText: '',
                                              errorText: _serieShowError
                                                  ? _serieError
                                                  : null,
                                              prefixIcon: const Icon(Icons.tag),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onChanged: (value) {
                                            _serie = value;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF282886),
                                            minimumSize: const Size(50, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () async {
                                            String barcodeScanRes;
                                            try {
                                              barcodeScanRes =
                                                  await FlutterBarcodeScanner
                                                      .scanBarcode(
                                                          '#3D8BEF',
                                                          'Cancelar',
                                                          false,
                                                          ScanMode.DEFAULT);
                                            } on PlatformException {
                                              barcodeScanRes = 'Error';
                                            }
                                            if (barcodeScanRes == '-1') {
                                              return;
                                            }
                                            _serieController.text =
                                                barcodeScanRes;
                                          },
                                          child: const Icon(Icons.qr_code_2)),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _showTiposEquipo(),
                                ],
                              ),
                              actions: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF120E43),
                                            minimumSize:
                                                const Size(double.infinity, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_serieController.text.length <
                                                6) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      title:
                                                          const Text('Aviso'),
                                                      content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const <
                                                              Widget>[
                                                            Text(
                                                                'El código debe tener al menos 6 caracteres.'),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ]),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(),
                                                            child: const Text(
                                                                'Ok')),
                                                      ],
                                                    );
                                                  });
                                              FocusScope.of(context)
                                                  .unfocus(); //Oculta el teclado
                                              return;
                                            }

                                            if (_serieController.text
                                                .contains("http")) {
                                              displayAlerta(context, "Aviso",
                                                  "No puede registrar direcciones Web.");

                                              FocusScope.of(context)
                                                  .unfocus(); //Oculta el teclado
                                              return;
                                            }

                                            _serie = _serieController.text
                                                .toUpperCase();

                                            // VALIDAR QUE EL NUMERO DE SERIE ESTE DISPONIBLE

                                            for (var serie in _series) {
                                              if (serie.nroseriesalida
                                                      .toLowerCase() ==
                                                  _serie.toLowerCase()) {
                                                existeSerie = true;
                                              }
                                            }

                                            if (existeSerie) {
                                              displayAlerta(context, "Aviso",
                                                  "Este N° de Serie ya fue agregado.");

                                              existeSerie = false;
                                              return;
                                            }

                                            isValidSerie =
                                                await _validarSerie(_serie);

                                            if (!isValidSerie) {
                                              if (_tipoequipo ==
                                                  'Elija un tipo de equipo...') {
                                                _tipoequipoShowError = true;
                                                _tipoequipoError =
                                                    'Debe elegir un tipo de equipo';
                                                return;
                                              } else {
                                                _tipoequipoShowError = false;
                                              }
                                            }

                                            if (!isValidSerie) {
                                              await showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      title: const Text(''),
                                                      content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const <
                                                              Widget>[
                                                            Text(
                                                                'N° de Serie no registrado para su Usuario. ¿Quiere agregarlo?'),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ]),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              _serie = "";
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              return;
                                                            },
                                                            child: const Text(
                                                                'NO')),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              return;
                                                            },
                                                            child: const Text(
                                                                'SI')),
                                                      ],
                                                    );
                                                  });
                                            }

                                            if (_serie.isNotEmpty) {
                                              _serieConDatos.foto = null;
                                              _serieConDatos
                                                  .familia = _tipoequipo ==
                                                      'Elija un tipo de equipo...'
                                                  ? null
                                                  : _tipoequipo;
                                              _series.add(_serieConDatos);
                                              _serie = '';
                                              _tipoequipo =
                                                  'Elija un tipo de equipo...';
                                              setState(() {});
                                            }

                                            FocusScope.of(context)
                                                .unfocus(); //Oculta el teclado
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: const [
                                              Icon(Icons.save),
                                              Text('Aceptar'),
                                            ],
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFB4161B),
                                          minimumSize:
                                              const Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: const [
                                            Icon(Icons.cancel),
                                            Text('Cancelar'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    barrierDismissible: false);
              },
              child: const Icon(Icons.qr_code_2)),
        ],
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showButtonsFirma -----------------
//--------------------------------------------------------------

  Widget _showButtonsFirma(ancho) {
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _takeSignature(),
                child: !widget.editMode
                    ? Container(
                        child: !_signatureChanged
                            ? Image(
                                image: const AssetImage('assets/firma.png'),
                                width: ancho * 0.7,
                                fit: BoxFit.contain)
                            : Image.memory(
                                _signature!.buffer.asUint8List(),
                                width: ancho * 0.7,
                              ),
                      )
                    : SizedBox(
                        width: ancho * 0.7,
                        child: !_signatureChanged
                            ? FadeInImage(
                                fit: BoxFit.contain,
                                placeholder:
                                    const AssetImage('assets/loading.gif'),
                                image: NetworkImage(widget
                                    .instalacion.firmaclienteImageFullPath),
                              )
                            : Image.memory(
                                _signature!.buffer.asUint8List(),
                                width: ancho * 0.7,
                              ),
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              // InkWell(
              //   onTap: () => _takeSignature(),
              //   child: ClipRRect(
              //     borderRadius: BorderRadius.circular(30),
              //     child: Container(
              //       color: const Color(0xFF781f1e),
              //       width: 40,
              //       height: 40,
              //       child: const Icon(
              //         Icons.drive_file_rename_outline,
              //         size: 40,
              //         color: Color(0xFFf6faf8),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _takeSignature --------------------
//--------------------------------------------------------------

  void _takeSignature() async {
    Response? response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FirmaScreen(),
      ),
    );
    if (response != null) {
      setState(() {
        _signatureChanged = true;
        _signature = response.result;
      });
    }
  }

//--------------------------------------------------------------
//-------------------------- _showCoinncideFirmante -----------
//--------------------------------------------------------------
  _showCoinncideFirmante() {
    return CheckboxListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Coincide con el Cliente'),
        ],
      ),
      value: _coincideFirmante,
      activeColor: Colors.blue,
      onChanged: (value) {
        if (value == true) {
          _signdocument = _document;
          _signdocumentController.text = _documentController.text;
          _signname =
              _firstnameController.text != "" ? "$_firstname $_lastname" : "";
          _signnameController.text = _firstnameController.text != ""
              ? "${_firstnameController.text} ${_lastnameController.text}"
              : "";
        } else {
          _signdocument = "";
          _signdocumentController.text = "";
          _signname = "";
          _signnameController.text = "";
        }

        setState(() {
          _coincideFirmante = value!;
        });
      },
    );
  }

//--------------------------------------------------------------
//-------------------------- _showSignDocument -----------------
//--------------------------------------------------------------

  Widget _showSignDocument() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _signdocumentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  fillColor:
                      _signdocument == "" ? Colors.yellow[200] : Colors.white,
                  filled: true,
                  enabled: true,
                  isDense: true,
                  hintText: 'Ingresa documento firmante...',
                  labelText: 'Documento firmante',
                  errorText: _signdocumentShowError ? _signdocumentError : null,
                  suffixIcon: const Icon(Icons.assignment_ind),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
              onChanged: (value) {
                _signdocument = value;
              },
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(50, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                String barcodeScanRes;
                try {
                  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                      '#3D8BEF', 'Cancelar', false, ScanMode.DEFAULT);
                } on PlatformException {
                  barcodeScanRes = 'Error';
                }
                if (barcodeScanRes == '-1') {
                  return;
                }

                int cantArrobas = 0;
                int arroba1 = 0;
                int arroba2 = 0;
                int arroba3 = 0;
                int arroba4 = 0;
                int arroba5 = 0;

                for (int c = 0; c <= barcodeScanRes.length - 1; c++) {
                  if (barcodeScanRes[c] == "@") {
                    cantArrobas++;

                    if (arroba4 != 0 && arroba5 == 0) {
                      arroba5 = c;
                    }
                    if (arroba3 != 0 && arroba4 == 0) {
                      arroba4 = c;
                    }
                    if (arroba2 != 0 && arroba3 == 0) {
                      arroba3 = c;
                    }

                    if (arroba1 != 0 && arroba2 == 0) {
                      arroba2 = c;
                    }
                    if (arroba1 == 0) {
                      arroba1 = c;
                    }
                  }
                }

                if (cantArrobas < 6) {
                  _signdocumentController.text = "";
                  _signnameController.text = "";
                } else {
                  _signdocumentController.text =
                      barcodeScanRes.substring(arroba4 + 1, arroba5);

                  _signdocument =
                      barcodeScanRes.substring(arroba4 + 1, arroba5);

                  _signnameController.text =
                      '${barcodeScanRes.substring(arroba1 + 1, arroba2)} ${barcodeScanRes.substring(arroba2 + 1, arroba3)}';

                  _signname =
                      '${barcodeScanRes.substring(arroba1 + 1, arroba2)} ${barcodeScanRes.substring(arroba2 + 1, arroba3)}';
                }
              },
              child: const Icon(Icons.qr_code_2)),
        ],
      ),
    );
  }

//--------------------------------------------------------------
//-------------------------- _showSignName ---------------------
//--------------------------------------------------------------

  Widget _showSignName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextField(
        controller: _signnameController,
        decoration: InputDecoration(
            fillColor: _signname == "" ? Colors.yellow[200] : Colors.white,
            filled: true,
            isDense: true,
            hintText: 'Ingrese Nombre y Apellido del Firmante...',
            labelText: 'Nombre y Apellido del Firmante',
            errorText: _signnameShowError ? _signnameError : null,
            suffixIcon: const Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _signname = value;
        },
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _showButton -------------------------------
//-----------------------------------------------------------------

  Widget _showButton() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _save,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.save),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Guardar Instalación'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _save -------------------------------------
//-----------------------------------------------------------------

  _save() {
    if (!validateFields()) {
      setState(() {});
      return;
    }
    _addRecord();
  }

//-----------------------------------------------------------------
//--------------------- validateFields ----------------------------
//-----------------------------------------------------------------

  bool validateFields() {
    bool isValid = true;

    if (_document == "") {
      isValid = false;
      _documentShowError = true;
      _documentError = 'Ingrese un Documento';
    } else {
      _documentShowError = false;
    }

    if (_firstname == "") {
      isValid = false;
      _firstnameShowError = true;
      _firstnameError = 'Ingrese un Nombre';
    } else {
      _firstnameShowError = false;
    }

    if (_lastname == "") {
      isValid = false;
      _lastnameShowError = true;
      _lastnameError = 'Ingrese un Apellido';
    } else {
      _lastnameShowError = false;
    }

    if (_address == "") {
      isValid = false;
      _addressShowError = true;
      _addressError = 'Ingrese un Domicilio';
    } else {
      _addressShowError = false;
    }

    if (_latitud == '' || _longitud == '') {
      isValid = false;
      _addressShowError = true;
      _addressError = 'Ingrese un Domicilio georeferenciado';
    } else {
      _addressShowError = false;
    }

    if (fechaInstalacion == null) {
      isValid = false;
      displayAlerta(
          context, "Aviso", "Debe ingresar una Fecha de Instalación.");
    }

    if (_tipoinstalacion == 'Elija un tipo de instalación...') {
      isValid = false;
      _tipoinstalacionShowError = true;
      _tipoinstalacionError = 'Debe elegir un tipo de instalación';
    } else {
      _tipoinstalacionShowError = false;
    }

    if (_pedido == "") {
      isValid = false;
      _pedidoShowError = true;
      _pedidoError = 'Ingrese Pedido';
    } else {
      if (_pedido.length > 11 || _pedido.length < 8) {
        isValid = false;
        _pedidoShowError = true;
        _pedidoError = 'Pedido debe contener entre 8 y 11 caracteres';
      } else {
        _pedidoShowError = false;
      }
    }

    if ((_series.isEmpty) && (!widget.editMode)) {
      isValid = false;
      displayAlerta(context, "Aviso", "No hay Equipos Registrados.");
    }

    if ((_materiales.isEmpty) && (!widget.editMode)) {
      isValid = false;
      displayAlerta(context, "Aviso", "No hay Materiales descargados.");
    }

    if (_signature == null && !widget.editMode) {
      isValid = false;
      displayAlerta(context, "Aviso", "Debe haber firma del cliente.");
    }

    if (_signdocument == "") {
      isValid = false;
      _signdocumentShowError = true;
      _signdocumentError = 'Ingrese un Documento del Firmante';
    } else {
      _signdocumentShowError = false;
    }

    if (_signname == "") {
      isValid = false;
      _signnameShowError = true;
      _signnameError = 'Ingrese un Nombre del Firmante';
    } else {
      _signnameShowError = false;
    }

    setState(() {});

    return isValid;
  }

//-----------------------------------------------------------------
//--------------------- _addRecord --------------------------------
//-----------------------------------------------------------------

  void _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    String base64ImageFirmaCliente = '';
    if (_signatureChanged) {
      List<int> imageBytesFirmaCliente = _signature!.buffer.asUint8List();
      base64ImageFirmaCliente = base64Encode(imageBytesFirmaCliente);
    }

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

    Map<String, dynamic> request = {
      'IDRegistro': widget.editMode ? widget.instalacion.idRegistro : 0,
      'NroObra': 2,
      'IdUsuario': widget.user.idUsuario,
      'Imei': widget.imei,
      'Fecha': DateTime.now().toString(),
      'Latitud': _latitud,
      'Longitud': _longitud,
      'FechaInstalacion': fechaInstalacion.toString(),
      'Grupo': widget.user.grupo,
      'Causante': widget.user.codigoCausante,
      'Pedido': _pedido,
      'NombreCliente': _firstname,
      'ApellidoCliente': _lastname,
      'Documento': _document,
      'DomicilioInstalacion': _address,
      'EntreCalles': _entrecalles,
      'ImageArrayFIRMACLIENTE': base64ImageFirmaCliente,
      'NombreApellidoFirmante': _signname,
      'TipoInstalacion': _tipoinstalacion,
      'EsAveria': _esAveria ? 'SI' : 'NO',
      'Auditado': 0,
      'DocumentoFirmante': _signdocument,
      'MismoFirmante': _coincideFirmante ? 1 : 0,
      'TipoPedido': _tipoPedido == 0 ? 'OMS' : 'SOM',
    };

    if (!widget.editMode) {
      //------- Graba AppInstalacionesEquipos CABECERA -----------------
      Response response = await ApiHelper.post(
          '/api/AppInstalacionesEquipo/PostAppInstalacionesEquipo', request);
      if (!response.isSuccess) {
        await showAlertDialog(
            context: context,
            title: 'Error',
            message: response.message,
            actions: <AlertDialogAction>[
              const AlertDialogAction(key: null, label: 'Aceptar'),
            ]);
        return;
      } else {
        //------- Graba AppInstalacionesEquiposDetalles DETALLE -----------------

        var decodedJson = jsonDecode(response.result);

        for (var serie in _series) {
          Map<String, dynamic> requestDetalle = {
            'IDINSTALACIONEQUIPO': decodedJson["idRegistro"],
            'NROSERIEINSTALADA': serie.nroseriesalida,
            'IDLOTECAB': serie.nrolotecab,
            'CODSIAG': serie.codigosiag,
            'CODSAP': serie.codigosap,
            'NombreEquipo': serie.denominacion,
            'NROREGISTROLOTESCAB': serie.nroregistro,
            'LinkFoto': serie.foto ?? "",
            'Familia': serie.familia,
          };
          await ApiHelper.post(
              '/api/AppInstalacionesEquipo/PostAppInstalacionesEquiposDetalle',
              requestDetalle);
        }

        //------- Pone Lote DetalleUsado -----------------

        for (var serie in _series) {
          Map<String, dynamic> requestLoteDetalle = {
            'MARCAR': 1,
            'NROREGISTRO': serie.nroregistro,
            'IDInstalacionesEquipos': decodedJson["idRegistro"].toString(),
          };
          await ApiHelper.put('/api/LotesDetalles/',
              serie.nroregistro.toString(), requestLoteDetalle);
        }

        //------- Graba AppInstalacionesMateriales -----------------

        for (var material in _materiales) {
          Map<String, dynamic> requestMaterial = {
            'IdInstalacionEquipo': decodedJson["idRegistro"],
            'CodigoSIAG': material.codProducto,
            'CodigoSAP': material.codigoSAP,
            'Descripcion': material.denominacion,
            'Cantidad': material.cantidad,
          };
          await ApiHelper.post(
              '/api/AppInstalacionesEquipo/PostAppInstalacionesMateriales',
              requestMaterial);
        }
      }
    } else {
      Response response = await ApiHelper.put('/api/AppInstalacionesEquipo/',
          widget.instalacion.idRegistro.toString(), request);
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
    }
    setState(() {
      _showLoader = false;
    });
    Navigator.pop(context, 'yes');
  }

//-----------------------------------------------------------------
//--------------------- _loadData ---------------------------------
//-----------------------------------------------------------------

  void _loadData() async {
    await _getTiposInstalacion();
    await _getProductos();
    await _getTiposEquipo();
  }

//-----------------------------------------------------------------
//--------------------- _showTiposInstalacion ---------------------
//-----------------------------------------------------------------

  Widget _showTiposInstalacion() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: _tiposinstalacion.isEmpty
          ? const Text('Cargando tipos de intalación...')
          : DropdownButtonFormField(
              value: _tipoinstalacion,
              decoration: InputDecoration(
                fillColor: _tipoinstalacion == 'Elija un tipo de instalación...'
                    ? Colors.yellow[200]
                    : Colors.white,
                filled: true,
                isDense: true,
                hintText: 'Elija un tipo de instalación...',
                labelText: 'Tipo de instalación',
                errorText:
                    _tipoinstalacionShowError ? _tipoinstalacionError : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: _getComboInstalaciones(),
              onChanged: (value) {
                _tipoinstalacion = value.toString();
              },
            ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _getTiposInstalacion ----------------------
//-----------------------------------------------------------------

  Future<void> _getTiposInstalacion() async {
    _tiposinstalacion = [
      TipoInstalacion(tipoinstalacion: 'Elija un tipo de instalación...'),
      TipoInstalacion(tipoinstalacion: 'FTTH'),
      TipoInstalacion(tipoinstalacion: 'IPTV'),
      TipoInstalacion(tipoinstalacion: 'Otro'),
    ];
  }

//-----------------------------------------------------------------
//--------------------- _getComboInstalaciones --------------------
//-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboInstalaciones() {
    List<DropdownMenuItem<String>> list = [];

    list.add(const DropdownMenuItem(
      value: 'Elija un tipo de instalación...',
      child: Text('Elija un tipo de instalación...'),
    ));

    list.add(const DropdownMenuItem(
      value: 'FTTH',
      child: Text('FTTH'),
    ));

    list.add(const DropdownMenuItem(
      value: 'IPTV',
      child: Text('IPTV'),
    ));

    list.add(const DropdownMenuItem(
      value: 'Otro',
      child: Text('Otro'),
    ));

    return list;
  }

//-----------------------------------------------------------------
//--------------------- _showTiposEquipo --------------------------
//-----------------------------------------------------------------

  Widget _showTiposEquipo() {
    return Container(
      padding: const EdgeInsets.all(0),
      child: _tipoequipo.isEmpty
          ? const Text('Cargando tipos de equipo...')
          : DropdownButtonFormField(
              value: _tipoequipo,
              decoration: InputDecoration(
                fillColor: false ? Colors.yellow[200] : Colors.white,
                filled: true,
                hintText: 'Elija un tipo de equipo...',
                labelText: 'Tipo de equipo',
                errorText: _tipoequipoShowError ? _tipoequipoError : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: _getComboEquipos(),
              onChanged: (value) {
                _tipoequipo = value.toString();
              },
            ),
    );
  }

//-----------------------------------------------------------------
//--------------------- _getTiposEquipo ---------------------------
//-----------------------------------------------------------------

  Future<void> _getTiposEquipo() async {
    _tiposequipo = [
      TipoInstalacion(tipoinstalacion: 'Elija un tipo de equipo...'),
      TipoInstalacion(tipoinstalacion: 'HGU'),
      TipoInstalacion(tipoinstalacion: 'HGU PLUS'),
      TipoInstalacion(tipoinstalacion: 'IPTV WIFI'),
      TipoInstalacion(tipoinstalacion: 'IPTV ETHERNET'),
      TipoInstalacion(tipoinstalacion: 'REPETIDOR'),
      TipoInstalacion(tipoinstalacion: 'NO LO SE'),
    ];

    if (widget.editMode) {
      await _loadFields();
    } else {
      setState(() {});
    }
  }

//-----------------------------------------------------------------
//--------------------- _getComboEquipos --------------------------
//-----------------------------------------------------------------

  List<DropdownMenuItem<String>> _getComboEquipos() {
    List<DropdownMenuItem<String>> list = [];

    list.add(const DropdownMenuItem(
      value: 'Elija un tipo de equipo...',
      child: Text('Elija un tipo de equipo...'),
    ));

    list.add(const DropdownMenuItem(
      value: 'HGU',
      child: Text('HGU'),
    ));

    list.add(const DropdownMenuItem(
      value: 'HGU PLUS',
      child: Text('HGU PLUS'),
    ));

    list.add(const DropdownMenuItem(
      value: 'IPTV WIFI',
      child: Text('IPTV WIFI'),
    ));
    list.add(const DropdownMenuItem(
      value: 'IPTV ETHERNET',
      child: Text('IPTV ETHERNET'),
    ));
    list.add(const DropdownMenuItem(
      value: 'REPETIDOR',
      child: Text('REPETIDOR'),
    ));
    list.add(const DropdownMenuItem(
      value: 'NO LO SE',
      child: Text('NO LO SE'),
    ));
    return list;
  }

//-----------------------------------------------------------------
//--------------------- _getPosition ------------------------------
//-----------------------------------------------------------------

  Future _getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        displayAlerta(
            context, "Aviso", "El permiso de localización está negado.");

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      displayAlerta(context, "Aviso",
          "El permiso de localización está negado permanentemente. No se puede requerir este permiso.");

      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _positionUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _latitud = _positionUser.latitude.toString();
      _longitud = _positionUser.longitude.toString();

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _positionUser.latitude, _positionUser.longitude);
      _address = "${placemarks[0].street} - ${placemarks[0].locality}";

      _addressController.text = _address;
    }
    setState(() {});
  }

//-------------------------------------------------------------
//-------------------- _loadFields ----------------------------
//-------------------------------------------------------------

  _loadFields() async {
    _document = widget.instalacion.documento;
    _documentController.text = widget.instalacion.documento;

    _firstname = widget.instalacion.nombreCliente;
    _firstnameController.text = widget.instalacion.nombreCliente;

    _lastname = widget.instalacion.apellidoCliente;
    _lastnameController.text = widget.instalacion.apellidoCliente;

    _address = widget.instalacion.domicilioInstalacion;
    _addressController.text = widget.instalacion.domicilioInstalacion;

    _latitud = widget.instalacion.latitud;
    _longitud = widget.instalacion.longitud;

    _entrecalles = widget.instalacion.entreCalles;
    _entrecallesController.text = widget.instalacion.entreCalles;

    _tipoinstalacion = widget.instalacion.tipoInstalacion;

    fechaInstalacion = DateTime.parse(widget.instalacion.fechaInstalacion);

    _pedido = widget.instalacion.pedido;
    _pedidoController.text = widget.instalacion.pedido;

    _esAveria = widget.instalacion.esAveria == "SI" ? true : false;

    _signname = widget.instalacion.nombreApellidoFirmante;
    _signnameController.text = widget.instalacion.nombreApellidoFirmante;

    _signdocument = widget.instalacion.documentoFirmante;
    _signdocumentController.text = widget.instalacion.documentoFirmante;

    _tipoPedido = widget.instalacion.tipoPedido == 'OMS' ? 0 : 1;
    _coincideFirmante = widget.instalacion.mismoFirmante == 0 ? false : true;

    setState(() {});
  }

//---------------------------------------------------------------------------
//-------------------------- _validarSerie ----------------------------------
//---------------------------------------------------------------------------

  Future<bool> _validarSerie(String serie) async {
    _serieConDatos = _serieConDatosVacia;
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
      return false;
    }

    Response response = Response(isSuccess: false);

    response = await ApiHelper.getEquipo(
        widget.user.grupo!, widget.user.codigoCausante, serie);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      _showLoader = false;
      return false;
    }

    _serieSinUsar = response.result;
    if (_serieSinUsar.isEmpty) {
      _serieConDatos = SerieSinUsar(
          nroregistro: 0,
          nrolotecab: 0,
          grupoh: '',
          causanteh: '',
          nroseriesalida: _serie,
          codigosiag: '',
          codigosap: '',
          denominacion: "Eq.No Reg.",
          foto: '',
          familia: '');
      _showLoader = false;
      return false;
    }

    _serieConDatos = _serieSinUsar[0];
    setState(() {
      _showLoader = false;
    });

    return true;
  }

//---------------------------------------------------------------------------
//-------------------------- _validarSerie ----------------------------------
//---------------------------------------------------------------------------
  void displayAlerta(BuildContext context, String titulo, String texto) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(titulo),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(texto),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Ok"),
              ),
            ],
          );
        });
  }

//--------------------------------------------------------------
//-------------------------- _takePicture ----------------------
//--------------------------------------------------------------

  Future<String> _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    Response? response = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SacarFotoScreen(
                  camera: firstCamera,
                )));
    if (response != null) {
      _photoChanged = true;
      _image = response.result;
      List<int> imageBytes = await _image.readAsBytes();
      return base64Encode(imageBytes);
    } else {
      return "";
    }
  }

//---------------------------------------------------------------------
//------------------- _getProductos -----------------------------------
//---------------------------------------------------------------------

  Future<void> _getProductos() async {
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

    response = await ApiHelper.getProductos();

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
      _productos = response.result;
    });
  }
}
