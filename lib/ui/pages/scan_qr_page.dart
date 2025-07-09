import 'package:bc_phthalmoscopy/ui/widgets/dark_qr_code_background.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // 1. Сканер на весь экран
        MobileScanner(
          onDetect: (result) {
            String code = result.barcodes.first.rawValue ?? "";
            print("From scanner:$code");
            context.go(
              "/patients_list/profile/devices_list/add_device",
              extra: code,
            );
          },
        ),

        // 2. Затемнение с "дыркой" для сканирования
        DarkQrCodeBackground(),

        // 3. Интерфейс поверх всего
        Scaffold(
          appBar: MyAppBar(isTransparent: true, textColor: Colors.white),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: [
                SizedBox(height: height * 0.1),
                Text(
                  "Сканировать QR-код",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                Text(
                  "Отсканируйте QR-код\nна устройстве",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
