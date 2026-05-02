import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/paginated_history.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/repositories/history_repository.dart';
import 'package:isef01_second_brain_frontend/features/history/presentation/bloc/history_cubit.dart';
import 'package:isef01_second_brain_frontend/features/history/presentation/bloc/history_state.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  late MockHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockHistoryRepository();
  });

  HistoryEntry makeEntry(int id) => HistoryEntry(
    id: id,
    prompt: 'Frage $id',
    createdAt: DateTime(2024, 1, id),
    conversationId: 'conv-$id',
  );

  PaginatedHistory makePage({
    required List<HistoryEntry> items,
    required int page,
    required int pages,
  }) => PaginatedHistory(
    items: items,
    total: pages * 2,
    page: page,
    pageSize: 2,
    pages: pages,
  );

  group('HistoryCubit', () {
    test('Initialzustand ist HistoryInitial', () {
      final cubit = HistoryCubit(mockRepository);
      expect(cubit.state, isA<HistoryInitial>());
      cubit.close();
    });

    blocTest<HistoryCubit, HistoryState>(
      'loadHistory() Erfolg → HistoryLoading dann HistoryLoaded',
      build: () {
        when(
          () => mockRepository.getHistory(
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          ),
        ).thenAnswer(
          (_) async =>
              (makePage(items: [makeEntry(1)], page: 1, pages: 2), null),
        );
        return HistoryCubit(mockRepository);
      },
      act: (cubit) => cubit.loadHistory(),
      expect: () => [
        isA<HistoryLoading>(),
        predicate<HistoryState>(
          (s) =>
              s is HistoryLoaded &&
              s.entries.length == 1 &&
              s.currentPage == 1 &&
              s.totalPages == 2 &&
              s.hasMore,
        ),
      ],
    );

    blocTest<HistoryCubit, HistoryState>(
      'loadHistory() Fehler → HistoryError',
      build: () {
        when(
          () => mockRepository.getHistory(
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          ),
        ).thenAnswer((_) async => (null, const NetworkFailure()));
        return HistoryCubit(mockRepository);
      },
      act: (cubit) => cubit.loadHistory(),
      expect: () => [isA<HistoryLoading>(), isA<HistoryError>()],
    );

    blocTest<HistoryCubit, HistoryState>(
      'loadMore() hängt weitere Einträge an',
      build: () {
        var callCount = 0;
        when(
          () => mockRepository.getHistory(
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          ),
        ).thenAnswer((_) async {
          callCount++;
          if (callCount == 1) {
            return (makePage(items: [makeEntry(1)], page: 1, pages: 2), null);
          }
          return (makePage(items: [makeEntry(2)], page: 2, pages: 2), null);
        });
        return HistoryCubit(mockRepository);
      },
      act: (cubit) async {
        await cubit.loadHistory();
        await cubit.loadMore();
      },
      expect: () => [
        isA<HistoryLoading>(),
        predicate<HistoryState>(
          (s) => s is HistoryLoaded && s.entries.length == 1,
        ),
        predicate<HistoryState>((s) => s is HistoryLoaded && s.isLoadingMore),
        predicate<HistoryState>(
          (s) =>
              s is HistoryLoaded &&
              s.entries.length == 2 &&
              s.currentPage == 2 &&
              !s.hasMore,
        ),
      ],
    );

    blocTest<HistoryCubit, HistoryState>(
      'deleteEntry() entfernt Eintrag aus der Liste',
      build: () {
        when(
          () => mockRepository.getHistory(
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          ),
        ).thenAnswer(
          (_) async => (
            makePage(items: [makeEntry(1), makeEntry(2)], page: 1, pages: 1),
            null,
          ),
        );
        when(() => mockRepository.deleteEntry(1)).thenAnswer((_) async => null);
        return HistoryCubit(mockRepository);
      },
      act: (cubit) async {
        await cubit.loadHistory();
        await cubit.deleteEntry(1);
      },
      expect: () => [
        isA<HistoryLoading>(),
        predicate<HistoryState>(
          (s) => s is HistoryLoaded && s.entries.length == 2,
        ),
        predicate<HistoryState>(
          (s) =>
              s is HistoryLoaded &&
              s.entries.length == 1 &&
              s.entries.first.id == 2,
        ),
      ],
    );
  });
}
