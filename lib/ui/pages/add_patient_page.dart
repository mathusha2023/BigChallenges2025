import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Добавьте нового пациента", style: theme.textTheme.titleLarge),
            Text(
              'Занесите данные пациента в поля ввода и нажмите кнопку сохранить',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.grey,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 24),

            // Поле ФИО
            Text('ФИО', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextField(
              textCapitalization: TextCapitalization.words,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: "Васильев Василий Васильевич",
              ),
            ),
            const SizedBox(height: 16),

            // Поле Пол
            Text('Пол', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              items: [
                DropdownMenuItem(
                  value: 'male',
                  child: Text('Мужской', style: theme.textTheme.bodyMedium),
                ),
                DropdownMenuItem(
                  value: 'female',
                  child: Text('Женский', style: theme.textTheme.bodyMedium),
                ),
              ],
              onChanged: (value) {},
              hint: const Text('Выберите пол'),
            ),
            const SizedBox(height: 16),

            // Поле Дата рождения
            Text('Дата рождения', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextField(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  locale: const Locale("ru", "RU"),
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                // Обработка выбранной даты
              },
              decoration: InputDecoration(hintText: 'ДД.ММ.ГГГГ'),
              readOnly: true,
            ),
            const Spacer(),

            // Кнопка Сохранить
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Логика сохранения
                },
                child: const Text('Сохранить', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
