import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../application/blocs/auth/auth_bloc.dart';
import '../../../application/blocs/auth/auth_event.dart';
import '../../../application/blocs/auth/auth_state.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/auth/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            // Navegación correcta usando go_router
            context.go('/dashboard');
          }
          if (state.status == AuthStatus.error) {
            // Mostrar mensaje de error SIEMPRE, aunque ya estemos en error
            final errorMsg = state.error ?? 'Error de autenticación';
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMsg),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            });
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Icon(Icons.account_balance, size: 120, color: AppTheme.primaryColor),
                const SizedBox(height: 24),
                const Text(
                  'UCIPS',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const Text(
                  'Unidad de Control Institucional de Procesos y Servicios',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                const SizedBox(height: 48),
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const LoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
