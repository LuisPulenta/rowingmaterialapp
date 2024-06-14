class Producto {
  String codProducto = '';
  String codigoSAP = '';
  String denominacion = '';

  Producto({
    required this.codProducto,
    required this.codigoSAP,
    required this.denominacion,
  });

  Producto.fromJson(Map<String, dynamic> json) {
    codProducto = json['codProducto'];
    codigoSAP = json['codigoSAP'];
    denominacion = json['denominacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codProducto'] = codProducto;
    data['codigoSAP'] = codigoSAP;
    data['denominacion'] = denominacion;
    return data;
  }
}
