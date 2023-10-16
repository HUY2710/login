import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../service/app_ad_id_manager.dart';
import '../../../shared/enum/ads/ad_remote_key.dart';
import '../../../shared/enum/language.dart';
import '../../../shared/mixin/ads_mixin.dart';
import '../../../shared/widgets/ads/large_native_ad.dart';
import '../../../shared/widgets/ads/large_native_ad_high.dart';
import '../bloc/language_bloc.dart';

@RoutePage()
class LanguageScreen extends StatelessWidget with AdsMixin {
  const LanguageScreen({super.key, this.isFirst});

  final bool? isFirst;

  AppAdIdManager get adManager => getIt<AppAdIdManager>();

  Widget? _buildAd() {
    final bool isVisible = checkVisibleStatus(AdRemoteKeys.native_language);
    if (!isVisible) {
      return null;
    }
    if (isFirst ?? false) {
      return LargeNativeAdHigh(
        unitIdHigh: adManager.adUnitId.nativeLanguage,
        unitId: adManager.adUnitId.nativeLanguage2,
      );
    } else {
      return LargeNativeAd(
        unitId: adManager.adUnitId.nativeLanguage3,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LanguageCubit(),
      child: Scaffold(
        body: SafeArea(child: _BodyWidget(isFirst)),
        bottomNavigationBar: _buildAd(),
      ),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget(this.isFirst);

  final bool? isFirst;

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  final LanguageCubit languageCubit = getIt<LanguageCubit>();
  late String oldLanguage;

  @override
  void initState() {
    languageCubit.state.maybeWhen(
      loaded: (language) => oldLanguage = language,
      orElse: () => oldLanguage = Language.english.languageCode,
    );
    super.initState();
  }

  void changeLanguage(String language) {
    languageCubit.changeLanguage(language);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: <Widget>[
              if (widget.isFirst == null || widget.isFirst == false)
                IconButton(
                  onPressed: () {
                    context.popRoute();
                    changeLanguage(oldLanguage);
                  },
                  icon: const Icon(Icons.abc),
                ),
              Expanded(
                child: Text(
                  'Language',
                  style:
                      TextStyle(fontWeight: FontWeight.w700, fontSize: 20.sp),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (widget.isFirst == null || widget.isFirst == false) {
                    context.popRoute();
                  } else {
                    context.replaceRoute(const OnBoardingRoute());
                  }
                },
                icon: const Icon(
                  Icons.check,
                ),
                // color: context.colorScheme.primary,
              )
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<LanguageCubit, LanguageState>(
            bloc: languageCubit,
            builder: (context, state) {
              return state.when(
                initial: () => const SizedBox(),
                loaded: (String language) {
                  return ListView.builder(
                    itemCount: Language.values.length,
                    itemBuilder: (BuildContext context1, int index) {
                      final Language item = Language.values[index];
                      return _buildItemLanguage(
                        context: context,
                        language: item,
                        value: language,
                        onTap: changeLanguage,
                      );
                    },
                  );
                },
                error: (String message) => Center(child: Text(message)),
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
  required String value,
  required CallbackFunction onTap,
}) {
  return GestureDetector(
    onTap: () => onTap(language.languageCode),
    child: Card(
      surfaceTintColor: const Color(0xffD9D9D9),
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Color(0xffD9D9D9),
          width: 0.2,
        ),
      ),
      child: ListTile(
        title: Text(
          language.languageName,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
        ),
        leading: Image.asset(
          language.flagPath,
          width: 36.w,
          height: 24.h,
        ),
        trailing: Transform.scale(
          scale: 1.3,
          child: Radio<String>(
            value: language.languageCode,
            groupValue: value,
            onChanged: (String? value) => onTap(value ?? 'en'),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            // fillColor: MaterialStateProperty.resolveWith<Color?>(
            //   (Set<MaterialState> states) {
            //     if (states.contains(MaterialState.selected)) {
            //       return context.colorScheme.primary;
            //     }
            //     return const Color(0xffC6C6C6);
            //   },
            // ),
          ),
        ),
      ),
    ),
  );
}

typedef CallbackFunction = void Function(String data);
