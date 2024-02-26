import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/di/di.dart';
import '../../../gen/gens.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/containers/shadow_container.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../map/cubit/map_type_cubit.dart';
import '../../map/models/map_type_item.dart';

@RoutePage()
class MapTypeScreen extends StatelessWidget {
  const MapTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late final List<MapItem> mapTypes = <MapItem>[
      MapItem(
        asset: Assets.images.mapTypes.traffic.path,
        title: context.l10n.mapTraffic,
        type: MapType.terrain,
      ),
      MapItem(
        asset: Assets.images.mapTypes.normal.path,
        title: context.l10n.mapNormal,
        type: MapType.normal,
      ),
      MapItem(
        asset: Assets.images.mapTypes.satellite.path,
        title: context.l10n.mapSatellite,
        type: MapType.satellite,
      ),
    ];

    final MapTypeCubit mapTypeCubit = getIt<MapTypeCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: context.l10n.mapType),
      body: BlocBuilder<MapTypeCubit, MapType>(
        bloc: mapTypeCubit,
        builder: (context, state) {
          return ListView.separated(
            itemCount: mapTypes.length,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            itemBuilder: (context, index) {
              final MapItem item = mapTypes[index];
              return GestureDetector(
                onTap: () {
                  mapTypeCubit.update(item.type);
                },
                child: ShadowContainer(
                  height: 152.h,
                  colorBorder:
                      state == item.type ? const Color(0xff7B3EFF) : null,
                  colorShadow: const Color(0xff9C747D).withOpacity(0.17),
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(18.r)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Image.asset(
                          item.asset,
                          fit: BoxFit.fill,
                        )),
                        10.verticalSpace,
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  color: MyColors.primary,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (state == item.type)
                              Positioned(
                                right: 10.w,
                                child: const Icon(
                                  Icons.check,
                                  color: MyColors.primary,
                                ),
                              )
                          ],
                        ),
                        14.verticalSpace
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
          );
        },
      ),
    );
  }
}
