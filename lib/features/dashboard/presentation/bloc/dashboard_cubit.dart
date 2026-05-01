import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/usecases/get_dashboard_items_usecase.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/presentation/bloc/dashboard_state.dart';

export 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._getDashboard) : super(const DashboardInitial());

  final GetDashboardItemsUseCase _getDashboard;

  Future<void> load() async {
    emit(const DashboardLoading());
    final (:data, :failure) = await _getDashboard();
    if (failure != null) {
      emit(DashboardError(failure.message));
      return;
    }
    emit(DashboardLoaded(
      nextEvent: data?.nextEvent,
      todos: data?.todos ?? [],
      lastNote: data?.lastNote,
    ));
  }
}
