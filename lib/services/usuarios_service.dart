import 'package:http/http.dart' as http;
import 'package:app_chat/models/usuarios_response.dart';

import 'package:app_chat/models/usuario.dart';
import 'package:app_chat/services/auth_service.dart';

import 'package:app_chat/global/enviroment.dart';

class UsuarioService {
  Future<List<Usuario>> getUsuarios() async {
    //obteniendo el token
    String? token = await AuthService.getToken();
    try {
      final resp = await http
          .get(Uri.parse('${Enviroment.apiUrl}/usuarios'), headers: {'Content-Type': 'application/json', 'x-Token': token.toString()});

      final usuarioResponse = usuariosResponseFromJson(resp.body);
      return usuarioResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
