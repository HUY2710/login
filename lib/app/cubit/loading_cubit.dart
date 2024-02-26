import 'package:injectable/injectable.dart';

import '../../src/config/di/di.dart';
import '../../src/shared/cubit/value_cubit.dart';

@singleton
class LoadingCubit extends ValueCubit<bool> {
  LoadingCubit() : super(false);
}

void showLoading() => getIt<LoadingCubit>().update(true);

void hideLoading() => getIt<LoadingCubit>().update(false);
