import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart'; // Adicionado
import 'firebase_options.dart'; // Adicionado

import 'core/theme/app_theme.dart';
import 'modules/login/login_page.dart'; // Vamos criar este arquivo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase antes de rodar o app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const KitRentalApp());
}

class KitRentalApp extends StatelessWidget {
  const KitRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Kits para Aluguel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Agora o app começa pela tela de Login
      home: const LoginPage(), 
    );
  }
}