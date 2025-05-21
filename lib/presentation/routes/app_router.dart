import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/blocs/auth/auth_bloc.dart';
import '../../../application/blocs/auth/auth_state.dart';
import '../pages/auth/login_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/auth/unauthorized_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = 
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final router = GoRouter(
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      // Lógica de autenticación para redirección
      final authBloc = BlocProvider.of<AuthBloc>(context, listen: false);
      final authState = authBloc.state;
      final isAuth = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.uri.toString() == '/login';

      // Si no está autenticado y no está en login, redirige a login
      if (!isAuth && !isLoggingIn) return '/login';
      // Si está autenticado y va a login, redirige a dashboard
      if (isAuth && isLoggingIn) return '/dashboard';
      // Si no aplica ningún caso, no redirige
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/unauthorized',
        name: 'unauthorized',
        builder: (context, state) => const UnauthorizedPage(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
}
