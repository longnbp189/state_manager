library state_package;

import 'package:state_package/src/base/state_base.dart';
import 'package:state_package/src/utils/logger.dart';

class ListStateManager<T> extends BaseStateManager<List<T>> {
  ListStateManager(
    super.initialValue,
  );

  void addItem(T item) {
    update([...value.value, item]);
  }

  void addAllItems(List<T> items) {
    update([...value.value, ...items]);
  }

  void updateItem(T item) {
    final updatedList = List<T>.from(value.value);
    final index = updatedList.indexOf(item);

    if (index != -1) {
      updatedList[index] = item;
      update(updatedList);
      // Logger.info("Update item: $item");
    } else {
      Logger.info("Item not found: $item");
    }
    update(updatedList);
  }

  void updateAt(int index, T newItem) {
    if (_isValidIndex(index)) {
      final updatedList = List<T>.from(value.value);
      updatedList[index] = newItem;
      update(updatedList);
    } else {
      Logger.info("Invalid index: $index");
    }
  }

  void removeAt(int index) {
    if (_isValidIndex(index)) {
      final updatedList = List<T>.from(value.value)..removeAt(index);
      update(updatedList);
    } else {
      Logger.info("Invalid index: $index");
    }
  }

  void removeItem(T item) {
    final updatedList = List<T>.from(value.value);

    if (updatedList.contains(item)) {
      updatedList.remove(item);
      update(updatedList);
      // Logger.info("Removed item: $item");
    } else {
      Logger.info("Item not found: $item");
    }
    update(updatedList);
  }

  void removeListItem(List<T> items) {
    if (items.isEmpty) {
      Logger.info("No items");
      return;
    }

    final itemsToRemove =
        items.where((item) => value.value.contains(item)).toList();

    if (itemsToRemove.isEmpty) {
      Logger.info("Not found in the list.");
      return;
    }

    final updatedList =
        value.value.where((element) => !items.contains(element)).toList();
    update(updatedList);
  }

  void clearList() {
    update([]);
  }

  void getWhere(bool Function(T) predicate) {
    update(value.value.where(predicate).toList());
  }

  bool _isValidIndex(int index) {
    return index >= 0 && index < value.value.length;
  }
}
