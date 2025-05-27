import 'dart:async';
import 'dart:developer' as developer;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_dashboard_stats_usecase.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../domain/usecases/get_dashboard_data_usecase.dart'; // Corrected import

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardDataUseCase getDashboardDataUseCase;
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  DashboardBloc({
    required this.getDashboardDataUseCase,
    required this.getDashboardStatsUseCase,
  }) : super(DashboardInitial()) {
    developer.log('%%%%% DashboardBloc: CONSTRUCTOR CALLED %%%%%', name: 'com.example.sigedin.dashboard.flow');
    on<LoadDashboard>(_onLoadDashboard);
    on<FetchDashboardStats>(_onFetchDashboardStats);
  }

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    developer.log('%%%%% DashboardBloc: _onLoadDashboard STARTED. UserID: ${event.userId} %%%%%', name: 'com.example.sigedin.dashboard.flow');
    emit(DashboardLoading());
    developer.log('%%%%% DashboardBloc: Emitted DashboardLoading state %%%%%', name: 'com.example.sigedin.dashboard.flow');

    final failureOrData = await getDashboardDataUseCase(NoParams());
    developer.log('%%%%% DashboardBloc: getDashboardDataUseCase COMPLETED %%%%%', name: 'com.example.sigedin.dashboard.flow');

    failureOrData.fold(
      (failure) {
        developer.log('%%%%% DashboardBloc: _onLoadDashboard - FAILED to load initial data: ${failure.message} %%%%%', name: 'com.example.sigedin.dashboard.flow', error: failure);
        emit(DashboardError(message: failure.message));
      },
      (data) { // data is DashboardData
        developer.log('%%%%% DashboardBloc: _onLoadDashboard - SUCCEEDED loading initial data. User: ${data.currentUser?.fullName} %%%%%', name: 'com.example.sigedin.dashboard.flow');
        emit(DashboardLoaded(currentUser: data.currentUser));
        developer.log('%%%%% DashboardBloc: Emitted DashboardLoaded. Current BLoC state is now: $state %%%%%', name: 'com.example.sigedin.dashboard.flow');
        
        add(FetchDashboardStats());
        developer.log('%%%%% DashboardBloc: Dispatched FetchDashboardStats event %%%%%', name: 'com.example.sigedin.dashboard.flow');
      },
    );
    developer.log('%%%%% DashboardBloc: _onLoadDashboard FINISHED %%%%%', name: 'com.example.sigedin.dashboard.flow');
  }

  Future<void> _onFetchDashboardStats(
    FetchDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    developer.log('%%%%% DashboardBloc: _onFetchDashboardStats STARTED. Current BLoC state: $state %%%%%', name: 'com.example.sigedin.dashboard.flow');
    final currentState = state;
    if (currentState is DashboardLoaded) {
      developer.log('%%%%% DashboardBloc: _onFetchDashboardStats - Current state IS DashboardLoaded. User: ${currentState.currentUser?.fullName}. Proceeding to fetch stats. %%%%%', name: 'com.example.sigedin.dashboard.flow');
      
      final failureOrStats = await getDashboardStatsUseCase(NoParams());
      developer.log('%%%%% DashboardBloc: getDashboardStatsUseCase COMPLETED %%%%%', name: 'com.example.sigedin.dashboard.flow');

      failureOrStats.fold(
        (failure) {
          developer.log('%%%%% DashboardBloc: _onFetchDashboardStats - FAILED to fetch dashboard stats: ${failure.message} %%%%%', name: 'com.example.sigedin.dashboard.flow', error: failure);
          emit(currentState.copyWith(errorMessage: failure.message));
          developer.log('%%%%% DashboardBloc: Emitted DashboardLoaded with stats error: ${failure.message} %%%%%', name: 'com.example.sigedin.dashboard.flow');
        },
        (stats) {
          developer.log('%%%%% DashboardBloc: _onFetchDashboardStats - SUCCEEDED fetching dashboard stats: ${stats.documentosRegistrados} documents %%%%%', name: 'com.example.sigedin.dashboard.flow');
          emit(currentState.copyWith(dashboardStats: stats, errorMessage: null));
          developer.log('%%%%% DashboardBloc: Emitted DashboardLoaded with new stats. %%%%%', name: 'com.example.sigedin.dashboard.flow');
        },
      );
    } else {
      developer.log('%%%%% DashboardBloc: _onFetchDashboardStats - Current state is NOT DashboardLoaded ($currentState), cannot fetch stats. %%%%%', name: 'com.example.sigedin.dashboard.flow', error: 'State is not DashboardLoaded');
    }
    developer.log('%%%%% DashboardBloc: _onFetchDashboardStats FINISHED %%%%%', name: 'com.example.sigedin.dashboard.flow');
  }
}
