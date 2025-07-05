import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key, this.code});

  final String? code;

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    if (widget.code != null) _codeController.text = widget.code!;

    print("Controller: ${_codeController.text}");

    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Добавьте новое устройство",
              style: theme.textTheme.titleLarge,
            ),
            Text(
              'Введите ID устройства или отсканируйте QR-код',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),

            Text('ID устройства', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _codeController,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(hintText: "000000000000"),
            ),

            SizedBox(height: 20),

            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40 - 50 - 10,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },

                      child: Text(
                        'Добавить',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go("/profile/devices_list/add_device/scan_qr");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Image(
                        image: AssetImage('assets/images/qr_icon.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
