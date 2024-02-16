import 'package:injectable/injectable.dart';

import '../../../data/models/store_location/store_location.dart';
import '../../../shared/cubit/value_cubit.dart';

@injectable
class SelectPlaceCubit extends ValueCubit<StoreLocation?> {
  SelectPlaceCubit() : super(null);
}
