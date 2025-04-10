part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdminProfile extends AdminEvent {}

class FetchPriorities extends AdminEvent {}

class FetchNotificationsCount extends AdminEvent {}