import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../config/navigation/app_router.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../gen/gens.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/widgets/containers/shadow_container.dart';
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

class GuideScreenState extends State<GuideScreen> {
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyCheckIn = GlobalKey();
  GlobalKey keyPro = GlobalKey();
  GlobalKey keyMember = GlobalKey();
  GlobalKey keyLocation = GlobalKey();
  GlobalKey keyPlace = GlobalKey();
  GlobalKey keyMessage = GlobalKey();
  GlobalKey keyGroup = GlobalKey();
  GlobalKey keySetting = GlobalKey();
  GlobalKey keyButton = GlobalKey();
  @override
  void initState() {
    createTutorial();
    Future.delayed(Duration.zero, showTutorial);
    super.initState();
  }

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
                  CheckInGuide(
                    key: keyCheckIn,
                  ),
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
                    key: keyMember,
                    pathIc: Assets.icons.icPeople.path,
                  ),
                  SizedBox(height: 16.h),
                  ItemRightGuide(
                    pathIc: Assets.icons.icGps.path,
                    key: keyLocation,
                  ),
                  SizedBox(height: 16.h),
                  ItemRightGuide(
                    pathIc: Assets.icons.icPlace.path,
                    key: keyPlace,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50.h,
              left: 16.w,
              right: 16.w,
              child: Row(
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: MyColors.primary,
                                backgroundImage: AssetImage(
                                    Assets.images.avatars.groups.group1.path),
                                radius: 14.r,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
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
      hideSkip: true,
      opacityShadow: 0.5,
      onFinish: () async {
        await SharedPreferencesManager.setGuide(false);
        if (context.mounted) {
          AutoRouter.of(context).replace(const HomeRoute());
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
      // focusAnimationDuration: const Duration(milliseconds: 300),
      // pulseAnimationDuration: const Duration(milliseconds: 700),
      // unFocusAnimationDuration: const Duration(milliseconds: 300),
    );
  }

  List<TargetFocus> _createTargets() {
    return [
      _buildTarget(keyCheckIn, context.l10n.guideCheckIn),
      _buildTarget(keyPro, context.l10n.guidePro),
      _buildTarget(keyMember, context.l10n.guideMember),
      _buildTarget(keyLocation, context.l10n.guideLocation),
      _buildTarget(keyPlace, context.l10n.guidePlace),
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
      radius: radius ?? 20.r,
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
                    style: TextStyle(
                      color: MyColors.black34,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  16.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child: BtnGuide(
                      title: context.l10n.next,
                      onTap: () {
                        tutorialCoachMark.next();
                      },
                    ),
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
