import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
// Importing the model directly for now, consider a domain entity later.
import '../../data/models/dashboard_stats_model.dart'; 

// TODO: Consider creating a domain entity for DashboardStatsData and using it here 
// instead of DashboardStatsDataModel directly.
// For now, we'll use DashboardStatsDataModel for simplicity, 
// assuming it might be used as a domain entity as well.

abstract class DashboardStatsRepository {
  Future<Either<Failure, DashboardStatsDataModel>> getDashboardStats();
}
