import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:app_chat/services/auth_service.dart';
import 'package:app_chat/services/socket_service.dart';

import 'package:app_chat/helpers/mostrar_alerta.dart';

import 'package:app_chat/widgets/boton_azul.dart';
import 'package:app_chat/widgets/labels.dart';
import 'package:app_chat/widgets/custom_input.dart';
import 'package:app_chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Logo(
                    texto: 'Registro',
                  ),
                  const _Form(),
                  const Labels(
                    ruta: 'login',
                    texto1: '¿Ya tienes cuenta?',
                    texto2: 'Ingresa ahora!',
                  ),
                  Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(color: Colors.black54, fontSize: size.width * 0.04, fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.001),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity_outlined,
            placeholder: 'Nombre',
            keyboardType: TextInputType.name,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.email_outlined,
            placeholder: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.visiblePassword,
            isPassword: true,
            textController: passwordCtrl,
          ),
          authService.autenticando
              ? const CircularProgressIndicator()
              : BotonAzul(
                  texto: 'Registrar',
                  onPressed: _registrar,
                )
        ],
      ),
    );
  }

  _registrar() async {
    FocusScope.of(context).unfocus();
    final authService = Provider.of<AuthService>(context, listen: false);
    final registroOk = await authService.register(nameCtrl.text, emailCtrl.text, passwordCtrl.text);
    if (registroOk == true) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.connect();

      Navigator.pushReplacementNamed(context, 'usuarios');
    } else {
      mostrarAlerta(context, 'Registro Incorrecto', registroOk.toString());
    }
  }
}
