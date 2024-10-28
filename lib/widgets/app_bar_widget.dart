import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required String title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(16, 4, 38, 1),
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        "Client Management",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      actions: const <Widget>[
        Icon(Icons.notifications, size: 30.0),
        SizedBox(width: 25.0),
        Icon(Icons.account_circle_sharp, size: 30.0),
        SizedBox(width: 20.0),
      ],
    );
  }
}
