import 'dart:async';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/cubit/loading_cubit.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/models/store_location/store_location.dart';
import '../../data/models/store_notification_place/store_notification_place.dart';
import '../../data/models/store_place/store_place.dart';
import '../../data/remote/firestore_client.dart';
import '../../data/remote/notification_place_manager.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/extension/int_extension.dart';
import '../../shared/helpers/capture_widget_helper.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/text_field/main_text_form_field.dart';
import '../map/cubit/map_type_cubit.dart';
import '../map/cubit/select_group_cubit.dart';
import '../onboarding/widgets/app_button.dart';
import '../place/cubit/default_places_cubit.dart';
import '../place/cubit/select_place_cubit.dart';

@RoutePage()
class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key, this.place, this.defaultPlace = true});
  final StorePlace? place;
  final bool defaultPlace;
  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
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
  late final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  BitmapDescriptor? markerPlace;

  GlobalKey keyCap = GlobalKey();
  Future<void> captureMarker() async {
    final Uint8List? bytes = await CaptureWidgetHelp.widgetToBytes(keyCap);
    if (bytes == null) {
      return;
    }
    final newMarker = BitmapDescriptor.fromBytes(
      bytes,
      size: const Size(20, 20),
    );
    setState(() {
      markerPlace = newMarker;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    captureMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.addPlaces),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 36.h, left: 16.w, right: 16.w),
        child: BlocBuilder<SelectPlaceCubit, StoreLocation?>(
          bloc: selectPlaceCubit,
          builder: (context, state) {
            return AppButton(
              title: context.l10n.done,
              onTap: nameLocationCtrl.text.isNotEmpty &&
                      addressLocationCtrl.text.isNotEmpty
                  ? () async {
                      try {
                        context.popRoute();
                        showLoading();
                        if (widget.defaultPlace) {
                          //chỉnh sửa và tạo mới 1 cái place
                          final StorePlace newPlace = StorePlace(
                            idCreator: Global.instance.user!.code,
                            idPlace: 24.randomString(),
                            iconPlace: icPlaceCubit.state,
                            namePlace: nameLocationCtrl.text,
                            location: state?.toJson(),
                            radius: currentRadius,
                            colorPlace: selectColor,
                          );

                          if (getIt<SelectGroupCubit>().state != null) {
                            await FirestoreClient.instance.createPlace(
                              getIt<SelectGroupCubit>().state!.idGroup!,
                              newPlace,
                            );
                            for (final member in Global.instance.groupMembers) {
                              await NotificationPlaceManager
                                  .createNotificationPlace(
                                idGroup:
                                    getIt<SelectGroupCubit>().state!.idGroup!,
                                idPlace: newPlace.idPlace!,
                                idDocNotification: member.code,
                                storeNotificationPlace:
                                    const StoreNotificationPlace(),
                              );
                            }
                          }
                          if (widget.place != null) {
                            final List<StorePlace> updatedList = List.from(
                                getIt<DefaultPlaceCubit>().state ?? []);
                            updatedList.remove(widget.place);
                            getIt<DefaultPlaceCubit>().update(updatedList);
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
                            await FirestoreClient.instance.updatePlace(
                              getIt<SelectGroupCubit>().state!.idGroup!,
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
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.containerBorder).r,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              child: Stack(
                children: [
                  BlocConsumer<ValueCubit<String>, String>(
                    bloc: icPlaceCubit,
                    listener: (context, state) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        captureMarker();
                      });
                    },
                    builder: (context, state) {
                      return Positioned(
                        child: RepaintBoundary(
                          key: keyCap,
                          child: SvgPicture.asset(
                            state,
                            width: 60.r,
                            height: 69.r,
                            colorFilter: const ColorFilter.mode(
                              Color(0xff7B3EFF),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                      child: Container(
                    color: Colors.white,
                  )),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: BlocBuilder<SelectPlaceCubit, StoreLocation?>(
                      bloc: selectPlaceCubit,
                      builder: (context, state) {
                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: Global.instance.currentLocation,
                            zoom: 16,
                          ),
                          onMapCreated: (controller) {
                            _mapController.complete(controller);
                          },
                          markers: <Marker>{
                            Marker(
                              markerId: const MarkerId('markerPlace'),
                              position: LatLng(
                                  state?.lat ??
                                      Global.instance.currentLocation.latitude,
                                  state?.lng ??
                                      Global
                                          .instance.currentLocation.longitude),
                              icon:
                                  markerPlace ?? BitmapDescriptor.defaultMarker,
                            ),
                          },
                          circles: {
                            Circle(
                              circleId: const CircleId('radiusPlace'),
                              center: LatLng(
                                  state?.lat ??
                                      Global.instance.currentLocation.latitude,
                                  state?.lng ??
                                      Global
                                          .instance.currentLocation.longitude),
                              radius: currentRadius,
                              fillColor: Color(selectColor).withOpacity(0.25),
                              strokeColor: Color(selectColor),
                              strokeWidth: 1,
                              zIndex: 1,
                            )
                          },
                          zoomControlsEnabled: false,
                          onCameraMove: (CameraPosition position) {},
                          compassEnabled: false,
                          mapType: getIt<MapTypeCubit>().state,
                          myLocationButtonEnabled: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            24.verticalSpace,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 20,
                        childAspectRatio: 56 / 40,
                      ),
                      shrinkWrap: true,
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
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 12.w),
                      ),
                    ),
                    24.verticalSpace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.l10n.name,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.l10n.location,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: MyColors.black34,
                        ),
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
                        Visibility(
                          visible: false,
                          maintainSize: true,
                          maintainState: true,
                          maintainAnimation: true,
                          child: Text(context.l10n.radius),
                        ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
