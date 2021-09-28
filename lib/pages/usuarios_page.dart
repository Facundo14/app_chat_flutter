import 'package:app_chat/services/chat_service.dart';
import 'package:app_chat/services/usuarios_service.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:app_chat/services/auth_service.dart';
import 'package:app_chat/services/socket_service.dart';

import 'package:app_chat/models/usuario.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarioService = UsuarioService();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    final usuario = authService.getUsuario;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            usuario.nombre,
            style: const TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
            onPressed: _logOut,
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.online)
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.offline_bolt, color: Colors.red),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue.shade400,
          ),
          child: _listViewUsuarios(),
        ));
  }

  void _logOut() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.disconnect();

    Navigator.pushReplacementNamed(context, 'login');
    AuthService.deleteToken();
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (_, int index) => const Divider(),
      itemBuilder: (_, int index) {
        return _usuarioListTile(usuarios[index]);
      },
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    final Size size = MediaQuery.of(context).size;
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(
          usuario.nombre.substring(0, 2),
        ),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: size.width * 0.03,
        height: size.width * 0.03,
        decoration: BoxDecoration(
          color: (usuario.online) ? Colors.green : Colors.red,
          shape: BoxShape.circle,
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  void _cargarUsuarios() async {
    usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // monitor network fetch
    //await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
