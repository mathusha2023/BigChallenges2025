import 'package:bc_phthalmoscopy/ui/pages/add_patient_page.dart';
import 'package:bc_phthalmoscopy/ui/pages/home_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
      routes: [
        GoRoute(
          path: "/add_patient",
          builder: (context, state) => AddPatientPage(),
        ),
      ],
    ),
  ],
);
