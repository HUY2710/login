// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/navigation/app_router.dart';
import '../../../gen/assets.gen.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../onboarding/widgets/app_button.dart';

@RoutePage()
class CreateGroupAvatarScreen extends StatelessWidget {
  const CreateGroupAvatarScreen({super.key});

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
            context.replaceRoute(const HomeRoute());
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
  final groupAvatars = <AssetGenImage>[
    Assets.images.avatars.avatar1,
    Assets.images.avatars.avatar2,
    Assets.images.avatars.avatar3,
    Assets.images.avatars.avatar4,
    Assets.images.avatars.avatar5,
    Assets.images.avatars.avatar6,
    Assets.images.avatars.avatar7,
    Assets.images.avatars.avatar8,
    Assets.images.avatars.avatar9,
    Assets.images.avatars.avatar10,
  ];

  AssetGenImage currentAvatar = Assets.images.avatars.avatar1;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAvatarPreview(),
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
          _buildAvatarGridView(),
        ],
      ),
    );
  }

  Widget _buildAvatarPreview() {
    return Container(
      height: 250.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: currentAvatar.image(
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildAvatarGridView() {
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
              currentAvatar = groupAvatars[index];
            });
          },
          child: CircleAvatar(
            backgroundImage: groupAvatars[index].provider(),
          ),
        );
      },
      itemCount: groupAvatars.length,
    );
  }
}
