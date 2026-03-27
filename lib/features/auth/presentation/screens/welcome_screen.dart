/*
import 'package:ajenda_app/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/dependency_injection.dart';
import '../../logic/auth_cubit/auth_cubit.dart';
import 'login_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isSignIn = true;
  late AnimationController _switchCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _switchCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _fadeAnim =
        CurvedAnimation(parent: _switchCtrl, curve: Curves.easeInOut);
    _switchCtrl.value = 1.0;
  }

  @override
  void dispose() {
    _switchCtrl.dispose();
    super.dispose();
  }

  Future<void> _switchView(bool toSignIn) async {
    await _switchCtrl.reverse();
    setState(() => _isSignIn = toSignIn);
    _switchCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: FadeTransition(
        opacity: _fadeAnim,
        child: _isSignIn
            ? LoginScreen(onSwitchToRegister: () => _switchView(false))
            : RegisterScreen(onSwitchToLogin: () => _switchView(true)),
      ),
    );
  }
}

 */

// lib/features/auth/views/auth_screen.dart
import 'package:ajenda_app/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  bool _isSignIn = true;
  late AnimationController _switchCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _switchCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
    _fadeAnim = CurvedAnimation(parent: _switchCtrl, curve: Curves.easeInOut);
    _switchCtrl.value = 1.0;
  }

  void _switchView(bool toSignIn) async {
    await _switchCtrl.reverse();
    setState(() => _isSignIn = toSignIn);
    _switchCtrl.forward();
  }

  @override
  void dispose() {
    _switchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: _isSignIn
          ? LoginScreen(onSwitchToSignUp: () => _switchView(false))
          : RegisterScreen(onSwitchToSignIn: () => _switchView(true)),
    );
  }
}