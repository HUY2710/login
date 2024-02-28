import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/cubit/loading_cubit.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/models/store_location/store_location.dart';
import '../../data/models/store_place/store_place.dart';
import '../../data/remote/firestore_client.dart';
import '../../gen/assets.gen.dart';
import '../../gen/colors.gen.dart';
import '../../global/global.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/extension/int_extension.dart';
import '../../shared/widgets/my_drag.dart';
import '../../shared/widgets/text_field/main_text_form_field.dart';
import '../map/cubit/select_group_cubit.dart';
import 'cubit/default_places_cubit.dart';
import 'cubit/select_place_cubit.dart';

class AddPlaceBottomSheet extends StatefulWidget {
  const AddPlaceBottomSheet({super.key, this.place, this.defaultPlace = true});
  final StorePlace? place;
  final bool defaultPlace;
  @override
  State<AddPlaceBottomSheet> createState() => _AddPlaceBottomSheetState();
}

class _AddPlaceBottomSheetState extends State<AddPlaceBottomSheet> {
  final ValueCubit<String> icPlaceCubit = ValueCubit(Assets.icons.icPlace.path);
  final TextEditingController nameLocationCtrl = TextEditingController();
  final TextEditingController addressLocationCtrl = TextEditingController();
  ValueCubit<bool> notifyGroupCubit = ValueCubit(true);
  final selectPlaceCubit = getIt<SelectPlaceCubit>();
  bool onNotify = true;

  StorePlace? tempPlace;
  final List<String> pathIcPlaces = [
    Assets.icons.icPlace.path,
    Assets.icons.places.icHome.path,
    Assets.icons.places.icSchool.path,
    Assets.icons.places.icBook.path,
    Assets.icons.places.icAnimal.path,
    Assets.icons.places.icBook2.path,
    Assets.icons.places.icCart.path,
    Assets.icons.places.icCook.path,
    Assets.icons.places.icStore.path,
    Assets.icons.places.icTree.path,
  ];

  final List<Color> listColors = [
    const Color(0xffA369FD),
    const Color(0xff00A7EE),
    const Color(0xffFF3E8D),
    const Color(0xffFFC428),
    const Color(0xff23D020),
    const Color(0xff2972D6),
    const Color(0xffFF5E5E),
  ];

  int selectColor = 0xffA369FD;
  double currentRadius = 100;

  @override
  void initState() {
    super.initState();
    setState(() {
      tempPlace = widget.place;
      nameLocationCtrl.text = widget.place?.namePlace ?? '';
      addressLocationCtrl.text = widget.place?.location?['address'] ?? '';
      selectColor = widget.place?.colorPlace ?? 0xffA369FD;
    });
    if (widget.place != null) {
      icPlaceCubit.update(widget.place!.iconPlace);
      currentRadius = widget.place!.radius;
    }
    if (!widget.defaultPlace) {
      selectPlaceCubit.update(StoreLocation.fromJson(widget.place!.location!));
    }
  }

  Future<void> updatePlace() async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.containerBorder).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: MyDrag()),
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
                      BlocBuilder<SelectPlaceCubit, StoreLocation?>(
                        bloc: selectPlaceCubit,
                        builder: (context, state) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: nameLocationCtrl.text.isNotEmpty &&
                                      addressLocationCtrl.text.isNotEmpty
                                  ? () async {
                                      try {
                                        context.popRoute();
                                        showLoading();
                                        if (widget.defaultPlace) {
                                          //chỉnh sửa và tạo mới 1 cái place
                                          final StorePlace newPlace =
                                              StorePlace(
                                            idCreator:
                                                Global.instance.user!.code,
                                            idPlace: 24.randomString(),
                                            iconPlace: icPlaceCubit.state,
                                            namePlace: nameLocationCtrl.text,
                                            location: state?.toJson(),
                                            radius: currentRadius,
                                            onNotify: onNotify,
                                            colorPlace: selectColor,
                                          );

                                          if (getIt<SelectGroupCubit>().state !=
                                              null) {
                                            await FirestoreClient.instance
                                                .createPlace(
                                              getIt<SelectGroupCubit>()
                                                  .state!
                                                  .idGroup!,
                                              newPlace,
                                            );
                                          }
                                          if (widget.place != null) {
                                            final List<StorePlace> updatedList =
                                                List.from(
                                                    getIt<DefaultPlaceCubit>()
                                                            .state ??
                                                        []);
                                            updatedList.remove(widget.place);
                                            getIt<DefaultPlaceCubit>()
                                                .update(updatedList);
                                          }
                                        } else {
                                          //update
                                          tempPlace = tempPlace?.copyWith(
                                            iconPlace: icPlaceCubit.state,
                                            namePlace: nameLocationCtrl.text,
                                            location: state?.toJson(),
                                            radius: currentRadius,
                                            colorPlace: selectColor,
                                          );
                                          if (tempPlace != null) {
                                            await FirestoreClient.instance
                                                .updatePlace(
                                              getIt<SelectGroupCubit>()
                                                  .state!
                                                  .idGroup!,
                                              tempPlace!.idPlace!,
                                              tempPlace!.toJson(),
                                            );
                                          }
                                        }

                                        hideLoading();
                                      } catch (error) {
                                        debugPrint('error:$error');
                                      }
                                    }
                                  : () {},
                              child: Text(
                                context.l10n.done,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp,
                                  color: nameLocationCtrl.text.isNotEmpty &&
                                          addressLocationCtrl.text.isNotEmpty
                                      ? const Color(0xff8E52FF)
                                      : const Color(0xffABABAB),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
            32.verticalSpace,
            SizedBox(
              height: 44.h,
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
                            width: 20.r,
                            height: 20.r,
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
            SizedBox(
              height: 40.h,
              child: ListView.separated(
                itemCount: listColors.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final item = listColors[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectColor = item.value;
                      });
                    },
                    child: Container(
                      height: 42.r,
                      width: 42.r,
                      padding: EdgeInsets.all(2.r),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectColor == item.value
                              ? const Color(0xff7B3EFF)
                              : Colors.transparent,
                        ),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: item),
                          color: item.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
              ),
            ),
            24.verticalSpace,
            Text(
              context.l10n.name,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            8.verticalSpace,
            MainTextFormField(
              controller: nameLocationCtrl,
              onChanged: (value) {
                setState(() {});
              },
              hintText: context.l10n.nameLocation,
            ),
            24.verticalSpace,
            Text(
              context.l10n.location,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: MyColors.black34,
              ),
            ),
            8.verticalSpace,
            BlocConsumer<SelectPlaceCubit, StoreLocation?>(
              bloc: selectPlaceCubit,
              listener: (context, state) {
                setState(() {
                  addressLocationCtrl.text =
                      widget.place?.location?['address'] ??
                          state?.address ??
                          '';
                });
              },
              builder: (context, state) {
                return MainTextFormField(
                  readonly: true,
                  controller: addressLocationCtrl,
                  hintText: context.l10n.addLocation,
                  onTap: () async {
                    await context.pushRoute(SelectLocationPlaceRoute(
                        selectPlaceCubit: selectPlaceCubit));
                  },
                );
              },
            ),
            28.verticalSpace,
            Row(
              children: [
                Text(
                  context.l10n.radius,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: MyColors.black34,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: currentRadius,
                    max: 300,
                    min: 50,
                    divisions: 300,
                    inactiveColor: const Color(0xffF5F5F5),
                    label: '${currentRadius.round()}m',
                    onChanged: (double value) {
                      setState(() {
                        currentRadius = value.roundToDouble();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Visibility(
                    visible: false,
                    maintainSize: true,
                    maintainState: true,
                    maintainAnimation: true,
                    child: Text('Radius')),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '50m',
                          style: TextStyle(
                            color: const Color(0xff6C6C6C),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '300m',
                          style: TextStyle(
                            color: const Color(0xff6C6C6C),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            50.verticalSpace
          ],
        ),
      ),
    );
  }
}
