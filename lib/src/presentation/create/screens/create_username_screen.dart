import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/navigation/app_router.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../../shared/cubit/value_cubit.dart';
import '../../../shared/helpers/valid_helper.dart';
import '../../onboarding/widgets/app_button.dart';

@RoutePage()
class CreateUsernameScreen extends StatelessWidget {
  CreateUsernameScreen({super.key});

  void changedUsername(String username) {
    Global.instance.user = Global.instance.user?.copyWith(
      userName: ValidHelper.removeExtraSpaces(username),
    );
  }

  final TextEditingController userNameCtrl = TextEditingController(text: '');
  final ValueCubit<String> userNameCubit = ValueCubit('');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Let’s get started',
                    style: TextStyle(
                      color: const Color(0xFF343434),
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    'What’s your name?',
                    style: TextStyle(
                      color: const Color(0xFF343434),
                      fontWeight: FontWeight.w500,
                      fontSize: 24.sp,
                    ),
                  ),
                  24.verticalSpace,
                  Assets.images.markers.profileMaker.image(height: 100.h),
                  24.verticalSpace,
                  SizedBox(
                    width: 200.w,
                    child: TextField(
                      controller: userNameCtrl,
                      textAlign: TextAlign.center,
                      onEditingComplete: () {},
                      onSubmitted: (value) {
                        final validName =
                            ValidHelper.containsSpecialCharacters(value);
                        if (!validName) {
                          userNameCubit.update(value);
                        } else {
                          Fluttertoast.showToast(msg: 'Not valid user name');
                        }
                      },
                      onChanged: (value) {
                        final validName =
                            ValidHelper.containsSpecialCharacters(value);
                        if (!validName) {
                          userNameCubit.update(value);
                        } else {
                          userNameCubit.update('');
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Your name',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          color: const Color(0xFFCCADFF),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                        color: const Color(0xFFCCADFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36.h),
              child: BlocBuilder<ValueCubit<String>, String>(
                bloc: userNameCubit,
                builder: (context, state) {
                  return AppButton(
                    title: 'Continue',
                    isEnable: state.isNotEmpty,
                    onTap: () {
                      changedUsername(userNameCtrl.text);
                      context.pushRoute(const CreateUserAvatarRoute());
                    },
                    isShowIcon: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
