import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowingmaterialapp/helpers/helpers.dart';
import 'package:rowingmaterialapp/models/models.dart';
import 'package:rowingmaterialapp/screens/screens.dart';
import 'package:rowingmaterialapp/widgets/widgets.dart';

class InstalacionDetalleScreen extends StatefulWidget {
  final User user;
  final String imei;
  final bool editMode;
  final AppInstalacionesEquipo instalacion;

  const InstalacionDetalleScreen(
      {Key? key,
      required this.user,
      required this.imei,
      required this.editMode,
      required this.instalacion})
      : super(key: key);

  @override
  State<InstalacionDetalleScreen> createState() =>
      _InstalacionDetalleScreenState();
}

class _InstalacionDetalleScreenState extends State<InstalacionDetalleScreen> {
//---------------------------------------------------------------
//----------------------- Variables -----------------------------
//---------------------------------------------------------------

  List<AppInstalacionesEquiposDetalle> _instalacionesDetalles = [];
  List<Producto> _materiales = [];
  List<AppInstalacionesMaterial> _materiales2 = [];

//---------------------------------------------------------------
//----------------------- initState -----------------------------
//---------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _getSeries();
  }

//---------------------------------------------------------------
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instalación ${widget.instalacion.idRegistro.toString()}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomRow(
              nombredato: 'Id Inst.: ',
              dato: widget.instalacion.idRegistro.toString(),
            ),
            CustomRow(
              nombredato: 'Fecha: ',
              dato: DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(widget.instalacion.fecha)),
            ),
            CustomRow(
              nombredato: 'N° Obra: ',
              dato: widget.instalacion.nroObra.toString(),
            ),
            CustomRow(
              nombredato: 'Cliente: ',
              dato:
                  '${widget.instalacion.nombreCliente} ${widget.instalacion.apellidoCliente}',
            ),
            CustomRow(
              nombredato: 'Documento: ',
              dato: widget.instalacion.domicilioInstalacion,
            ),
            CustomRow(
              nombredato: 'Entre calles: ',
              dato: widget.instalacion.entreCalles,
            ),
            CustomRow(
              nombredato: 'Tipo Instalación: ',
              dato: widget.instalacion.tipoInstalacion,
            ),
            CustomRow(
              nombredato: 'Fecha Instalación: ',
              dato: DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(widget.instalacion.fechaInstalacion)),
            ),
            CustomRow(
              nombredato: 'Pedido: ',
              dato: widget.instalacion.tipoPedido + widget.instalacion.pedido,
            ),
            CustomRow(
              nombredato: 'Firmante.: ',
              dato: widget.instalacion.nombreApellidoFirmante,
            ),
            CustomRow(
              nombredato: 'Doc. Firmante.: ',
              dato: widget.instalacion.documentoFirmante,
            ),
            CustomRow(nombredato: 'Firma: ', dato: ""),
            const SizedBox(
              height: 20,
            ),
            FadeInImage(
              fit: BoxFit.contain,
              placeholder: const AssetImage('assets/loading.gif'),
              image: NetworkImage(widget.instalacion.firmaclienteImageFullPath),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Titulo(
                  texto: "EQUIPOS INSTALADOS",
                  color: Color.fromARGB(255, 10, 226, 250),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                  "Cant. de Equipos instalados: ${_instalacionesDetalles.length}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text("Lista de N° de Series instalados:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            _instalacionesDetalles.isNotEmpty
                ? SizedBox(
                    height: _instalacionesDetalles.length * 54,
                    child: _showSeries())
                : Container(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Titulo(
                  texto: "MATERIALES DESCARGADOS",
                  color: Color.fromARGB(255, 10, 226, 250),
                ),
              ],
            ),
            _materiales.isNotEmpty
                ? SizedBox(
                    height: _materiales.length * 24, child: _showMateriales())
                : Container(),
            const SizedBox(
              height: 20,
            ),
            _showButton(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
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
              onPressed: _volver,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.arrow_back_ios),
                  SizedBox(
                    width: 20,
                  ),
                  Text('Volver'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//-------------------------------------------------------------
//--------------------- _volver -------------------------------
//-------------------------------------------------------------
  void _volver() {
    Navigator.pop(context, 'yes');
  }

//------------------------------------------------------------------
//------------------------------ _getSeries ------------------------
//------------------------------------------------------------------

  Future<void> _getSeries() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response =
        await ApiHelper.getSeries(widget.instalacion.idRegistro);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "N° de Instalación no válido",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {});
      return;
    }
    _instalacionesDetalles = response.result;

    await _getMateriales();
  }

//------------------------------------------------------------------
//------------------------------ _getMateriales --------------------
//------------------------------------------------------------------

  Future<void> _getMateriales() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {});
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response =
        await ApiHelper.getMateriales(widget.instalacion.idRegistro);

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: "N° de Instalación no válidoABC",
          actions: <AlertDialogAction>[
            const AlertDialogAction(key: null, label: 'Aceptar'),
          ]);

      setState(() {});
      return;
    }
    _materiales2 = response.result;

    _materiales = [];

    for (var material in _materiales2) {
      _materiales.add(Producto(
          codProducto: material.codigoSIAG,
          codigoSAP: material.codigoSAP,
          denominacion: material.descripcion,
          cantidad: material.cantidad));
    }

    setState(() {});
  }

//--------------------------------------------------------------
//-------------------------- _showSeries ---------------------
//--------------------------------------------------------------

  Widget _showSeries() {
    return ListView(
      children: _instalacionesDetalles.map((e) {
        return Card(
          color: const Color.fromARGB(255, 142, 210, 237),
          shadowColor: Colors.white,
          elevation: 10,
          margin: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          child: Container(
            height: 50,
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Text(
                  e.nroserieinstalada.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                "${e.nombreEquipo!}-${e.familia}".length > 25
                    ? Text(
                        "${e.nombreEquipo!}-${e.familia}".substring(0, 25),
                      )
                    : Text(
                        "${e.nombreEquipo!}-${e.familia}",
                      ),
                const Spacer(),
                (e.linkFoto != null && e.linkFoto != '')
                    ? IconButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InstalacionVerFotoScreen(
                                          foto: e.imageFullPath!)));
                        },
                        icon: const Icon(
                          Icons.photo_camera,
                          color: Color.fromARGB(255, 58, 204, 39),
                        ),
                      )
                    : Container(),
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
}
