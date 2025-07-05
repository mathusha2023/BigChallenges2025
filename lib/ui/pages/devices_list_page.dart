import 'package:bc_phthalmoscopy/data/device_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/accept_delete_dialog.dart';
import 'package:bc_phthalmoscopy/ui/widgets/device_list_tile_widget.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DevicesListPage extends StatefulWidget {
  const DevicesListPage({super.key});

  @override
  State<DevicesListPage> createState() => _DevicesListPageState();
}

class _DevicesListPageState extends State<DevicesListPage> {
  late Future<List<DeviceListModel>> _future;
  List<DeviceListModel> _devices = [];

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  void _loadDevices() {
    _future = Future.delayed(
      Duration(seconds: 1),
      () => List.generate(
        3,
        (index) => DeviceListModel(deviceId: "1281928371$index"),
      ),
    );
  }

  void _removeDevice(int index) {
    setState(() {
      _devices.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Устройства"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: FutureBuilder<List<DeviceListModel>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _devices = snapshot.data!;

                if (_devices.isEmpty) {
                  return Text(
                    "Нет устройств",
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }

                return ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    final device = _devices[index];
                    return Dismissible(
                      key: Key(device.deviceId),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AcceptDeleteDialog(
                              text: "Удалить это устройство?",
                            );
                          },
                        );
                      },
                      onDismissed: (direction) {
                        _removeDevice(index);
                      },
                      child: DeviceListTileWidget(device: device),
                    );
                  },
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
