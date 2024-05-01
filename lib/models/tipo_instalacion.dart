class TipoInstalacion {
  String tipoinstalacion = '';

  TipoInstalacion({required this.tipoinstalacion});

  TipoInstalacion.fromJson(Map<String, dynamic> json) {
    tipoinstalacion = json['tipoinstalacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tipoinstalacion'] = tipoinstalacion;
    return data;
  }
}
