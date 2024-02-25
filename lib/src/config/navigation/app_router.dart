import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../presentation/chat/chat_detail_screen.dart';
import '../../presentation/chat/chat_screen.dart';
import '../../presentation/create/screens/create_group_avatar_screen.dart';
import '../../presentation/create/screens/create_group_name_screen.dart';
import '../../presentation/create/screens/create_user_avatar_screen.dart';
import '../../presentation/create/screens/create_username_screen.dart';
import '../../presentation/create/screens/join_group_screen.dart';
import '../../presentation/create/screens/share_code_group.dart';
import '../../presentation/guide/guide_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/language/screen/language_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/permission/permission_screen.dart';
import '../../presentation/premium/premium_screen.dart';
import '../../presentation/place/cubit/select_place_cubit.dart';
import '../../presentation/place/select_location_place.dart';
import '../../presentation/setting/about_screen.dart';
import '../../presentation/setting/edit_infor_screen.dart';
import '../../presentation/setting/map_type/map_type_screen.dart';
import '../../presentation/setting/setting_screen.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../shared/enum/language.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes => <AutoRoute>[
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LanguageRoute.page),
        AutoRoute(page: OnBoardingRoute.page),
        AutoRoute(page: CreateUsernameRoute.page),
        AutoRoute(page: CreateUserAvatarRoute.page),
        AutoRoute(page: CreateGroupNameRoute.page),
        AutoRoute(page: CreateGroupAvatarRoute.page),
        AutoRoute(page: ShareCodeGroupRoute.page),
        AutoRoute(page: PermissionRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: SettingRoute.page),
        AutoRoute(page: ChatRoute.page),
        AutoRoute(page: ChatDetailRoute.page),
        AutoRoute(page: JoinGroupRoute.page),
        AutoRoute(page: PremiumRoute.page),
        AutoRoute(page: SelectLocationPlaceRoute.page),
        AutoRoute(page: MapTypeRoute.page),
        AutoRoute(page: EditInfoRoute.page),
        AutoRoute(page: GuideRoute.page),
      ];

  AutoRoute routeWithFadeTransition(
      {required PageInfo<void> page, bool initial = false}) {
    return CustomRoute(
      page: page,
      initial: initial,
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}
