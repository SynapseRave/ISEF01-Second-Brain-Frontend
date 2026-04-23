import 'package:isef01_second_brain_frontend/features/user/domain/entities/user_data.dart';

sealed class UserState {
  const UserState();
}

final class UserInitial extends UserState {
  const UserInitial();
}

final class UserLoading extends UserState {
  const UserLoading();
}

final class UserLoaded extends UserState {
  const UserLoaded(this.data);
  final UserData data;
}

final class UserUpdating extends UserState {
  const UserUpdating(this.data);
  final UserData data;
}

final class UserUpdateSuccess extends UserState {
  const UserUpdateSuccess(this.data);
  final UserData data;
}

final class UserError extends UserState {
  const UserError(this.message);
  final String message;
}
