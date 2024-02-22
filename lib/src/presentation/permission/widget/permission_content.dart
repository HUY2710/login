import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/gens.dart';
import '../../../shared/cubit/value_cubit.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/mixin/permission_mixin.dart';
import 'permission_item.dart';

class PermissionContent extends StatefulWidget {
  const PermissionContent({
    super.key,
    required this.typeRequest,
    required this.locationCubit,
    required this.notifyCubit,
    required this.motionCubit,
    required this.showNotify,
    required this.showMotion,
  });
  final ValueCubit<int> typeRequest;
  final ValueCubit<bool?> locationCubit;
  final ValueCubit<bool?> notifyCubit;
  final ValueCubit<bool?> motionCubit;
  final ValueCubit<bool> showNotify;
  final ValueCubit<bool> showMotion;

  @override
  State<PermissionContent> createState() => _PermissionContentState();
}

class _PermissionContentState extends State<PermissionContent>
    with PermissionMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            100.verticalSpace,
            Image.asset(
              Assets.images.permission.path,
              width: 160.r,
              height: 160.r,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 40.h),
              child: Text(
                context.l10n.titlePermission,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: MyColors.black34,
                ),
              ),
            ),
            BlocBuilder<ValueCubit<bool?>, bool?>(
              bloc: widget.notifyCubit,
              builder: (context, state) {
                return PermissionItem(
                  pathIc: Assets.icons.icLocation.path,
                  title: context.l10n.location,
                  subTitle: context.l10n.subLocation,
                  colorDisable:
                      state == null || state ? null : const Color(0xff6C6C6C),
                );
              },
            ),
            24.verticalSpace,
            BlocBuilder<ValueCubit<bool>, bool>(
              bloc: widget.showNotify,
              builder: (context, state) {
                return Visibility(
                  visible: state,
                  child: BlocBuilder<ValueCubit<bool?>, bool?>(
                    bloc: widget.notifyCubit,
                    builder: (context, state) {
                      return PermissionItem(
                        pathIc: Assets.icons.icNotify.path,
                        title: context.l10n.notification,
                        subTitle: context.l10n.subNotification,
                        colorDisable: state == null || state
                            ? null
                            : const Color(0xff6C6C6C),
                      );
                    },
                  ),
                );
              },
            ),
            24.verticalSpace,
            BlocBuilder<ValueCubit<bool>, bool>(
              bloc: widget.showMotion,
              builder: (context, state) {
                return Visibility(
                  visible: state,
                  child: BlocBuilder<ValueCubit<bool?>, bool?>(
                    bloc: widget.motionCubit,
                    builder: (context, state) {
                      return PermissionItem(
                        pathIc: Assets.icons.icMotion.path,
                        title: context.l10n.motionTracking,
                        subTitle: context.l10n.subMotionTracking,
                        colorDisable: state == null || state
                            ? null
                            : const Color(0xff6C6C6C),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
