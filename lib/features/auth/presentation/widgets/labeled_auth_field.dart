import 'package:flutter/material.dart';
import '../screens/auth_widget.dart';

class LabeledAuthField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool obscure;
  final bool enabled;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const LabeledAuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.prefixIcon,
    this.obscure = false,
    this.enabled = true,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthFieldLabel(label: label),
        const SizedBox(height: 6),
        AuthTextField(
          controller: controller,
          hint: hint,
          prefixIcon: prefixIcon,
          obscure: obscure,
          enabled: enabled,
          suffixIcon: suffixIcon,
          keyboardType: keyboardType,
          validator: validator,
        ),
        const SizedBox(height: 14), // مسافة ثابتة مريحة للعين بين الـ Fields
      ],
    );
  }
}