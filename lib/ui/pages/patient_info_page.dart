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
  Future? _future;
  final ScrollController _scrollController = ScrollController();
  bool _showProfile = true;
  double _lastScrollOffset = 0;

  @override
  void initState() {
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
      _lastScrollOffset = currentOffset;
    });
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
                      return Container();
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 5,
                          ),
                      itemCount: 120,
                      controller: _scrollController,
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
