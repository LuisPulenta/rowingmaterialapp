class AppInstalacionesEquipo {
  int idRegistro = 0;
  int nroObra = 0;
  int idUsuario = 0;
  String? imei = '';
  String fecha = '';
  String latitud = '';
  String longitud = '';
  String fechaInstalacion = '';
  String grupo = '';
  String causante = '';
  String pedido = '';
  String nombreCliente = '';
  String apellidoCliente = '';
  String documento = '';
  String domicilioInstalacion = '';
  String entreCalles = '';
  String firmacliente = '';
  String nombreApellidoFirmante = '';
  String tipoInstalacion = '';
  String esAveria = '';
  String documentoFirmante = '';
  int? mismoFirmante = 0;
  String tipoPedido = '';

  int? auditado = 0;
  String firmaclienteImageFullPath = '';

  AppInstalacionesEquipo(
      {required this.idRegistro,
      required this.nroObra,
      required this.idUsuario,
      required this.imei,
      required this.fecha,
      required this.latitud,
      required this.longitud,
      required this.fechaInstalacion,
      required this.grupo,
      required this.causante,
      required this.pedido,
      required this.nombreCliente,
      required this.apellidoCliente,
      required this.documento,
      required this.domicilioInstalacion,
      required this.entreCalles,
      required this.firmacliente,
      required this.nombreApellidoFirmante,
      required this.tipoInstalacion,
      required this.esAveria,
      required this.auditado,
      required this.firmaclienteImageFullPath,
      required this.documentoFirmante,
      required this.mismoFirmante,
      required this.tipoPedido});

  AppInstalacionesEquipo.fromJson(Map<String, dynamic> json) {
    idRegistro = json['idRegistro'];
    nroObra = json['nroObra'];
    idUsuario = json['idUsuario'];
    imei = json['imei'];
    fecha = json['fecha'];
    latitud = json['latitud'];
    longitud = json['longitud'];
    fechaInstalacion = json['fechaInstalacion'];
    grupo = json['grupo'];
    causante = json['causante'];
    pedido = json['pedido'];
    nombreCliente = json['nombreCliente'];
    apellidoCliente = json['apellidoCliente'];
    documento = json['documento'];
    domicilioInstalacion = json['domicilioInstalacion'];
    entreCalles = json['entreCalles'];
    firmacliente = json['firmacliente'];
    nombreApellidoFirmante = json['nombreApellidoFirmante'];
    tipoInstalacion = json['tipoInstalacion'];
    esAveria = json['esAveria'];
    auditado = json['auditado'];
    firmaclienteImageFullPath = json['firmaclienteImageFullPath'];
    documentoFirmante = json['documentoFirmante'];
    mismoFirmante = json['mismoFirmante'];
    tipoPedido = json['tipoPedido'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idRegistro'] = idRegistro;
    data['nroObra'] = nroObra;
    data['idUsuario'] = idUsuario;
    data['imei'] = imei;
    data['fecha'] = fecha;
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    data['fechaInstalacion'] = fechaInstalacion;
    data['grupo'] = grupo;
    data['causante'] = causante;
    data['pedido'] = pedido;
    data['nombreCliente'] = nombreCliente;
    data['apellidoCliente'] = apellidoCliente;
    data['documento'] = documento;
    data['domicilioInstalacion'] = domicilioInstalacion;
    data['entreCalles'] = entreCalles;
    data['firmacliente'] = firmacliente;
    data['nombreApellidoFirmante'] = nombreApellidoFirmante;
    data['tipoInstalacion'] = tipoInstalacion;
    data['esAveria'] = esAveria;
    data['auditado'] = auditado;
    data['firmaclienteImageFullPath'] = firmaclienteImageFullPath;
    data['documentoFirmante'] = documentoFirmante;
    data['mismoFirmante'] = mismoFirmante;
    data['tipoPedido'] = tipoPedido;
    return data;
  }
}
