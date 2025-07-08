import 'package:bc_phthalmoscopy/data/eye_enum.dart';
import 'package:bc_phthalmoscopy/data/snapshot_list_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatientSnapshotTileWidget extends StatelessWidget {
  const PatientSnapshotTileWidget({super.key, required this.snapshot});

  final SnapshotListModel snapshot;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSnapshotInfoBottomSheet(context),
      child: Card(
        margin: const EdgeInsets.all(0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(15),
              child: Image.network(snapshot.path),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(100, 0, 0, 0),
                borderRadius: BorderRadiusGeometry.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.all(5),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${eyeToString(snapshot.eye)} глаз",
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    DateFormat("dd.MM.yyyy").format(snapshot.date),
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnapshotInfoBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[Text('This is a modal bottom sheet.')],
            ),
          ),
        );
      },
    );
  }
}
