import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:bc_phthalmoscopy/ui/widgets/user_profile_block_widget.dart';
import 'package:flutter/material.dart';

class PatientInfoPage extends StatefulWidget {
  const PatientInfoPage({super.key, required this.patient});
  final PatientListModel patient;

  @override
  State<PatientInfoPage> createState() => _PatientInfoPageState();
}

class _PatientInfoPageState extends State<PatientInfoPage> {
  late final patient = widget.patient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [UserProfileBlockWidget(patient: patient)]),
        ),
      ),
    );
  }
}
