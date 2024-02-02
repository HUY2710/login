// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/navigation/app_router.dart';
import '../../../data/local/avatar/avatar_repository.dart';
import '../../../data/models/avatar/avatar_model.dart';
import '../../../shared/enum/gender_type.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../onboarding/widgets/app_button.dart';
import '../widgets/gender_switch.dart';

@RoutePage()
class CreateUserAvatarScreen extends StatelessWidget {
  const CreateUserAvatarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _MainBody(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const CustomAppBar(title: 'Set avatar'),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 36.h),
        child: AppButton(
          title: 'Save',
          onTap: () {
            context.pushRoute(const CreateGroupNameRoute());
          },
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
  var currentGender = GenderType.male;
  var currentAvatar = maleAvatarList.first.previewAvatarPath;
  @override
  Widget build(BuildContext context) {
    final currentList =
        currentGender == GenderType.male ? maleAvatarList : femaleAvatarList;
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAvatarPreview(),
          16.verticalSpace,
          GenderSwitch(
            onChanged: (value) {
              setState(() {
                currentGender = value;
              });
            },
          ),
          24.verticalSpace,
          Text(
            'Choose your favorite avatar!',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF3A3A3C),
            ),
          ),
          16.verticalSpace,
          _buildAvatarGridView(currentList),
        ],
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Image.asset(
        currentAvatar,
        gaplessPlayback: true,
      ),
    );
  }

  Widget _buildAvatarGridView(List<AvatarModel> currentImage) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 32.w,
        mainAxisSpacing: 32.h,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              currentAvatar = currentImage[index].previewAvatarPath;
            });
          },
          child: CircleAvatar(
            backgroundImage: Image.asset(
              currentImage[index].avatarPath,
              gaplessPlayback: true,
            ).image,
          ),
        );
      },
      itemCount: currentImage.length,
    );
  }
}
