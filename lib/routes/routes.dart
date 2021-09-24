import 'package:app_chat/pages/chat_page.dart';
import 'package:app_chat/pages/loading_page.dart';
import 'package:app_chat/pages/login_page.dart';
import 'package:app_chat/pages/register_page.dart';
import 'package:app_chat/pages/usuarios_page.dart';
import 'package:flutter/cupertino.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => const UsuariosPage(),
  'chat': (_) => const ChatPage(),
  'login': (_) => const LoginPage(),
  'register': (_) => const RegisterPage(),
  'loading': (_) => const LoadingPage(),
};
