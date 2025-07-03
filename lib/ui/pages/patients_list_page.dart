import 'package:bc_phthalmoscopy/data/patient_list_model.dart';
import 'package:bc_phthalmoscopy/ui/widgets/patient_list_tile_widget.dart';
import 'package:flutter/material.dart';
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

  void fetch() async {
    _future = Future.delayed(
      Duration(seconds: 1),
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
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Image(
                          width: 20,
                          height: 15,
                          image: AssetImage("assets/images/filter_icon.png"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text("Фильтры", style: theme.textTheme.displayLarge),
                    ],
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
                    return const Center(child: CircularProgressIndicator());
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
}
