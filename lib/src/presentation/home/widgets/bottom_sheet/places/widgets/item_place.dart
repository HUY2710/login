import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../data/models/store_location/store_location.dart';
import '../../../../../../data/models/store_place/store_place.dart';
import '../../../../../../shared/constants/app_constants.dart';
import '../../../../../../shared/extension/context_extension.dart';
import '../../../../../../shared/widgets/containers/shadow_container.dart';

class ItemPlace extends StatelessWidget {
  const ItemPlace({super.key, required this.place, this.defaultPlace = false});
  final StorePlace place;
  final bool? defaultPlace;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          ShadowContainer(
            colorShadow: Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
              colorBg: Color(place.colorPlace).withOpacity(0.25),
              colorBorder: Color(place.colorPlace),
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: SvgPicture.asset(
                  place.iconPlace,
                  colorFilter: const ColorFilter.mode(
                      Color(0xff7B3EFF), BlendMode.srcIn),
                ),
              )),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.namePlace,
                  style: TextStyle(
                      color: const Color(0xff343434),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  defaultPlace != null && defaultPlace!
                      ? context.l10n.addLocation
                      : StoreLocation.fromJson(place.location!).address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: const Color(0xff6C6C6C),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          if (defaultPlace != null && defaultPlace!)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              margin: EdgeInsets.only(right: 16.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0xffB67DFF),
                  Color(0xff7B3EFF),
                ]),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.widgetBorderRadius.r),
                ),
              ),
              child: Text(
                context.l10n.setUp,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
