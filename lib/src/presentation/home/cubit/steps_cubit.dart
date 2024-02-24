import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class StepsCubit extends Cubit<int> with HydratedMixin {
  StepsCubit() : super(0) {
    hydrate();
  }

  void update(int step) {
    emit(step);
  }

  @override
  int fromJson(Map<String, dynamic> json) {
    if (json['steps'] != null) {
      return json['steps'];
    }
    return 0;
  }

  @override
  Map<String, dynamic>? toJson(int state) {
    return {'steps': state};
  }
}
