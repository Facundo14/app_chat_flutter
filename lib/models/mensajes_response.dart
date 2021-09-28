// To parse this JSON data, do
//
//     final mensajesResponse = mensajesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:app_chat/models/mensaje.dart';

MensajesResponse mensajesResponseFromJson(String str) => MensajesResponse.fromJson(json.decode(str));

String mensajesResponseToJson(MensajesResponse data) => json.encode(data.toJson());

class MensajesResponse {
  MensajesResponse({
    this.ok = false,
    mensajes,
  }) : mensajes = mensajes ?? [];

  bool ok;
  List<Mensaje> mensajes;

  factory MensajesResponse.fromJson(Map<String, dynamic> json) => MensajesResponse(
        ok: json["ok"] ?? false,
        mensajes: List<Mensaje>.from(json["mensajes"].map((x) => Mensaje.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "mensajes": List<dynamic>.from(mensajes.map((x) => x.toJson())),
      };
}
