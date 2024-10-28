import 'package:flutter/material.dart';
//Firebase
import 'package:client_management_system/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//Auth Gate
import 'package:client_management_system/screens/auth/auth_gate.dart';

void main() async {
  //this tells flutter not to start running the application widget code until the flutter framework is completely booted
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ClientManagementApp());
}

class ClientManagementApp extends StatelessWidget {
  const ClientManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Client Management",
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
