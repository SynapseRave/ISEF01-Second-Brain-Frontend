import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/usecases/get_user_usecase.dart';
import 'package:isef01_second_brain_frontend/features/user/domain/usecases/update_user_usecase.dart';
import 'package:isef01_second_brain_frontend/features/user/presentation/bloc/user_state.dart';

@lazySingleton
class UserCubit extends Cubit<UserState> {
  UserCubit(this._getUser, this._updateUser) : super(const UserInitial());

  final GetUserUseCase _getUser;
  final UpdateUserUseCase _updateUser;

  Future<void> loadUser() async {
    emit(const UserLoading());
    final (data, failure) = await _getUser();
    if (failure != null) {
      emit(UserError(failure.message));
    } else {
      emit(UserLoaded(data!));
    }
  }

  Future<void> updateUser({
    String? email,
    String? password,
    String? preferredLlm,
    Map<String, dynamic>? defaultTargets,
  }) async {
    final current = state;
    if (current is! UserLoaded && current is! UserUpdateSuccess) return;
    final currentData =
        current is UserLoaded ? current.data : (current as UserUpdateSuccess).data;

    emit(UserUpdating(currentData));
    final (data, failure) = await _updateUser(
      email: email,
      password: password,
      preferredLlm: preferredLlm,
      defaultTargets: defaultTargets,
    );
    if (failure != null) {
      emit(UserError(failure.message));
    } else {
      emit(UserUpdateSuccess(data!));
    }
  }
}
