import 'package:client_management_system/screens/home/client_management_screen.dart';
import 'package:client_management_system/widgets/app_bar_widget.dart';
import 'package:client_management_system/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(),
      drawer: DrawerWidget(),
      body: ClientManagementScreen(),
    );
  }
}
