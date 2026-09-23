import 'package:flutter_test/flutter_test.dart';
import 'package:patt_petti/core/errors/app_error.dart';

void main() {
  group('Result<T> Pattern', () {
    test('Success holds data and invokes onSuccess callback', () {
      const result = Success<String>('Hello Pattu Petti');

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, 'Hello Pattu Petti');
      expect(result.errorOrNull, isNull);

      final folded = result.fold(
        onSuccess: (data) => 'Got: $data',
        onFailure: (err) => 'Error: ${err.userMessage}',
      );
      expect(folded, 'Got: Hello Pattu Petti');
    });

    test('Failure holds AppError and invokes onFailure callback', () {
      const error = NetworkError(message: 'Connection timeout');
      const result = Failure<String>(error);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.errorOrNull, equals(error));

      final folded = result.fold(
        onSuccess: (data) => 'Got: $data',
        onFailure: (err) => 'Error: ${err.userMessage}',
      );
      expect(folded, contains('Connection timeout'));
    });
  });
}
