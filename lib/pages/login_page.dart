import 'package:app_chat/widgets/boton_azul.dart';
import 'package:app_chat/widgets/labels.dart';
import 'package:flutter/material.dart';
import 'package:app_chat/widgets/custom_input.dart';
import 'package:app_chat/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                    texto: 'Messenger',
                  ),
                  const _Form(),
                  const Labels(
                    ruta: 'register',
                    texto1: '¿No tienes cuenta?',
                    texto2: 'Crea tu cuenta ahora!',
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
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.001),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        children: [
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
          BotonAzul(
            texto: 'Ingresar',
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
