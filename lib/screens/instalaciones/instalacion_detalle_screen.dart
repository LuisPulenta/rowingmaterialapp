import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rowingmaterialapp/models/models.dart';
import 'package:rowingmaterialapp/widgets/widgets.dart';

class InstalacionDetalleScreen extends StatefulWidget {
  final User user;
  final String imei;
  final bool editMode;
  final Instalacion instalacion;

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
//----------------------- Pantalla ------------------------------
//---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Instalación ${widget.instalacion.idRegistro.toString()}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: const Color(0xFFC7C7C8),
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              CustomRow(
                nombredato: 'Id Inst.: ',
                dato: widget.instalacion.idRegistro.toString(),
              ),
              CustomRow(
                nombredato: 'Fecha: ',
                dato: DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(widget.instalacion.fecha!)),
              ),
              CustomRow(
                nombredato: 'N° Obra: ',
                dato: widget.instalacion.nroObra.toString(),
              ),
              CustomRow(
                nombredato: 'Cliente: ',
                dato: widget.instalacion.nombreCliente +
                    ' ' +
                    widget.instalacion.apellidoCliente,
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
                dato: DateFormat('dd/MM/yyyy').format(
                    DateTime.parse(widget.instalacion.fechaInstalacion!)),
              ),
              CustomRow(
                nombredato: 'Pedido: ',
                dato: widget.instalacion.pedido,
              ),
              CustomRow(
                nombredato: 'Firmante.: ',
                dato: widget.instalacion.nombreApellidoFirmante,
              ),
              CustomRow(nombredato: 'Firma: ', dato: ""),
              const SizedBox(
                height: 20,
              ),
              FadeInImage(
                fit: BoxFit.contain,
                placeholder: const AssetImage('assets/loading.gif'),
                image:
                    NetworkImage(widget.instalacion.firmaclienteImageFullPath),
              ),
              const SizedBox(
                height: 20,
              ),
              _showButton(),
            ],
          ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF781f1e),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: _volver,
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
}
