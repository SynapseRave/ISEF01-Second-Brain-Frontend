import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/usecases/get_dashboard_items_usecase.dart';

// mocktail erstellt ein Fake-Objekt das das Interface implementiert.
// Der Use Case bekommt das Fake-Repository injiziert — kein echtes HTTP.
class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late GetDashboardItemsUseCase useCase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetDashboardItemsUseCase(mockRepository);
  });

  group('GetDashboardItemsUseCase', () {
    final tItems = [
      const NoteItem(id: '1', title: 'Test Note', sourceService: 'notion'),
    ];

    test('gibt Items zurück wenn Repository erfolgreich antwortet', () async {
      // arrange — Mock definieren: was soll das Repository zurückgeben?
      when(
        () => mockRepository.getDashboardItems(),
      ).thenAnswer((_) async => (items: tItems, failure: null));

      // act — Use Case aufrufen
      final result = await useCase();

      // assert — Ergebnis prüfen
      expect(result.items, tItems);
      expect(result.failure, isNull);
      verify(() => mockRepository.getDashboardItems()).called(1);
    });

    test('gibt Failure zurück wenn Repository fehlschlägt', () async {
      const tFailure = NetworkFailure();
      when(
        () => mockRepository.getDashboardItems(),
      ).thenAnswer((_) async => (items: <DashboardItem>[], failure: tFailure));

      final result = await useCase();

      expect(result.items, isEmpty);
      expect(result.failure, isA<NetworkFailure>());
    });
  });
}
