import 'package:flutter/material.dart';

Future<void> showBottomTypeOfHome({
  required BuildContext context,
  required Widget child,
  bool? isScrollControlled,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled ?? false,
    barrierColor: Colors.white.withOpacity(0.1),
    builder: (context) {
      return child;
    },
  );
}
