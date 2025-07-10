import 'package:apptomate_custom_snackbar/apptomate_custom_snackbar.dart';
import 'package:flutter/material.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  CustomSnackbar.show(
    context,
    message: message,
    backgroundColor: Theme.of(context).colorScheme.secondary,
    icon: Icons.check_circle,
    duration: const Duration(seconds: 2),
  );
}
