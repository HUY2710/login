import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../data/models/store_place/store_place.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../../shared/cubit/value_cubit.dart';
import '../../../../../shared/widgets/my_drag.dart';

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
                        onTap: () {},
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
        ],
      ),
    );
  }
}
