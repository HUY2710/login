import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../module/iap/my_purchase_manager.dart';
import '../src/config/di/di.dart';
import '../src/config/navigation/app_router.dart';
import '../src/config/observer/route_observer.dart';
import '../src/config/theme/light/light_theme.dart';
import '../src/shared/enum/language.dart';
import 'cubit/language_cubit.dart';
import 'cubit/native_ad_status_cubit.dart';
import 'cubit/rate_status_cubit.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double get designWidth => 390; //default
  double get designHeight => 844; //default

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<LanguageCubit>(),
        ),
        BlocProvider(
          create: (context) => NativeAdStatusCubit(),
        ),
        BlocProvider(
          create: (context) => RateStatusCubit(),
        ),
        BlocProvider(
          create: (context) => getIt<MyPurchaseManager>(),
        )
      ],
      child: ScreenUtilInit(
        designSize: Size(designWidth, designHeight),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: true,
        builder: (context, child) => GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: const BodyApp(),
        ),
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
    return BlocBuilder<LanguageCubit, Language>(
      builder: (context, state) => MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(state.languageCode),
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        // darkTheme: darkThemeData, //optional
        routerConfig: getIt<AppRouter>().config(
          navigatorObservers: () => [MainRouteObserver()],
        ),
        builder: EasyLoading.init(),
      ),
    );
  }
}
