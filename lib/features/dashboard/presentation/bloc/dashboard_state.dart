part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
  
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final DashboardUser? currentUser;
  final List<DashboardUser> users;
  final DateTime lastUpdated;
  final DashboardStatsDataModel? dashboardStats;
  final String? errorMessage;

  DashboardLoaded({
    this.currentUser,
    this.users = const [],
    DateTime? lastUpdated,
    this.dashboardStats,
    this.errorMessage,
  }) : lastUpdated = lastUpdated ?? DateTime.now().toUtc();

  @override
  List<Object?> get props => [currentUser, users, lastUpdated, dashboardStats, errorMessage];
  
  @override
  bool? get stringify => true;

  DashboardLoaded copyWith({
    DashboardUser? currentUser,
    List<DashboardUser>? users,
    DateTime? lastUpdated,
    DashboardStatsDataModel? dashboardStats,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return DashboardLoaded(
      currentUser: currentUser ?? this.currentUser,
      users: users ?? this.users,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      dashboardStats: dashboardStats ?? this.dashboardStats,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
