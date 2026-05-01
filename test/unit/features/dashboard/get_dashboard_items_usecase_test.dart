import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/usecases/get_dashboard_items_usecase.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late GetDashboardItemsUseCase useCase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetDashboardItemsUseCase(mockRepository);
  });

  group('GetDashboardItemsUseCase', () {
    final tNote = const NoteItem(
      id: '1',
      title: 'Test Note',
      sourceService: 'notion',
    );
    final tData = DashboardData(todos: const [], lastNote: tNote);

    test(
      'gibt DashboardData zurück wenn Repository erfolgreich antwortet',
      () async {
        when(
          () => mockRepository.getDashboard(),
        ).thenAnswer((_) async => (data: tData, failure: null));

        final result = await useCase();

        expect(result.data, tData);
        expect(result.failure, isNull);
        verify(() => mockRepository.getDashboard()).called(1);
      },
    );

    test('gibt Failure zurück wenn Repository fehlschlägt', () async {
      const tFailure = NetworkFailure();
      when(
        () => mockRepository.getDashboard(),
      ).thenAnswer((_) async => (data: null, failure: tFailure));

      final result = await useCase();

      expect(result.data, isNull);
      expect(result.failure, isA<NetworkFailure>());
    });
  });
}
