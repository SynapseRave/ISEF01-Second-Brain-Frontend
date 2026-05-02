import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_data.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_profile.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_settings.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/repositories/user_repository.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/usecases/get_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late GetUserUseCase useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserUseCase(mockRepository);
  });

  const tProfile = UserProfile(sub: 'user-1', name: 'Test', email: 'test@example.com');
  const tSettings = UserSettings(preferredLlm: 'gpt-4');
  const tUserData = UserData(profile: tProfile, settings: tSettings);

  group('GetUserUseCase', () {
    test('gibt UserData zurück bei Erfolg', () async {
      when(() => mockRepository.getUser()).thenAnswer((_) async => (tUserData, null));

      final (data, failure) = await useCase();

      expect(data, tUserData);
      expect(failure, isNull);
      verify(() => mockRepository.getUser()).called(1);
    });

    test('gibt Failure zurück wenn Repository fehlschlägt', () async {
      const tFailure = AuthFailure();
      when(() => mockRepository.getUser()).thenAnswer((_) async => (null, tFailure));

      final (data, failure) = await useCase();

      expect(data, isNull);
      expect(failure, isA<AuthFailure>());
    });
  });
}
