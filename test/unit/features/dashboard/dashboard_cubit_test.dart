import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/usecases/get_dashboard_items_usecase.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/presentation/bloc/dashboard_cubit.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
  });

  final tNote = const NoteItem(
    id: '1',
    title: 'Notiz',
    sourceService: 'notion',
  );
  final tData = DashboardData(todos: const [], lastNote: tNote);

  group('DashboardCubit', () {
    test('Initialzustand ist DashboardInitial', () {
      final cubit = DashboardCubit(GetDashboardItemsUseCase(mockRepository));
      expect(cubit.state, isA<DashboardInitial>());
      cubit.close();
    });

    blocTest<DashboardCubit, DashboardState>(
      'load() Erfolg → DashboardLoading dann DashboardLoaded',
      build: () {
        when(
          () => mockRepository.getDashboard(),
        ).thenAnswer((_) async => (data: tData, failure: null));
        return DashboardCubit(GetDashboardItemsUseCase(mockRepository));
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<DashboardLoading>(),
        predicate<DashboardState>(
          (s) =>
              s is DashboardLoaded &&
              s.lastNote?.title == 'Notiz' &&
              s.todos.isEmpty,
        ),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'load() Fehler → DashboardLoading dann DashboardError',
      build: () {
        when(() => mockRepository.getDashboard()).thenAnswer(
          (_) async => (data: null, failure: const NetworkFailure()),
        );
        return DashboardCubit(GetDashboardItemsUseCase(mockRepository));
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<DashboardLoading>(),
        predicate<DashboardState>(
          (s) =>
              s is DashboardError && s.message == 'Keine Netzwerkverbindung.',
        ),
      ],
    );
  });
}
