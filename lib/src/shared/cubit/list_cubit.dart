import 'restorable_cubit.dart';

class ListCubit<T> extends RestorableCubit<List<T>> {
  ListCubit(super.initialState);

  void add(T element) => emit([...state, element]);

  void addToHead(T element) => emit([element, ...state]);

  void removeAt(int index) {
    state.removeAt(index);
    emit([...state]);
  }

  void remove(T element) {
    state.remove(element);
    emit([...state]);
  }

  void removeWhere(bool Function(T element) test) {
    state.removeWhere(test);
    emit([...state]);
  }

  void removeLast() {
    state.removeLast();
    emit([...state]);
  }

  void updateAt(int index, T newValue) {
    state.removeAt(index);
    state.insert(index, newValue);
    emit([...state]);
  }

  void updateWhere(bool Function(T element) test, T newValue) {
    final int index = state.indexWhere(test);
    if (index >= 0) {
      state.removeAt(index);
      state.insert(index, newValue);
      emit([...state]);
    }
  }

  void moveWhere(bool Function(T element) test, int to) {
    final int index = state.indexWhere(test);
    if (index >= 0) {
      final T element = state[index];
      state.removeAt(index);
      state.insert(to, element);
      emit([...state]);
    }
  }

  void refresh() => emit([...state]);
}
