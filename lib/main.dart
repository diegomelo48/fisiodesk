import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/recuperar_senha_screen.dart';
import 'screens/main_screen.dart';
import 'screens/artigos_screen.dart';
import 'screens/resource_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FisioDeskApp());
}

class FisioDeskApp extends StatelessWidget {
  const FisioDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FisioDesk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/cadastro': (_) => const CadastroScreen(),
        '/recuperar-senha': (_) => const RecuperarSenhaScreen(),
        '/home': (_) => const MainScreen(),
        '/artigos': (_) => const ArtigosScreen(),
      },
      // Telas de recurso (robotica, gameterapia, etc.) usam argumento de rota:
      // Navigator.pushNamed(context, '/recurso', arguments: 'robotica');
      onGenerateRoute: (settings) {
        if (settings.name == '/recurso') {
          final key = settings.arguments as String;
          return MaterialPageRoute(builder: (_) => ResourceScreen(recursoKey: key));
        }
        return null;
      },
    );
  }
}
