import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/cubit/value_cubit.dart';

@singleton
class TrackingRoutesCubit extends ValueCubit<Set<Polyline>?> {
  TrackingRoutesCubit() : super(null);
}
