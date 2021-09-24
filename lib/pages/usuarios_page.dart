import 'package:app_chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/models/usuario.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(email: 'facundotanovich@gmail.com', nombre: 'Facundo', online: true, uid: '1'),
    Usuario(email: 'ginnacomparin@gmail.com', nombre: 'Ginna', online: true, uid: '2'),
    Usuario(email: 'giovannitanovich@gmail.com', nombre: 'Giovanni', online: false, uid: '3'),
    Usuario(email: 'ceciliatanovich@gmail.com', nombre: 'Cecilia', online: true, uid: '4'),
  ];
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
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
              //child: Icon(Icons.check_circle_outline, color: Colors.green),
              child: const Icon(Icons.offline_bolt_outlined, color: Colors.red),
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
    //TODO: Desconectar del socket Server

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
    );
  }

  void _cargarUsuarios() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
