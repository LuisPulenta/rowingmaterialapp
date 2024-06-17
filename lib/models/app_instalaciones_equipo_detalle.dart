class AppInstalacionesEquiposDetalle {
  int? iddetalle = 0;
  int? idinstalacionequipo = 0;
  String? nroserieinstalada = '';
  int? idlotecab = 0;
  String? codsiag = '';
  String? codsap = '';
  String? nombreEquipo = '';
  String? linkFoto = '';
  int? nroregistrolotescab = 0;
  String? familia = '';
  String? imageFullPath = '';

  AppInstalacionesEquiposDetalle(
      {required this.iddetalle,
      required this.idinstalacionequipo,
      required this.nroserieinstalada,
      required this.idlotecab,
      required this.codsiag,
      required this.codsap,
      required this.nombreEquipo,
      required this.linkFoto,
      required this.nroregistrolotescab,
      required this.familia,
      required this.imageFullPath});

  AppInstalacionesEquiposDetalle.fromJson(Map<String, dynamic> json) {
    iddetalle = json['iddetalle'];
    idinstalacionequipo = json['idinstalacionequipo'];
    nroserieinstalada = json['nroserieinstalada'];
    idlotecab = json['idlotecab'];
    codsiag = json['codsiag'];
    codsap = json['codsap'];
    nombreEquipo = json['nombreEquipo'];
    linkFoto = json['linkFoto'];
    nroregistrolotescab = json['nroregistrolotescab'];
    familia = json['familia'];
    imageFullPath = json['imageFullPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['iddetalle'] = iddetalle;
    data['idinstalacionequipo'] = idinstalacionequipo;
    data['nroserieinstalada'] = nroserieinstalada;
    data['idlotecab'] = idlotecab;
    data['codsiag'] = codsiag;
    data['codsap'] = codsap;
    data['nombreEquipo'] = nombreEquipo;
    data['linkFoto'] = linkFoto;
    data['nroregistrolotescab'] = nroregistrolotescab;
    data['familia'] = familia;
    data['imageFullPath'] = imageFullPath;
    return data;
  }
}
