import 'package:bc_phthalmoscopy/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  await dotenv.load();
  await FlutterSecureStorage().deleteAll();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
