import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/check_eye_button_widget.dart';
import 'package:bc_phthalmoscopy/ui/widgets/patient_icon_widget.dart';
import 'package:flutter/material.dart';

class UserProfileBlockWidget extends StatefulWidget {
  const UserProfileBlockWidget({
    super.key,
    required this.patient,
    required this.height,
  });
  final PatientListModel patient;
  final double? height;

  @override
  State<UserProfileBlockWidget> createState() => _UserProfileBlockWidgetState();
}

class _UserProfileBlockWidgetState extends State<UserProfileBlockWidget> {
  late final patient = widget.patient;
  int? _eye; // 0 - left, 1 - right

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PatientIconWidget(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.18,
                isMale: patient.gender == 0,
              ),
              Expanded(
                // 1. Добавляем Expanded
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        // 2. Ограничиваем ширину текста
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.5,
                        ),
                        child: Text(
                          patient.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          softWrap: true, // 3. Включаем перенос слов
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Text(
                        patient.gender == 1 ? "Женщина" : "Мужчина",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "${patient.age} лет",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "Чтобы сделать новый снимок, переключите статус получения фото на активный",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 35,
            child: Row(
              children: [
                CheckEyeButtonWidget(
                  isChecked: _eye == 0,
                  title: "Правый",
                  onTap: () {
                    setState(() {
                      if (_eye == 0) {
                        _eye = null;
                      } else {
                        _eye = 0;
                      }
                    });
                  },
                ),
                const SizedBox(width: 10),
                CheckEyeButtonWidget(
                  isChecked: _eye == 1,
                  title: "Левый",
                  onTap: () {
                    setState(() {
                      if (_eye == 1) {
                        _eye = null;
                      } else {
                        _eye = 1;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
