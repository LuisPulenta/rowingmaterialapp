class SerieSinUsar {
  int nroregistro = 0;
  int nrolotecab = 0;
  String grupoh = '';
  String causanteh = '';
  String nroseriesalida = '';
  String codigosiag = '';
  String codigosap = '';
  String? denominacion = '';

  SerieSinUsar(
      {required this.nroregistro,
      required this.nrolotecab,
      required this.grupoh,
      required this.causanteh,
      required this.nroseriesalida,
      required this.codigosiag,
      required this.codigosap,
      required this.denominacion});

  SerieSinUsar.fromJson(Map<String, dynamic> json) {
    nroregistro = json['nroregistro'];
    nrolotecab = json['nrolotecab'];
    grupoh = json['grupoh'];
    causanteh = json['causanteh'];
    nroseriesalida = json['nroseriesalida'];
    codigosiag = json['codigosiag'];
    codigosap = json['codigosap'];
    denominacion = json['denominacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nroregistro'] = this.nroregistro;
    data['nrolotecab'] = this.nrolotecab;
    data['grupoh'] = this.grupoh;
    data['causanteh'] = this.causanteh;
    data['nroseriesalida'] = this.nroseriesalida;
    data['codigosiag'] = this.codigosiag;
    data['codigosap'] = this.codigosap;
    data['denominacion'] = this.denominacion;
    return data;
  }
}
