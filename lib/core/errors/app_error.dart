import 'package:flutter/material.dart';

/// App-level error types for structured error handling.
/// Every error has a human-readable message and an optional action.
sealed class AppError {
  const AppError();
}

class NetworkError extends AppError {
  const NetworkError({this.message = 'No internet connection. Please check your network and try again.'});
  final String message;
}

class AuthError extends AppError {
  const AuthError({required this.message});
  final String message;
}

class StorageError extends AppError {
  const StorageError({required this.message});
  final String message;
}

class PermissionError extends AppError {
  const PermissionError({required this.message});
  final String message;
}

class PlaybackError extends AppError {
  const PlaybackError({required this.message});
  final String message;
}

class ClipError extends AppError {
  const ClipError({required this.message});
  final String message;
}

class MergeError extends AppError {
  const MergeError({required this.message});
  final String message;
}

class RecordingError extends AppError {
  const RecordingError({required this.message});
  final String message;
}

class ServerError extends AppError {
  const ServerError({this.message = 'Server error. Please try again later.', this.code});
  final String message;
  final int? code;
}

class UnknownError extends AppError {
  const UnknownError({this.message = 'An unexpected error occurred.'});
  final String message;
}

/// Result type for repository operations.
/// Use instead of throwing exceptions in business logic.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppError error;
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
    Success(:final data) => data,
    Failure() => null,
  };

  AppError? get errorOrNull => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onFailure,
  }) =>
      switch (this) {
        Success(:final data) => onSuccess(data),
        Failure(:final error) => onFailure(error),
      };
}

/// Human-readable messages for all error types.
extension AppErrorMessage on AppError {
  String get userMessage => switch (this) {
    NetworkError(:final message) => message,
    AuthError(:final message) => message,
    StorageError(:final message) => message,
    PermissionError(:final message) => message,
    PlaybackError(:final message) => message,
    ClipError(:final message) => message,
    MergeError(:final message) => message,
    RecordingError(:final message) => message,
    ServerError(:final message) => message,
    UnknownError(:final message) => message,
  };

  String get actionLabel => switch (this) {
    NetworkError() => 'Retry',
    AuthError() => 'Try Again',
    StorageError() => 'Check Storage',
    PermissionError() => 'Open Settings',
    PlaybackError() => 'Retry',
    ClipError() => 'Try Again',
    MergeError() => 'Try Again',
    RecordingError() => 'Try Again',
    ServerError() => 'Retry',
    UnknownError() => 'Dismiss',
  };
}

/// Helper to show a standardized error snackbar.
void showErrorSnackBar(BuildContext context, AppError error, {VoidCallback? onAction}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error.userMessage),
      action: onAction != null
          ? SnackBarAction(label: error.actionLabel, onPressed: onAction)
          : null,
      duration: const Duration(seconds: 4),
    ),
  );
}
