import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/navigation/app_router.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../data/models/store_message/store_message.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../../shared/cubit/value_cubit.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/extension/int_extension.dart';
import '../../../shared/helpers/valid_helper.dart';
import '../../onboarding/widgets/app_button.dart';

@RoutePage()
class CreateGroupNameScreen extends StatelessWidget {
  CreateGroupNameScreen({super.key});
  final ValueCubit<String> groupNameCubit = ValueCubit('');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.popRoute();
          },
          icon: Assets.icons.icBack.svg(
            height: 28.h,
            colorFilter: ColorFilter.mode(
              context.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          children: [
            Align(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.createOrJoinGroup,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF343434),
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                    ),
                  ),
                  24.verticalSpace,
                  Assets.images.markers.profileMaker.image(height: 100.h),
                  24.verticalSpace,
                  SizedBox(
                    width: 200.w,
                    child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        final validName =
                            ValidHelper.containsSpecialCharacters(value);
                        if (!validName) {
                          groupNameCubit.update(value.trimLeft().trimRight());
                        } else {
                          groupNameCubit.update('');
                        }
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: context.l10n.groupNameText,
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 36.h, right: 16.w, left: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ValueCubit<String>, String>(
              bloc: groupNameCubit,
              builder: (context, state) {
                return AppButton(
                  title: context.l10n.continueText,
                  isEnable: state.trimLeft().trimRight().isNotEmpty,
                  onTap: () {
                    Global.instance.group ??= StoreGroup(
                      idGroup: 24.randomString(),
                      passCode: 6.randomUpperCaseString().toUpperCase(),
                      groupName: ValidHelper.removeExtraSpaces(state),
                      avatarGroup: '',
                      lastMessage: MessageModel(
                        content: '',
                        senderId: Global.instance.user!.code,
                        sentAt: DateTime.now().toIso8601String(),
                      ),
                    );

                    debugPrint('GroupGlobal:${Global.instance.group}');
                    context.pushRoute(CreateGroupAvatarRoute());
                  },
                  isShowIcon: true,
                );
              },
            ),
            16.verticalSpace,
            AppButton(
              title: context.l10n.joinAGroup,
              onTap: () {
                context.pushRoute(JoinGroupRoute());
              },
              isShowIcon: true,
            ),
          ],
        ),
      ),
    );
  }
}
