import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/dashboard_stats_repository.dart';
import '../datasources/dashboard_stats_remote_data_source.dart';
import '../models/dashboard_stats_model.dart';

class DashboardStatsRepositoryImpl implements DashboardStatsRepository {
  final DashboardStatsRemoteDataSource remoteDataSource;

  DashboardStatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardStatsDataModel>> getDashboardStats() async {
    try {
      final result = await remoteDataSource.getDashboardStats();
      return Right(result.data);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
