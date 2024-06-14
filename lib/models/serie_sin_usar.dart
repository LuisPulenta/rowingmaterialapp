class SerieSinUsar {
  int nroregistro = 0;
  int nrolotecab = 0;
  String grupoh = '';
  String causanteh = '';
  String nroseriesalida = '';
  String codigosiag = '';
  String codigosap = '';
  String? denominacion = '';
  String? foto = '';
  String? familia = '';

  SerieSinUsar(
      {required this.nroregistro,
      required this.nrolotecab,
      required this.grupoh,
      required this.causanteh,
      required this.nroseriesalida,
      required this.codigosiag,
      required this.codigosap,
      required this.denominacion,
      required this.foto,
      required this.familia});

  SerieSinUsar.fromJson(Map<String, dynamic> json) {
    nroregistro = json['nroregistro'];
    nrolotecab = json['nrolotecab'];
    grupoh = json['grupoh'];
    causanteh = json['causanteh'];
    nroseriesalida = json['nroseriesalida'];
    codigosiag = json['codigosiag'];
    codigosap = json['codigosap'];
    denominacion = json['denominacion'];
    foto = json['foto'];
    familia = json['familia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nroregistro'] = nroregistro;
    data['nrolotecab'] = nrolotecab;
    data['grupoh'] = grupoh;
    data['causanteh'] = causanteh;
    data['nroseriesalida'] = nroseriesalida;
    data['codigosiag'] = codigosiag;
    data['codigosap'] = codigosap;
    data['denominacion'] = denominacion;
    data['foto'] = foto;
    data['familia'] = familia;
    return data;
  }
}
