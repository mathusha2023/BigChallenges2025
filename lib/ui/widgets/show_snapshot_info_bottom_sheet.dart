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
  final FocusNode inputNode = FocusNode();
  final TextEditingController controller = TextEditingController();
  const int duration = 300;
  bool editDiagnosis = false;
  String diagnosis = snapshot.diagnosis;
  controller.text = diagnosis;

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
        child: Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
            bottom: 30,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: StatefulBuilder(
            builder: (context, setLocalState) {
              void toggleEdit() {
                setLocalState(() {
                  editDiagnosis = !editDiagnosis;
                });
                if (editDiagnosis) {
                  Future.delayed(Duration(milliseconds: 50), () {
                    if (context.mounted) {
                      FocusScope.of(context).requestFocus(inputNode);
                    }
                  });
                }
                // Добавляем небольшую задержку для гарантии обновления UI
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AnimatedSize(
                    duration: const Duration(milliseconds: duration),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: duration),
                      opacity: editDiagnosis ? 0.0 : 1.0,
                      child: SizedBox(
                        height: editDiagnosis ? 0 : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
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
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Информация",
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: toggleEdit,
                                    child: Icon(
                                      Icons.edit_rounded,
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Анализ нейросети:",
                        style: theme.textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: duration),
                        opacity: editDiagnosis ? 1.0 : 0.0,
                        child: GestureDetector(
                          onTap:
                              editDiagnosis
                                  ? () {
                                    toggleEdit();
                                    controller.text = diagnosis;
                                  }
                                  : null,
                          child: Text(
                            "Отмена",
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: duration),
                    child: SizedBox(height: editDiagnosis ? 10 : 0),
                  ),
                  TextFormField(
                    controller: controller,
                    style: theme.textTheme.bodySmall,
                    enabled: editDiagnosis,
                    maxLines: null,
                    focusNode: inputNode,
                    autofocus: editDiagnosis,
                    decoration:
                        editDiagnosis
                            ? InputDecoration(hintText: "Введите диагноз")
                            : InputDecoration(
                              filled: false,
                              contentPadding: EdgeInsets.all(0),
                            ),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSize(
                    duration: const Duration(milliseconds: duration),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: duration),
                      opacity: editDiagnosis ? 1.0 : 0.0,
                      child: SizedBox(
                        height: editDiagnosis ? null : 0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              editDiagnosis
                                  ? () {
                                    if (controller.text.trim().isNotEmpty) {
                                      diagnosis = controller.text;
                                      toggleEdit();
                                    }
                                  }
                                  : null,
                          child: const Text('Сохранить'),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
