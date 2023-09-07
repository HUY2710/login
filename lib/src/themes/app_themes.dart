import 'package:flutter/material.dart';

import '../gen/fonts.gen.dart';
import 'app_colors.dart';

class AppThemes {
  AppThemes._();
  static ThemeData light() {
    return getThemeData(
      Brightness.light,
      const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondaryDefault,
        onBackground: AppColors.backgroundLight,
      ),
    );
  }

  static ThemeData dark() {
    return getThemeData(
      Brightness.dark,
      const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondaryDefault,
        background: AppColors.backgroundDark,
        onBackground: AppColors.backgroundDark,
        surface: AppColors.black,
      ),
    );
  }

  static ThemeData getThemeData(
    Brightness brightness,
    ColorScheme colorScheme,
  ) {
    final bool isDark = colorScheme.brightness == Brightness.dark;
    final primaryText = isDark ? AppColors.white : AppColors.neutral01;
    return ThemeData(
      fontFamily: FontFamily.openSans,
      brightness: brightness,
      colorScheme: colorScheme.copyWith(
        background: isDark ? AppColors.backgroundDark : AppColors.background,
      ),
      primaryColor: AppColors.primary,
      unselectedWidgetColor: AppColors.neutral02,
      scaffoldBackgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.scaffoldBackground,
      canvasColor: AppColors.white,
      indicatorColor: AppColors.primary,
      dividerColor: AppColors.neutral05,
      appBarTheme: AppBarTheme(
        color: isDark ? AppColors.black : AppColors.white,
        foregroundColor: isDark ? AppColors.white : AppColors.neutral02,
        iconTheme: IconThemeData(
          color: isDark ? AppColors.white : AppColors.neutral01,
        ),
        elevation: 0.3,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.white : AppColors.neutral01,
          fontFamily: FontFamily.openSans,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.black : AppColors.white,
        selectedItemColor: isDark ? AppColors.white : AppColors.primary,
        unselectedItemColor: isDark ? AppColors.neutral04 : AppColors.neutral02,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral05,
        thickness: 0.5,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(46, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          foregroundColor: AppColors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 20 / 16,
            fontFamily: FontFamily.openSans,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.neutral01,
          textStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            fontFamily: FontFamily.openSans,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(46, 46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: AppColors.neutral01),
          foregroundColor: AppColors.neutral01,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 20 / 16,
            fontFamily: FontFamily.openSans,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: AppColors.white,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 56,
          height: 72 / 56,
        ),
        displayMedium: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 42,
          height: 52 / 42,
        ),
        displaySmall: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 36,
          height: 48 / 36,
        ),
        headlineLarge: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 28,
          height: 36 / 28,
        ),
        headlineMedium: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 24,
          height: 32 / 24,
        ),
        headlineSmall: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          height: 28 / 20,
        ),
        titleLarge: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          height: 24 / 18,
        ),
        titleMedium: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 18 / 14,
        ),
        titleSmall: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          height: 18 / 14,
        ),
        bodyLarge: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 20 / 16,
        ),
        bodyMedium: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 18 / 14,
        ),
        bodySmall: TextStyle(
          color: primaryText,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          height: 16 / 12,
        ),
      ).apply(
        fontFamily: FontFamily.openSans,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: AppColors.white,
        // constraints: const BoxConstraints(
        //   minHeight: 40,
        // ),
        contentPadding: const EdgeInsets.all(14),
        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.neutral04,
          fontWeight: FontWeight.w400,
          height: 18 / 14,
          fontFamily: FontFamily.openSans,
        ),
        errorStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.errorDefault,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.openSans,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutral04),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutral04),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutral06),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorDefault),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.errorDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.neutral01),
        ),
      ),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: AppColors.neutral04,
        labelColor: isDark ? AppColors.white : AppColors.neutral01,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: FontFamily.openSans,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return null;
        }),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.zero,
        dense: true,
        horizontalTitleGap: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        visualDensity: VisualDensity.compact,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ).copyWith(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.neutral07;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.neutral06;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.neutral07;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.neutral06;
        }),
      ),
    );
  }
}
