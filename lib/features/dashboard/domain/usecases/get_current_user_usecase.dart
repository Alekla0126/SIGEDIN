import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/dashboard_repository.dart';
import '../entities/user.dart';

class GetCurrentUserUseCase {
  final DashboardRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, DashboardUser>> call() async {
    try {
      final result = await repository.getCurrentUser();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
