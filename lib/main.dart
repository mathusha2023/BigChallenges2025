// import 'dart:io';
import 'package:bc_phthalmoscopy/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

void main() async {
  await dotenv.load(fileName: ".env.univer");
  // HttpOverrides.global = MyHttpOverrides();
  // await FlutterSecureStorage().deleteAll();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
