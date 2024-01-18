import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';

class RateSuccessDialog extends Dialog {
  const RateSuccessDialog(this.context, {super.key});

  final BuildContext context;

  @override
  Widget? get child => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24).r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Assets.images.pinkHeart.image(width: 68.r),
            16.verticalSpace,
            Text(
              'context.l10n.feedbackMessage',
              style: TextStyle(
                fontSize: 18.sp,
                color: MyColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
}
