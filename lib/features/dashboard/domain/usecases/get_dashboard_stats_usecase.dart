import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart'; // Added import for UseCase and NoParams
import '../../data/models/dashboard_stats_model.dart'; // TODO: Change to domain entity if created
import '../repositories/dashboard_stats_repository.dart';

class GetDashboardStatsUseCase implements UseCase<DashboardStatsDataModel, NoParams> {
  final DashboardStatsRepository repository;

  GetDashboardStatsUseCase(this.repository);

  @override
  Future<Either<Failure, DashboardStatsDataModel>> call(NoParams params) async {
    return await repository.getDashboardStats();
  }
}
