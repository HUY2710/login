import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/di/di.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../gen/assets.gen.dart';
import '../../../global/global.dart';
import '../../../shared/widgets/containers/border_container.dart';
import '../../map/cubit/location_listen/location_listen_cubit.dart';
import '../../map/cubit/select_user_cubit.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.mapController,
    required this.locationListenCubit,
  });
  final Completer<GoogleMapController> mapController;
  final LocationListenCubit locationListenCubit;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  GoogleMapController? _googleMapController;
import '../../../gen/gens.dart';
import 'modal_bottom/members/widgets/modal_edit.dart';
import 'modal_bottom/members/widgets/modal_show.dart';

  @override
  void initState() {
    widget.mapController.future.then((value) => _googleMapController = value);
    super.initState();
  }

  Future<void> _goToDetailLocation() async {
    //test
    final CameraPosition newPosition = CameraPosition(
      target: Global.instance.location,
      zoom: 16,
    );
    _googleMapController
        ?.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildItem(Assets.icons.icPeople.path, context),
        23.horizontalSpace,
        //avatar
        23.horizontalSpace,
        buildItem(Assets.icons.icMessage.path, context),
      ],
    );
  }

  Widget buildItem(String path, BuildContext context, {bool? avatar}) {
    final value = ValueNotifier<int>(0);
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, _) {
                return ValueListenableBuilder(
                    valueListenable: value,
                    builder: (context, val, child) {
                      return AnimatedSwitcher(
                          duration: const Duration(
                            microseconds: 700,
                          ),
                          child: (val == 0)
                              ? ModalShowMember(value: value)
                              : ModalEditMember(value: value));
                    });
              });
            });
      },
      child: Container(
        height: 48.r,
        width: 48.r,
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
          gradient: const LinearGradient(colors: [
            Color(0xffB67DFF),
            Color(0xff7B3EFF),
          ]),
        ),
        child: SvgPicture.asset(
          path,
          height: 22.r,
          width: 22.r,
        ),
      ),
    );
  }

  Widget _buildAvatar(String pathAvatar) {
    return Container(
      height: 72.r,
      width: 72.r,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(25.r),
        ),
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 2.5,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(25.r),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        pathAvatar,
      ),
    );
  }
}
