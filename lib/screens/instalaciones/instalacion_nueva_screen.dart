import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rowingmaterialapp/components/loader_component.dart';
import 'package:rowingmaterialapp/models/models.dart';
import 'package:rowingmaterialapp/screens/screens.dart';

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
  bool _showLoader = false;
  final String _textComponent = 'Por favor espere...';
  bool _signatureChanged = false;
  late ByteData? _signature;

  String _document = '';
  String _documentError = '';
  bool _documentShowError = false;
  final TextEditingController _documentController = TextEditingController();

  String _firstname = '';
  String _firstnameError = '';
  bool _firstnameShowError = false;
  final TextEditingController _firstnameController = TextEditingController();

  String _lastname = '';
  String _lastnameError = '';
  bool _lastnameShowError = false;
  final TextEditingController _lastnameController = TextEditingController();

  DateTime? fechaInstalacion;

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
                  "Lat-Long:: ${widget.positionUser.latitude} - ${widget.positionUser.longitude}",
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

            _showDocument(),
            _showFirstName(),
            _showLastName(),
            _showFechaInstalacion(),

            const SizedBox(
              height: 10,
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
            // _showDomicilio(),
            // _showBarrio(),
            // _showLocalidad(),
            // _showPartido(),
            // _showEntrecalles1(),
            // _showEntrecalles2(),
            // _showTelefono(),
            // _showEmail(),
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
                  fillColor: _document == "" ? Colors.yellow : Colors.white,
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
              child: const Icon(Icons.qr_code_2),
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
                }
              }),
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
            fillColor: _firstname == "" ? Colors.yellow : Colors.white,
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
            fillColor: _firstname == "" ? Colors.yellow : Colors.white,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.calendar_month),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF781f1e),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _fechaInstalacion(),
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
}
