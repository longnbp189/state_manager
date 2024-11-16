import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:state_package/src/models/state_model.dart';
import 'package:state_package/src/utils/logger.dart';

class BaseValueListenableBuilder<T> extends StatelessWidget {
  final ValueListenable<T> valueListenable;
  final Widget Function(BuildContext context, T value) builder;
  final bool Function(T previousValue, T newValue)? buildWhen;
  final String? log;

  const BaseValueListenableBuilder({
    super.key,
    required this.valueListenable,
    required this.builder,
    this.buildWhen,
    this.log,
  });

  @override
  Widget build(BuildContext context) {
    T? previousValue;
    return ValueListenableBuilder<T>(
      valueListenable: valueListenable,
      builder: (context, newValue, _) {
        T currentValue = newValue;

        if (buildWhen != null &&
            !buildWhen!(previousValue ?? newValue, newValue)) {
          currentValue = previousValue ?? newValue;
        } else {
          previousValue = newValue;
        }

        if (log != null) {
          Logger.info(
              '$log: Rebuilding with value: ${currentValue is StateModel ? currentValue.value : currentValue}');
        }
        return builder(context, currentValue);
      },
    );
  }
}
