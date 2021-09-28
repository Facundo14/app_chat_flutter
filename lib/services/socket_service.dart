import 'package:app_chat/global/enviroment.dart';
import 'package:app_chat/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  void connect() async {
    final token = await AuthService.getToken();
    // Dart client
    _socket = IO.io(
        Enviroment.socketUrl,
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({
              'x-token': token,
            })
            .build());

    _socket.onConnect((_) {
      print('Conectado');
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      print('Desconectado');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
