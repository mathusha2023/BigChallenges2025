import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(56); // or any other size you want

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 100, // Фиксированная ширина для leading
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque, // Кликабельная область
        onTap: () => Navigator.pop(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 8), // Отступ слева
          child: Row(
            mainAxisSize: MainAxisSize.min, // Важно!
            children: [
              Icon(
                Icons.arrow_back_ios_new_outlined,
                color: theme.colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 4), // Отступ между иконкой и текстом
              Text(
                "Назад",
                style: theme.textTheme.titleSmall?.copyWith(
                  overflow:
                      TextOverflow.visible, // Предотвращаем обрезку текста
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
