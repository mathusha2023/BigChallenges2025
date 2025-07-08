import 'package:bc_phthalmoscopy/data/eye_enum.dart';
import 'package:bc_phthalmoscopy/data/snapshot_edit_list_model.dart';

class SnapshotListModel {
  final int id;
  final int patientId;
  final String diagnosis;
  final String path;
  final EyeEnum eye;
  final DateTime date;
  final List<SnapshotEditListModel> edits;

  SnapshotListModel({
    required this.id,
    required this.patientId,
    required this.diagnosis,
    required this.path,
    required this.eye,
    required this.date,
    required this.edits,
  });
}
