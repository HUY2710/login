import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../config/di/di.dart';
import '../../../../../data/models/store_location/store_location.dart';
import '../../../../../data/models/store_place/store_place.dart';
import '../../../../../data/remote/firestore_client.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../global/global.dart';
import '../../../../../services/location_service.dart';
import '../../../../../shared/cubit/value_cubit.dart';
import '../../../../../shared/extension/int_extension.dart';
import '../../../../../shared/widgets/main_switch.dart';
import '../../../../../shared/widgets/my_drag.dart';
import '../../../../map/cubit/select_group_cubit.dart';

class AddPlaceBottomSheet extends StatefulWidget {
  const AddPlaceBottomSheet({super.key});

  @override
  State<AddPlaceBottomSheet> createState() => _AddPlaceBottomSheetState();
}

class _AddPlaceBottomSheetState extends State<AddPlaceBottomSheet> {
  final ValueCubit<String> icPlaceCubit = ValueCubit(Assets.icons.icPlace.path);
  final TextEditingController nameLocationCtrl = TextEditingController();
  final TextEditingController addressLocationCtrl = TextEditingController();

  StorePlace? tempGroup;
  bool onNotify = true;
  final List<String> pathIcPlaces = [
    Assets.icons.icPlace.path,
    Assets.icons.places.icAnimal.path,
    Assets.icons.places.icBook.path,
    Assets.icons.places.icBook2.path,
    Assets.icons.places.icCart.path,
    Assets.icons.places.icCook.path,
    Assets.icons.places.icHome.path,
    Assets.icons.places.icSchool.path,
    Assets.icons.places.icStore.path,
    Assets.icons.places.icTree.path,
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyDrag(),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      child: Text(
                        'Places',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          color: const Color(0xff343434),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => context.popRoute(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: const Color(0xff8E52FF),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          EasyLoading.show();
                          final location = Global.instance.location;
                          final address = await getIt<LocationService>()
                              .getCurrentAddress(location);
                          //test add place
                          final StorePlace newPlace = StorePlace(
                            idCreator: Global.instance.user!.code,
                            idPlace: 24.randomString(),
                            iconPlace: Assets.icons.places.icAnimal.path,
                            namePlace: nameLocationCtrl.text,
                            location: StoreLocation(
                              address: address,
                              lat: location.latitude,
                              lng: location.longitude,
                              updatedAt: DateTime.now(),
                            ).toJson(),
                            radius: 100,
                            onNotify: onNotify,
                          );

                          if (getIt<SelectGroupCubit>().state != null) {
                            await FirestoreClient.instance.createPlace(
                                getIt<SelectGroupCubit>().state!.idGroup!,
                                newPlace);
                          }
                          EasyLoading.dismiss();
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: nameLocationCtrl.text.isNotEmpty
                                ? const Color(0xff8E52FF)
                                : const Color(0xffABABAB),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          32.verticalSpace,
          SizedBox(
            height: 40.h,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: pathIcPlaces.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    icPlaceCubit.update(pathIcPlaces[index]);
                  },
                  child: BlocBuilder<ValueCubit<String>, String>(
                    bloc: icPlaceCubit,
                    builder: (context, state) {
                      return Container(
                        height: 40.h,
                        width: 56.w,
                        margin: EdgeInsets.only(right: 20.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.r),
                          ),
                          border: Border.all(
                              color: state == pathIcPlaces[index]
                                  ? const Color(0xff7B3EFF)
                                  : const Color(0xffE2E2E2)),
                        ),
                        child: SvgPicture.asset(
                          pathIcPlaces[index],
                          width: 20.w,
                          height: 20.h,
                          colorFilter: ColorFilter.mode(
                            state == pathIcPlaces[index]
                                ? const Color(0xff7B3EFF)
                                : const Color(0xffE2E2E2),
                            BlendMode.srcIn,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          24.verticalSpace,
          Text(
            'Name',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          8.verticalSpace,
          TextField(
            controller: nameLocationCtrl,
          ),
          24.verticalSpace,
          Text(
            'Location',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          8.verticalSpace,
          TextField(
            controller: addressLocationCtrl,
          ),
          24.verticalSpace,
          Row(
            children: [
              const Expanded(
                  child:
                      Text('Get notified if members leaved or arrived here')),
              MainSwitch(value: true, onChanged: (value) {}),
            ],
          ),
          const Text(
              "Don't worry, we won't let them know that you're tracking their location"),
          16.verticalSpace,
        ],
      ),
    );
  }
}
