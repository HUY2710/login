import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/di/di.dart';
import '../cubit/map_type_cubit.dart';
import '../models/map_type_item.dart';

class MapTypeSelector extends StatefulWidget {
  const MapTypeSelector({super.key});

  @override
  State<MapTypeSelector> createState() => _MapTypeSelectorState();
}

class _MapTypeSelectorState extends State<MapTypeSelector> {
  late final List<MapItem> mapTypes = <MapItem>[
    MapItem(
        asset: 'Assets.images.map.normalMap.path',
        title: 'context.l10n.normalMap',
        type: MapType.normal),
    MapItem(
        asset: 'Assets.images.map.satelliteMap.path',
        title: 'context.l10n.satelliteMap',
        type: MapType.satellite),
    MapItem(
        asset: ' Assets.images.map.trafficMap.path',
        title: 'context.l10n.traffic',
        type: MapType.hybrid),
    MapItem(
        asset: 'Assets.images.map.streetMap.path',
        title: 'context.l10n.streetView',
        type: MapType.terrain),
  ];

  final MapTypeCubit _mapTypeCubit = getIt<MapTypeCubit>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).w,
      child: BlocBuilder<MapTypeCubit, MapType>(
        bloc: _mapTypeCubit,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              6.verticalSpace,
              Center(
                child: Container(
                  height: 5,
                  width: 36.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5).r,
                    color: Colors.grey,
                  ),
                ),
              ),
              Text(
                'Map Detail',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              16.verticalSpace,
              Expanded(
                child: Row(children: [
                  Expanded(child: _buildItem(0, state)),
                  10.horizontalSpace,
                  Expanded(child: _buildItem(1, state)),
                ]),
              ),
              16.verticalSpace,
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildItem(2, state)),
                    10.horizontalSpace,
                    Expanded(child: _buildItem(3, state)),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem(int index, MapType state) {
    return GestureDetector(
      onTap: () {
        _mapTypeCubit.update(mapTypes[index].type);
      },
      child: Container(
        color: Colors.green,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15).r,
                border: Border.all(
                  width: 2,
                  color: state.name == mapTypes[index]
                      ? Colors.red
                      : Colors.transparent,
                ),
              ),
              // child: Image.asset(
              //   mapType[index].asset,
              //   width: 173.w,
              //   height: 60.h,
              //   fit: BoxFit.fill,
              // ),
            ),
            10.verticalSpace,
            Expanded(
              child: Text(
                mapTypes[index].title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color:
                      state.name == mapTypes[index] ? Colors.red : Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
