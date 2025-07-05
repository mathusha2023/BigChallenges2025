import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/accept_delete_dialog.dart';
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
  bool _showHeader = true;
  double _lastScrollOffset = 0;
  List<PatientListModel> _patients = [];

  bool? male = false;
  bool? female = false;

  void fetch() async {
    _future = Future.delayed(
      Duration(seconds: 2),
      () => List.generate(
        10,
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
      if (currentOffset > _lastScrollOffset + 10 && currentOffset > 50) {
        if (_showHeader) setState(() => _showHeader = false);
      } else if (currentOffset < _lastScrollOffset - 10 ||
          currentOffset <= 30) {
        if (!_showHeader) setState(() => _showHeader = true);
      }
      _lastScrollOffset = currentOffset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _removePatient(int index) {
    setState(() {
      _patients.removeAt(index);
      if (_patients.length < 7 && !_showHeader) {
        _showHeader = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
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
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, size: 20),
                            hintText: "Поиск пациентов",
                            hintStyle: theme.inputDecorationTheme.hintStyle
                                ?.copyWith(color: theme.colorScheme.secondary),
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
                            image: AssetImage("assets/images/doctor_icon.png"),
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
                    onTap: () => _showFilterBottomSheet(context),
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

                      if (_patients.isEmpty) {
                        return Center(
                          child: Text(
                            "Нет пациентов",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: _patients.length,
                        itemBuilder: (context, index) {
                          PatientListModel p = _patients[index];
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
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      isScrollControlled: true, // 1. Включаем управление прокруткой
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  context,
                ).viewInsets.bottom, // 2. Учитываем клавиатуру
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return IntrinsicHeight(
                // 3. Используем IntrinsicHeight
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 4. Главное - это строка
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Ваше содержимое без изменений
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Фильтры",
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                "Отмена",
                                style: theme.textTheme.titleSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text("Пол", style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text("Мужской", style: theme.textTheme.bodyLarge),
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: male,
                            onChanged: (value) => setState(() => male = value),
                          ),
                          Text("Женский", style: theme.textTheme.bodyLarge),
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: female,
                            onChanged:
                                (value) => setState(() => female = value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text("Возраст", style: theme.textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "от",
                                counterText: "",
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(" - "),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "до",
                                counterText: "",
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Применить'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
