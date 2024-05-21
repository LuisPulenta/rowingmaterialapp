class AppInstalacionesEquiposDetalle {
  int? iddetalle = 0;
  int? idinstalacionequipo = 0;
  String? nroserieinstalada = '';
  int? idlotecab = 0;
  String? codsiag = '';
  String? codsap = '';

  AppInstalacionesEquiposDetalle(
      {required this.iddetalle,
      required this.idinstalacionequipo,
      required this.nroserieinstalada,
      required this.idlotecab,
      required this.codsiag,
      required this.codsap});

  AppInstalacionesEquiposDetalle.fromJson(Map<String, dynamic> json) {
    iddetalle = json['iddetalle'];
    idinstalacionequipo = json['idinstalacionequipo'];
    nroserieinstalada = json['nroserieinstalada'];
    idlotecab = json['idlotecab'];
    codsiag = json['codsiag'];
    codsap = json['codsap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iddetalle'] = this.iddetalle;
    data['idinstalacionequipo'] = this.idinstalacionequipo;
    data['nroserieinstalada'] = this.nroserieinstalada;
    data['idlotecab'] = this.idlotecab;
    data['codsiag'] = this.codsiag;
    data['codsap'] = this.codsap;
    return data;
  }
}
