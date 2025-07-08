import 'package:bc_phthalmoscopy/data/eye_enum.dart';
import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/data/snapshot_list_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnapshotInfoBottomSheet(
  BuildContext context,
  PatientListModel patient,
  SnapshotListModel snapshot,
) {
  final ThemeData theme = Theme.of(context);

  showModalBottomSheet<void>(
    context: context,
    isDismissible: true,
    isScrollControlled: true, // 1. Включаем управление прокруткой
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(
                context,
              ).viewInsets.bottom, // 2. Учитываем клавиатуру
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setLocalState) {
            return IntrinsicHeight(
              // 3. Используем IntrinsicHeight
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
                    // Ваше содержимое без изменений
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            patient.name,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(15),
                      child: Image.network(snapshot.path),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Spacer(),
                        Text("Информация", style: theme.textTheme.titleMedium),
                        Spacer(),
                      ],
                    ),
                    Text("Глаз", style: theme.textTheme.bodyLarge),
                    Text(
                      "${eyeToString(snapshot.eye)} глаз",
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 10),
                    Text("Дата", style: theme.textTheme.bodyLarge),
                    Text(
                      DateFormat("dd.MM.yyyy").format(snapshot.date),
                      style: theme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 10),
                    Text("Анализ нейросети:", style: theme.textTheme.bodyLarge),
                    Text(snapshot.diagnosis, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
