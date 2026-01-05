import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

// Módulos
import 'modules/login/login_page.dart';
import 'modules/dashboard/dashboard_page.dart';

import 'modules/clientes/clientes_page.dart';
import 'modules/clientes/cliente_form_page.dart';

import 'modules/produtos/produtos_page.dart';
import 'modules/produtos/produto_form_page.dart';

import 'modules/kits/kits_page.dart';
import 'modules/kits/kit_form_page.dart';

import 'modules/alugueis/alugueis_page.dart';
import 'modules/alugueis/aluguel_form_page.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PegueEMonteApp());
}

class PegueEMonteApp extends StatelessWidget {
  const PegueEMonteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pegue e Monte',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,

      // 🔥 NECESSÁRIO PARA DATE PICKER PT-BR
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      initialRoute: '/login',
      routes: {
        // AUTH
        '/login': (_) => const LoginPage(),
        '/dashboard': (_) => DashboardPage(),

        // CLIENTES
        '/clientes': (_) => ClientesPage(selecionar: false),
        '/clientes-select': (_) => ClientesPage(selecionar: true),
        '/cliente-form': (_) => const ClienteFormPage(),

        // PRODUTOS
        '/produtos': (_) => ProdutosPage(),
        '/produto-form': (_) => const ProdutoFormPage(),

        // KITS
        '/kits': (_) => KitsPage(selecionar: false),
        '/kits-select': (_) => KitsPage(selecionar: true),
        '/kit-form': (_) => KitFormPage(),

        // ALUGUÉIS
        '/alugueis': (_) => AlugueisPage(),
        '/aluguel-form': (_) => AluguelFormPage(),
      },
    );
  }
}
