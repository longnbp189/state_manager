library state_package;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:state_package/src/models/state_model.dart';
import 'package:state_package/src/utils/logger.dart';

abstract class BaseStateManager<T> extends ValueNotifier<StateModel<T>> {
  BaseStateManager(
    super.initialValue,
  );

  void update(T newValue) {
    value = value.copyWith(value: newValue, isLoading: false);
  }

  Future<void> updateAsync(Future<T> newValueFuture) async {
    value = value.copyWith(isLoading: true);
    try {
      final newValue = await newValueFuture;
      value = value.copyWith(isLoading: false);
      update(newValue);
    } catch (e) {
      value.copyWith(isLoading: false, error: e.toString());
      Logger.error("Failed to update asynchronously: ${e.toString()}");
    }
  }
}
