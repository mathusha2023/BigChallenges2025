import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
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

  bool? male = false;
  bool? female = false;

  void fetch() async {
    _future = Future.delayed(
      Duration(seconds: 2),
      () => List.generate(
        20,
        (int index) => PatientListModel("Иван Иванов", 47, 0, index),
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
                        onTap: () {},
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
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: PatientListTileWidget(
                              patient: snapshot.data![index],
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.secondary,
          size: 30,
        ),
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
