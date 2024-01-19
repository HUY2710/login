part of '../light_theme.dart';

class MyIconButtonTheme extends IconButtonThemeData {
  @override
  ButtonStyle? get style => IconButton.styleFrom(
        foregroundColor: MyColors.primary,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        iconSize: 24.r,
      );
}
