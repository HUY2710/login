import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/di/di.dart';
import '../../../../../shared/extension/context_extension.dart';
import '../../../../../shared/widgets/containers/custom_container.dart';
import '../../../../../shared/widgets/custom_my_slidable.dart';
import '../../../../../shared/widgets/my_drag.dart';
import '../../../../map/cubit/tracking_places/tracking_places_cubit.dart';
import '../../../../place/add_place.dart';
import '../show_bottom_sheet_home.dart';
import 'widgets/item_place.dart';

class PlacesBottomSheet extends StatelessWidget {
  const PlacesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      constraints: BoxConstraints(maxHeight: 1.sh * 0.7),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          const MyDrag(),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      child: Text(
                        context.l10n.places,
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
                          context.l10n.cancel,
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
                        onTap: () {
                          context.popRoute();
                        },
                        child: Text(
                          context.l10n.done,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: const Color(0xff8E52FF),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          20.verticalSpace,
          GestureDetector(
            onTap: () {
              showAppModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: const AddPlaceBottomSheet(),
                ),
              );
            },
            child: Row(
              children: [
                CustomContainer(
                  radius: 15.r,
                  colorBg: const Color(0xff8E52FF),
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                12.horizontalSpace,
                Text(context.l10n.addPlaces),
              ],
            ),
          ),
          20.verticalSpace,
          Expanded(
              child: BlocBuilder<TrackingPlacesCubit, TrackingPlacesState>(
            bloc: getIt<TrackingPlacesCubit>(),
            builder: (context, state) {
              return state.maybeWhen(
                  orElse: () => const SizedBox(),
                  failed: (message) => Text('Error:$message'),
                  success: (places) {
                    if (places.isEmpty) {
                      return Center(child: Text(context.l10n.noPlace));
                    }
                    return ListView.separated(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        return CustomSwipeWidget(
                          actionRight1: () {},
                          actionRight2: () {},
                          firstRight: true,
                          child: ItemPlace(
                            place: places[index],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 28.h),
                    );
                  });
            },
          ))
        ],
      ),
    );
  }
}
