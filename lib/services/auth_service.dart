import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app_chat/global/enviroment.dart';
import 'package:app_chat/models/login_response.dart';
import 'package:app_chat/models/usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  Usuario usuario = Usuario();
  bool _autenticando = false;

  Usuario get getUsuario => usuario;

  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estática
  static Future<String?> getToken() async {
    const _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    email = email.trim();
    password = password.trim();

    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Enviroment.apiUrl}/login');

    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      //TODO: Guardar token en lugar seguro
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final uri = Uri.parse('${Enviroment.apiUrl}/login/renew');

    final resp = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'x-token': token.toString(),
      },
    );
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      logout();
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;

    nombre = nombre.trim();
    email = email.trim();
    password = password.trim();

    final data = {'nombre': nombre, 'email': email, 'password': password};

    final uri = Uri.parse('${Enviroment.apiUrl}/login/new');

    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
