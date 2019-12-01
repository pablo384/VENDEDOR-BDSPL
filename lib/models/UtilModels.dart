import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../index.dart';

class ClientDataModel {
  String cuidad;
  String descuento;
  String rnc;
  String calle;
  String of101;
  String tipoClientes;
  String semana;
  String provincia;
  String condicion;
  String of253;
  String of5M;
  String balance;
  String clienteNombre;
  String orden;
  String ruta;
  String ssync;
  String telefono;
  String dia;
  String sector;
  String id;
  bool visited = false;
  bool noVenta = false;

  ClientDataModel({
    this.cuidad,
    this.descuento,
    this.rnc,
    this.calle,
    this.of101,
    this.tipoClientes,
    this.semana,
    this.provincia,
    this.condicion,
    this.of253,
    this.of5M,
    this.balance,
    this.clienteNombre,
    this.orden,
    this.ruta,
    this.ssync,
    this.telefono,
    this.dia,
    this.sector,
    this.id,
  });

  updateData() async {
    noVenta = await StorageService.getNotSellslient(id);
    visited = await StorageService.getVisitedClient(id);
  }

  factory ClientDataModel.fromJson(Map<String, dynamic> json) =>
      new ClientDataModel(
        cuidad: json["cuidad"],
        descuento: json["descuento"],
        rnc: json["rnc"],
        calle: json["calle"],
        of101: json["OF_10_1"],
        tipoClientes: json["tipo_clientes"],
        semana: json["SEMANA"],
        provincia: json["provincia"],
        condicion: json["condicion"],
        of253: json["OF_25_3"],
        of5M: json["OF_5_M"],
        balance: json["BALANCE"],
        clienteNombre: json["cliente_nombre"],
        orden: json["ORDEN"],
        ruta: json["RUTA"],
        ssync: json["SYNC"],
        telefono: json["telefono"],
        dia: json["DIA"],
        sector: json["sector"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "cuidad": cuidad,
        "descuento": descuento,
        "rnc": rnc,
        "calle": calle,
        "OF_10_1": of101,
        "OF_25_3": of253,
        "OF_5_M": of5M,
        "tipo_clientes": tipoClientes,
        "SEMANA": semana,
        "provincia": provincia,
        "condicion": condicion,
        "BALANCE": balance,
        "cliente_nombre": clienteNombre,
        "ORDEN": orden,
        "RUTA": ruta,
        "SYNC": ssync,
        "telefono": telefono,
        "DIA": dia,
        "sector": sector,
        "id": id,
      };

  static List<ClientDataModel> clientDataModelFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<ClientDataModel>.from(
        jsonData.map((x) => ClientDataModel.fromJson(x)));
  }

  static String clientDataModelToJson(List<ClientDataModel> data) {
    final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
    return json.encode(dyn);
  }
}

class ConfigDataModel {
  String email;
  String password;
  String ruta;

  ConfigDataModel({
    this.email,
    this.password,
    this.ruta,
  });

  factory ConfigDataModel.fromJson(Map<String, dynamic> json) =>
      new ConfigDataModel(
        email: json["email"],
        password: json["password"],
        ruta: json["ruta"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "ruta": ruta,
      };

  static ConfigDataModel configDataModelFromJson(String str) {
    final jsonData = json.decode(str);
    return ConfigDataModel.fromJson(jsonData);
  }

  static String configDataModelToJson(ConfigDataModel data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }
}

class Factura {
  ClientDataModel cliente;
  String codigo;
  DateTime fecha;
  List<LineaFactura> lineas = [];
  double descuento = 0.0;
  double subTotal = 0.0;
  double itbis = 0.0;
  double total = 0.0;
  Factura({
    @required this.cliente,
    this.codigo,
    this.fecha,
    this.itbis = 0.0,
    this.total = 0.0,
    this.subTotal = 0.0,
    this.descuento = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      "ITBIS": itbis,
      "subTotal": subTotal,
      "descuento": descuento,
      "total": total,
      "codigo": codigo,
      "fecha": fecha.toIso8601String(),
      "cliente": cliente.toJson(),
      "lineas": lineas.map<Map<String, dynamic>>((f) => f.toJson()).toList(),
    };
  }

  static Factura fromJson(Map<String, dynamic> json) {
    Factura fact = Factura(
      cliente: ClientDataModel.fromJson(Map.castFrom(json['cliente'])),
      fecha: DateTime.parse(json['fecha']),
      codigo: json['codigo'],
      total: json['total'] == null ? 0.0 : json['total'].toDouble(),
      itbis: json['ITBIS'] == null ? 0.0 : json['ITBIS'].toDouble(),
      subTotal: json['subTotal'] == null ? 0.0 : json['subTotal'].toDouble(),
      descuento: json['descuento'] == null ? 0.0 : json['descuento'].toDouble(),
    );

    if (json['lineas'] == null) json['lineas'] = [];
    fact.addAll(
      json['lineas']
          .map<LineaFactura>(
            (l) => LineaFactura.fromJson(Map.castFrom(l)),
          )
          .toList(),
    );
    return fact;
  }

  static List<Factura> fromMap(Map str) {
    List<Factura> res = [];
    for (var k in str.keys) {
      res.add(Factura.fromJson({...str[k]}));
    }
    return res;
  }

  get fechaString => Util.formatterFecha.format(fecha);

  addLinea(LineaFactura ln) {
    lineas.add(ln);
    calcularTotales();
  }

  removeLinea(LineaFactura ln) {
    lineas.removeWhere((test) {
      var equal = ln == test;
      var second = ln.producto.id == test.producto.id && test.total == 0.0;
      print("condiciones $equal || $second");
      return equal || second;
    });
    // lineas.remove(ln);
    calcularTotales();
  }

  addAll(List<LineaFactura> ln) {
    lineas.addAll(ln);
    calcularTotales();
  }

  calcularTotales() {
    double tLn = 0.0;
    lineas.forEach((f) => tLn += f.total);
    subTotal = tLn;
    var _descuento = double.tryParse(this.cliente.descuento) ?? 0.0;
    descuento = (subTotal * _descuento);
    itbis = 0.18 * subTotal;
    total = subTotal - descuento + itbis;
  }
}

class LineaFactura {
  ProductDataModel producto;
  double cantidad;
  double total;
  LineaFactura({
    this.producto,
    this.cantidad,
    this.total = 0.0,
  }) {
    calcularTotal();
  }
  calcularTotal() {
    total = (double.tryParse(producto.precio) ?? 0.0) * cantidad;
  }

  Map<String, dynamic> toJson() {
    return {
      "producto": producto.toJson(),
      "cantidad": cantidad,
      "total": total,
    };
  }

  static LineaFactura fromJson(json) {
    return LineaFactura(
      cantidad: json['cantidad'] is int
          ? json['cantidad'].toDouble()
          : json['cantidad'],
      total: json['total'].toDouble(),
      producto: ProductDataModel.fromJson(Map.castFrom(json['producto'])),
    );
  }
}

class ProductDataModel {
  String id;
  String descCorta;
  String descLarga;
  String lineaProd;
  String marca;
  String precio;
  String presentacion;
  String tipoProd;
  String ultExist;
  String viscocidad;
  String of101;
  String of253;
  String of5M;

  ProductDataModel({
    this.id,
    this.descCorta,
    this.descLarga,
    this.lineaProd,
    this.marca,
    this.precio,
    this.presentacion,
    this.tipoProd,
    this.ultExist,
    this.viscocidad,
    this.of101 = "1",
    this.of253 = "1",
    this.of5M = "1",
  });

  factory ProductDataModel.fromJson(Map<String, dynamic> json) =>
      new ProductDataModel(
        id: json["ID"],
        descCorta: json["DESC_CORTA"],
        descLarga: json["DESC_LARGA"],
        lineaProd: json["LINEA_PROD"],
        marca: json["MARCA"],
        precio: json["PRECIO"],
        presentacion: json["PRESENTACION"],
        tipoProd: json["TIPO_PROD"],
        ultExist: json["ULT_EXIST"],
        viscocidad: json["VISCOCIDAD"],
        of101: json["OF_10_1"].toString() ?? "1",
        of253: json["OF_25_3"].toString() ?? "1",
        of5M: json["OF_5_M"].toString() ?? "1",
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "DESC_CORTA": descCorta,
        "DESC_LARGA": descLarga,
        "LINEA_PROD": lineaProd,
        "MARCA": marca,
        "PRECIO": precio,
        "PRESENTACION": presentacion,
        "TIPO_PROD": tipoProd,
        "ULT_EXIST": ultExist,
        "VISCOCIDAD": viscocidad,
        "OF_10_1": of101,
        "OF_25_3": of253,
        "OF_5_M": of5M,
      };
  static List<ProductDataModel> productDataModelFromJson(String str) {
    final jsonData = json.decode(str);
    return new List<ProductDataModel>.from(
      jsonData.map(
        (x) => ClientDataModel.fromJson(x),
      ),
    );
  }

  static List<ProductDataModel> productDataModelsFromMap(Map str) {
    List<ProductDataModel> res = [];
    for (var k in str.keys) {
      res.add(ProductDataModel.fromJson({...str[k], "ID": k}));
    }
    return res;
  }

  static String productDataModelToJson(ProductDataModel data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }
}
