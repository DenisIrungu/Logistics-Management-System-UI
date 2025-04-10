import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:admin_repository/admin_repository.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminBlocState> {
  final AdminRepository adminRepository;

  AdminBloc({required this.adminRepository})
      : super(AdminBlocState(
          profileState: ProfileLoading(),
          prioritiesState: PrioritiesLoading(),
          notificationsState: NotificationsLoading(),
        )) {
    on<FetchAdminProfile>(_onFetchAdminProfile);
    on<FetchPriorities>(_onFetchPriorities);
    on<FetchNotificationsCount>(_onFetchNotificationsCount);
  }

  Future<void> _onFetchAdminProfile(
    FetchAdminProfile event,
    Emitter<AdminBlocState> emit,
  ) async {
    emit(state.copyWith(profileState: ProfileLoading()));
    try {
      final adminProfile = await adminRepository.fetchAdminProfile();
      emit(state.copyWith(profileState: ProfileSuccess(adminProfile)));
    } catch (e) {
      emit(state.copyWith(profileState: ProfileFailure(e.toString())));
    }
  }

  Future<void> _onFetchPriorities(
    FetchPriorities event,
    Emitter<AdminBlocState> emit,
  ) async {
    emit(state.copyWith(prioritiesState: PrioritiesLoading()));
    try {
      final priorities = await adminRepository.fetchPriorities();
      emit(state.copyWith(prioritiesState: PrioritiesSuccess(priorities)));
    } catch (e) {
      emit(state.copyWith(prioritiesState: PrioritiesFailure(e.toString())));
    }
  }

  Future<void> _onFetchNotificationsCount(
    FetchNotificationsCount event,
    Emitter<AdminBlocState> emit,
  ) async {
    emit(state.copyWith(notificationsState: NotificationsLoading()));
    try {
      final count = await adminRepository.fetchNotificationsCount();
      emit(state.copyWith(notificationsState: NotificationsSuccess(count)));
    } catch (e) {
      emit(state.copyWith(notificationsState: NotificationsFailure(e.toString())));
    }
  }
}