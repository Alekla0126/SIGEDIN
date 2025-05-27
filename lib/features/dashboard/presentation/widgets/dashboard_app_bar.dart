import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:aucips/features/auth/presentation/bloc/auth_bloc.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Navigate to login page when state changes to AuthUnauthenticated
        if (state is AuthUnauthenticated) {
          print('⚠️ Auth state is AuthUnauthenticated, navigating to login');
          context.go('/login');
        }
      },
      child: AppBar(
        title: const Text(
          'UCIPS Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          // Botón de logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              print('⚠️ Logout button pressed, sending LogoutRequested event');
              context.read<AuthBloc>().add(LogoutRequested());
            },
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
