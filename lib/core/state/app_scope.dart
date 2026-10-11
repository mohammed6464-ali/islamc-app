import 'package:flutter/widgets.dart';

import 'app_state.dart';

/// Makes the shared demo state available to the whole widget tree.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final AppScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope was not found above this widget.');
    return scope!.notifier!;
  }

  /// Reads the state without subscribing — for callbacks and one-off writes.
  static AppState read(BuildContext context) {
    final AppScope? scope =
        context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope was not found above this widget.');
    return scope!.notifier!;
  }
}
