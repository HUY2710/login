import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../src/config/di/di.dart';
import '../src/config/navigation/app_router.dart';
import '../src/config/observer/route_observer.dart';
import '../src/config/theme/light/light_theme.dart';
import 'cubit/app_cubit.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double get designWidth => 360; //default
  double get designHeight => 800; //default

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(designWidth, designHeight),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      builder: (context, child) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BodyApp(),
      ),
    );
  }
}

class BodyApp extends StatelessWidget {
  const BodyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      bloc: getIt<AppCubit>()..init(),
      builder: (context, state) => MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(state.currentLanguage.languageCode),
        theme: lightThemeData,
        // darkTheme: darkThemeData, //optional
        routerConfig: getIt<AppRouter>().config(
          navigatorObservers: () => [MainRouteObserver()],
        ),
      ),
    );
  }
}
