import 'package:app_chat/models/mensaje.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_chat/services/auth_service.dart';

import 'package:app_chat/global/enviroment.dart';

import 'package:app_chat/models/mensajes_response.dart';
import 'package:app_chat/models/usuario.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara = Usuario();

  Future<List<Mensaje>> getChat(String usuarioID) async {
    String? token = await AuthService.getToken();
    final uri = Uri.parse('${Enviroment.apiUrl}/mensajes/$usuarioID');

    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString(),
      },
    );

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;
  }
}
