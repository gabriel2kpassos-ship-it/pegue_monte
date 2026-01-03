import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'core/services/cliente_service.dart';
import 'modules/clientes/clientes_controller.dart';
import 'modules/dashboard/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ClienteService>(
          create: (_) =>
              ClienteService(FirebaseFirestore.instance),
        ),
        ChangeNotifierProvider<ClientesController>(
          create: (context) => ClientesController(
            context.read<ClienteService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Pegue e Monte',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const DashboardPage(),
      ),
    );
  }
}
