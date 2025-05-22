import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../../../application/blocs/auth/auth_bloc.dart';
import '../../../application/blocs/auth/auth_event.dart';
import '../../../application/blocs/auth/auth_state.dart';
import '../../../core/theme/app_theme.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Iniciar Sesión',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese su correo electrónico';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Ingrese un correo electrónico válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, ingrese su contraseña';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state.status == AuthStatus.loading;
              return SizedBox(
                width: double.infinity, // Full width button for login
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submitForm,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('INGRESAR'),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Info de usuarios mock para pruebas (con botones para copiar)
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Color(0xFFF1F8E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Usuarios de prueba:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  _CopiableUserTile(user: 'admin@ucips.gob.mx', role: 'Administrador'),
                  _CopiableUserTile(user: 'auditor@ucips.gob.mx', role: 'Auditor'),
                  _CopiableUserTile(user: 'gestion@ucips.gob.mx', role: 'Gestión Documental'),
                  const SizedBox(height: 10),
                  _CopiablePasswordTile(password: 'admin123'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopiableUserTile extends StatelessWidget {
  final String user;
  final String role;
  const _CopiableUserTile({required this.user, required this.role});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Text('$user ($role)', style: const TextStyle(fontSize: 13))),
        IconButton(
          icon: const Icon(Icons.copy, size: 18),
          tooltip: 'Copiar usuario',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: user));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Usuario copiado: $user'), duration: const Duration(seconds: 1)),
            );
          },
        ),
      ],
    );
  }
}

class _CopiablePasswordTile extends StatelessWidget {
  final String password;
  const _CopiablePasswordTile({required this.password});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Contraseña:', style: TextStyle(fontSize: 13)),
        const SizedBox(width: 6),
        Expanded(child: Text(password, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
        IconButton(
          icon: const Icon(Icons.copy, size: 18),
          tooltip: 'Copiar contraseña',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: password));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Contraseña copiada'), duration: Duration(seconds: 1)),
            );
          },
        ),
      ],
    );
  }
}
