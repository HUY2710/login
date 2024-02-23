import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../config/di/di.dart';
import '../../../gen/gens.dart';
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
        title: 'Traffic',
        type: MapType.terrain,
      ),
      MapItem(
        asset: Assets.images.mapTypes.normal.path,
        title: 'Normal',
        type: MapType.normal,
      ),
      MapItem(
        asset: Assets.images.mapTypes.satellite.path,
        title: 'Satellite',
        type: MapType.satellite,
      ),
    ];

    final MapTypeCubit mapTypeCubit = getIt<MapTypeCubit>();
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              itemCount: mapTypes.length,
              itemBuilder: (context, index) {
                return const ShadowContainer(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
