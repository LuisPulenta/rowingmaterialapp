import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
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

class InstalacionNuevaScreen extends StatefulWidget {
  final User user;
  final String imei;

  const InstalacionNuevaScreen(
      {Key? key, required this.user, required this.imei})
      : super(key: key);

  @override
  State<InstalacionNuevaScreen> createState() => _InstalacionNuevaScreenState();
}

class _InstalacionNuevaScreenState extends State<InstalacionNuevaScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------
  bool _showLoader = false;
  final String _textComponent = 'Por favor espere...';
  bool _signatureChanged = false;
  late ByteData? _signature;

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

  String _signname = '';
  String _signnameError = '';
  bool _signnameShowError = false;
  TextEditingController _signnameController = TextEditingController();

  DateTime? fechaInstalacion;

  String _tipoinstalacion = 'Elija un tipo de instalación...';
  String _tipoinstalacionError = '';
  bool _tipoinstalacionShowError = false;

  List<TipoInstalacion> _tiposinstalacion = [];

  String _pedido = '';
  String _pedidoError = '';
  bool _pedidoShowError = false;
  TextEditingController _pedidoController = TextEditingController();

  String _entrecalles = '';
  String _entrecallesError = '';
  bool _entrecallesShowError = false;
  TextEditingController _entrecallesController = TextEditingController();

  bool _esAveria = false;

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
    _loadData();
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Instalación'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "IDUsuario: ${widget.user.idUsuario}",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Imei: ${widget.imei}",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Fecha y Hora de carga: ${DateTime.now().toString()}",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Lat-Long: ${_positionUser.latitude} / ${_positionUser.longitude}",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Grupo: ${widget.user.grupo}",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Causante: ${widget.user.codigoCausante}",
                ),
              ),
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
            _showDocument(),
            _showFirstName(),
            _showLastName(),
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
            _showPedido(),
            _showEntrecalles(),
            _showAveria(),
            const Divider(
              color: Colors.black,
            ),
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
                child: Container(
                  child: !_signatureChanged
                      ? Image(
                          image: const AssetImage('assets/firma.png'),
                          width: ancho * 0.7,
                          fit: BoxFit.contain)
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
//--------------------- _showFechas -------------------------------
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
//--------------------- _fechaInicio ------------------------------
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

      setState(() {});
      return isValid;
    } else {
      _documentShowError = false;
    }

    if (_firstname == "") {
      isValid = false;
      _firstnameShowError = true;
      _firstnameError = 'Ingrese un Nombre';

      setState(() {});
      return isValid;
    } else {
      _firstnameShowError = false;
    }

    if (_lastname == "") {
      isValid = false;
      _lastnameShowError = true;
      _lastnameError = 'Ingrese un Apellido';

      setState(() {});
      return isValid;
    } else {
      _lastnameShowError = false;
    }

    if (fechaInstalacion == null) {
      isValid = false;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso!'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text('Debe ingresar una Fecha de Instalación.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
      setState(() {});
      return isValid;
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

    String ahora = DateTime.now().toString();

    Map<String, dynamic> request = {
      //'nroregistro': _ticket.nroregistro,
      'grupo': widget.user.codigogrupo,
      'causante': widget.user.codigoCausante,
      'fechacarga': ahora,
      'fechaiinstalacion': fechaInstalacion.toString(),
      'idusuario': widget.user.idUsuario,
    };

    Response response =
        await ApiHelper.postNoToken('/api/Controlador/Metodo', request);

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
    Navigator.pop(context, 'yes');
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
//--------------------- _loadData ---------------------------------
//-----------------------------------------------------------------

  void _loadData() async {
    await _getTiposInstalacion();
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
    await _getPosition();
    setState(() {});
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

  //-----------------------------------------------------------------
//--------------------- _getPosition ------------------------------
//-----------------------------------------------------------------

  Future _getPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: const Text('Aviso'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('El permiso de localización está negado.'),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Ok')),
                ],
              );
            });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text('Aviso'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const <Widget>[
                    Text(
                        'El permiso de localización está negado permanentemente. No se puede requerir este permiso.'),
                    SizedBox(
                      height: 10,
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok')),
              ],
            );
          });
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      _positionUser = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
          _positionUser.latitude, _positionUser.longitude);
      direccion =
          "${placemarks[0].street} - ${placemarks[0].locality} - ${placemarks[0].country}";
    }
  }
}
