import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/accept_delete_dialog.dart';
import 'package:bc_phthalmoscopy/ui/widgets/show_filter_bottom_sheet.dart';
import 'package:bc_phthalmoscopy/ui/widgets/my_floating_button.dart';
import 'package:bc_phthalmoscopy/ui/widgets/patient_list_tile_widget.dart';
import 'package:flutter/material.dart' hide showBottomSheet;
import 'package:go_router/go_router.dart';

class PatientsListPage extends StatefulWidget {
  const PatientsListPage({super.key});

  @override
  State<PatientsListPage> createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  static Future? _future;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _minAgeController = TextEditingController();
  final TextEditingController _maxAgeController = TextEditingController();
  bool _showHeader = true;
  double _lastScrollOffset = 0;
  List<PatientListModel> _patients = [];
  String _search = "";
  int _minAge = 0;
  int _maxAge = 999;

  bool male = true;
  bool female = true;

  final FocusNode _searchFocusNode = FocusNode(); // Добавляем FocusNode

  void fetch() async {
    _future = Future.delayed(
      Duration(seconds: 2),
      () => List.generate(
        15,
        (int index) =>
            PatientListModel("Базин Алексей Сергеевич", 47, 0, index),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetch();

    _scrollController.addListener(() {
      final currentOffset = _scrollController.offset;
      if (currentOffset > _lastScrollOffset + 10 && currentOffset > 30) {
        if (_showHeader) setState(() => _showHeader = false);
      } else if (currentOffset < _lastScrollOffset - 10 ||
          currentOffset <= 30) {
        if (!_showHeader) setState(() => _showHeader = true);
      }
      _lastScrollOffset = currentOffset;

      // Добавляем проверку при достижении верха списка
      if (_scrollController.offset <= 0 && !_showHeader) {
        setState(() => _showHeader = true);
      }
    });

    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        _searchPatient("");
      }
    });
    _minAgeController.text = _minAge.toString();
    _maxAgeController.text = _maxAge.toString();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose(); // Не забываем освободить ресурсы
    _searchController.dispose();
    _maxAgeController.dispose();
    _minAgeController.dispose();
    super.dispose();
  }

  void _removePatient(int index) {
    setState(() {
      _patients.removeAt(index);
      if (_scrollController.offset <= 0 && !_showHeader) {
        setState(() => _showHeader = true);
      }
    });
  }

  void _searchPatient(value) {
    setState(() {
      _search = value;
    });
  }

  List<PatientListModel> get _filterPatients {
    List allowedGender = [];
    if (male) {
      allowedGender.add(0);
    }
    if (female) {
      allowedGender.add(1);
    }
    return _patients
        .where(
          (element) =>
              element.name.contains(_search) &&
              allowedGender.contains(element.gender) &&
              element.age >= _minAge &&
              element.age <= _maxAge,
        )
        .toList();
  }

  void _filter(bool localMale, bool localFemale) {
    setState(() {
      _minAge = int.parse(_minAgeController.text);
      _maxAge = int.parse(_maxAgeController.text);
      male = localMale;
      female = localFemale;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Анимированный заголовок
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _showHeader ? 45 : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _showHeader ? 1 : 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: _searchPatient,
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              prefixIcon: GestureDetector(
                                onTap:
                                    () =>
                                        _searchPatient(_searchController.text),
                                child: Icon(Icons.search, size: 20),
                              ),
                              hintText: "Поиск пациентов",
                              hintStyle: theme.inputDecorationTheme.hintStyle
                                  ?.copyWith(
                                    color: theme.colorScheme.secondary,
                                  ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go("/profile");
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).cardColor,
                            child: Image(
                              image: AssetImage(
                                "assets/images/doctor_icon.png",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Фильтры
                AnimatedPadding(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.only(
                    top: _showHeader ? 10 : 0,
                    bottom: _showHeader ? 12 : 0,
                  ), // Уменьшенный отступ
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: _showHeader ? 15 : 0,
                    child: GestureDetector(
                      onTap:
                          () => showFilterBottomSheet(
                            context,
                            _filter,
                            male,
                            female,
                            _minAgeController,
                            _maxAgeController,
                          ),
                      child: Row(
                        children: [
                          Image(
                            width: 20,
                            height: 15,
                            image: AssetImage("assets/images/filter_icon.png"),
                          ),
                          const SizedBox(width: 8),
                          Text("Фильтры", style: theme.textTheme.displayLarge),
                        ],
                      ),
                    ),
                  ),
                ),

                // Список пациентов
                Expanded(
                  child: FutureBuilder(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        _patients = snapshot.data!;
                        List<PatientListModel> filtered = _filterPatients;

                        if (filtered.isEmpty) {
                          return Center(
                            child: Text(
                              "Нет пациентов",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            PatientListModel p = filtered[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Dismissible(
                                key: Key(p.id.toString()),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AcceptDeleteDialog(
                                        text: "Удалить этого пациента?",
                                      );
                                    },
                                  );
                                },
                                onDismissed: (direction) {
                                  _removePatient(index);
                                },
                                child: PatientListTileWidget(patient: p),
                              ),
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: MyFloatingButton(
          onPressed: () {
            context.go("/add_patient");
          },
        ),
      ),
    );
  }
}
