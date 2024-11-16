library state_package;

import 'package:state_package/src/base/state_base.dart';
import 'package:state_package/src/utils/logger.dart';

class MapStateManager<K, V> extends BaseStateManager<Map<K, V>> {
  MapStateManager(
    super.initialValue,
  );

  void addItem(K key, V itemValue) {
    final updatedMap = Map<K, V>.from(value.value)..[key] = itemValue;
    update(updatedMap);
  }

  void addAllItems(Map<K, V> items) {
    final updatedMap = Map<K, V>.from(value.value)..addAll(items);
    update(updatedMap);
  }

  void updateItem(K key, V newValue) {
    final updatedMap = Map<K, V>.from(value.value);
    if (updatedMap.containsKey(key)) {
      updatedMap[key] = newValue;
      update(updatedMap);
      // Logger.info("Updated item: $key -> $newValue");
    } else {
      Logger.info("Key not found: $key");
    }
  }

  void removeItem(K key) {
    final updatedMap = Map<K, V>.from(value.value);
    if (updatedMap.containsKey(key)) {
      updatedMap.remove(key);
      update(updatedMap);
      // Logger.info("Removed item with key: $key");
    } else {
      Logger.info("Key not found: $key");
    }
  }

  void removeListItem(List<K> keys) {
    if (keys.isEmpty) {
      Logger.info("No keys");
      return;
    }
    final keysToRemove =
        keys.where((key) => value.value.containsKey(key)).toList();

    if (keysToRemove.isEmpty) {
      Logger.info("Not found in the map.");
      return;
    }

    final updatedMap = Map<K, V>.from(value.value)
      ..removeWhere((key, _) => keysToRemove.contains(key));

    update(updatedMap);
  }

  void clearMap() {
    update({});
  }

  void mergeMap(Map<K, V> newMap) {
    final updatedMap = {...value.value, ...newMap};
    update(updatedMap);
  }
}
