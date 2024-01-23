import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../config/navigation/app_router.dart';
import '../../../gen/assets.gen.dart';
import '../../map/widgets/bottom_sheet_map.dart';
import '../../map/widgets/map_type_selector.dart';

class FloatRightAppBar extends StatefulWidget {
  const FloatRightAppBar({super.key});

  @override
  State<FloatRightAppBar> createState() => _FloatRightAppBarState();
}

class _FloatRightAppBarState extends State<FloatRightAppBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildItem(() {
          context.pushRoute(const SettingRoute());
        }, Assets.icons.icSetting.path),
        16.verticalSpace,
        buildItem(() {}, Assets.icons.icLocation.path),
        16.verticalSpace,
        buildItem(
          () async {
            await showBottomTypeOfHome(
              context: context,
              child: const MapTypeSelector(),
            );
          },
          Assets.icons.icMap.path,
        ),
      ],
    );
  }

  Widget buildItem(VoidCallback onTap, String pathIc) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15.r),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff42474C).withOpacity(0.3),
                blurRadius: 17,
              )
            ]),
        child: SvgPicture.asset(
          pathIc,
          height: 20.r,
          width: 20.r,
        ),
      ),
    );
  }
}
