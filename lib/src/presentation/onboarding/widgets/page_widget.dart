import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/extension/context_extension.dart';

class ContentPageWidget extends StatelessWidget {
  const ContentPageWidget({
    super.key,
    required this.image,
    required this.title,
    this.isRichText = false,
  });

  final AssetGenImage image;
  final String title;
  final bool isRichText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: image.image(width: double.infinity, fit: BoxFit.cover),
        ),
        SizedBox(
          height: 90.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            child: isRichText
                ? RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: context.l10n.onboarding_title_5_1,
                          style: TextStyle(
                            color: const Color(0xFF343434),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          )),
                      TextSpan(
                          text: context.l10n.sos,
                          style: TextStyle(
                            color: const Color(0xFFFF3B30),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          )),
                      TextSpan(
                          text: context.l10n.onboarding_title_5_2,
                          style: TextStyle(
                            color: const Color(0xFF343434),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          )),
                    ]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  )
                : AutoSizeText(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      color: const Color(0xFF343434),
                      fontSize: 20.sp,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
