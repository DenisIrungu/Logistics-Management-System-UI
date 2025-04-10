part of 'admin_bloc.dart';

// Base state for admin profile
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final AdminProfile adminProfile;

  const ProfileSuccess(this.adminProfile);

  @override
  List<Object?> get props => [adminProfile];
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Base state for priorities
abstract class PrioritiesState extends Equatable {
  const PrioritiesState();

  @override
  List<Object?> get props => [];
}

class PrioritiesLoading extends PrioritiesState {}

class PrioritiesSuccess extends PrioritiesState {
  final List<Issue> priorities;

  const PrioritiesSuccess(this.priorities);

  @override
  List<Object?> get props => [priorities];
}

class PrioritiesFailure extends PrioritiesState {
  final String error;

  const PrioritiesFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Base state for notifications
abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final int count;

  const NotificationsSuccess(this.count);

  @override
  List<Object?> get props => [count];
}

class NotificationsFailure extends NotificationsState {
  final String error;

  const NotificationsFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Combined state for the bloc
class AdminBlocState extends Equatable {
  final ProfileState profileState;
  final PrioritiesState prioritiesState;
  final NotificationsState notificationsState;

  const AdminBlocState({
    required this.profileState,
    required this.prioritiesState,
    required this.notificationsState,
  });

  AdminBlocState copyWith({
    ProfileState? profileState,
    PrioritiesState? prioritiesState,
    NotificationsState? notificationsState,
  }) {
    return AdminBlocState(
      profileState: profileState ?? this.profileState,
      prioritiesState: prioritiesState ?? this.prioritiesState,
      notificationsState: notificationsState ?? this.notificationsState,
    );
  }

  @override
  List<Object?> get props => [profileState, prioritiesState, notificationsState];
}