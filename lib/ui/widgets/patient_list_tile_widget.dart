import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:flutter/material.dart';

class PatientListTileWidget extends StatefulWidget {
  const PatientListTileWidget({super.key, required this.patient});

  final PatientListModel patient;

  @override
  State<PatientListTileWidget> createState() => _PatientListTileWidgetState();
}

class _PatientListTileWidgetState extends State<PatientListTileWidget> {
  late final PatientListModel patient = widget.patient;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              Container(
                width: 80,
                height: 94,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primary,
                ),
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image(
                    image: AssetImage(
                      patient.gender == 1
                          ? "assets/images/female_icon.png"
                          : "assets/images/male_icon.png",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      patient.name,
                      style: Theme.of(context).textTheme.bodyMedium,
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
            ],
          ),
        ),
      ),
    );
  }
}
