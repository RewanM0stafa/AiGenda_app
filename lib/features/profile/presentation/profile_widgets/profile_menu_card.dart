import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_values.dart';
import '../../../../core/constants/app_icons.dart';
import 'profile_menu_item.dart';

class ProfileMenuCard extends StatefulWidget {
  final VoidCallback onAccountsTap;
  final VoidCallback onLogoutTap;

  const ProfileMenuCard({
    super.key,
    required this.onAccountsTap,
    required this.onLogoutTap,
  });

  @override
  State<ProfileMenuCard> createState() => _ProfileMenuCardState();
}

class _ProfileMenuCardState extends State<ProfileMenuCard> {
  bool _lightMode = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.horizontalPadding,
        24,
        AppValues.horizontalPadding,
        0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppValues.radiusCard),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.white.withOpacity(0.6),
                  AppColors.gradientPurple.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(AppValues.radiusCard),
              border: Border.all(
                color: AppColors.white.withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                ProfileMenuItem(
                  icon: AppIcons.person,
                  title: 'Accounts',
                  subtitle: 'Manage your accounts',
                  onTap: widget.onAccountsTap,
                ),
                _divider(),
                ProfileMenuItem(
                  icon: AppIcons.language,
                  title: 'Language',
                  subtitle: 'You can change the app language',
                  onTap: () {},
                ),
                _divider(),
                ProfileMenuItem(
                  icon: AppIcons.lockFilled,
                  title: 'Screen Lock',
                  subtitle: 'Manage Touch ID or Face ID',
                  onTap: () {},
                ),
                _divider(),
                ProfileMenuItem(
                  icon: AppIcons.brightness,
                  title: 'Light Mode',
                  subtitle: 'Switch between light & dark mode',
                  trailing: Switch(
                    value: _lightMode,
                    onChanged: (v) => setState(() => _lightMode = v),
                    activeColor: AppColors.primary,
                    activeTrackColor: AppColors.gradientPurple.withOpacity(0.3),
                  ),
                ),
                _divider(),
                ProfileMenuItem(
                  icon: AppIcons.star,
                  title: 'Rate',
                  titleSuffix: ' AiGenda',
                  onTap: () {},
                ),
                _divider(),
                ProfileMenuItem(
                  icon: AppIcons.logout,
                  title: 'Log Out',
                  isDestructive: true,
                  onTap: widget.onLogoutTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() => Divider(
    height: 1,
    thickness: 0.5,
    color: AppColors.primary.withOpacity(0.08),
    indent: 20,
    endIndent: 20,
  );
}
