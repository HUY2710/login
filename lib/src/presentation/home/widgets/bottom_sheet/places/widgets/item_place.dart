import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../data/models/store_location/store_location.dart';
import '../../../../../../data/models/store_place/store_place.dart';
import '../../../../../../gen/assets.gen.dart';

class ItemPlace extends StatelessWidget {
  const ItemPlace({super.key, required this.place});
  final StorePlace place;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: SvgPicture.asset(place.iconPlace),
        ),
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
                StoreLocation.fromJson(place.location!).address,
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
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
        IconButton(
          onPressed: () {},
          icon: Assets.icons.icTrash.svg(width: 20.r),
        ),
      ],
    );
  }
}
