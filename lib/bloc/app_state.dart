import 'package:bloc_example/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final LoginError? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchNotes;

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchNotes = null;

  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.fetchNotes,
  });

  @override
  String toString() => {
        'isLoading': isLoading,
        'loginErrors': loginError,
        'loginHandle': loginHandle,
        'fetchNotes': fetchNotes,
      }.toString();
}
