import 'package:bc_phthalmoscopy/common/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

void showFilterBottomSheet(
  BuildContext context,
  Function(bool localMale, bool localFemale, int minAge, int maxAge) setFilters,
  bool male,
  bool female,
  int minAge,
  int maxAge,
) {
  final theme = Theme.of(context);
  bool localMale = male;
  bool localFemale = female;
  final TextEditingController minAgeController = TextEditingController(
    text: minAge.toString(),
  );
  final TextEditingController maxAgeController = TextEditingController(
    text: maxAge.toString(),
  );

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
          builder: (BuildContext context, StateSetter setLocalState) {
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
                          value: localMale,
                          onChanged:
                              (value) =>
                                  setLocalState(() => localMale = value!),
                        ),
                        Text("Женский", style: theme.textTheme.bodyLarge),
                        Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: localFemale,
                          onChanged:
                              (value) =>
                                  setLocalState(() => localFemale = value!),
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
                            controller: minAgeController,
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
                            controller: maxAgeController,
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
                        onPressed: () {
                          if (minAgeController.text.isInteger() &&
                              maxAgeController.text.isInteger()) {
                            int minAge = int.parse(minAgeController.text);
                            int maxAge = int.parse(maxAgeController.text);
                            if (minAge > maxAge) return;
                            setFilters(localMale, localFemale, minAge, maxAge);
                            Navigator.pop(context);
                          }
                        },
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
