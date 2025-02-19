import 'package:auto_route/auto_route.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../gen/gens.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/widgets/containers/shadow_container.dart';
import '../place/cubit/default_places_cubit.dart';
import 'widgets/btn.dart';
import 'widgets/checkin_guide.dart';
import 'widgets/item_bottom.dart';
import 'widgets/item_right.dart';
import 'widgets/pro_guider.dart';

@RoutePage()
class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  GuideScreenState createState() => GuideScreenState();
}

class GuideScreenState extends State<GuideScreen> with WidgetsBindingObserver {
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyCheckIn = GlobalKey();
  GlobalKey keyPro = GlobalKey();
  GlobalKey keyMember = GlobalKey();
  GlobalKey keyLocation = GlobalKey();
  GlobalKey keyAddMember = GlobalKey();
  GlobalKey keyPlace = GlobalKey();
  GlobalKey keyMessage = GlobalKey();
  GlobalKey keyGroup = GlobalKey();
  GlobalKey keySetting = GlobalKey();
  GlobalKey keyButton = GlobalKey();
  GlobalKey keySos = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getIt<DefaultPlaceCubit>().update(defaultListPlace);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      createTutorial();
      Future.delayed(Duration.zero, showTutorial);
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(true);
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    EasyAds.instance.appLifecycleReactor?.setIsExcludeScreen(false);
    super.dispose();
  }

  //check xem có null không

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset(Assets.images.home.path).image,
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: ScreenUtil().statusBarHeight == 0
                  ? 20.h
                  : ScreenUtil().statusBarHeight,
              left: 16.w,
              right: 70.w,
              child: Row(
                children: [
                  CheckInGuide(key: keyCheckIn),
                  12.horizontalSpace,
                  ProGuide(key: keyPro),
                ],
              ),
            ),
            Positioned(
              top: ScreenUtil().statusBarHeight == 0
                  ? 20.h
                  : ScreenUtil().statusBarHeight,
              right: 16.w,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ItemRightGuide(
                    key: keyAddMember,
                    pathIc: Assets.icons.icAddMember.path,
                  ),
                  SizedBox(height: 16.h),
                  ItemRightGuide(
                    key: keyMember,
                    pathIc: Assets.icons.icPeople.path,
                  ),
                  SizedBox(height: 16.h),
                  ItemRightGuide(
                    pathIc: Assets.icons.icPlace.path,
                    key: keyPlace,
                  ),
                  SizedBox(height: 16.h),
                  Image.asset(
                    Assets.images.sosBtn.path,
                    width: 40.r,
                    height: 40.r,
                    fit: BoxFit.cover,
                    key: keySos,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50.h,
              left: 16.w,
              right: 16.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ItemRightGuide(
                      pathIc: Assets.icons.icGps.path,
                      key: keyLocation,
                    ),
                  ),
                  20.verticalSpace,
                  Row(
                    children: [
                      ItemBottomGuide(
                        path: Assets.icons.icMessage.path,
                        key: keyMessage,
                      ),
                      16.horizontalSpace,
                      Expanded(
                          key: keyGroup,
                          child: GestureDetector(
                            onTap: () {},
                            child: ShadowContainer(
                              maxWidth: MediaQuery.sizeOf(context).width - 80.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 10.h),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.widgetBorderRadius.r),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: MyColors.primary,
                                    backgroundImage: AssetImage(Assets
                                        .images.avatars.groups.group1.path),
                                    radius: 14.r,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w),
                                      child: Text(
                                        context.l10n.newGroup,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: const Color(0xff8E52FF),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: MyColors.primary,
                                  )
                                ],
                              ),
                            ),
                          )),
                      16.horizontalSpace,
                      ItemBottomGuide(
                        path: Assets.icons.icSetting.path,
                        key: keySetting,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      opacityShadow: 0.5,
      hideSkip: true,
      onFinish: () async {
        await SharedPreferencesManager.setGuide(false);
        if (context.mounted) {
          AutoRouter.of(context).replace(PremiumRoute(fromStart: true));
        }
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print('target: $target');
        print(
            'clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}');
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print('skip');
        return true;
      },
      focusAnimationDuration: const Duration(milliseconds: 400),
      // pulseAnimationDuration: const Duration(milliseconds: 700),
      unFocusAnimationDuration: const Duration(milliseconds: 400),
    );
  }

  List<TargetFocus> _createTargets() {
    return [
      _buildTarget(keyCheckIn, context.l10n.guideCheckIn),
      _buildTarget(keyPro, context.l10n.guidePro),
      _buildTarget(keyAddMember, context.l10n.guideAddMember),
      _buildTarget(keyMember, context.l10n.guideMember),
      _buildTarget(keyPlace, context.l10n.guidePlace),
      _buildTarget(keySos, context.l10n.guideSos),
      _buildTarget(keyLocation, context.l10n.guideLocation,
          align: ContentAlign.top),
      _buildTarget(keyMessage, context.l10n.guideMessenger,
          align: ContentAlign.top),
      _buildTarget(keyGroup, context.l10n.guideGroup,
          radius: 15.r, align: ContentAlign.top),
      _buildTarget(keySetting, context.l10n.guideSetting,
          radius: 15.r, align: ContentAlign.top),
    ];
  }

  TargetFocus _buildTarget(GlobalKey key, String content,
      {double? radius, ContentAlign align = ContentAlign.bottom}) {
    return TargetFocus(
      keyTarget: key,
      shape: ShapeLightFocus.RRect,
      radius: radius ?? 10.r,
      enableTargetTab: false,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            return ShadowContainer(
              padding: EdgeInsets.all(16.r),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
              child: Column(
                children: [
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors.black34,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  16.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          tutorialCoachMark.finish();
                        },
                        child: Text(context.l10n.skip),
                      ),
                      BtnGuide(
                        title: context.l10n.next,
                        onTap: () {
                          tutorialCoachMark.next();
                        },
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
