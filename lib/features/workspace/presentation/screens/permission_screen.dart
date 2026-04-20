// presentation/screens/permission_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_permissions.dart';
import '../../../roles/models/workspce_role.dart';
import '../../logic/permission_cubit/permission_cubit.dart';
import '../../logic/permission_cubit/permission_state.dart';

class PermissionsScreen extends StatelessWidget {
  final int workspaceId;
  final String userId;

  const PermissionsScreen({
    super.key,
    required this.workspaceId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // FIX: Added BlocListener to handle PermissionsUpdateSuccess and
      // PermissionsError so the user gets visual feedback and the screen
      // pops on success. Previously, PermissionsUpdateSuccess was emitted
      // but nothing listened to it — the button appeared broken.
      body: BlocListener<PermissionsCubit, PermissionsState>(
        listener: (context, state) {
          if (state is PermissionsUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.white),
                ),
                backgroundColor: const Color(0xFF1D9E75),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              ),
            );
            context.pop(); // Navigate back to MembersScreen on success.
          }

          if (state is PermissionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.white),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<PermissionsCubit, PermissionsState>(
                  // buildWhen avoids a flicker: we only rebuild the body
                  // for PermissionsLoaded/Initial; listener handles the rest.
                  buildWhen: (prev, curr) =>
                      curr is PermissionsLoaded || curr is PermissionsInitial,
                  builder: (context, state) {
                    if (state is PermissionsLoaded) {
                      return _PermissionsBody(state: state);
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  },
                ),
              ),
              _SaveBar(workspaceId: workspaceId, userId: userId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primary, size: 18),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Manage Permissions',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark)),
                Text('Set member access level',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// BODY
// ════════════════════════════════════════════════
class _PermissionsBody extends StatelessWidget {
  final PermissionsLoaded state;
  const _PermissionsBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoleSelector(state: state),
          const SizedBox(height: 20),

          if (state.role == WorkspaceRole.viewer) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBFF),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Viewers have basic read access to all content.',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          ..._buildGroups(context, state),
        ],
      ),
    );
  }

  List<Widget> _buildGroups(BuildContext context, PermissionsLoaded state) {
    final Map<String, List<String>> groups = {
      'Spaces':
          AppPermissions.all.where((p) => p.startsWith('spaces')).toList(),
      'Tasks':
          AppPermissions.all.where((p) => p.startsWith('tasks')).toList(),
      'Notes':
          AppPermissions.all.where((p) => p.startsWith('notes')).toList(),
    };

    final groupIcons = {
      'Spaces': Icons.folder_outlined,
      'Tasks': Icons.task_alt_rounded,
      'Notes': Icons.note_outlined,
    };

    final groupColors = {
      'Spaces': const Color(0xFF4A90E2),
      'Tasks': const Color(0xFF1D9E75),
      'Notes': const Color(0xFFF59E0B),
    };

    return groups.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Column(
            children: [
              // Group header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: groupColors[entry.key]!.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(groupIcons[entry.key]!,
                          color: groupColors[entry.key]!, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Text(entry.key,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark)),
                    const Spacer(),
                    Text(
                      '${entry.value.where((p) => state.selectedPermissions.contains(p)).length}/${entry.value.length}',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFF5F3FF)),

              // Permission rows
              ...entry.value.map((permission) {
                final isSelected =
                    state.selectedPermissions.contains(permission);
                final action = permission.split(':')[1];
                final actionLabels = {
                  'add': ('Create', Icons.add_circle_outline_rounded),
                  'read': ('View', Icons.visibility_outlined),
                  'update': ('Edit', Icons.edit_outlined),
                  'delete': ('Delete', Icons.delete_outline_rounded),
                };
                final label =
                    actionLabels[action]?.$1 ?? action.toUpperCase();
                final icon = actionLabels[action]?.$2 ??
                    Icons.check_circle_outline_rounded;

                return GestureDetector(
                  onTap: state.canUserModify
                      ? () => context
                          .read<PermissionsCubit>()
                          .togglePermission(permission)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(icon,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textMuted,
                            size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(label,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? AppColors.textDark
                                      : AppColors.textSecondary)),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.cardBorder,
                              width: 1.5,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.white, size: 14)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// ════════════════════════════════════════════════
// ROLE SELECTOR
// ════════════════════════════════════════════════
class _RoleSelector extends StatelessWidget {
  final PermissionsLoaded state;
  const _RoleSelector({required this.state});

  static const _roleData = {
    WorkspaceRole.viewer:
        ('Viewer', Icons.visibility_outlined, 'Read only'),
    WorkspaceRole.editor:
        ('Editor', Icons.edit_outlined, 'Can edit content'),
    WorkspaceRole.admin:
        ('Admin', Icons.admin_panel_settings_outlined, 'Full access'),
    WorkspaceRole.custom: ('Custom', Icons.tune_rounded, 'Manual setup'),
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Role',
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: WorkspaceRole.values.map((role) {
              final data = _roleData[role]!;
              final isSelected = state.role == role;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: state.canUserModify
                      ? () =>
                          context.read<PermissionsCubit>().changeRole(role)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.cardBorder,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color:
                                      AppColors.primary.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4))
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(data.$2,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textMuted,
                            size: 16),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.$1,
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textDark)),
                            Text(data.$3,
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: isSelected
                                        ? Colors.white70
                                        : AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════
// SAVE BAR
// ════════════════════════════════════════════════
class _SaveBar extends StatelessWidget {
  final int workspaceId;
  final String userId;
  const _SaveBar({required this.workspaceId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionsCubit, PermissionsState>(
      // Only rebuild the save bar for PermissionsLoaded states.
      buildWhen: (prev, curr) =>
          curr is PermissionsLoaded || curr is PermissionsInitial,
      builder: (context, state) {
        final isLoading =
            state is PermissionsLoaded && state.isLoading;
        final canModify =
            state is PermissionsLoaded && state.canUserModify;

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: AppColors.cardBorder)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -4))
            ],
          ),
          child: GestureDetector(
            onTap: (isLoading || !canModify)
                ? null
                : () => context
                    .read<PermissionsCubit>()
                    .updatePermissions(
                      workspaceId: workspaceId,
                      userId: userId,
                      canUserModify: canModify,
                    ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 52,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: (isLoading || !canModify)
                    ? LinearGradient(
                        colors: [AppColors.grey, AppColors.grey])
                    : AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
                boxShadow: (isLoading || !canModify)
                    ? []
                    : [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6))
                      ],
              ),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white))
                    : Text('Update Permissions',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
              ),
            ),
          ),
        );
      },
    );
  }
}