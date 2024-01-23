import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/di/di.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../../shared/widgets/containers/border_container.dart';
import '../../map/cubit/select_user_cubit.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BorderContainer(
              colorBackGround: Colors.white,
              colorBorder: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                child: BlocBuilder<SelectUserCubit, StoreUser?>(
                  bloc: getIt<SelectUserCubit>(),
                  builder: (context, state) {
                    return Text(
                      'ME',
                      style: TextStyle(
                        color: const Color(0xff343434),
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
        8.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildItem(Assets.icons.icPeople.path),
            23.horizontalSpace,
            BlocBuilder<SelectUserCubit, StoreUser?>(
              bloc: getIt<SelectUserCubit>(),
              builder: (context, state) {
                if (state != null && state.avatarUrl != null) {
                  return _buildAvatar(state.avatarUrl!);
                }
                return _buildAvatar(Global.instance.user!.avatarUrl!);
              },
            ),
            23.horizontalSpace,
            buildItem(Assets.icons.icMessage.path)
          ],
        ),
      ],
    );
  }

  Widget buildItem(String path, {bool? avatar}) {
    return Container(
      height: 48.r,
      width: 48.r,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
        gradient: const LinearGradient(colors: [
          Color(0xffB67DFF),
          Color(0xff7B3EFF),
        ]),
      ),
      child: SvgPicture.asset(
        path,
        height: 22.r,
        width: 22.r,
      ),
    );
  }

  Widget _buildAvatar(String pathAvatar) {
    return Container(
      height: 72.r,
      width: 72.r,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(25.r),
        ),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(25.r),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        pathAvatar,
      ),
    );
  }
}
