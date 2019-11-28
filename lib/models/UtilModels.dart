import 'dart:convert';

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
        "tipo_clientes": tipoClientes,
        "SEMANA": semana,
        "provincia": provincia,
        "condicion": condicion,
        "OF_25_3": of253,
        "OF_5_M": of5M,
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
