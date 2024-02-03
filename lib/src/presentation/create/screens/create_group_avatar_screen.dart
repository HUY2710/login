// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/navigation/app_router.dart';
import '../../../data/local/avatar/avatar_repository.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../onboarding/widgets/app_button.dart';

@RoutePage()
class CreateGroupAvatarScreen extends StatelessWidget {
  const CreateGroupAvatarScreen({super.key});

  Future<void> onSave(BuildContext context) async {
    await SharedPreferencesManager.saveIsCreateInfoFistTime(false);
    if (context.mounted) {
      context.replaceRoute(const HomeRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _MainBody(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const CustomAppBar(
              title: 'Avatar Group',
              textColor: Color(
                0xFF343434,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 36.h),
        child: AppButton(
          title: 'Save',
          onTap: () => onSave(context),
          // isEnable: false,
          textSecondColor: const Color(0xFFB685FF),
        ),
      ),
    );
  }
}

class _MainBody extends StatefulWidget {
  const _MainBody();

  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> {
  var currentAvatarSelected = 0;
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
          _buildAvatarGridView(),
        ],
      ),
    );
  }

  Widget _buildAvatarGridView() {
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
        return _buildAvatarItem(index);
      },
      itemCount: groupAvatarList.length,
    );
  }

  GestureDetector _buildAvatarItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentAvatarSelected = index;
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
              border: currentAvatarSelected == index
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
                groupAvatarList[index].avatarPath,
              ),
            ),
          ),
          if (currentAvatarSelected == index)
            Positioned(
              right: -6.h,
              top: -6.h,
              child: Assets.icons.icRoundedChecked.svg(height: 24.h),
            ),
        ],
      ),
    );
  }
}
