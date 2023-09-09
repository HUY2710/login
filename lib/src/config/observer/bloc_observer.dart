import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/utils/logger_utils.dart';

class MainBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    logger.w('CREATE', '${bloc.runtimeType}');
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    logger.w('CLOSE', '${bloc.runtimeType}');
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.e('ERROR', 'Bloc: ${bloc.runtimeType}, Error: $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    logger.d('TRANSITION', '${bloc.runtimeType} , Transition: $transition');
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    logger.i('CHANGE', '${bloc.runtimeType}, Change: $change');
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    logger.d('EVENT', 'Bloc: ${bloc.runtimeType}, Event: ${event.runtimeType}');
    super.onEvent(bloc, event);
  }
}
