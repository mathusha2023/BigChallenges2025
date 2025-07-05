import 'package:bc_phthalmoscopy/data/device_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/device_list_tile_widget.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DevicesListPage extends StatelessWidget {
  DevicesListPage({super.key});

  final Future _future = Future.delayed(
    Duration(seconds: 1),
    () => List.generate(1, (index) => DeviceListModel(deviceId: "12819283712")),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Устройства"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final devices = snapshot.data as List<DeviceListModel>;
                if (devices.isEmpty) {
                  return Text(
                    "Нет устройств",
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }
                return ListView.builder(
                  itemCount: devices.length,
                  itemBuilder:
                      (context, index) =>
                          DeviceListTileWidget(device: devices[index]),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
      floatingActionButton: MyFloatingButton(
        onPressed: () {
          context.go("/profile/devices_list/add_device");
        },
      ),
    );
  }
}
