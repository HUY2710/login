// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/local/avatar/avatar_repository.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../data/models/avatar/avatar_model.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../../shared/cubit/value_cubit.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../map/cubit/select_group_cubit.dart';
import '../../onboarding/widgets/app_button.dart';

@RoutePage()
class CreateGroupAvatarScreen extends StatelessWidget {
  CreateGroupAvatarScreen({super.key});

  final ValueCubit<String> avatarGroupCubit =
      ValueCubit(groupAvatarList[0].avatarPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const CustomAppBar(
              title: 'Avatar Group',
              textColor: Color(
                0xFF343434,
              ),
            ),
          ),
          _MainBody(avatarGroupCubit),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 36.h),
        child: BlocBuilder<ValueCubit<String>, String>(
          bloc: avatarGroupCubit,
          builder: (context, state) {
            return AppButton(
              title: 'Save',
              onTap: () async {
                debugPrint('${Global.instance.group}');
                try {
                  if (Global.instance.group != null) {
                    EasyLoading.show();
                    //update local
                    Global.instance.group =
                        Global.instance.group?.copyWith(avatarGroup: state);

                    //update database
                    await FirestoreClient.instance
                        .createGroup(Global.instance.group!);
                    await SharedPreferencesManager.saveIsCreateInfoFistTime(
                        false);

                    getIt<SelectGroupCubit>().update(Global.instance.group);
                    if (context.mounted) {
                      EasyLoading.dismiss();
                      context.replaceRoute(const HomeRoute());
                    }
                  } else {
                    debugPrint('empty');
                  }
                } catch (error) {
                  EasyLoading.dismiss();
                  Fluttertoast.showToast(msg: error.toString());
                }
              },
              textSecondColor: const Color(0xFFB685FF),
            );
          },
        ),
      ),
    );
  }
}

class _MainBody extends StatefulWidget {
  const _MainBody(this.avatarGroupCubit);
  final ValueCubit<String> avatarGroupCubit;
  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          100.verticalSpace,
          Text(
            'Choose your favorite avatar!',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF3A3A3C),
            ),
          ),
          16.verticalSpace,
          _buildAvatarGridView(widget.avatarGroupCubit),
        ],
      ),
    );
  }

  Widget _buildAvatarGridView(ValueCubit<String> avatarGroupCubit) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 24.w,
        mainAxisSpacing: 24.h,
      ),
      itemBuilder: (context, index) {
        return _buildAvatarItem(groupAvatarList[index], avatarGroupCubit);
      },
      itemCount: groupAvatarList.length,
    );
  }

  BlocBuilder _buildAvatarItem(
      AvatarModel avatarModel, ValueCubit<String> avatarGroupCubit) {
    return BlocBuilder<ValueCubit<String>, String>(
      bloc: avatarGroupCubit,
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            avatarGroupCubit.update(avatarModel.avatarPath);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                foregroundDecoration: BoxDecoration(
                  border: avatarModel.avatarPath == state
                      ? Border.all(
                          color: const Color(0xFF7B3EFF),
                          width: 2.w,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset(
                    avatarModel.avatarPath,
                  ),
                ),
              ),
              if (avatarModel.avatarPath == state)
                Positioned(
                  right: -6.h,
                  top: -6.h,
                  child: Assets.icons.icChecked.svg(height: 24.h),
                ),
            ],
          ),
        );
      },
    );
  }
}
