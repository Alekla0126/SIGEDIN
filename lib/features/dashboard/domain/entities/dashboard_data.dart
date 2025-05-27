
import 'package:equatable/equatable.dart';
import 'user.dart'; // Assuming DashboardUser is the User entity

class DashboardData extends Equatable {
  final DashboardUser? currentUser;
  // Add other initial dashboard data fields here if any, excluding stats

  const DashboardData({this.currentUser});

  @override
  List<Object?> get props => [currentUser];
}
