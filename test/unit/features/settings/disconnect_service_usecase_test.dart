import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/repositories/settings_repository.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/usecases/disconnect_service_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late DisconnectServiceUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = DisconnectServiceUseCase(mockRepository);
  });

  group('DisconnectServiceUseCase', () {
    const tService = ServiceType.googleCalendar;

    test('gibt null zurück bei Erfolg', () async {
      when(
        () => mockRepository.deleteCredential(tService),
      ).thenAnswer((_) async => null);

      final result = await useCase(tService);

      expect(result, isNull);
      verify(() => mockRepository.deleteCredential(tService)).called(1);
    });

    test('gibt Failure zurück wenn Repository fehlschlägt', () async {
      const tFailure = NetworkFailure();
      when(
        () => mockRepository.deleteCredential(tService),
      ).thenAnswer((_) async => tFailure);

      final result = await useCase(tService);

      expect(result, isA<NetworkFailure>());
    });
  });
}
