import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/cubit/language_cubit.dart';
import '../../../config/navigation/app_router.dart';
import '../../../gen/colors.gen.dart';
import '../../../shared/cubit/value_cubit.dart';
import '../../../shared/enum/language.dart';
import '../../../shared/extension/context_extension.dart';

@RoutePage()
class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key, this.isFirst,});

  final bool? isFirst;

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    final Language currentLanguage = context.read<LanguageCubit>().state;
    return BlocProvider(
      create: (context) => ValueCubit<Language>(currentLanguage),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.h,
          leading: (widget.isFirst == null || widget.isFirst == false)
              ? IconButton(
            onPressed: () => context.popRoute(),
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
          )
              : null,
          title: Text(
            context.l10n.language,
            style: TextStyle(
              fontSize: 24.sp,
            ),
          ),
          actions: [_buildAcceptButton()],
        ),
        body: SafeArea(child: _BodyWidget(widget.isFirst,)),
      ),
    );
  }

  Builder _buildAcceptButton() {
    return Builder(builder: (context) {
      return IconButton(
        onPressed: () {
          final Language selectedLanguage =
              context.read<ValueCubit<Language>>().state;
          context.read<LanguageCubit>().update(selectedLanguage);
          if (widget.isFirst == null || widget.isFirst == false) {
            context.popRoute();
          } else {
            context.replaceRoute(const OnBoardingRoute());
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
                      selectedValue: state,);
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
  return GestureDetector(
    onTap: () => selectedLanguageCubit.update(language),
    child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: MyColors.primary.shade100,
        ),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16).w,
            child: Image.asset(
              language.flagPath,
              width: 24.w,
              height: 24.h,
            ),
          ),
          Expanded(
            child: Text(
              language.languageName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Radio<Language>(
            value: language,
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return context.colorScheme.primary;
              }
              return MyColors.primary.shade100;
            }),
            groupValue: selectedValue,
            onChanged: (Language? value) =>
                selectedLanguageCubit.update(language),
          )
        ],
      ),
    ),
  );
}
