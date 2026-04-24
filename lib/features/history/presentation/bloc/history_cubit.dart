import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/repositories/history_repository.dart';
import 'package:isef01_second_brain_frontend/features/history/presentation/bloc/history_state.dart';

@injectable
class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this._repository) : super(const HistoryInitial());

  final HistoryRepository _repository;

  Future<void> loadHistory() async {
    emit(const HistoryLoading());
    final (data, failure) = await _repository.getHistory();
    if (failure != null) {
      emit(HistoryError(failure.message));
    } else {
      emit(
        HistoryLoaded(
          entries: data!.items,
          currentPage: data.page,
          totalPages: data.pages,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! HistoryLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    final (data, failure) = await _repository.getHistory(
      page: current.currentPage + 1,
    );
    if (failure != null) {
      emit(current.copyWith(isLoadingMore: false));
    } else {
      emit(
        current.copyWith(
          entries: [...current.entries, ...data!.items],
          currentPage: data.page,
          totalPages: data.pages,
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> deleteEntry(int id) async {
    final current = state;
    if (current is! HistoryLoaded) return;

    final failure = await _repository.deleteEntry(id);
    if (failure == null) {
      emit(
        current.copyWith(
          entries: current.entries.where((e) => e.id != id).toList(),
        ),
      );
    }
  }
}
