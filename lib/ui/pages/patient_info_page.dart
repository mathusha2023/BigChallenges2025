import 'package:bc_phthalmoscopy/data/eye_enum.dart';
import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/data/snapshot_edit_list_model.dart';
import 'package:bc_phthalmoscopy/data/snapshot_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:bc_phthalmoscopy/ui/widgets/patient_snapshot_tile_widget.dart';
import 'package:bc_phthalmoscopy/ui/widgets/show_snapshot_info_bottom_sheet.dart';
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
  Future? _future;
  final ScrollController _scrollController = ScrollController();
  bool _showProfile = true;
  List<SnapshotListModel> _snapshots = [];

  @override
  void initState() {
    fetch();

    super.initState();
    _scrollController.addListener(() {
      final currentOffset = _scrollController.offset;
      if (_showProfile && currentOffset > 40) {
        setState(() {
          _showProfile = false;
        });
      } else if (!_showProfile && currentOffset <= 40) {
        setState(() {
          _showProfile = true;
        });
      }
    });
  }

  void fetch() async {
    _future = Future.delayed(
      Duration(seconds: 1),
      () => List.generate(
        500,
        (index) => SnapshotListModel(
          id: index,
          patientId: patient.id,
          diagnosis:
              "ДЗН серый, границы четкие, форма правильная, размер нормальный. Экскавация нормальная, в центре. Сосудистый пучок расположен центрально. Ход, извитость, бифуркация и калибр артерий и вен не изменены. Макулярный рефлекс отсутствует, фовеальный рефлекс нормальный.",
          path:
              "https://steamuserimages-a.akamaihd.net/ugc/1691650191459972353/58AD2C7026076D745FC4345D79CA24241C38C045/?imw=512&&ima=fit&impolicy=Letterbox&imcolor=%23000000&letterbox=false",
          eye: index % 2 == 0 ? EyeEnum.left : EyeEnum.right,
          date: DateTime.now(),
          edits: List.generate(
            10,
            (int i) => SnapshotEditListModel(
              id: i,
              snapshotId: index,
              diagnosis: "ЛАСОСЬ",
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Анимированный блок профиля
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: _showProfile ? 1.0 : 0.0,
                  child: UserProfileBlockWidget(
                    patient: patient,
                    height: _showProfile ? null : 0,
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                child: SizedBox(height: _showProfile ? 20 : 0),
              ),
              Text("Снимки", style: Theme.of(context).textTheme.titleLarge),
              Text(
                "Нажмите на снимок, чтобы узнать подробности",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              // Список снимков
              Expanded(
                child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _snapshots = snapshot.data!;

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 5,
                            ),
                        itemCount: _snapshots.length,
                        controller: _scrollController,
                        itemBuilder:
                            (context, index) => GestureDetector(
                              onTap:
                                  () => showSnapshotInfoBottomSheet(
                                    context,
                                    patient,
                                    _snapshots[index],
                                  ),
                              child: PatientSnapshotTileWidget(
                                snapshot: _snapshots[index],
                              ),
                            ),
                      );
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 5,
                          ),
                      itemCount: 12,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder:
                          (context, index) => Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
