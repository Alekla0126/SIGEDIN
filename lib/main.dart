import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'application/blocs/auth/auth_bloc.dart';
import 'application/blocs/auth/auth_event.dart';
import 'infrastructure/repositories/auth_repository_impl.dart';
import 'presentation/routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = AuthBloc(
              authRepository: AuthRepositoryImpl(),
            );
            bloc.add(AuthCheckRequested());
            return bloc;
          },
        ),
      ],
      child: MaterialApp.router(
        title: 'UCIPS',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
