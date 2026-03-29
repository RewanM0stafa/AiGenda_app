import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import '../../logic/auth_cubit/auth_state.dart';
import '../screens/auth_widget.dart';
import 'auth_scaffold.dart';

class AuthConsumer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final void Function(BuildContext context, AuthState state) listener;
  final bool Function(AuthState state) isLoadingCondition;

  const AuthConsumer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.listener,
    required this.isLoadingCondition,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: listener,
      builder: (context, state) {
        final isLoading = isLoadingCondition(state);

        String? errorMessage;
        if (state is LoginFailure) errorMessage = state.message;
        if (state is RegisterFailure) errorMessage = state.message;
        if (state is ConfirmEmailFailure) errorMessage = state.message;

        return AuthScaffold(
          headerTitle: title,
          headerSubtitle: subtitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errorMessage != null) ...[
                AuthErrorBanner(message: errorMessage),
                const SizedBox(height: 14),
              ],
              child,
            ],
          ),
        );
      },
    );
  }
}


