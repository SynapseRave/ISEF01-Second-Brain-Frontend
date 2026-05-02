import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_data.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_profile.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_settings.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/repositories/user_repository.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/usecases/update_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UpdateUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UpdateUserUseCase(mockRepository);
  });

  const tProfile = UserProfile(
    sub: 'user-1',
    name: 'Test',
    email: 'new@example.com',
  );
  const tSettings = UserSettings(preferredLlm: 'claude-3');
  const tUpdated = UserData(profile: tProfile, settings: tSettings);

  group('UpdateUserUseCase', () {
    test('gibt aktualisierte UserData zurück bei Erfolg', () async {
      when(
        () => mockRepository.updateUser(
          email: any(named: 'email'),
          password: any(named: 'password'),
          preferredLlm: any(named: 'preferredLlm'),
          defaultTargets: any(named: 'defaultTargets'),
        ),
      ).thenAnswer((_) async => (tUpdated, null));

      final (data, failure) = await useCase(
        email: 'new@example.com',
        preferredLlm: 'claude-3',
      );

      expect(data, tUpdated);
      expect(failure, isNull);
    });

    test('gibt Failure zurück wenn Repository fehlschlägt', () async {
      const tFailure = ValidationFailure();
      when(
        () => mockRepository.updateUser(
          email: any(named: 'email'),
          password: any(named: 'password'),
          preferredLlm: any(named: 'preferredLlm'),
          defaultTargets: any(named: 'defaultTargets'),
        ),
      ).thenAnswer((_) async => (null, tFailure));

      final (data, failure) = await useCase(email: 'invalid');

      expect(data, isNull);
      expect(failure, isA<ValidationFailure>());
    });
  });
}
