import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
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
import '../../../shared/constants/app_constants.dart';
import '../../../shared/cubit/value_cubit.dart';
import '../../../shared/enum/language.dart';
import '../../../shared/extension/context_extension.dart';

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

class _LanguageScreenState extends State<LanguageScreen> {
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
          toolbarHeight: 56.h,
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
          } else {
            await SharedPreferencesManager.saveIsFirstLaunch(false);
            if (mounted) {
              context.replaceRoute(OnBoardingRoute(language: selectedLanguage));
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
        border: isSelected
            ? Border.all(
                color: MyColors.primary,
              )
            : null,
        borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
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
              ),
            ),
          ),
          if (isSelected)
            Radio(
              value: true,
              groupValue: true,
              onChanged: (val) {},
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
            ),
        ],
      ),
    ),
  );
}
