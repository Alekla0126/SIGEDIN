import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/document_reception/presentation/bloc/document_reception_bloc.dart';
import '../../injection_container.dart' as di;
import '../pages/auth/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../pages/auth/unauthorized_page.dart';
import '../pages/splash/splash_screen.dart';
import '../../features/document_reception/presentation/pages/document_reception_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = 
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    redirect: (BuildContext context, GoRouterState state) async {
      // No redirects for splash screen
      if (state.uri.toString() == '/') return null;
      
      try {
        // Get the auth state
        final authBloc = BlocProvider.of<AuthBloc>(context, listen: false);
        final authState = authBloc.state;
        
        print('⚠️ AppRouter redirect: Current auth state: ${authState.runtimeType}, path: ${state.uri.toString()}');
        
        final isAuth = authState is AuthAuthenticated;
        final isLoggingIn = state.uri.toString() == '/login';
        final isUnauthenticated = authState is AuthUnauthenticated;
        
        // If explicitly unauthenticated and not going to login, redirect to login
        if (isUnauthenticated && !isLoggingIn) {
          print('⚠️ AppRouter redirect: Unauthenticated, redirecting to login');
          return '/login';
        }
        
        // If not authenticated and not going to login, redirect to login
        if (!isAuth && !isLoggingIn) {
          print('⚠️ AppRouter redirect: Not authenticated, redirecting to login');
          return '/login';
        }
        
        // If authenticated and going to login, redirect to dashboard
        if (isAuth && isLoggingIn) {
          print('⚠️ AppRouter redirect: Authenticated but on login page, redirecting to dashboard');
          return '/dashboard';
        }
      } catch (e) {
        // If there's an error getting the auth state, redirect to login
        print('⚠️ AppRouter redirect: Error getting auth state: $e, redirecting to login');
        return '/login';
      }
      
      // If none of the above, don't redirect
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => BlocProvider.value(
          value: context.read<AuthBloc>(),
          child: Builder(
            builder: (context) {
              // Obtener el usuario del AuthBloc y extraer el ID
              final authState = context.watch<AuthBloc>().state;
              String userId = "1"; // Valor predeterminado

              if (authState is AuthAuthenticated && authState.user != null) {
                userId = authState.user!.id.toString(); // Asumiendo que User tiene una propiedad id
                print('%%%%% AppRouter: Navegando a DashboardPage con userId: $userId %%%%%');
              } else {
                print('%%%%% AppRouter: Navegando a DashboardPage con userId predeterminado: $userId %%%%%');
              }

              return DashboardPage(userId: userId);
            },
          ),
        ),
      ),
      GoRoute(
        path: '/unauthorized',
        name: 'unauthorized',
        builder: (context, state) => const UnauthorizedPage(),
      ),
      GoRoute(
        path: '/documentos/recepcion/nuevo',
        name: 'document_reception',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => DocumentReceptionBloc(
                createDocumentReception: di.sl(),
                getDocumentReception: di.sl(),
                downloadDocumentFile: di.sl(),
                repository: di.sl(),
              ),
            ),
          ],
          child: const DocumentReceptionPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  );
}
