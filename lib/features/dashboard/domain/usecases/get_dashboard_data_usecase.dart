import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';
import './get_current_user_usecase.dart'; // Import GetCurrentUserUseCase

class GetDashboardDataUseCase implements UseCase<DashboardData, NoParams> {
  final DashboardRepository repository;
  // Add GetCurrentUserUseCase dependency
  final GetCurrentUserUseCase getCurrentUserUseCase;

  GetDashboardDataUseCase({required this.repository, required this.getCurrentUserUseCase});

  @override
  Future<Either<Failure, DashboardData>> call(NoParams params) async {
    final userResult = await getCurrentUserUseCase(); 
    return userResult.fold(
      (failure) => Left(failure),
      // Assuming DashboardData has a constructor that takes DashboardUser
      (user) => Right(DashboardData(currentUser: user)), 
    );
  }
}
