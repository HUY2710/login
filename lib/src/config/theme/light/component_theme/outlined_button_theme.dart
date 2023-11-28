part of '../light_theme.dart';

class MyOutlinedButtonTheme extends OutlinedButtonThemeData {
  @override
  ButtonStyle? get style => OutlinedButton.styleFrom(
        side: const BorderSide(
          color: MyColors.primary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        foregroundColor: MyColors.primary,
      );
}
