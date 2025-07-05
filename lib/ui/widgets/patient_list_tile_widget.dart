import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/patient_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PatientListTileWidget extends StatelessWidget {
  const PatientListTileWidget({super.key, required this.patient});

  final PatientListModel patient;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go("/patients/${patient.id}", extra: patient);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                PatientIconWidget(
                  width: 80,
                  height: 94,
                  image:
                      patient.gender == 0
                          ? "assets/images/male_icon.png"
                          : "assets/images/female_icon.png",
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      spacing: 3,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width -
                                80 -
                                16 -
                                20,
                          ),
                          child: Text(
                            patient.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        Text(
                          patient.gender == 1 ? "Женщина" : "Мужчина",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          "${patient.age} лет",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
