import 'package:injectable/injectable.dart';

import '../../../shared/cubit/value_cubit.dart';

@singleton
class BannerCollapseAdCubit extends ValueCubit<bool> {
  BannerCollapseAdCubit() : super(true);
}
