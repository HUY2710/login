import 'package:flutter/material.dart';

Future<void> showBottomSheetTypeOfHome({
  required BuildContext context,
  required Widget child,
  bool? isScrollControlled,
}) async {
  await showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
    context: context,
    isScrollControlled: isScrollControlled ?? false,
    barrierColor: Colors.white.withOpacity(0.1),
    builder: (context) {
      return child;
    },
  );
}
