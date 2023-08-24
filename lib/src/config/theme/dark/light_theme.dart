import 'package:flutter/material.dart';

import '../../../../gen/colors.gen.dart';

part 'component_theme/text_theme.dart';

ThemeData darkThemeData = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: MyColors.primary,
  ),
  useMaterial3: true,
  textTheme: MyTextTheme(),
);
