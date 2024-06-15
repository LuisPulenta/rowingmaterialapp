class Producto {
  String codProducto = '';
  String codigoSAP = '';
  String denominacion = '';
  double? cantidad = 0;

  Producto({
    required this.codProducto,
    required this.codigoSAP,
    required this.denominacion,
    required this.cantidad,
  });

  Producto.fromJson(Map<String, dynamic> json) {
    codProducto = json['codProducto'];
    codigoSAP = json['codigoSAP'];
    denominacion = json['denominacion'];
    cantidad = json['cantidad'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codProducto'] = codProducto;
    data['codigoSAP'] = codigoSAP;
    data['denominacion'] = denominacion;
    data['cantidad'] = cantidad;
    return data;
  }
}
