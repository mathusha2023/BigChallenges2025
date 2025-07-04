import 'package:flutter/material.dart';

class CheckEyeButtonWidget extends StatelessWidget {
  const CheckEyeButtonWidget({
    super.key,
    required this.isChecked,
    required this.title,
    required this.onTap,
  });
  final String title;
  final bool isChecked;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    if (isChecked) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(
          onPressed: onTap,
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text(title), Icon(Icons.check)],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: ElevatedButton(
          onPressed: onTap,
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            padding: WidgetStatePropertyAll(EdgeInsets.zero),
            backgroundColor: WidgetStatePropertyAll(Colors.grey),
          ),
          child: Text(title),
        ),
      );
    }
  }
}
