/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF9D64FC);
const Color kBackgroundColor = Colors.white;
const Color kHeaderTextColor = Color(0xFF6A31B8);
const Color kSecondaryTextColor = Colors.grey;
const Color kVerifiedColor = Color(0xFF43D17C);
const Color kGradientStart = Color(0xFFE0C3FC);
const Color kGradientEnd = Color(0xFF8EC5FC);
const Color kShadowColor = Colors.black12;

void main() {
  runApp(const HomeScreen());
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/routes/route_names.dart';

class TemporarySelectionScreen extends StatelessWidget {
  const TemporarySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: Text('Explore Ajenda', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Where would you like to go?',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),

            // خيار الـ Profile
            _SelectionCard(
              title: 'My Profile',
              subtitle: 'View and edit your personal info',
              icon: Icons.person_rounded,
              color: const Color(0xFF6C3FC8),
              onTap: () {
                context.push(RouteNames.profile);
                print('Navigate to Profile');
              },
            ),

            const SizedBox(height: 16),

            // خيار الـ Workspace
            _SelectionCard(
              title: 'Workspace',
              subtitle: 'Manage your tasks and projects',
              icon: Icons.work_rounded,
              color: const Color(0xFF1E0F5C),
              onTap: () {
                context.push(RouteNames.workspaces);
                print('Navigate to Workspace');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E0F5C),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300], size: 16),
          ],
        ),
      ),
    );
  }
}