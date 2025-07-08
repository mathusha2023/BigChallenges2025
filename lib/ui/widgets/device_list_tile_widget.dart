import 'package:bc_phthalmoscopy/data/device_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/patient_icon_widget.dart';
import 'package:flutter/material.dart';

class DeviceListTileWidget extends StatelessWidget {
  const DeviceListTileWidget({
    super.key,
    required this.device,
    required this.isActive,
  });

  final DeviceListModel device;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape:
          isActive
              ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 3,
                ),
              )
              : Theme.of(context).cardTheme.shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              PatientIconWidget(
                width: 80,
                height: 94,
                image: "assets/images/device_list_icon.png",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Офтальмоскоп",
                      style: Theme.of(context).textTheme.bodyMedium,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      "ID: ${device.deviceId}",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
