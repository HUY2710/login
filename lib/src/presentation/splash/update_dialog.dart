import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:upgrader/upgrader.dart';

import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';

class UpdateDialog extends UpgradeBase {
  UpdateDialog({
    super.key,
    Upgrader? upgrader,
    required this.context,
    required this.forceUpdate,
  }) : super(upgrader ?? Upgrader.sharedInstance);

  final BuildContext context;
  final bool forceUpdate;

  @override
  Widget build(BuildContext context, UpgradeBaseState state) {
    return StreamBuilder(
        initialData: state.widget.upgrader.evaluationReady,
        stream: state.widget.upgrader.evaluationStream,
        builder: (BuildContext context,
            AsyncSnapshot<UpgraderEvaluateNeed> snapshot) {
          if ((snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) &&
              snapshot.data != null &&
              snapshot.data!) {
            if (upgrader.shouldDisplayUpgrade()) {
              return buildUpdateCard(context, state);
            } else {
              if (upgrader.debugLogging) {
                print('upgrader: UpgradeCard will not display');
              }
            }
          }
          return const SizedBox.shrink();
        });
  }

  Center buildUpdateCard(BuildContext context, UpgradeBaseState state) {
    final UpgraderMessages appMessages = upgrader.determineMessages(context);
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: const EdgeInsets.all(16).r,
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              appMessages.message(UpgraderMessage.title) ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16).h,
              child: Assets.icons.update.svg(
                width: 69.r,
                height: 69.r,
                colorFilter: const ColorFilter.mode(
                  MyColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Text(
              upgrader.body(appMessages),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xffADADAD),
              ),
            ),
            5.verticalSpace,
            Text(
              appMessages.message(UpgraderMessage.prompt) ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            16.verticalSpace,
            FilledButton(
              onPressed: () {
                upgrader.saveLastAlerted();

                upgrader.onUserUpdated(context, false);
                state.forceUpdateState();
              },
              child: Text(
                appMessages.message(UpgraderMessage.buttonTitleUpdate) ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (!forceUpdate)
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      upgrader.saveLastAlerted();

                      upgrader.onUserLater(context, false);
                      state.forceUpdateState();
                    },
                    child: SizedBox(
                      height: 30.h,
                      child: Text(
                        appMessages.message(UpgraderMessage.buttonTitleLater) ??
                            '',
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
