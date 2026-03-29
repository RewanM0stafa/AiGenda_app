import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../config/routes/route_names.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/presentation/widgets/auth_helpers.dart';
import '../../logic/profile_cubit/profile_cubit.dart';
import '../../logic/profile_cubit/profile_state.dart';
import '../profile_widgets/profile_header_card.dart';
import '../profile_widgets/profile_menu_card.dart';
import '../profile_widgets/shared_profile_widgets.dart';

// ════════════════════════════════════════════════════════════
// 📁 features/profile/presentation/screens/profile_screen.dart
// UI: Project A بالظبط
// ════════════════════════════════════════════════════════════

// ════════════════════════════════════════════════════════════
// 📁 features/profile/presentation/screens/profile_screen.dart
// ════════════════════════════════════════════════════════════

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) showAuthError(context, state.errMessage);
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C5CBF)),
                strokeWidth: 2.5,
              ),
            );
          }

          final profile = context.read<ProfileCubit>().currentProfile;
          final firstName = profile?.firstName ?? '';
          final lastName = profile?.secondName ?? '';
          final email = profile?.email ?? '';
          final initials = [
            if (firstName.isNotEmpty) firstName[0],
            if (lastName.isNotEmpty) lastName[0],
          ].join().toUpperCase();
          final fullName = '$firstName $lastName'.trim();

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  GestureDetector(onTap: () => context.pop(), child: backBtn()),
                  _buildTopBar(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ProfileCard(
                      initials: initials.isEmpty ? 'U' : initials,
                      fullName: fullName.isEmpty ? 'User' : fullName,
                      email: email,
                      imageUrl: profile?.profileImage,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionLabel(label: 'Account'),
                        MenuCard(items: [
                          MenuItem(
                            icon: Icons.person_outline_rounded,
                            iconBg: const Color(0xFFEDE6FF),
                            iconColor: const Color(0xFF7C5CBF),
                            label: 'Edit Profile',
                            sub: 'Update your info',
                            onTap: () async {
                              await context.push(RouteNames.editProfile);
                              if (mounted) context.read<ProfileCubit>().refreshProfile();
                            },
                          ),
                          MenuItem(
                            icon: Icons.lock_outline_rounded,
                            iconBg: const Color(0xFFE6F4FF),
                            iconColor: const Color(0xFF3B7ADE),
                            label: 'Change Password',
                            sub: 'Keep your account safe',
                            onTap: () => context.push(RouteNames.changePassword),
                          ),
                        ]),
                        const SectionLabel(label: 'Preferences'),
                        MenuCard(items: [
                          MenuItem(
                            icon: Icons.dark_mode_outlined,
                            iconBg: const Color(0xFFE6FFEF),
                            iconColor: const Color(0xFF1D9E75),
                            label: 'Dark Mode',
                            sub: 'Switch appearance',
                            trailing: ToggleSwitch(value: false, onChanged: (_) {}),
                          ),
                          MenuItem(
                            icon: Icons.notifications_none_rounded,
                            iconBg: const Color(0xFFFFF8E1),
                            iconColor: const Color(0xFFFFB300),
                            label: 'Notifications',
                            sub: 'Reminders and alerts',
                            onTap: () {},
                          ),
                          MenuItem(
                            icon: Icons.star_outline_rounded,
                            iconBg: const Color(0xFFFFEBEE),
                            iconColor: const Color(0xFFE53935),
                            label: 'Rate AI-Genda',
                            sub: 'Share your feedback',
                            onTap: () {},
                          ),
                        ]),
                        const SizedBox(height: 14),
                        SignOutButton(onTap: () => _showLogoutDialog(context)),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(children: [
                            Text('Powered by',
                                style: GoogleFonts.poppins(
                                    fontSize: 10, color: const Color(0xFFC0BCDA))),
                            Text('ByteVerse',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF7C5CBF))),
                          ]),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 36),
          Text('Profile',
              style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E0F5C))),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8E4F5), width: 1.2),
            ),
            child: const Icon(Icons.settings_outlined,
                color: Color(0xFF7C5CBF), size: 18),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log Out',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, color: const Color(0xFF1E0F5C))),
        content: Text('Are you sure you want to log out?',
            style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF8A84A3))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(color: const Color(0xFF8A84A3))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await SecureStorageService().clearAll();
              if (context.mounted) context.go(RouteNames.login);
            },
            child: Text('Log Out',
                style: GoogleFonts.poppins(
                    color: const Color(0xFFE53935),
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}


/*
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppValues.animSlow,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().load();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            showAuthError(context, state.errMessage);
          }
        },
        builder: (context, state) {
          final cubit = context.read<ProfileCubit>();
          final profile = cubit.current;

          if (state is ProfileLoading && profile == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return FadeTransition(
            opacity: _fadeAnim,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 210,
                  pinned: true,
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  actions: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(AppValues.radiusMd),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                  title: Text(
                    'Profile',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.gradientPurple.withOpacity(0.05),
                            AppColors.background,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ProfileHeaderCard(
                            profile: profile,
                            onEditTap: () => context.push(RouteNames.editProfile),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ProfileMenuCard(
                        onAccountsTap: () => context.push(RouteNames.editProfile),
                        onLogoutTap: () => _showLogoutDialog(context),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Powered by',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) =>
                            AppColors.primaryGradient.createShader(bounds),
                        child: Text(
                          'ByteVerse',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppValues.radiusCard),
        ),
        title: Text(
          'Log Out',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: AppTextStyles.bodyRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final storage = SecureStorageService();
              await storage.clearAll();
              if (context.mounted) context.go(RouteNames.login);
            },
            child: Text(
              'Log Out',
              style: GoogleFonts.outfit(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/