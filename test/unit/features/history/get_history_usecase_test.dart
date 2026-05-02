import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/paginated_history.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/repositories/history_repository.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/usecases/get_history_usecase.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late GetHistoryUseCase useCase;
  late MockHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoryRepository();
    useCase = GetHistoryUseCase(mockRepository);
  });

  final tEntry = HistoryEntry(
    id: 1,
    prompt: 'Was ist KI?',
    createdAt: DateTime(2024, 1, 1),
    conversationId: 'conv-1',
  );
  final tPaginated = PaginatedHistory(
    items: [tEntry],
    total: 5,
    page: 1,
    pageSize: 20,
    pages: 3,
  );

  group('GetHistoryUseCase', () {
    test('gibt PaginatedHistory zurück bei Erfolg', () async {
      when(
        () => mockRepository.getHistory(page: any(named: 'page'), pageSize: any(named: 'pageSize')),
      ).thenAnswer((_) async => (tPaginated, null));

      final (data, failure) = await useCase(page: 1);

      expect(data, tPaginated);
      expect(failure, isNull);
    });

    test('ruft Repository mit page=1 standardmäßig auf', () async {
      when(
        () => mockRepository.getHistory(page: any(named: 'page'), pageSize: any(named: 'pageSize')),
      ).thenAnswer((_) async => (tPaginated, null));

      await useCase();

      verify(() => mockRepository.getHistory(page: 1, pageSize: any(named: 'pageSize'))).called(1);
    });

    test('gibt Failure zurück wenn Repository fehlschlägt', () async {
      const tFailure = NetworkFailure();
      when(
        () => mockRepository.getHistory(page: any(named: 'page'), pageSize: any(named: 'pageSize')),
      ).thenAnswer((_) async => (null, tFailure));

      final (data, failure) = await useCase();

      expect(data, isNull);
      expect(failure, isA<NetworkFailure>());
    });
  });
}
