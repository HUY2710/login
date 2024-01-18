import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../../shared/extension/context_extension.dart';

class ContentPageWidget extends StatelessWidget {
  const ContentPageWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final AssetGenImage image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: image.image(fit: BoxFit.fitWidth),
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: context.colorScheme.primary,
            fontSize: 22.sp,
          ),
        ),
        10.verticalSpace,
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: context.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
