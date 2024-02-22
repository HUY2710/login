import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../gen/gens.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/mixin/permission_mixin.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../home/cubit/validate_code/code_validation_cubit.dart';

@RoutePage()
class JoinGroupScreen extends StatelessWidget with PermissionMixin {
  JoinGroupScreen({super.key});
  final CodeValidationCubit codeValidCubit = getIt<CodeValidationCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'Joining a group? Enter your invite code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MyColors.black34,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: 24.r,
                height: 24.r,
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
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  textCapitalization: TextCapitalization.characters,
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
                    EasyLoading.show();
                    await codeValidCubit.submit(code, context);
                    EasyLoading.dismiss();
                  },
                  onChanged: (value) {
                    debugPrint(value);
                  },
                  beforeTextPaste: (text) {
                    debugPrint('Allowing to paste $text');
                    return true;
                  },
                ),
              ),
              20.verticalSpace,
              Text(
                context.l10n.joinGroupContent,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.4,
                    color: MyColors.black34),
              ),
              BlocConsumer<CodeValidationCubit, CodeValidationState>(
                bloc: codeValidCubit,
                listener: (context, state) {
                  state.maybeWhen(
                      orElse: () {},
                      valid: (group) async {
                        Fluttertoast.showToast(msg: 'Join group success');
                        await SharedPreferencesManager.saveIsCreateInfoFistTime(
                            false);
                        final bool statusLocation =
                            await checkPermissionLocation();
                        if (!statusLocation && context.mounted) {
                          getIt<AppRouter>().replaceAll(
                              [PermissionRoute(fromMapScreen: false)]);
                          return;
                        } else if (context.mounted) {
                          getIt<AppRouter>().replaceAll([const HomeRoute()]);
                        }
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
