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
    final dateJson = json['date'] as Map<String, dynamic>?;
    if (json['steps'] != null && dateJson != null) {
      final year = dateJson['year'] as int?;
      final month = dateJson['month'] as int?;
      final day = dateJson['day'] as int?;
      if (year != null && month != null && day != null) {
        final currentDate = DateTime.now();
        final previousDate = DateTime(year, month, day);
        if (currentDate.day != previousDate.day) {
          // Reset countStep về 0 nếu ngày trước đó khác với ngày hiện tại
          return 0;
        }
        return json['steps'] as int;
      }
    }
    return 0;
  }

  @override
  Map<String, dynamic>? toJson(int state) {
    final currentDate = DateTime.now();
    return {
      'steps': state,
      'date': {
        'year': currentDate.year,
        'month': currentDate.month,
        'day': currentDate.day,
      }
    };
  }
}
