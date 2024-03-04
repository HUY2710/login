import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/models/store_history_place/store_history_place.dart';
import '../../../gen/colors.gen.dart';
import '../../../gen/gens.dart';
import '../../../shared/helpers/time_helper.dart';
import '../../../shared/widgets/containers/shadow_container.dart';

class ItemHistoryPlace extends StatelessWidget {
  const ItemHistoryPlace({super.key, required this.historyPlace});
  final StoreHistoryPlace historyPlace;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShadowContainer(
          borderRadius: BorderRadius.circular(15.r),
          colorShadow: const Color(0xff42474C).withOpacity(.15),
          blurRadius: 17,
          width: 40.r,
          height: 40.r,
          child: Padding(
            padding: EdgeInsets.all(10.r),
            child: SvgPicture.asset(
              historyPlace.idPlace == ''
                  ? Assets.icons.icPlace.path
                  : historyPlace.place!.iconPlace,
              colorFilter:
                  const ColorFilter.mode(Color(0xff7B3EFF), BlendMode.srcIn),
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              historyPlace.nameDefault != ''
                  ? historyPlace.nameDefault ?? ''
                  : historyPlace.place!.namePlace,
              style: TextStyle(
                fontSize: 16.sp,
                color: MyColors.black34,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(TimerHelper.formatTimeHHMM(historyPlace.enterTime) ?? ''),
                Text(
                    ' - ${TimerHelper.formatTimeHHMM(historyPlace.leftTime) ?? '...'}'),
              ],
            )
          ],
        ))
      ],
    );
  }
}
