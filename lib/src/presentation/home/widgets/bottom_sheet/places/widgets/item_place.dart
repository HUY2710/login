import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../app/cubit/loading_cubit.dart';
import '../../../../../../config/di/di.dart';
import '../../../../../../data/models/store_location/store_location.dart';
import '../../../../../../data/models/store_place/store_place.dart';
import '../../../../../../data/remote/firestore_client.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../global/global.dart';
import '../../../../../../shared/extension/context_extension.dart';
import '../../../../../../shared/widgets/containers/custom_container.dart';
import '../../../../../../shared/widgets/containers/shadow_container.dart';
import '../../../../../map/cubit/select_group_cubit.dart';
import '../../../../../map/cubit/tracking_places/tracking_places_cubit.dart';
import '../../../../../onboarding/widgets/app_button.dart';
import '../../../dialog/action_dialog.dart';

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
              borderRadius: BorderRadius.circular(15.r),
              colorShadow: const Color(0xff42474C).withOpacity(.15),
              blurRadius: 17,
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
                  Radius.circular(12.r),
                ),
              ),
              child: Text(
                'Set up',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                ),
              ),
            ),
          if (defaultPlace != null &&
              !defaultPlace! &&
              place.idCreator == Global.instance.user?.code)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ActionDialog(
                    title: 'Remove this Place',
                    subTitle:
                        'Are you sure to the remove this place from your group?',
                    confirmTap: () async {
                      try {
                        context.popRoute();
                        // EasyLoading.show();
                        showLoading();
                        await FirestoreClient.instance.removePlace(
                            getIt<SelectGroupCubit>().state!.idGroup!,
                            place.idPlace!);
                        getIt<TrackingPlacesCubit>()
                            .removePlace(place.idPlace!);
                        // EasyLoading.dismiss();
                        hideLoading();
                      } catch (error) {
                        debugPrint('error:$error');
                      }
                    },
                    confirmText: context.l10n.delete,
                  ),
                );
              },
              icon: Assets.icons.icTrash.svg(width: 20.r),
            ),
        ],
      ),
    );
  }
}
