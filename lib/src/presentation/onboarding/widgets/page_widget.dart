import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';

class ContentPageWidget extends StatelessWidget {
  const ContentPageWidget({
    super.key,
    required this.image,
    required this.title,
  });

  final AssetGenImage image;
  final String title;

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
            child: AutoSizeText(
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
