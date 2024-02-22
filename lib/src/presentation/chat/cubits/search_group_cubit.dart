import '../../../data/models/store_group/store_group.dart';
import '../../../shared/cubit/value_cubit.dart';

class SearchGroupCubit extends ValueCubit<List<StoreGroup>> {
  SearchGroupCubit() : super([]);

  void searchGroup(String text, List<StoreGroup> myGroups) {
    final result = myGroups
        .where(
          (group) => group.groupName.contains(text),
        )
        .toList();
    if (text.isEmpty) {
      emit([]);
    } else {
      if (result.isEmpty) {
        emit([]);
      } else {
        emit(result);
      }
    }
  }
}
