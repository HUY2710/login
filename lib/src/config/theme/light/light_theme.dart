import 'package:flutter/material.dart';

import '../../../gen/colors.gen.dart';

part 'component_theme/text_theme.dart';

ThemeData lightThemeData = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: MyColors.primary,
  ),
  useMaterial3: true,
  textTheme: MyTextTheme(),
);
