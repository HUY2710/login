import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../config/di/di.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/widgets/my_drag.dart';
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
      asset: Assets.images.mapTypes.normal.path,
      title: 'Normal',
      type: MapType.normal,
    ),
    MapItem(
        asset: Assets.images.mapTypes.street.path,
        title: 'Street',
        type: MapType.terrain),
    MapItem(
      asset: Assets.images.mapTypes.satellite.path,
      title: 'Satellite',
      type: MapType.satellite,
    ),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              6.verticalSpace,
              const MyDrag(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Map Type',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: MyColors.black34,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.popRoute(),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: context.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              _buildItem(0, state),
              24.verticalSpace,
              _buildItem(1, state),
              24.verticalSpace,
              _buildItem(2, state),
              31.verticalSpace
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: state == mapTypes[index].type
                    ? context.colorScheme.primary
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            child: Image.asset(
              mapTypes[index].asset,
              width: 40.r,
              height: 40.r,
              fit: BoxFit.fill,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(
              mapTypes[index].title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: MyColors.black34,
              ),
            ),
          ),
          if (state == mapTypes[index].type) const Icon(Icons.check)
        ],
      ),
    );
  }
}
