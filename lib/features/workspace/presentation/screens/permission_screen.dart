import 'package:ajenda_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_permissions.dart';
import '../../../roles/models/workspce_role.dart';
import '../../logic/permission_cubit/permission_cubit.dart';
import '../../logic/permission_cubit/permission_state.dart';


class PermissionsScreen extends StatelessWidget {
  final int workspaceId;
  final String userId;

  const PermissionsScreen({super.key, required this.workspaceId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Member Permissions")),
      body: const _PermissionsBody(),
      bottomNavigationBar: _SaveButton(workspaceId: workspaceId, userId: userId),
    );
  }
}

class _PermissionsBody extends StatelessWidget {
  const _PermissionsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionsCubit, PermissionsState>(
      builder: (context, state) {
        if (state is PermissionsError) return Center(child: Text(state.message));
        if (state is PermissionsLoaded) {
          return CustomScrollView(
            slivers: [
              // 1. اختيار الـ Role (بشكل ChoiceChips)
              SliverToBoxAdapter(child: _RoleSelector(state: state)),

              const SliverToBoxAdapter(child: Divider()),

              if (state.role == WorkspaceRole.viewer)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: AppColors.gradientLight,
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "ℹ️ Viewers have basic read access to all content by default.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),

              ..._buildPermissionGroups(state, context),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> _buildPermissionGroups(PermissionsLoaded state, BuildContext context) {
    final Map<String, List<String>> groups = {
      'Spaces': AppPermissions.all.where((p) => p.startsWith('spaces')).toList(),
      'Tasks': AppPermissions.all.where((p) => p.startsWith('tasks')).toList(),
      'Notes': AppPermissions.all.where((p) => p.startsWith('notes')).toList(),
    };

    return groups.entries.map((entry) {
      return SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text(entry.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final permission = entry.value[index];
                final isSelected = state.selectedPermissions.contains(permission);

                final displayName = permission.split(':')[1].toUpperCase();

                return CheckboxListTile(
                  title: Text(displayName),
                  value: isSelected,
                  onChanged: (_) => context.read<PermissionsCubit>().togglePermission(permission),
                  controlAffinity: ListTileControlAffinity.trailing,
                );
              },
              childCount: entry.value.length,
            ),
          ),
        ],
      );
    }).toList();
  }
}

class _RoleSelector extends StatelessWidget {
  final PermissionsLoaded state;
  const _RoleSelector({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: WorkspaceRole.values.map((role) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(role.name.toUpperCase()),
                selected: state.role == role,
                onSelected: (selected) {
                  if (selected) context.read<PermissionsCubit>().changeRole(role);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final int workspaceId;
  final String userId;
  const _SaveButton({required this.workspaceId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionsCubit, PermissionsState>(
      builder: (context, state) {
        final isLoading = state is PermissionsLoaded && state.isLoading;
        return Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            onPressed: isLoading ? null : () {
              context.read<PermissionsCubit>().updatePermissions(
                workspaceId: workspaceId,
                userId: userId,
              );
            },
            child: isLoading ? const CircularProgressIndicator() : const Text("Update Permissions"),
          ),
        );
      },
    );
  }
}