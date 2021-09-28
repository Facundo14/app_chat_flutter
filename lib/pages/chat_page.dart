import 'dart:io';

import 'package:app_chat/models/mensaje.dart';
import 'package:app_chat/services/auth_service.dart';
import 'package:app_chat/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:app_chat/services/chat_service.dart';

import 'package:app_chat/widgets/chat_messages.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  ChatService chatService = ChatService();
  SocketService socketService = SocketService();
  AuthService authService = AuthService();

  final List<ChatMessage> _messages = [];
// Manejo de Nulls

  // int valAbs(int? val) {
  //   if (val == null) {
  //     return 0;
  //   }
  //   return val.abs();
  // }

  // String valAbsString(String? val) => val ?? '';

  // String valAbsString1(String? val) {
  //   if (val == null) {
  //     return '';
  //   }
  //   return val.trim();
  // }

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMensaje);

    _cargarHistorial(chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);
    final history = chat.map(
      (m) => ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward(),
      ),
    );
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300)),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = chatService.usuarioPara;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: Column(
            children: [
              CircleAvatar(
                child: Text(usuario.nombre.substring(0, 2), style: TextStyle(fontSize: size.width * 0.03)),
                backgroundColor: Colors.blue[100],
                maxRadius: 14,
              ),
              SizedBox(height: size.height * 0.005),
              Text(usuario.nombre, style: TextStyle(color: Colors.black54, fontSize: size.width * 0.04))
            ],
          ),
        ),
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, int index) => _messages[index],
                reverse: true,
              ),
            ),
            Divider(height: size.height * 0.01),
            Container(
              height: size.height * 0.07,
              color: Colors.white,
              child: _inputChat(size),
            ),
          ],
        ));
  }

  Widget _inputChat(Size size) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: size.height * 0.01),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  setState(() {
                    if (texto.trim().isNotEmpty) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                focusNode: _focusNode,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Envar mensaje',
                ),
              ),
            ),
            //Boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: const Text('Enviar'),
                      onPressed: _estaEscribiendo ? () => _handleSubmit(_textController.text.trim()) : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: size.height * 0.0001),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: const Icon(Icons.send),
                          onPressed: _estaEscribiendo ? () => _handleSubmit(_textController.text.trim()) : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      uid: authService.usuario.uid,
      texto: texto,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _estaEscribiendo = false;
    });

    socketService.socket.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': texto,
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
