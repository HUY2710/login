import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../../../app/cubit/loading_cubit.dart';
import '../../../../../data/remote/firestore_client.dart';
import '../../../../../global/global.dart';
import '../../../../map/cubit/select_group_cubit.dart';
import '../../../../place/cubit/default_places_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/di/di.dart';
import '../../../../../data/models/store_place/store_place.dart';
import '../../../../../shared/extension/context_extension.dart';
import '../../../../../shared/widgets/containers/custom_container.dart';
import '../../../../../shared/widgets/custom_my_slidable.dart';
import '../../../../../shared/widgets/my_drag.dart';
import '../../../../map/cubit/tracking_places/tracking_places_cubit.dart';
import '../../../../place/add_place.dart';
import '../../dialog/action_dialog.dart';
import '../show_bottom_sheet_home.dart';
import 'widgets/item_place.dart';

class PlacesBottomSheet extends StatelessWidget {
  const PlacesBottomSheet({super.key});

  Future<void> removeDefaultItemPlace(BuildContext context,
      List<StorePlace> listDefault, StorePlace item) async {
    showDialog(
      context: context,
      builder: (context) => ActionDialog(
        title: 'Remove this Place',
        subTitle: 'Are you sure to the remove this place from your group?',
        confirmTap: () async {
          try {
            context.popRoute();
            showLoading();
            final List<StorePlace> updatedList = List.from(listDefault);
            updatedList
                .removeWhere((element) => element.idPlace == item.idPlace);
            getIt<DefaultPlaceCubit>().update(updatedList);
            hideLoading();
          } catch (error) {
            debugPrint('error:$error');
          }
        },
        confirmText: context.l10n.delete,
      ),
    );
  }

  Future<void> removePlace(BuildContext context, String idPlace) async {
    showDialog(
      context: context,
      builder: (context) => ActionDialog(
        title: 'Remove this Place',
        subTitle: 'Are you sure to the remove this place from your group?',
        confirmTap: () async {
          try {
            context.popRoute();
            showLoading();
            await FirestoreClient.instance.removePlace(
                getIt<SelectGroupCubit>().state!.idGroup!, idPlace);
            getIt<TrackingPlacesCubit>().removePlace(idPlace);
            hideLoading();
          } catch (error) {
            debugPrint('error:$error');
          }
        },
        confirmText: context.l10n.delete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      constraints: BoxConstraints(maxHeight: 1.sh * 0.7),
      child: Column(
        children: [
          const MyDrag(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
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
          ),
          12.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: GestureDetector(
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
          ),
          BlocBuilder<DefaultPlaceCubit, List<StorePlace>?>(
            bloc: getIt<DefaultPlaceCubit>(),
            builder: (context, state) {
              if (state != null && state.isNotEmpty) {
                return ListView.separated(
                  itemCount: state.length,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = getIt<DefaultPlaceCubit>().state![index];
                    return CustomSwipeWidget(
                      actionRight1: () {
                        showAppModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: AddPlaceBottomSheet(
                              place: item,
                            ),
                          ),
                        );
                      },
                      actionRight2: () async {
                        removeDefaultItemPlace(context, state, item);
                      },
                      firstRight: true,
                      child: ItemPlace(
                        place: state[index],
                        defaultPlace: true,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 14.h),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<TrackingPlacesCubit, TrackingPlacesState>(
              bloc: getIt<TrackingPlacesCubit>(),
              builder: (context, state) {
                return state.maybeWhen(
                    orElse: () => const SizedBox(),
                    failed: (message) => Text('Error:$message'),
                    success: (places) {
                      if (places.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return ListView.separated(
                        itemCount: places.length,
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        itemBuilder: (context, index) {
                          return CustomSwipeWidget(
                            enable: places[index].idCreator ==
                                Global.instance.user?.code,
                            actionRight1: () {
                              showAppModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: AddPlaceBottomSheet(
                                    place: places[index],
                                    defaultPlace: false,
                                  ),
                                ),
                              );
                            },
                            actionRight2: () {
                              removePlace(context, places[index].idPlace!);
                            },
                            firstRight: true,
                            child: ItemPlace(
                              place: places[index],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
