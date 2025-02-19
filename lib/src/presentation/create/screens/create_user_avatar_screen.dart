// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/navigation/app_router.dart';
import '../../../data/local/avatar/avatar_repository.dart';
import '../../../data/models/avatar/avatar_model.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../../shared/cubit/value_cubit.dart';
import '../../../shared/enum/gender_type.dart';
import '../../../shared/extension/context_extension.dart';
import '../../onboarding/widgets/app_button.dart';
import '../widgets/gender_switch.dart';

@RoutePage()
class CreateUserAvatarScreen extends StatelessWidget {
  CreateUserAvatarScreen({super.key});
  final ValueCubit<String> avatarCubit =
      ValueCubit(maleAvatarList.first.avatarPath);
  final ValueCubit<String> avatarBgCubit =
      ValueCubit(maleAvatarList.first.previewAvatarPath);

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leadingWidth: 44.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: GestureDetector(
                onTap: () {
                  context.popRoute();
                },
                child: Assets.icons.icBack.svg(
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              context.l10n.setAvatar,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            expandedHeight: MediaQuery.sizeOf(context).height * 0.34,
            automaticallyImplyLeading: false,
            flexibleSpace: PreferredSize(
              preferredSize: Size(
                  double.infinity, MediaQuery.sizeOf(context).height * 0.34),
              child: BlocBuilder<ValueCubit<String>, String>(
                bloc: avatarBgCubit,
                builder: (context, state) {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.34,
                    width: double.infinity,
                    child: _buildAvatarPreview(state),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _MainBody(avatarCubit, avatarBgCubit),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: AppButton(
          title: context.l10n.save,
          onTap: () async {
            Global.instance.user =
                Global.instance.user?.copyWith(avatarUrl: avatarCubit.state);
            user?.updatePhotoURL(Global.instance.user?.avatarUrl);
            try {
              await FirestoreClient.instance.updateUser({
                'userName': Global.instance.user?.userName,
                'avatarUrl': Global.instance.user?.avatarUrl
              });
            } catch (error) {
              debugPrint('error:$error');
            }
            if (context.mounted) {
              context.pushRoute(const CreateGroupNameRoute());
            }
          },
          textSecondColor: const Color(0xFFB685FF),
        ),
      ),
    );
  }

  Widget _buildAvatarPreview(String path) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
      ),
      child: Image.asset(
        path,
        gaplessPlayback: true,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _MainBody extends StatefulWidget {
  const _MainBody(this.avatarCubit, this.avatarBgCubit);
  final ValueCubit<String> avatarCubit;
  final ValueCubit<String> avatarBgCubit;
  @override
  State<_MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<_MainBody> {
  var currentGender = GenderType.male;
  @override
  Widget build(BuildContext context) {
    final currentList =
        currentGender == GenderType.male ? maleAvatarList : femaleAvatarList;
    return SingleChildScrollView(
      child: Column(
        children: [
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
            context.l10n.chooseAvatar,
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
            widget.avatarCubit.update(currentImage[index].avatarPath);
            widget.avatarBgCubit.update(currentImage[index].previewAvatarPath);
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
