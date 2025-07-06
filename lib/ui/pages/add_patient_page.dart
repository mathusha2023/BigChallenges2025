import 'package:bc_phthalmoscopy/ui/widgets/my_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:go_router/go_router.dart';

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  int _selectedGender = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

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
              controller: _nameController,
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
              value: _selectedGender == 0 ? 'male' : 'female',
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
              onChanged: (value) {
                setState() {
                  if (value == "male") {
                    _selectedGender = 0;
                  }
                  if (value == "female") {
                    _selectedGender = 1;
                  }
                }
              },
              hint: const Text('Выберите пол'),
            ),
            const SizedBox(height: 16),

            // Поле Дата рождения
            Text('Дата рождения', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            TextField(
              onTap: () {
                _openDatePicker(context);
                // Обработка выбранной даты
              },
              controller: _dateController,
              decoration: InputDecoration(hintText: 'ДД.ММ.ГГГГ'),
              readOnly: true,
            ),
            SizedBox(height: 50),
            // Кнопка Сохранить
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _dateController.text.isNotEmpty) {
                    // Отправка данных на сервер
                    context.pop();
                  }
                },

                child: Text(
                  'Сохранить',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      dismissable: true,
      pickerTitle: Text(
        'Выберите дату',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      dateOrder: DatePickerDateOrder.dmy,
      initialDateTime: _selectedDate ?? DateTime.now(),
      maxDateTime: DateTime.now(),
      minDateTime: DateTime(1900),
      pickerTextStyle: Theme.of(context).textTheme.displayLarge ?? TextStyle(),
      buttonContent: Text(
        "Выбрать",
        style: Theme.of(context).textTheme.bodyLarge,
        textAlign: TextAlign.center,
      ),
      buttonWidth: MediaQuery.of(context).size.width * 0.5,
      buttonStyle: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(15),
      ),
      onSubmit: (value) {
        setState(() {
          _selectedDate = value;
          _dateController.text =
              "${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year.toString().padLeft(4, '0')}";
        });
      },
      // bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }
}
