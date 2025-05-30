import 'package:equatable/equatable.dart';
import 'package:admin_repository/src/models/region_model.dart';
import 'package:admin_repository/src/entities/entities_admin_profile.dart';
import 'package:admin_repository/src/entities/entities_issue.dart';
import 'package:admin_repository/src/models/feedback_model.dart';
import 'package:logistcs/components/shared_rider.dart'; // Added for Rider

class AdminBlocState extends Equatable {
  final ProfileState profileState;
  final PrioritiesState prioritiesState;
  final NotificationsState notificationsState;
  final UpdateState updateState;
  final PreferencesState preferencesState;
  final TopRegionsState topRegionsState;
  final FeedbackState feedbackState;
  final RiderRegistrationState riderRegistrationState;
  final RiderUpdateState riderUpdateState;
  final RidersState ridersState;

  const AdminBlocState({
    this.profileState = const ProfileLoading(),
    this.prioritiesState = const PrioritiesLoading(),
    this.notificationsState = const NotificationsLoading(),
    this.updateState = const UpdateInitial(),
    this.preferencesState = const PreferencesLoading(),
    this.topRegionsState = const TopRegionsInitial(),
    this.feedbackState = const FeedbackLoading(),
    this.riderRegistrationState = const RiderRegistrationInitial(),
    this.riderUpdateState = const RiderUpdateInitial(),
    this.ridersState = const RidersInitial(),
  });

  AdminBlocState copyWith({
    ProfileState? profileState,
    PrioritiesState? prioritiesState,
    NotificationsState? notificationsState,
    UpdateState? updateState,
    PreferencesState? preferencesState,
    TopRegionsState? topRegionsState,
    FeedbackState? feedbackState,
    RiderRegistrationState? riderRegistrationState,
    RiderUpdateState? riderUpdateState,
    RidersState? ridersState,
  }) {
    return AdminBlocState(
      profileState: profileState ?? this.profileState,
      prioritiesState: prioritiesState ?? this.prioritiesState,
      notificationsState: notificationsState ?? this.notificationsState,
      updateState: updateState ?? this.updateState,
      preferencesState: preferencesState ?? this.preferencesState,
      topRegionsState: topRegionsState ?? this.topRegionsState,
      feedbackState: feedbackState ?? this.feedbackState,
      riderRegistrationState: riderRegistrationState ?? this.riderRegistrationState,
      riderUpdateState: riderUpdateState ?? this.riderUpdateState,
      ridersState: ridersState ?? this.ridersState,
    );
  }

  @override
  List<Object> get props => [
        profileState,
        prioritiesState,
        notificationsState,
        updateState,
        preferencesState,
        topRegionsState,
        feedbackState,
        riderRegistrationState,
        riderUpdateState,
        ridersState,
      ];
}

// Profile States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

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

// Priorities States
abstract class PrioritiesState extends Equatable {
  const PrioritiesState();

  @override
  List<Object?> get props => [];
}

class PrioritiesLoading extends PrioritiesState {
  const PrioritiesLoading();
}

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

// Notifications States
abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

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

// Update States
abstract class UpdateState extends Equatable {
  const UpdateState();

  @override
  List<Object?> get props => [];
}

class UpdateInitial extends UpdateState {
  const UpdateInitial();
}

class UpdateLoading extends UpdateState {
  const UpdateLoading();
}

class UpdateSuccess extends UpdateState {
  const UpdateSuccess();
}

class UpdateFailure extends UpdateState {
  final String error;

  const UpdateFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Preferences States
abstract class PreferencesState extends Equatable {
  const PreferencesState();

  @override
  List<Object?> get props => [];
}

class PreferencesLoading extends PreferencesState {
  const PreferencesLoading();
}

class PreferencesSuccess extends PreferencesState {
  final String theme;
  final bool notifications;

  const PreferencesSuccess({
    required this.theme,
    required this.notifications,
  });

  @override
  List<Object?> get props => [theme, notifications];
}

class PreferencesFailure extends PreferencesState {
  final String error;

  const PreferencesFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Top Regions States
abstract class TopRegionsState extends Equatable {
  const TopRegionsState();

  @override
  List<Object?> get props => [];
}

class TopRegionsInitial extends TopRegionsState {
  const TopRegionsInitial();
}

class TopRegionsLoading extends TopRegionsState {
  const TopRegionsLoading();
}

class TopRegionsSuccess extends TopRegionsState {
  final List<Region> regions;

  const TopRegionsSuccess(this.regions);

  @override
  List<Object?> get props => [regions];
}

class TopRegionsFailure extends TopRegionsState {
  final String error;

  const TopRegionsFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Feedback States
abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object?> get props => [];
}

class FeedbackLoading extends FeedbackState {
  const FeedbackLoading();
}

class FeedbackSuccess extends FeedbackState {
  final List<Feedback> feedbacks;

  const FeedbackSuccess(this.feedbacks);

  @override
  List<Object?> get props => [feedbacks];
}

class FeedbackFailure extends FeedbackState {
  final String error;

  const FeedbackFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Rider Registration States
abstract class RiderRegistrationState extends Equatable {
  const RiderRegistrationState();

  @override
  List<Object?> get props => [];
}

class RiderRegistrationInitial extends RiderRegistrationState {
  const RiderRegistrationInitial();
}

class RiderRegistrationLoading extends RiderRegistrationState {
  const RiderRegistrationLoading();
}

class RiderRegistrationSuccess extends RiderRegistrationState {
  const RiderRegistrationSuccess();
}

class RiderRegistrationFailure extends RiderRegistrationState {
  final String error;

  const RiderRegistrationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Rider Update States
abstract class RiderUpdateState extends Equatable {
  const RiderUpdateState();

  @override
  List<Object?> get props => [];
}

class RiderUpdateInitial extends RiderUpdateState {
  const RiderUpdateInitial();
}

class RiderUpdateLoading extends RiderUpdateState {
  const RiderUpdateLoading();
}

class RiderUpdateSuccess extends RiderUpdateState {
  const RiderUpdateSuccess();
}

class RiderUpdateFailure extends RiderUpdateState {
  final String error;

  const RiderUpdateFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Riders States
// Riders States
abstract class RidersState extends Equatable {
  const RidersState();

  @override
  List<Object?> get props => [];
}

class RidersInitial extends RidersState {
  const RidersInitial();
}

class RidersLoading extends RidersState {
  const RidersLoading();
}

class RidersSuccess extends RidersState {
  final List<Rider> riders;
  final int total;
  final int skip;
  final int limit;

  const RidersSuccess(this.riders, this.total, this.skip, this.limit);

  @override
  List<Object?> get props => [riders, total, skip, limit];
}

class RidersFailure extends RidersState {
  final String error;

  const RidersFailure(this.error);

  @override
  List<Object?> get props => [error];
}