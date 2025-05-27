import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../injection_container.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_drawer.dart';
import '../widgets/user_profile_card.dart';

class DashboardPage extends StatelessWidget {
  final String userId; // Added userId
  const DashboardPage({Key? key, required this.userId}) : super(key: key); // Added userId

  @override
  Widget build(BuildContext context) {
    // LOG PARA VERIFICAR SI DashboardPage.build SE LLAMA Y CON QUÉ userId
    print('%%%%% DashboardPage: build() called. userId: $userId %%%%%'); 
    return BlocProvider(
      create: (context) {
        // LOG PARA VERIFICAR SI DashboardBloc SE ESTÁ CREANDO
        print('%%%%% DashboardPage: BlocProvider.create() called. Creating DashboardBloc. %%%%%');
        return sl<DashboardBloc>()..add(LoadDashboard(userId: userId));
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // If auth state is unauthenticated, navigate to login
          if (state is AuthUnauthenticated) {
            print('⚠️ DashboardPage: AuthBloc state is AuthUnauthenticated, navigating to login');
            context.go('/login');
          }
        },
        child: const _DashboardView(),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access userId from the DashboardPage widget if needed here, or pass it down
    // For simplicity, LoadDashboard is dispatched from DashboardPage
    final String currentUserId = (context.findAncestorWidgetOfExactType<DashboardPage>())!.userId;

    return Scaffold(
      appBar: const DashboardAppBar(),
      drawer: const DashboardDrawer(),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is DashboardError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is DashboardLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardInitial || (state is DashboardLoading && state.props.isEmpty)) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is DashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(LoadDashboard(userId: currentUserId)); // Pass userId
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.currentUser != null)
                            UserProfileCard(user: state.currentUser!)
                          else
                            const Center(child: Text('No user data available')),
                          const SizedBox(height: 24.0),
                          // Display Dashboard Stats if available
                          if (state.dashboardStats != null)
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Dashboard Estadistico', style: Theme.of(context).textTheme.titleLarge),
                                    const SizedBox(height: 8),
                                    Text('Documentos Registrados: ${state.dashboardStats!.documentosRegistrados}'),
                                    Text('Turnados Pendientes: ${state.dashboardStats!.turnadosPendientes}'),
                                    Text('Con Acuse: ${state.dashboardStats!.conAcuse}'),
                                  ],
                                ),
                              ),
                            )
                          else if (state.errorMessage != null && state.dashboardStats == null)
                            // Show error related to stats if stats are null and there's an error message
                            Card(
                              color: Colors.red[50],
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text('Could not load statistics: ${state.errorMessage}', style: TextStyle(color: Colors.red[700])),
                              ),
                            ),
                          // Add more dashboard widgets here
                          // e.g., recent activities, statistics, etc.
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading dashboard',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(LoadDashboard(userId: currentUserId)); // Pass userId
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Unhandled state'));
        },
      ),
    );
  }
}
