import 'package:bc_phthalmoscopy/repository/keycloak.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Keycloak().login().then((value) {
      Future.delayed(
        Duration(seconds: 1),
      ).then((value) => navigateToMainScreen());
    });
    super.initState();
  }

  void navigateToMainScreen() {
    if (context.mounted) {
      context.replace("/patients_list");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
