import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:admin_repository/admin_repository.dart';
import 'package:logistcs/blocs/admin/theme_bloc.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminBlocState> {
  final AdminRepository adminRepository;
  final ThemeBloc themeBloc;
  AdminProfile? _cachedProfile;

  AdminBloc({
    required this.adminRepository,
    required this.themeBloc,
  }) : super(const AdminBlocState()) {
    print('AdminBloc: Initializing event handlers');
    on<FetchAdminProfile>(_onFetchAdminProfile);
    on<FetchPriorities>(_onFetchPriorities);
    on<FetchNotificationsCount>(_onFetchNotificationsCount);
    on<SendVerificationCode>(_onSendVerificationCode);
    on<UpdateAdminProfile>(_onUpdateAdminProfile);
    on<FetchAdminPreferences>(_onFetchAdminPreferences);
    on<UpdateAdminPreferences>(_onUpdateAdminPreferences);
    on<FetchTopRegions>(_onFetchTopRegions);
    on<FetchFeedbacks>(_onFetchFeedbacks); // Add this
  }

  Future<void> _onFetchAdminProfile(
  FetchAdminProfile event,
  Emitter<AdminBlocState> emit,
) async {
  print('AdminBloc: FetchAdminProfile event triggered');
  if (_cachedProfile != null && state.profileState is! ProfileFailure) {
    print('AdminBloc: Using cached profile data');
    emit(state.copyWith(
      profileState: ProfileSuccess(_cachedProfile!),
      updateState: const UpdateInitial(),  // Fix: Use UpdateInitial instead of null
    ));
    return;
  }

  emit(state.copyWith(profileState: const ProfileLoading()));
  try {
    final adminProfile = await adminRepository.fetchAdminProfile();
    _cachedProfile = adminProfile;
    print(
        'AdminBloc: Profile fetched successfully: ${adminProfile.name}, ${adminProfile.email}');
    emit(state.copyWith(
      profileState: ProfileSuccess(adminProfile),
      updateState: const UpdateInitial(),  // Fix: Use UpdateInitial instead of null
    ));
  } catch (e) {
    print('AdminBloc: Error fetching profile: $e');
    emit(state.copyWith(
      profileState: ProfileFailure(e.toString()),
      updateState: const UpdateInitial(),  // Fix: Use UpdateInitial instead of null
    ));
  }
}

  Future<void> _onFetchPriorities(
    FetchPriorities event,
    Emitter<AdminBlocState> emit,
  ) async {
    emit(state.copyWith(prioritiesState: const PrioritiesLoading()));
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
    emit(state.copyWith(notificationsState: const NotificationsLoading()));
    try {
      final count = await adminRepository.fetchNotificationsCount();
      emit(state.copyWith(notificationsState: NotificationsSuccess(count)));
    } catch (e) {
      emit(state.copyWith(
          notificationsState: NotificationsFailure(e.toString())));
    }
  }

  Future<void> _onSendVerificationCode(
    SendVerificationCode event,
    Emitter<AdminBlocState> emit,
  ) async {
    emit(state.copyWith(updateState: const UpdateLoading()));
    try {
      await adminRepository.sendVerificationCode(event.type);
      emit(state.copyWith(updateState: const UpdateSuccess()));
    } catch (e) {
      emit(state.copyWith(updateState: UpdateFailure(e.toString())));
    }
  }

  Future<void> _onUpdateAdminProfile(
    UpdateAdminProfile event,
    Emitter<AdminBlocState> emit,
  ) async {
    emit(state.copyWith(updateState: const UpdateLoading()));
    try {
      await adminRepository.updateAdminProfile(
        name: event.name,
        email: event.email,
        verificationCode: event.verificationCode,
        profilePicture: event.profilePicture,
      );
      _cachedProfile = null;
      final adminProfile = await adminRepository.fetchAdminProfile();
      emit(state.copyWith(
        profileState: ProfileSuccess(adminProfile),
        updateState: const UpdateSuccess(),
      ));
    } catch (e) {
      emit(state.copyWith(updateState: UpdateFailure(e.toString())));
    }
  }

  Future<void> _onFetchAdminPreferences(
    FetchAdminPreferences event,
    Emitter<AdminBlocState> emit,
  ) async {
    print('AdminBloc: FetchAdminPreferences event triggered');
    emit(state.copyWith(preferencesState: const PreferencesLoading()));
    try {
      final preferences = await adminRepository.fetchPreferences();
      emit(state.copyWith(
        preferencesState: PreferencesSuccess(
          theme: preferences['theme'],
          notifications: preferences['notifications'],
        ),
      ));

      add(UpdateAdminPreferences(
        theme: preferences['theme'],
        notifications: preferences['notifications'],
      ));
    } catch (e) {
      print('AdminBloc: Error fetching preferences: $e');
      emit(state.copyWith(
        preferencesState: PreferencesFailure(e.toString()),
      ));
    }
  }

  Future<void> _onUpdateAdminPreferences(
    UpdateAdminPreferences event,
    Emitter<AdminBlocState> emit,
  ) async {
    print('AdminBloc: UpdateAdminPreferences event triggered');
    emit(state.copyWith(
      preferencesState: PreferencesSuccess(
        theme: event.theme,
        notifications: event.notifications,
      ),
      updateState: const UpdateLoading(),
    ));
    try {
      await adminRepository.updatePreferences({
        'theme': event.theme,
        'notifications': event.notifications,
      });
      emit(state.copyWith(
        preferencesState: PreferencesSuccess(
          theme: event.theme,
          notifications: event.notifications,
        ),
        updateState: const UpdateSuccess(),
      ));

      themeBloc.add(UpdateTheme(event.theme));
    } catch (e) {
      emit(state.copyWith(
        updateState: UpdateFailure(e.toString()),
      ));
    }
  }

  Future<void> _onFetchTopRegions(
    FetchTopRegions event,
    Emitter<AdminBlocState> emit,
  ) async {
    emit(state.copyWith(topRegionsState: const TopRegionsLoading()));
    try {
      final regions = await adminRepository.fetchTopRegions();
      emit(state.copyWith(topRegionsState: TopRegionsSuccess(regions)));
    } catch (e) {
      emit(state.copyWith(topRegionsState: TopRegionsFailure(e.toString())));
    }
  }

  Future<void> _onFetchFeedbacks(
    FetchFeedbacks event,
    Emitter<AdminBlocState> emit,
  ) async {
    emit(state.copyWith(feedbackState: const FeedbackLoading()));
    try {
      final feedbacks = await adminRepository.fetchFeedbacks(
        region: event.region,
        dateStart: event.dateStart,
        dateEnd: event.dateEnd,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
      );
      emit(state.copyWith(feedbackState: FeedbackSuccess(feedbacks)));
    } catch (e) {
      emit(state.copyWith(feedbackState: FeedbackFailure(e.toString())));
    }
  }
}
