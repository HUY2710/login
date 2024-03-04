import 'package:injectable/injectable.dart';

import '../../../shared/cubit/value_cubit.dart';

enum CodeType { code, qrCode }

@injectable
class CodeTypeCubit extends ValueCubit<CodeType> {
  CodeTypeCubit() : super(CodeType.code);
}
