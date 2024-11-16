class StateModel<T> {
  final T value;
  final bool? isLoading;
  final String? error;
  const StateModel({
    required this.value,
    this.isLoading = false,
    this.error,
  });

  StateModel<T> copyWith({
    T? value,
    bool? isLoading,
    String? error,
  }) {
    return StateModel<T>(
      value: value ?? this.value,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
