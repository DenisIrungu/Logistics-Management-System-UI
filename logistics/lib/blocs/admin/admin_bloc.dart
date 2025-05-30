import 'package:bloc/bloc.dart';
import 'package:admin_repository/admin_repository.dart';
import 'package:logistcs/blocs/admin/theme_bloc.dart';
import 'package:logistcs/components/shared_rider.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminBlocState> {
  final AdminRepository adminRepository;
  final ThemeBloc? themeBloc; // Nullable
  AdminProfile? _cachedProfile;

  AdminBloc({
    required this.adminRepository,
    this.themeBloc, // Made optional
  }) : super(const AdminBlocState()) {
    print(
        'AdminBloc: Initializing event handlers with themeBloc: ${themeBloc != null}');
    on<FetchAdminProfile>(_onFetchAdminProfile);
    on<FetchPriorities>(_onFetchPriorities);
    on<FetchNotificationsCount>(_onFetchNotificationsCount);
    on<SendVerificationCode>(_onSendVerificationCode);
    on<UpdateAdminProfile>(_onUpdateAdminProfile);
    on<FetchAdminPreferences>(_onFetchAdminPreferences);
    on<UpdateAdminPreferences>(_onUpdateAdminPreferences);
    on<FetchTopRegions>(_onFetchTopRegions);
    on<FetchFeedbacks>(_onFetchFeedbacks);
    on<RegisterRider>(_onRegisterRider);
    on<ResendRiderEmail>(_onResendRiderEmail);
    on<UpdateRider>(_onUpdateRider);
    on<FetchRiders>(_onFetchRiders);
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
        updateState: const UpdateInitial(),
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
        updateState: const UpdateInitial(),
      ));
    } catch (e) {
      print('AdminBloc: Error fetching profile: $e');
      emit(state.copyWith(
        profileState: ProfileFailure(e.toString()),
        updateState: const UpdateInitial(),
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

      // Use null-safe operator to handle nullable themeBloc
      themeBloc?.add(UpdateTheme(event.theme));
      if (themeBloc == null) {
        print('AdminBloc: themeBloc is null, skipping theme update');
      }
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

  Future<void> _onRegisterRider(
    RegisterRider event,
    Emitter<AdminBlocState> emit,
  ) async {
    print(
        'AdminBloc: Handling RegisterRider event with data: ${event.riderData}');
    final email = event.riderData['email'] as String?;
    final termsAcceptedStr = event.riderData['terms_accepted'] as String?;
    final termsAccepted = termsAcceptedStr?.toLowerCase() == 'true';

    if (email == null || email.isEmpty) {
      print('AdminBloc: Validation failed - Email is required');
      emit(state.copyWith(
        riderRegistrationState: RiderRegistrationFailure(
          'Email is required',
        ),
      ));
      return;
    }
    if (termsAccepted != true) {
      print('AdminBloc: Validation failed - Terms not accepted');
      emit(state.copyWith(
        riderRegistrationState: RiderRegistrationFailure(
          'Please accept the terms and conditions',
        ),
      ));
      return;
    }

    emit(state.copyWith(
        riderRegistrationState: const RiderRegistrationLoading()));
    print('AdminBloc: Emitting RiderRegistrationLoading');

    try {
      print('AdminBloc: Calling registerRider with data: ${event.riderData}');
      await adminRepository.registerRider(riderData: event.riderData);
      print('AdminBloc: registerRider call completed successfully');

      emit(state.copyWith(
          riderRegistrationState: const RiderRegistrationSuccess()));
      print('AdminBloc: Emitting RiderRegistrationSuccess');
    } catch (e) {
      print('AdminBloc: Error during registration: $e');
      emit(state.copyWith(
        riderRegistrationState: RiderRegistrationFailure(e.toString()),
      ));
      print('AdminBloc: Emitting RiderRegistrationFailure: $e');
    }
  }

  Future<void> _onResendRiderEmail(
    ResendRiderEmail event,
    Emitter<AdminBlocState> emit,
  ) async {
    print(
        'AdminBloc: Handling ResendRiderEmail event for email: ${event.email}');
    emit(state.copyWith(
        riderRegistrationState: const RiderRegistrationLoading()));
    try {
      await adminRepository.resendVerificationEmail(event.email);
      emit(state.copyWith(
          riderRegistrationState: const RiderRegistrationSuccess()));
    } catch (e) {
      print('AdminBloc: Error during resend email: $e');
      emit(state.copyWith(
        riderRegistrationState: RiderRegistrationFailure(e.toString()),
      ));
    }
  }

  Future<void> _onUpdateRider(
    UpdateRider event,
    Emitter<AdminBlocState> emit,
  ) async {
    print(
        'AdminBloc: Handling UpdateRider event for riderId: ${event.riderId}, fields: ${event.fields}, files: ${event.files.keys}');
    emit(state.copyWith(riderUpdateState: const RiderUpdateLoading()));
    try {
      await adminRepository.updateRider(
        riderId: event.riderId,
        fields: event.fields,
        files: event.files,
      );
      print('AdminBloc: Rider update completed successfully');
      emit(state.copyWith(riderUpdateState: const RiderUpdateSuccess()));
    } catch (e) {
      print('AdminBloc: Error during rider update: $e');
      emit(state.copyWith(riderUpdateState: RiderUpdateFailure(e.toString())));
    }
  }

  Future<void> _onFetchRiders(
    FetchRiders event,
    Emitter<AdminBlocState> emit,
  ) async {
    print(
        'AdminBloc: FetchRiders event triggered with skip: ${event.skip}, limit: ${event.limit}, query: ${event.searchQuery}');
    emit(state.copyWith(ridersState: const RidersLoading()));
    try {
      final paginatedRiders = await adminRepository.fetchRiders(
        skip: event.skip,
        limit: event.limit,
        searchQuery: event.searchQuery,
      );
      print(
          'AdminBloc: Emitting RidersSuccess with ${paginatedRiders.riders.length} riders, total: ${paginatedRiders.total}');
      emit(state.copyWith(
          ridersState: RidersSuccess(
        paginatedRiders.riders,
        paginatedRiders.total,
        paginatedRiders.skip,
        paginatedRiders.limit,
      )));
    } catch (e) {
      print('AdminBloc: Error fetching riders: $e');
      emit(state.copyWith(ridersState: RidersFailure(e.toString())));
    }
  }
}
