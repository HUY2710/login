import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../module/iap/my_purchase_manager.dart';
import '../src/config/di/di.dart';
import '../src/config/navigation/app_router.dart';
import '../src/config/observer/route_observer.dart';
import '../src/config/theme/light/light_theme.dart';
import '../src/presentation/home/cubit/banner_collapse_cubit.dart';
import '../src/presentation/sign_in/cubit/authen_cubit.dart';
import '../src/presentation/sign_in/cubit/join_anonymous_cubit.dart';
import '../src/shared/enum/language.dart';
import '../src/shared/widgets/dialog/no_internet_dialog.dart';
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
    // ActivityRecognitionService.instance.initActivityRecognitionService();
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
          create: (context) => JoinAnonymousCubit(),
        ),
        BlocProvider(
          create: (context) => getIt<MyPurchaseManager>(),
        ),
        BlocProvider(create: (context) => getIt<LoadingCubit>()),
        BlocProvider(create: (context) => AuthCubit()..appStarted())
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

class BodyApp extends StatefulWidget {
  const BodyApp({
    super.key,
  });

  @override
  State<BodyApp> createState() => _BodyAppState();
}

class _BodyAppState extends State<BodyApp> {
  bool shownDialog = false;
  late final StreamSubscription internetListener;
  void listenInternet() {
    internetListener = InternetConnection()
        .onStatusChange
        .listen((InternetStatus status) async {
      switch (status) {
        case InternetStatus.connected:
          if (shownDialog) {
            shownDialog = false;
            getIt<AppRouter>().navigatorKey.currentContext!.popRoute();
          }
          break;
        case InternetStatus.disconnected:
          if (!shownDialog) {
            shownDialog = true;
            context.read<NativeAdStatusCubit>().update(false);
            getIt<BannerCollapseAdCubit>().update(false);
            showDialog(
                barrierDismissible: false,
                context: getIt<AppRouter>().navigatorKey.currentContext!,
                builder: (context) => const NoIternetDialog()).then((_) {
              context.read<NativeAdStatusCubit>().update(true);
              getIt<BannerCollapseAdCubit>().update(true);
            });
          }
          break;
      }
      await Future.delayed(const Duration(seconds: 3));
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listenInternet();
    });
    super.initState();
  }

  @override
  void dispose() {
    internetListener.cancel();
    super.dispose();
  }

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
            }),
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
