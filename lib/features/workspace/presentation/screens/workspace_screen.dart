// presentation/screens/workspace_screen.dart

import 'package:ajenda_app/core/storage/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_colors.dart';

import '../../../../core/utils/icon_mapper.dart';
import '../../../roles/models/workspce_role.dart';
import '../../../roles/utils/role_permissions_mapper.dart';
import '../../data/models/workspace_model.dart';
import '../../logic/workspace_cubit/workspace_cubit.dart';
import '../../logic/workspace_cubit/workspace_state.dart';

class _WsColor {
  static const _key = 'ws_color_';

  static const List<Color> palette = [
    Color.fromARGB(255, 182, 74, 74),
    Color.fromARGB(255, 6, 106, 74),
    Color.fromARGB(255, 188, 21, 102),
    Color.fromARGB(255, 171, 113, 147),
    Color.fromARGB(255, 245, 11, 11),
    Color.fromARGB(255, 79, 2, 2),
    Color.fromARGB(255, 52, 164, 216),
    Color.fromARGB(255, 246, 218, 92),
    Color.fromARGB(255, 87, 173, 136),
    Color(0xFFD97706),
    Color.fromARGB(255, 124, 86, 190),
    Color.fromARGB(255, 17, 5, 150),
  ];

  static Future<void> save(int id, Color color) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('$_key$id', color.value);
  }

  static Future<Color> load(int id) async {
    final p = await SharedPreferences.getInstance();
    final v = p.getInt('$_key$id');
    return v != null ? Color(v) : palette[id % palette.length];
  }
}

class _MemberEntry {
  final String email;
  final WorkspaceRole role;

  const _MemberEntry({required this.email, required this.role});

  List<String> get permissions => RolePermissionsMapper.map(role);

  String get roleLabel {
    switch (role) {
      case WorkspaceRole.viewer: return 'Viewer';
      case WorkspaceRole.editor: return 'Editor';
      case WorkspaceRole.admin:  return 'Admin';
      case WorkspaceRole.custom: return 'Custom';
    }
  }

  Color get roleColor {
    switch (role) {
      case WorkspaceRole.viewer: return const Color(0xFF6B7280);
      case WorkspaceRole.editor: return const Color(0xFF4A90E2);
      case WorkspaceRole.admin:  return const Color(0xFF1D9E75);
      case WorkspaceRole.custom: return const Color(0xFF7C3AED);
    }
  }
}

class WorkspacesScreen extends StatelessWidget {
  const WorkspacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkspaceCubit>()..getWorkspaces(),
      child: const _Screen(),
    );
  }
}

class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: BlocBuilder<WorkspaceCubit, WorkspaceState>(
                builder: (ctx, state) {
                  if (state is WorkspaceLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary, strokeWidth: 2.5),
                    );
                  }
                  if (state is WorkspaceError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () =>
                          ctx.read<WorkspaceCubit>().getWorkspaces(),
                    );
                  }
                  if (state is WorkspaceSuccess) {
                    if (state.workspaces.isEmpty) {
                      return _EmptyView(
                          onCreateTap: () => _openCreate(ctx));
                    }
                    return _Grid(workspaces: state.workspaces);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (ctx) => _FAB(onTap: () => _openCreate(ctx)),
      ),
    );
  }

  void _openCreate(BuildContext context) {
    final cubit = context.read<WorkspaceCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) =>
          BlocProvider.value(value: cubit, child: const _CreateSheet()),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          _BackBtn(onTap: () => context.pop()),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Workspaces',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1035))),
                Text('Your projects & teams',
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

class _BackBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _BackBtn({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E4FF)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary, size: 18),
        ),
      );
}

class _Grid extends StatelessWidget {
  final List<WorkspaceModel> workspaces;
  const _Grid({required this.workspaces});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.88,
      ),
      itemCount: workspaces.length,
      itemBuilder: (_, i) => _Card(workspace: workspaces[i]),
    );
  }
}

class _Card extends StatefulWidget {
  final WorkspaceModel workspace;
  const _Card({required this.workspace});

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  Color _color = AppColors.primary;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _loadColor();
  }

  Future<void> _loadColor() async {
    final c = await _WsColor.load(widget.workspace.id);
    if (mounted) setState(() => _color = c);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emoji = IconMapper.getEmoji(widget.workspace.iconCode);

    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) =>
          Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          context.push(RouteNames.workspaceDashboard, extra: {
            'workspaceId': widget.workspace.id,
            'workspaceName': widget.workspace.name,
            'workspaceDescription': widget.workspace.description,
            'numberOfMembers': widget.workspace.numberOfMembers,
            'numberOfTasks': widget.workspace.numberOfTasks,
            'isCurrentUserOwner': widget.workspace.isOwnedByCurrentUser,
          });
        },
        onTapCancel: () => _ctrl.reverse(),
        onLongPress: () {
          HapticFeedback.mediumImpact();
          _openActions();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _color.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                  color: _color.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.08),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(emoji,
                          style: const TextStyle(fontSize: 32)),
                    ),
                    Positioned(
                      top: 8, right: 8,
                      child: GestureDetector(
                        onTap: _openActions,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.more_horiz_rounded,
                              color: _color, size: 16),
                        ),
                      ),
                    ),
                    if (widget.workspace.isOwnedByCurrentUser)
                      Positioned(
                        top: 8, left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('Owner',
                              style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workspace.name,
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1035),
                            height: 1.2),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.workspace.description.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          widget.workspace.description,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF6B6880),
                              height: 1.3),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.people_outline_rounded,
                              size: 12, color: _color.withOpacity(0.7)),
                          const SizedBox(width: 3),
                          Text('${widget.workspace.numberOfMembers}',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 10),
                          Icon(Icons.task_alt_rounded,
                              size: 12, color: _color.withOpacity(0.7)),
                          const SizedBox(width: 3),
                          Text('${widget.workspace.numberOfTasks}',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openActions() {
    final cubit = context.read<WorkspaceCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _ActionsSheet(
          workspace: widget.workspace,
          color: _color,
          isOwner: widget.workspace.isOwnedByCurrentUser,
          onEditTap: widget.workspace.isOwnedByCurrentUser
              ? () => _openEdit(cubit)
              : null,
          onDeleteTap: widget.workspace.isOwnedByCurrentUser
              ? () => _confirmDelete(cubit)
              : null,
          onLeaveTap: !widget.workspace.isOwnedByCurrentUser
              ? () => _confirmLeave(cubit)
              : null,
        ),
      ),
    );
  }

  void _openEdit(WorkspaceCubit cubit) {
    if (!widget.workspace.isOwnedByCurrentUser) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _EditSheet(
          workspace: widget.workspace,
          currentColor: _color,
          onColorSaved: (c) {
            if (mounted) setState(() => _color = c);
          },
        ),
      ),
    );
  }

  void _confirmDelete(WorkspaceCubit cubit) {
    if (!widget.workspace.isOwnedByCurrentUser) return;

    final sm = ScaffoldMessenger.of(context);
    final name = widget.workspace.name;
    final id = widget.workspace.id;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (d) => _Dialog(
        title: 'Delete Workspace?',
        body: '"$name" and all its data will be permanently removed.',
        confirmLabel: 'Delete',
        confirmColor: AppColors.error,
        onConfirm: () async {
          Navigator.of(d).pop();
          final ok = await cubit.deleteWorkspace(id,
              isOwner: widget.workspace.isOwnedByCurrentUser);
          if (!mounted) return;
          sm.clearSnackBars();
          sm.showSnackBar(_snack(
              ok ? '"$name" deleted.' : 'Failed to delete.',
              ok ? const Color(0xFF1D9E75) : AppColors.error));
        },
        onCancel: () => Navigator.of(d).pop(),
      ),
    );
  }

  void _confirmLeave(WorkspaceCubit cubit) async {
    final email = await SecureStorageService().getEmail() ?? '';

    // mounted check بعد الـ async
    if (!mounted) return;

    final sm = ScaffoldMessenger.of(context);
    final name = widget.workspace.name;
    final id = widget.workspace.id;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (d) => _Dialog(
        title: 'Leave Workspace?',
        body: 'You will lose access to "$name".',
        confirmLabel: 'Leave',
        confirmColor: const Color(0xFFD97706),
        onConfirm: () async {
          Navigator.of(d).pop();
          // ✅ بنبعت الإيميل مع الـ request body
          final ok = await cubit.leaveWorkspace(id, email);
          if (!mounted) return;
          sm.clearSnackBars();
          sm.showSnackBar(_snack(
              ok ? 'Left "$name".' : 'Failed to leave.',
              ok ? const Color(0xFF1D9E75) : AppColors.error));
        },
        onCancel: () => Navigator.of(d).pop(),
      ),
    );
  }

  SnackBar _snack(String msg, Color bg) => SnackBar(
        content: Text(msg,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
}

// ════════════════════════════════════════════════
// ACTIONS SHEET
// ════════════════════════════════════════════════
class _ActionsSheet extends StatelessWidget {
  final WorkspaceModel workspace;
  final Color color;
  final bool isOwner;
  final VoidCallback? onEditTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onLeaveTap;

  const _ActionsSheet({
    required this.workspace,
    required this.color,
    required this.isOwner,
    this.onEditTap,
    this.onDeleteTap,
    this.onLeaveTap,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = IconMapper.getEmoji(workspace.iconCode);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Handle(),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                    child: Text(emoji,
                        style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workspace.name,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1035))),
                    if (workspace.description.isNotEmpty)
                      Text(workspace.description,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.textMuted),
                          overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOwner
                      ? color.withOpacity(0.12)
                      : AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isOwner ? 'Owner' : 'Member',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isOwner ? color : AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: color.withOpacity(0.12)),
          const SizedBox(height: 8),

          if (isOwner) ...[
            _ActionRow(
              icon: Icons.edit_outlined,
              iconColor: const Color(0xFF4A90E2),
              iconBg: const Color(0xFFE6F4FF),
              label: 'Edit Workspace',
              sub: 'Change name, icon or color',
              onTap: () {
                Navigator.of(context).pop();
                onEditTap?.call();
              },
            ),
            _ActionRow(
              icon: Icons.people_outline_rounded,
              iconColor: const Color(0xFF1D9E75),
              iconBg: const Color(0xFFE8FFF0),
              label: 'Manage Members',
              sub: 'View and invite team',
              onTap: () {
                Navigator.of(context).pop();
                context.push(RouteNames.members, extra: {
                  'workspaceId': workspace.id,
                  'workspaceName': workspace.name,
                  'isCurrentUserOwner': true,
                });
              },
            ),
            _ActionRow(
              icon: Icons.delete_outline_rounded,
              iconColor: AppColors.error,
              iconBg: const Color(0xFFFEECEC),
              label: 'Delete Workspace',
              sub: 'Cannot be undone',
              isDestructive: true,
              onTap: () {
                Navigator.of(context).pop();
                onDeleteTap?.call();
              },
            ),
          ],

          if (!isOwner) ...[
            _ActionRow(
              icon: Icons.people_outline_rounded,
              iconColor: AppColors.primary,
              iconBg: AppColors.primary.withOpacity(0.08),
              label: 'View Members',
              sub: "See who's in this workspace",
              onTap: () {
                Navigator.of(context).pop();
                context.push(RouteNames.members, extra: {
                  'workspaceId': workspace.id,
                  'workspaceName': workspace.name,
                  'isCurrentUserOwner': false,
                });
              },
            ),
            _ActionRow(
              icon: Icons.logout_rounded,
              iconColor: const Color(0xFFD97706),
              iconBg: const Color(0xFFFEF3CD),
              label: 'Leave Workspace',
              sub: 'You will lose access',
              onTap: () {
                Navigator.of(context).pop();
                onLeaveTap?.call();
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, sub;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.sub,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 19),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: isDestructive
                                ? AppColors.error
                                : const Color(0xFF1A1035))),
                    Text(sub,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted.withOpacity(0.5), size: 18),
            ],
          ),
        ),
      );
}

class _Dialog extends StatelessWidget {
  final String title, body, confirmLabel;
  final Color confirmColor;
  final VoidCallback onConfirm, onCancel;

  const _Dialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
    required this.confirmColor,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22)),
        backgroundColor: Colors.white,
        title: Text(title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1035))),
        content: Text(body,
            style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.5)),
        actions: [
          TextButton(
            onPressed: onCancel,
            child: Text('Cancel',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textMuted)),
          ),
          GestureDetector(
            onTap: onConfirm,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                  color: confirmColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(confirmLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
        ],
      );
}

class _CreateSheet extends StatefulWidget {
  const _CreateSheet();

  @override
  State<_CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<_CreateSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final List<_MemberEntry> _members = [];

  String _emoji = IconMapper.all.first.emoji;
  String _emojiCode = IconMapper.all.first.code;
  int _colorIdx = 0;
  int _visibility = 0;
  bool _isLoading = false;

  Color get _accent => _WsColor.palette[_colorIdx];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _addMember() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) return;
    if (_members.any((m) => m.email == email)) return;

    final role = await _showRolePickerSheet();
    if (role == null) return;

    setState(() {
      _members.add(_MemberEntry(email: email, role: role));
      _emailCtrl.clear();
    });
  }

  Future<WorkspaceRole?> _showRolePickerSheet() {
    return showModalBottomSheet<WorkspaceRole>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RolePickerSheet(accent: _accent),
    );
  }

  Future<void> _create() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    final cubit = context.read<WorkspaceCubit>();

    final newId = await cubit.createWorkspace(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      iconCode: _emojiCode,
      visibility: _visibility,
    );

    if (newId != null) {
      await _WsColor.save(newId, _accent);
      for (final member in _members) {
        await cubit.addMember(newId, member.email, member.permissions);
      }
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Workspace created!',
            style: GoogleFonts.poppins(
                fontSize: 13, color: Colors.white)),
        backgroundColor: const Color(0xFF1D9E75),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Handle(),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Center(
                      child: Text(_emoji,
                          style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create a New Workspace',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1035))),
                      Text('Set up a space for your team.',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: _accent.withOpacity(0.12)),
            const SizedBox(height: 18),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Workspace Icon'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickEmoji,
                      child: Container(
                        width: 70, height: 70,
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: _accent.withOpacity(0.3),
                              width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_emoji,
                                style: const TextStyle(fontSize: 30)),
                            Text('CHANGE',
                                style: GoogleFonts.poppins(
                                    fontSize: 7,
                                    color: _accent,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Color Theme'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          _WsColor.palette.length,
                          (i) => _Dot(
                            color: _WsColor.palette[i],
                            isSelected: _colorIdx == i,
                            onTap: () =>
                                setState(() => _colorIdx = i),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            _Label('Workspace Name'),
            const SizedBox(height: 6),
            _Field(
                ctrl: _nameCtrl,
                hint: 'e.g. Marketing Team',
                accent: _accent),
            const SizedBox(height: 14),
            _Label('Description (Optional)'),
            const SizedBox(height: 6),
            _Field(
                ctrl: _descCtrl,
                hint: 'What is this workspace for?',
                accent: _accent,
                maxLines: 3),
            const SizedBox(height: 18),

            Row(
              children: [
                Icon(Icons.person_add_alt_1_outlined,
                    size: 15, color: _accent),
                const SizedBox(width: 5),
                _Label('Invite Team Members'),
              ],
            ),
            const SizedBox(height: 4),
            Text('Tap "Add" to choose a role for each member.',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.textMuted)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    ctrl: _emailCtrl,
                    hint: 'member@example.com',
                    accent: _accent,
                    onSubmitted: (_) => _addMember(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addMember,
                  child: Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                            color: _accent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: Center(
                      child: Text('Add',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            if (_members.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _members
                    .map((m) => _MemberChip(
                          member: m,
                          accentColor: _accent,
                          onRemove: () =>
                              setState(() => _members.remove(m)),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 18),

            _Label('Workspace Visibility'),
            const SizedBox(height: 10),
            _VisibilityPicker(
              selected: _visibility,
              accent: _accent,
              onChanged: (v) => setState(() => _visibility = v),
            ),
            const SizedBox(height: 26),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: _accent.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _create,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isLoading ? AppColors.grey : _accent,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: _isLoading
                            ? []
                            : [
                                BoxShadow(
                                    color: _accent.withOpacity(0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6))
                              ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white))
                            : Text('Create Workspace',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _pickEmoji() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EmojiPicker(
        selectedCode: _emojiCode,
        accent: _accent,
        onSelected: (item) => setState(() {
          _emoji = item.emoji;
          _emojiCode = item.code;
        }),
      ),
    );
  }
}

class _RolePickerSheet extends StatelessWidget {
  final Color accent;
  const _RolePickerSheet({required this.accent});

  static const _roles = [
    (WorkspaceRole.viewer, 'Viewer', Icons.visibility_outlined,
        'Read only — can view content', Color(0xFF6B7280)),
    (WorkspaceRole.editor, 'Editor', Icons.edit_outlined,
        'Can create & edit content', Color(0xFF4A90E2)),
    (WorkspaceRole.admin, 'Admin', Icons.admin_panel_settings_outlined,
        'Full access, including delete', Color(0xFF1D9E75)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Handle(),
          const SizedBox(height: 16),
          Text('Select Member Role',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1035))),
          const SizedBox(height: 4),
          Text('Choose the permission level for this member.',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 20),
          ..._roles.map(
            (r) => GestureDetector(
              onTap: () => Navigator.pop(context, r.$1),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 46, height: 46,
                      decoration: BoxDecoration(
                        color: r.$5.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(r.$3, color: r.$5, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.$2,
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A1035))),
                          Text(r.$4,
                              style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: AppColors.textMuted.withOpacity(0.5),
                        size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberChip extends StatelessWidget {
  final _MemberEntry member;
  final Color accentColor;
  final VoidCallback onRemove;

  const _MemberChip({
    required this.member,
    required this.accentColor,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 9,
            backgroundColor: accentColor,
            child: Text(
              member.email.isNotEmpty
                  ? member.email[0].toUpperCase()
                  : '?',
              style: GoogleFonts.poppins(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
          const SizedBox(width: 5),
          Text(member.email,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: accentColor,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 5),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: member.roleColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(member.roleLabel,
                style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: member.roleColor,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded,
                size: 12, color: accentColor),
          ),
        ],
      ),
    );
  }
}

class _EditSheet extends StatefulWidget {
  final WorkspaceModel workspace;
  final Color currentColor;
  final ValueChanged<Color> onColorSaved;

  const _EditSheet({
    required this.workspace,
    required this.currentColor,
    required this.onColorSaved,
  });

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late String _emoji;
  late String _emojiCode;
  late int _colorIdx;
  bool _isLoading = false;

  Color get _accent => _WsColor.palette[_colorIdx];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.workspace.name);
    _descCtrl =
        TextEditingController(text: widget.workspace.description);
    _emojiCode = widget.workspace.iconCode;
    _emoji = IconMapper.getEmoji(_emojiCode);
    _colorIdx = _WsColor.palette
        .indexWhere((c) => c.value == widget.currentColor.value);
    if (_colorIdx == -1) _colorIdx = 0;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);

    await _WsColor.save(widget.workspace.id, _accent);
    widget.onColorSaved(_accent);

    final ok = await context.read<WorkspaceCubit>().editWorkspace(
          workspaceId: widget.workspace.id,
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          iconCode: _emojiCode,
          visibility: widget.workspace.visibility,
          isOwner: widget.workspace.isOwnedByCurrentUser,
        );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            ok ? 'Workspace updated!' : 'Failed to update.',
            style: GoogleFonts.poppins(
                fontSize: 13, color: Colors.white)),
        backgroundColor:
            ok ? const Color(0xFF1D9E75) : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Handle(),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2FE),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.edit_outlined,
                      color: Color(0xFF4A90E2), size: 18),
                ),
                const SizedBox(width: 11),
                Text('Edit Workspace',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1035))),
              ],
            ),
            const SizedBox(height: 20),
            Divider(height: 1, color: _accent.withOpacity(0.12)),
            const SizedBox(height: 18),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label('Icon'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: _pickEmoji,
                      child: Container(
                        width: 70, height: 70,
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: _accent.withOpacity(0.3),
                              width: 1.5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_emoji,
                                style: const TextStyle(fontSize: 30)),
                            Text('CHANGE',
                                style: GoogleFonts.poppins(
                                    fontSize: 7,
                                    color: _accent,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Color'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(
                          _WsColor.palette.length,
                          (i) => _Dot(
                            color: _WsColor.palette[i],
                            isSelected: _colorIdx == i,
                            onTap: () =>
                                setState(() => _colorIdx = i),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            _Label('Workspace Name'),
            const SizedBox(height: 6),
            _Field(
                ctrl: _nameCtrl,
                hint: 'Workspace name',
                accent: _accent),
            const SizedBox(height: 14),
            _Label('Description'),
            const SizedBox(height: 6),
            _Field(
                ctrl: _descCtrl,
                hint: 'Short description...',
                accent: _accent,
                maxLines: 2),
            const SizedBox(height: 26),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F3FF),
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                            color: _accent.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: _isLoading ? null : _save,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isLoading ? AppColors.grey : _accent,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: _isLoading
                            ? []
                            : [
                                BoxShadow(
                                    color: _accent.withOpacity(0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6))
                              ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white))
                            : Text('Save Changes',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _pickEmoji() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EmojiPicker(
        selectedCode: _emojiCode,
        accent: _accent,
        onSelected: (item) => setState(() {
          _emoji = item.emoji;
          _emojiCode = item.code;
        }),
      ),
    );
  }
}

class _EmojiPicker extends StatelessWidget {
  final String selectedCode;
  final Color accent;
  final ValueChanged<WorkspaceEmoji> onSelected;

  const _EmojiPicker({
    required this.selectedCode,
    required this.accent,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _Handle(),
          const SizedBox(height: 14),
          Text('Choose Icon',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1035))),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
              itemCount: IconMapper.all.length,
              itemBuilder: (ctx, i) {
                final item = IconMapper.all[i];
                final isSel = item.code == selectedCode;
                return GestureDetector(
                  onTap: () {
                    onSelected(item);
                    Navigator.pop(ctx);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      color: isSel
                          ? accent.withOpacity(0.12)
                          : const Color(0xFFF8F7FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: isSel ? accent : Colors.transparent,
                          width: 2),
                    ),
                    child: Center(
                      child: Text(item.emoji,
                          style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VisibilityPicker extends StatelessWidget {
  final int selected;
  final Color accent;
  final ValueChanged<int> onChanged;

  const _VisibilityPicker({
    required this.selected,
    required this.accent,
    required this.onChanged,
  });

  static const _opts = [
    (Icons.lock_outline_rounded, 'Private',
        'Only invited members can see this.'),
    (Icons.people_outline_rounded, 'Team',
        'Visible to everyone in the organization.'),
    (Icons.public_rounded, 'Public', 'Anyone with the link can view.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        final isSelected = selected == i;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? 8.0 : 0),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? accent.withOpacity(0.07)
                      : const Color(0xFFF8F7FF),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: isSelected
                        ? accent
                        : const Color(0xFFE8E4FF),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? accent
                              : const Color(0xFFCCC8E8),
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 9, height: 9,
                                decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Icon(_opts[i].$1,
                        color: isSelected
                            ? accent
                            : AppColors.textMuted,
                        size: 17),
                    const SizedBox(height: 4),
                    Text(_opts[i].$2,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? accent
                                : const Color(0xFF1A1035))),
                    const SizedBox(height: 3),
                    Text(_opts[i].$3,
                        style: GoogleFonts.poppins(
                            fontSize: 8.5,
                            color: AppColors.textMuted,
                            height: 1.3),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 36, height: 4,
          decoration: BoxDecoration(
              color: const Color(0xFFE0DCF0),
              borderRadius: BorderRadius.circular(2)),
        ),
      );
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF1A1035)));
}

class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final Color accent;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;

  const _Field({
    required this.ctrl,
    required this.hint,
    required this.accent,
    this.maxLines = 1,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: ctrl,
        maxLines: maxLines,
        onSubmitted: onSubmitted,
        style: GoogleFonts.poppins(
            fontSize: 13, color: const Color(0xFF1A1035)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
              fontSize: 13, color: AppColors.textHint),
          filled: true,
          fillColor: const Color(0xFFF8F7FF),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: Color(0xFFE8E4FF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(color: accent, width: 1.5),
          ),
        ),
      );
}

class _Dot extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  const _Dot({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 26, height: 26,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: isSelected
                ? Border.all(color: Colors.white, width: 2.5)
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: color.withOpacity(0.55), blurRadius: 7)
                  ]
                : [],
          ),
          child: isSelected
              ? const Icon(Icons.check_rounded,
                  color: Colors.white, size: 13)
              : null,
        ),
      );
}

class _FAB extends StatelessWidget {
  final VoidCallback onTap;
  const _FAB({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 18,
                  offset: const Offset(0, 6))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 7),
              Text('New Workspace',
                  style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
        ),
      );
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onCreateTap;
  const _EmptyView({required this.onCreateTap});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 76, height: 76,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                    child:
                        Text('💼', style: TextStyle(fontSize: 36))),
              ),
              const SizedBox(height: 20),
              Text('No workspaces yet',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1035))),
              const SizedBox(height: 8),
              Text(
                  'Create your first workspace\nto organize your team.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.6)),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onCreateTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text('Create Workspace',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.error_outline_rounded,
                    color: AppColors.error, size: 28),
              ),
              const SizedBox(height: 14),
              Text('Something went wrong',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1035))),
              const SizedBox(height: 6),
              Text(message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 11),
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(11)),
                  child: Text('Try Again',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
}