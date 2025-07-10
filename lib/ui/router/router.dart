import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/ui/pages/add_device_page.dart';
import 'package:bc_phthalmoscopy/ui/pages/add_patient_page.dart';
import 'package:bc_phthalmoscopy/ui/pages/devices_list_page.dart';
import 'package:bc_phthalmoscopy/ui/pages/home_page.dart';
import 'package:bc_phthalmoscopy/ui/pages/patient_info_page.dart';
import 'package:bc_phthalmoscopy/ui/pages/patients_list_page.dart';
import 'package:bc_phthalmoscopy/ui/pages/profile_page.dart';
import 'package:bc_phthalmoscopy/ui/pages/scan_qr_page.dart';
import 'package:go_router/go_router.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(path: "/", builder: (context, state) => HomePage()),
    GoRoute(
      path: '/patients_list',
      builder: (context, state) => PatientsListPage(),
      routes: [
        GoRoute(
          path: "/add_patient",
          builder: (context, state) => AddPatientPage(),
        ),
        GoRoute(
          path: '/patients/:patientId',
          builder: (context, state) {
            final patient = state.extra as PatientListModel;
            return PatientInfoPage(patient: patient);
          },
        ),
        GoRoute(
          path: "/profile",
          builder: (context, state) => ProfilePage(),
          routes: [
            GoRoute(
              path: "/devices_list",
              builder: (context, state) => DevicesListPage(),
              routes: [
                GoRoute(
                  path: "/add_device",
                  builder: (context, state) {
                    final code = state.extra as String?;
                    return AddDevicePage(code: code);
                  },
                  routes: [
                    GoRoute(
                      path: "/scan_qr",
                      builder: (context, state) => ScanQrPage(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
