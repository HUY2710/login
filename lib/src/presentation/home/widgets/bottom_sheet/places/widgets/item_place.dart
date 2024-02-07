import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../gen/assets.gen.dart';

class ItemPlace extends StatelessWidget {
  const ItemPlace({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Home',
                style: TextStyle(
                    color: const Color(0xff343434),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'Address',
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
