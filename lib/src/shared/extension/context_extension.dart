import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  InputDecorationTheme get inputDecoration =>
      Theme.of(this).inputDecorationTheme;
  Color get primary => Theme.of(this).primaryColor;
}

extension StringExtensions on String {
  String capitalize() {
    // ignore: prefer_single_quotes
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
