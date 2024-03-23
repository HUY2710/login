import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/cubit/language_cubit.dart';
import '../../../../module/admob/app_ad_id_manager.dart';
import '../../../../module/admob/enum/ad_remote_key.dart';
import '../../../../module/admob/widget/ads/large_native_ad.dart';
import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../config/remote_config.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../gen/gens.dart';
import '../../../global/global.dart';
import '../../../shared/constants/app_constants.dart';
import '../../../shared/cubit/value_cubit.dart';
import '../../../shared/enum/language.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/mixin/permission_mixin.dart';

@RoutePage()
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({
    super.key,
    this.isFirst,
  });

  final bool? isFirst;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> with PermissionMixin {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    super.initState();
  }

  Widget? _buildAd() {
    final bool isShow =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.native_language);
    if (!isShow) {
      return null;
    }
    if (widget.isFirst ?? true) {
      return LargeNativeAd(
        unitId: getIt<AppAdIdManager>().adUnitId.nativeLanguage,
        remoteKey: AdRemoteKeys.native_language,
      );
    } else {
      return LargeNativeAd(
        unitId: getIt<AppAdIdManager>().adUnitId.nativeLanguageSetting,
        remoteKey: AdRemoteKeys.native_language_setting,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Language currentLanguage = context.read<LanguageCubit>().state;
    return BlocProvider(
      create: (context) => ValueCubit<Language>(currentLanguage),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 67.h,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: (widget.isFirst == null || widget.isFirst == false)
              ? Center(
                  child: GestureDetector(
                    onTap: () {
                      context.popRoute();
                    },
                    child: Assets.icons.icBack.svg(
                      height: 28.h,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              : null,
          title: Text(
            context.l10n.language,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF343434),
            ),
          ),
          centerTitle: false,
          actions: (widget.isFirst == null || widget.isFirst == false)
              ? []
              : [_buildAcceptButton()],
        ),
        bottomNavigationBar: _buildAd(),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: _BodyWidget(
              widget.isFirst,
            ),
          ),
        ),
      ),
    );
  }

  Builder _buildAcceptButton() {
    return Builder(builder: (context) {
      return IconButton(
        onPressed: () async {
          final Language selectedLanguage =
              context.read<ValueCubit<Language>>().state;
          if (widget.isFirst == null || widget.isFirst == false) {
            context.popRoute();
            return;
          }
          final isFirstLaunch =
              await SharedPreferencesManager.getIsFirstLaunch();
          //Nếu lần đầu dùng app
          if (isFirstLaunch && context.mounted) {
            context.replaceRoute(OnBoardingRoute(language: selectedLanguage));
            return;
          }

          //nếu lần thứ 2 trở lên và chưa login
          final isLogin = await SharedPreferencesManager.isLogin();
          if (!isLogin && !isFirstLaunch && context.mounted) {
            context.replaceRoute(const SignInRoute());
            return;
          }

          //nếu lần thứ 2 trở đi
          if (!isFirstLaunch) {
            //xem có đầy đủ thông tin của user chưa
            if (Global.instance.user?.userName == '' && context.mounted) {
              context.replaceRoute(const CreateUsernameRoute());
              return;
            }
            //Nếu đã qua màn intro và đã tạo thông tin user rồi
            final bool allowPermission = await checkAllPermission();
            if (!allowPermission && context.mounted) {
              context.replaceRoute(PermissionRoute(fromMapScreen: false));
              return;
            }

            //xem đến màn guide chưa
            final showGuide = await SharedPreferencesManager.getGuide();
            if (showGuide && context.mounted) {
              context.replaceRoute(const GuideRoute());
              return;
            } else if (context.mounted) {
              context.replaceRoute(PremiumRoute(fromStart: true));
              return;
            }
          }
        },
        icon: Icon(
          Icons.check,
          color: context.colorScheme.primary,
        ),
      );
    });
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget(this.isFirst);

  final bool? isFirst;

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: BlocBuilder<ValueCubit<Language>, Language>(
            builder: (context, state) {
              return ListView.builder(
                itemCount: Language.values.length,
                itemBuilder: (BuildContext context1, int index) {
                  final Language item = Language.values[index];
                  return _buildItemLanguage(
                    context: context,
                    language: item,
                    selectedValue: state,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget _buildItemLanguage({
  required BuildContext context,
  required Language language,
  required Language selectedValue,
}) {
  final selectedLanguageCubit = context.read<ValueCubit<Language>>();
  final isSelected = language == selectedValue;
  return GestureDetector(
    onTap: () {
      selectedLanguageCubit.update(language);
      getIt<LanguageCubit>().update(language);
    },
    child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
        gradient: isSelected
            ? const LinearGradient(colors: [
                Color(0xffB67DFF),
                Color(0xff7B3EFF),
              ])
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C747D).withOpacity(0.17),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            language.flagPath,
            width: 24.w,
            height: 24.h,
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(
              language.languageName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : MyColors.black34,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
