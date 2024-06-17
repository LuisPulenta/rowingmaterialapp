class AppInstalacionesMaterial {
  int idMaterial = 0;
  int idInstalacionEquipo = 0;
  String codigoSIAG = '';
  String codigoSAP = '';
  String descripcion = '';
  double cantidad = 0;

  AppInstalacionesMaterial({
    required this.idMaterial,
    required this.idInstalacionEquipo,
    required this.codigoSIAG,
    required this.codigoSAP,
    required this.descripcion,
    required this.cantidad,
  });

  AppInstalacionesMaterial.fromJson(Map<String, dynamic> json) {
    idMaterial = json['idMaterial'];
    idInstalacionEquipo = json['idInstalacionEquipo'];
    codigoSIAG = json['codigoSIAG'];
    codigoSAP = json['codigoSAP'];
    descripcion = json['descripcion'];
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idMaterial'] = idMaterial;
    data['idInstalacionEquipo'] = idInstalacionEquipo;
    data['codigoSIAG'] = codigoSIAG;
    data['codigoSAP'] = codigoSAP;
    data['descripcion'] = descripcion;
    data['cantidad'] = cantidad;
    return data;
  }
}
