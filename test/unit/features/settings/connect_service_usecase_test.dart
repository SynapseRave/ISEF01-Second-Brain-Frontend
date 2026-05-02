import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/repositories/settings_repository.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/usecases/connect_service_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late ConnectServiceUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = ConnectServiceUseCase(mockRepository);
  });

  group('ConnectServiceUseCase', () {
    const tService = ServiceType.notion;
    final tCredentials = {'api_token': 'secret-123'};

    test('gibt null zurück bei Erfolg', () async {
      when(
        () => mockRepository.storeCredential(tService, tCredentials),
      ).thenAnswer((_) async => null);

      final result = await useCase(tService, tCredentials);

      expect(result, isNull);
      verify(
        () => mockRepository.storeCredential(tService, tCredentials),
      ).called(1);
    });

    test('gibt Failure zurück wenn Repository fehlschlägt', () async {
      const tFailure = ServerFailure();
      when(
        () => mockRepository.storeCredential(tService, tCredentials),
      ).thenAnswer((_) async => tFailure);

      final result = await useCase(tService, tCredentials);

      expect(result, isA<ServerFailure>());
    });
  });
}
