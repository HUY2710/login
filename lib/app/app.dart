import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../module/iap/my_purchase_manager.dart';
import '../src/config/di/di.dart';
import '../src/config/navigation/app_router.dart';
import '../src/config/observer/route_observer.dart';
import '../src/config/theme/light/light_theme.dart';
import '../src/services/activity_recognition_service.dart';
import '../src/shared/enum/language.dart';
import '../src/shared/widgets/loading/loading_indicator.dart';
import 'cubit/language_cubit.dart';
import 'cubit/loading_cubit.dart';
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
  void initState() {
    super.initState();
    ActivityRecognitionService.instance.initActivityRecognitionService();
  }

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
        ),
        BlocProvider(create: (context) => getIt<LoadingCubit>())
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
          deepLinkBuilder: (deepLink) {
            debugPrint('DEEPLINK===>');
            debugPrint(deepLink.path);
            if (deepLink.path.startsWith('/code')) {
              return DeepLink([JoinGroupRoute()]);
            } else {
              return DeepLink.defaultPath;
            }
          }
        ),
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              BlocBuilder<LoadingCubit, bool>(
                builder: (context, loadingState) {
                  return loadingState
                      ? buildLoading(loadingState)
                      : const SizedBox();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Positioned buildLoading(bool loadingState) {
    return Positioned.fill(
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: Colors.black54),
        child: SizedBox(
          height: 100.r,
          width: 100.r,
          child: LoadingIndicator(
            colors: const [
              Color.fromARGB(255, 113, 63, 207),
              Color(0xffB78CFF),
              Color(0xffD2B0FF)
            ],
            pause: !loadingState,
            indicatorType: Indicator.ballScaleMultiple,
          ),
        ),
      ),
    );
  }
}
