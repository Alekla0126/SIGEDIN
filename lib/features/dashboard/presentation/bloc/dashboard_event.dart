part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  final String userId;
  const LoadDashboard({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

class UpdateUserProfile extends DashboardEvent {
  final String userId;
  final Map<String, dynamic> updates;

  const UpdateUserProfile({required this.userId, required this.updates});

  @override
  List<Object?> get props => [userId, updates];
}

class FetchDashboardStats extends DashboardEvent {
  const FetchDashboardStats();

  @override
  List<Object?> get props => [];
}
