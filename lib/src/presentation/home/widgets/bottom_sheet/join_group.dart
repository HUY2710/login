import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../../app/cubit/loading_cubit.dart';
import '../../../../config/di/di.dart';
import '../../../../config/navigation/app_router.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../shared/extension/context_extension.dart';
import '../../../../shared/widgets/my_drag.dart';
import '../../cubit/banner_collapse_cubit.dart';
import '../../cubit/validate_code/code_validation_cubit.dart';

class JoinGroupWidget extends StatefulWidget {
  const JoinGroupWidget({super.key});

  @override
  State<JoinGroupWidget> createState() => _JoinGroupWidgetState();
}

class _JoinGroupWidgetState extends State<JoinGroupWidget> {
  final CodeValidationCubit codeValidCubit = getIt<CodeValidationCubit>();
  @override
  Widget build(BuildContext context) {
    getIt<BannerCollapseAdCubit>().update(false);
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MyDrag(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: IconButton.filled(
                      splashRadius: 10,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => const Color(0xffD5BBFF))),
                      padding: const EdgeInsets.all(0),
                      onPressed: () => context.popRoute(),
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14.r,
                      )),
                ),
                Text(
                  context.l10n.joinTheGroup,
                  style: TextStyle(
                    color: MyColors.black34,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 24.r,
                  height: 24.r,
                ),
              ],
            ),
            60.verticalSpace,
            Text(
              context.l10n.joinGroupContent,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.4,
                  color: MyColors.black34),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                textStyle: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    color: MyColors.black34),
                length: 6,
                textCapitalization: TextCapitalization.characters,
                // obscureText: false,
                // obscuringCharacter: '*',
                // obscuringWidget: const FlutterLogo(
                //   size: 24,
                // ),

                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                    inactiveColor: MyColors.secondPrimary,
                    activeColor: MyColors.secondPrimary,
                    shape: PinCodeFieldShape.underline,
                    borderRadius: BorderRadius.circular(50),
                    fieldHeight: 50.h,
                    fieldWidth: 32.w,
                    activeFillColor: Colors.transparent,
                    selectedColor: MyColors.primary,
                    inactiveFillColor: Colors.transparent,
                    selectedFillColor: Colors.transparent,
                    activeBorderWidth: 4.r,
                    borderWidth: 4.r,
                    inactiveBorderWidth: 4.r,
                    selectedBorderWidth: 4.r,
                    disabledBorderWidth: 4.r),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                // errorAnimationController: errorController,
                // controller: textEditingController,
                keyboardType: TextInputType.text,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onCompleted: (code) async {
                  debugPrint('Completed');
                  // EasyLoading.show();
                  showLoading();
                  await codeValidCubit.submit(code, context);
                  // EasyLoading.dismiss();
                  hideLoading();
                },
                // onTap: () {
                //   print("Pressed");
                // },
                onChanged: (value) {
                  debugPrint(value);
                  // setState(() {
                  //   currentText = value;
                  // });
                },
                beforeTextPaste: (text) {
                  debugPrint('Allowing to paste $text');
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
            ),
            BlocConsumer<CodeValidationCubit, CodeValidationState>(
              bloc: codeValidCubit,
              listener: (context, state) {
                state.maybeWhen(
                    orElse: () {},
                    valid: (group) {
                      Fluttertoast.showToast(msg: context.l10n.joinAGroup);
                      context.popRoute();
                    });
              },
              builder: (context, state) {
                return BlocBuilder<CodeValidationCubit, CodeValidationState>(
                  bloc: codeValidCubit,
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => SizedBox(height: 30.h),
                      inValid: (error) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Text(error,
                              style: const TextStyle(
                                color: Colors.red,
                              )),
                        );
                      },
                    );
                  },
                );
              },
            ),
            Text(
              context.l10n.joinGroupSub,
              style: TextStyle(color: const Color(0xff343434), fontSize: 13.sp),
            ),
            TextButton(
                onPressed: () => context.pushRoute(const JoinQrCodeRoute()),
                child: Text(
                  context.l10n.joinGroupQr,
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color(0xff8E52FF),
                      fontWeight: FontWeight.w500),
                )),
            20.h.verticalSpace,
          ],
        ),
      ),
    );
  }
}
