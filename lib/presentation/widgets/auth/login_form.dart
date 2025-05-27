import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../features/auth/presentation/bloc/auth_bloc.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else if (state is AuthAuthenticated) {
          if (mounted) {
            context.go('/dashboard'); // Changed from /home to /dashboard
          }
        } else if (state is AuthFailure) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else if (state is AuthUnauthenticated) {
          setState(() => _isLoading = false);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Por favor ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Password field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu contraseña';
                  }
                  if (value.length < 6) {
                    return 'La contraseña debe tener al menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Login button
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'INICIAR SESIÓN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              // Forgot password link
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password
                },
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              // Demo users section
              if (kDebugMode) ..._buildDemoUsers(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildDemoUsers() {
    return [
      const SizedBox(height: 24),
      const Text(
        'Usuarios de prueba:',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      const SizedBox(height: 8),
      _CopiableUserTile(
        user: 'alekla0126@gmail.com',
        role: 'Administrador',
        onTap: () {
          _emailController.text = 'alekla0126@gmail.com';
          _passwordController.text = 'password123';
        },
      ),
      // _CopiableUserTile(
      //   user: 'admin@ucips.gob.mx',
      //   role: 'Administrador',
      //   onTap: () {
      //     _emailController.text = 'admin@ucips.gob.mx';
      //     _passwordController.text = 'admin123';
      //   },
      // ),
      // _CopiableUserTile(
      //   user: 'auditor@ucips.gob.mx',
      //   role: 'Auditor',
      //   onTap: () {
      //     _emailController.text = 'auditor@ucips.gob.mx';
      //     _passwordController.text = 'auditor123';
      //   },
      // ),
      // _CopiableUserTile(
      //   user: 'gestion@ucips.gob.mx',
      //   role: 'Gestión Documental',
      //   onTap: () {
      //     _emailController.text = 'gestion@ucips.gob.mx';
      //     _passwordController.text = 'gestion123';
      //   },
      // ),
      const SizedBox(height: 8),
      const _CopiablePasswordTile(password: 'secret'),
    ];
  }
}

class _CopiableUserTile extends StatelessWidget {
  final String user;
  final String role;
  final VoidCallback onTap;

  const _CopiableUserTile({
    Key? key,
    required this.user,
    required this.role,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(user),
      subtitle: Text(role),
      onTap: onTap,
      trailing: IconButton(
        icon: const Icon(Icons.content_copy, size: 20),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: user));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Correo copiado: $user'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}

class _CopiablePasswordTile extends StatelessWidget {
  final String password;

  const _CopiablePasswordTile({
    Key? key,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: const Text('Contraseña de prueba:'),
      subtitle: Text('•' * password.length),
      trailing: IconButton(
        icon: const Icon(Icons.content_copy, size: 20),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: password));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Contraseña copiada'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
