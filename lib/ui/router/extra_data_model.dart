import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/data/snapshot_list_model.dart';

class ExtraDataModel {
  final PatientListModel? patient;
  final SnapshotListModel? snapshot;

  ExtraDataModel({this.patient, this.snapshot});
}
