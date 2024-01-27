import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    this.radius,
    required this.pathImageAssets,
    this.widthImage,
    this.heightImage,
  });
  final double? radius;
  final String pathImageAssets;
  final double? widthImage;
  final double? heightImage;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 42.r,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: buildAvatar(pathImageAssets),
      ),
    );
  }

  Widget buildAvatar(String pathImageAssets, {double? widthHeight}) {
    return Image.asset(
      pathImageAssets,
      fit: BoxFit.cover,
      width: widthHeight ?? 84.r,
      height: widthHeight ?? 84.r,
    );
  }
}
