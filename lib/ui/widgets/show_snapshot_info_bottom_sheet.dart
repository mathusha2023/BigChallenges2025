import 'package:bc_phthalmoscopy/data/eye_enum.dart';
import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/data/snapshot_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/full_screen_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnapshotInfoBottomSheet(
  BuildContext context,
  PatientListModel patient,
  SnapshotListModel snapshot,
) {
  final ThemeData theme = Theme.of(context);
  final double size = MediaQuery.of(context).size.width - 2 * 20;

  void openFullScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder:
            (_, __, ___) => FullScreenImageWidget(imageUrl: snapshot.path),
      ),
    );
  }

  showModalBottomSheet<void>(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 30,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        patient.name,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        snapshot.path,
                        fit: BoxFit.contain,
                        width: size,
                        height: size,
                      ),
                    ),
                    GestureDetector(
                      onTap: openFullScreen,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.zoom_out_map,
                          color: theme.scaffoldBackgroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Spacer(),
                    Text("Информация", style: theme.textTheme.titleMedium),
                    const Spacer(),
                  ],
                ),
                Text("Глаз", style: theme.textTheme.bodyLarge),
                Text(
                  "${eyeToString(snapshot.eye)} глаз",
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Text("Дата", style: theme.textTheme.bodyLarge),
                Text(
                  DateFormat("dd.MM.yyyy").format(snapshot.date),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Text("Анализ нейросети:", style: theme.textTheme.bodyLarge),
                Text(snapshot.diagnosis, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      );
    },
  );
}
