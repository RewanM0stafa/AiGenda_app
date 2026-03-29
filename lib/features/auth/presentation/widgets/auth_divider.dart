import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFFE8E4F5))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('Or continue with',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: const Color(0xFF8A84A3))),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFFE8E4F5))),
      ],
    );
  }
}
