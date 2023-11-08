import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:upgrader/upgrader.dart';

class UpdateDialog extends AlertDialog {
  const UpdateDialog({
    super.key,
    required this.upgrader,
    required this.context,
    required this.forceUpdate,
  });

  final Upgrader upgrader;
  final BuildContext context;
  final bool forceUpdate;

  @override
  Widget? get content => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            upgrader.messages.message(UpgraderMessage.title) ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16).h,
            child: SizedBox.square(
              dimension: 70.r,
              child: const Placeholder(),
            ),
          ),
          Text(
            upgrader.messages.message(UpgraderMessage.body) ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xffADADAD),
            ),
          ),
          5.verticalSpace,
          Text(
            upgrader.messages.message(UpgraderMessage.prompt) ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );

  @override
  EdgeInsetsGeometry? get contentPadding =>
      EdgeInsets.fromLTRB(12.w, 16.h, 16.w, 20.h);

  @override
  List<Widget>? get actions => [
        Column(
          children: [
            FilledButton(
              onPressed: () =>
                  upgrader.onUserUpdated(context, !upgrader.blocked()),
              child: Text(
                upgrader.messages.message(UpgraderMessage.buttonTitleUpdate) ??
                    '',
                style: TextStyle(
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (forceUpdate)
              16.verticalSpace
            else
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: GestureDetector(
                  onTap: () {
                    upgrader.onLater?.call();
                  },
                  child: SizedBox(
                    height: 30.h,
                    child: Text(
                      upgrader.messages
                              .message(UpgraderMessage.buttonTitleLater) ??
                          '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ];

  @override
  EdgeInsetsGeometry? get actionsPadding =>
      EdgeInsets.symmetric(horizontal: 12.w);
}
