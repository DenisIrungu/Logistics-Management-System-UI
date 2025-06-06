import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdminProfile extends AdminEvent {}

class FetchPriorities extends AdminEvent {}

class FetchNotificationsCount extends AdminEvent {}

class SendVerificationCode extends AdminEvent {
  final String type;

  const SendVerificationCode(this.type);

  @override
  List<Object?> get props => [type];
}

class UpdateAdminProfile extends AdminEvent {
  final String? name;
  final String? email;
  final String? verificationCode;
  final File? profilePicture;

  const UpdateAdminProfile({
    this.name,
    this.email,
    this.verificationCode,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [name, email, verificationCode, profilePicture];
}

class FetchAdminPreferences extends AdminEvent {}

class UpdateAdminPreferences extends AdminEvent {
  final String theme;
  final bool notifications;

  const UpdateAdminPreferences({
    required this.theme,
    required this.notifications,
  });

  @override
  List<Object?> get props => [theme, notifications];
}

class FetchTopRegions extends AdminEvent {}

class FetchFeedbacks extends AdminEvent {
  final String? region;
  final String? dateStart;
  final String? dateEnd;
  final String sortBy;
  final String sortOrder;

  const FetchFeedbacks({
    this.region,
    this.dateStart,
    this.dateEnd,
    this.sortBy = 'date',
    this.sortOrder = 'desc',
  });

  @override
  List<Object?> get props => [region, dateStart, dateEnd, sortBy, sortOrder];
}

class RegisterRider extends AdminEvent {
  final Map<String, dynamic> riderData;

  const RegisterRider({
    required this.riderData,
  });

  @override
  List<Object?> get props => [riderData];
}

class ResendRiderEmail extends AdminEvent {
  final String email;

  const ResendRiderEmail({required this.email});

  @override
  List<Object?> get props => [email];
}

class UpdateRider extends AdminEvent {
  final int riderId;
  final Map<String, String> fields;
  final Map<String, File> files;

  const UpdateRider({
    required this.riderId,
    required this.fields,
    required this.files,
  });

  @override
  List<Object?> get props => [riderId, fields, files];
}

class FetchRiders extends AdminEvent {
  final int skip;
  final int limit;
  final String? searchQuery;

  const FetchRiders({
    this.skip = 0,
    this.limit = 10,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [skip, limit, searchQuery];
}