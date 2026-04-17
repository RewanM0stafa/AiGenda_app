// presentation/screens/workspace_screen.dart

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
import '../../data/models/workspace_model.dart';
import '../../logic/workspace_cubit/workspace_cubit.dart';
import '../../logic/workspace_cubit/workspace_state.dart';

// ════════════════════════════════════════════════
// COLOR SERVICE — inline, no separate file
// ════════════════════════════════════════════════
class _WsColor {
  static const _key = 'ws_color_';

  static const List<Color> palette = [
    Color(0xFF6C4AB6), // Purple
    Color(0xFF1D9E75), // Green
    Color(0xFF4A90E2), // Blue
    Color(0xFFE11D8E), // Pink
    Color(0xFFF59E0B), // Amber
    Color(0xFFEF4444), // Red
    Color(0xFF0EA5E9), // Sky
    Color(0xFF8B5CF6), // Violet
    Color(0xFF0D9488), // Teal
    Color(0xFFD97706), // Orange
    Color(0xFF7C3AED), // Deep Violet
    Color(0xFF059669), // Emerald
  ];

  /// Save user-chosen color for a workspace
  static Future<void> save(int id, Color color) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('$_key$id', color.value);
  }

  /// Load saved color — falls back to palette[id % length]
  static Future<Color> load(int id) async {
    final p = await SharedPreferences.getInstance();
    final v = p.getInt('$_key$id');
    return v != null ? Color(v) : palette[id % palette.length];
  }
}

// ════════════════════════════════════════════════
// ENTRY
// ════════════════════════════════════════════════
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

// ════════════════════════════════════════════════
// HEADER
// ════════════════════════════════════════════════
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
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary, size: 18),
        ),
      );
}

// ════════════════════════════════════════════════
// GRID
// ════════════════════════════════════════════════
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

// ════════════════════════════════════════════════
// CARD — loads saved color from SharedPreferences
// ════════════════════════════════════════════════
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
    // ✅ Load the saved color for this workspace
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
          context.push(RouteNames.members, extra: {
            'workspaceId': widget.workspace.id,
            'workspaceName': widget.workspace.name,
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
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Emoji area (colored bg) ──
              Container(
                height: 90,
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
                          style: const TextStyle(fontSize: 42)),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _openActions,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 28,
                          height: 28,
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
                        top: 8,
                        left: 8,
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

              // ── Info ──
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.workspace.name,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1035),
                            height: 1.2),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.workspace.description.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          widget.workspace.description,
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.textMuted,
                              height: 1.3),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.people_outline_rounded,
                              size: 12,
                              color: _color.withOpacity(0.7)),
                          const SizedBox(width: 3),
                          Text('${widget.workspace.numberOfMembers}',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(width: 10),
                          Icon(Icons.task_alt_rounded,
                              size: 12,
                              color: _color.withOpacity(0.7)),
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
          onEditTap: () => _openEdit(cubit),
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
          // ✅ When user saves a new color, update the card immediately
          onColorSaved: (newColor) {
            if (mounted) setState(() => _color = newColor);
          },
        ),
      ),
    );
  }

  void _confirmDelete(WorkspaceCubit cubit) {
    final sm = ScaffoldMessenger.of(context);
    final name = widget.workspace.name;
    final id = widget.workspace.id;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (d) => _Dialog(
        title: 'Delete Workspace?',
        body:
            '"$name" and all its data will be permanently removed.',
        confirmLabel: 'Delete',
        confirmColor: AppColors.error,
        onConfirm: () async {
          Navigator.of(d).pop();
          final ok = await cubit.deleteWorkspace(id);
          sm.clearSnackBars();
          sm.showSnackBar(_snack(
              ok ? '"$name" deleted.' : 'Failed to delete.',
              ok ? const Color(0xFF1D9E75) : AppColors.error));
        },
        onCancel: () => Navigator.of(d).pop(),
      ),
    );
  }

  void _confirmLeave(WorkspaceCubit cubit) {
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
          final ok = await cubit.leaveWorkspace(id);
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
            style:
                GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
        backgroundColor: bg,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
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
  final VoidCallback onEditTap;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onLeaveTap;

  const _ActionsSheet({
    required this.workspace,
    required this.color,
    required this.onEditTap,
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
                width: 48,
                height: 48,
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
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: color.withOpacity(0.12)),
          const SizedBox(height: 8),
          _ActionRow(
            icon: Icons.edit_outlined,
            iconColor: const Color(0xFF4A90E2),
            iconBg: const Color(0xFFE6F4FF),
            label: 'Edit Workspace',
            sub: 'Change name, icon or color',
            onTap: () { Navigator.of(context).pop(); onEditTap(); },
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
              });
            },
          ),
          if (onLeaveTap != null)
            _ActionRow(
              icon: Icons.logout_rounded,
              iconColor: const Color(0xFFD97706),
              iconBg: const Color(0xFFFEF3CD),
              label: 'Leave Workspace',
              sub: 'You will lose access',
              onTap: () {
                Navigator.of(context).pop();
                onLeaveTap!();
              },
            ),
          if (onDeleteTap != null)
            _ActionRow(
              icon: Icons.delete_outline_rounded,
              iconColor: AppColors.error,
              iconBg: const Color(0xFFFEECEC),
              label: 'Delete Workspace',
              sub: 'Cannot be undone',
              isDestructive: true,
              onTap: () {
                Navigator.of(context).pop();
                onDeleteTap!();
              },
            ),
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
                width: 42,
                height: 42,
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

// ════════════════════════════════════════════════
// CONFIRM DIALOG
// ════════════════════════════════════════════════
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

// ════════════════════════════════════════════════
// CREATE SHEET
// ════════════════════════════════════════════════
class _CreateSheet extends StatefulWidget {
  const _CreateSheet();

  @override
  State<_CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends State<_CreateSheet> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final List<String> _emails = [];

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

  void _addEmail() {
    final e = _emailCtrl.text.trim();
    if (e.isEmpty || _emails.contains(e)) return;
    setState(() { _emails.add(e); _emailCtrl.clear(); });
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

    // ✅ Save the user-chosen color using the new workspace ID
    if (newId != null) {
      await _WsColor.save(newId, _accent);
      for (final email in _emails) {
        await cubit.addMember(newId, email);
      }
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Workspace created!',
            style:
                GoogleFonts.poppins(fontSize: 13, color: Colors.white)),
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

            // Title row
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
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

            // ── Icon + Color ──
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
                        width: 70,
                        height: 70,
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
                                style:
                                    const TextStyle(fontSize: 30)),
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

            // ── Invite Members ──
            Row(
              children: [
                Icon(Icons.person_add_alt_1_outlined,
                    size: 15, color: _accent),
                const SizedBox(width: 5),
                _Label('Invite Team Members'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    ctrl: _emailCtrl,
                    hint: 'member@example.com',
                    accent: _accent,
                    onSubmitted: (_) => _addEmail(),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addEmail,
                  child: Container(
                    height: 46,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
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
            if (_emails.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _emails
                    .map((e) => _Chip(
                          email: e,
                          color: _accent,
                          onRemove: () =>
                              setState(() => _emails.remove(e)),
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
                onChanged: (v) => setState(() => _visibility = v)),
            const SizedBox(height: 26),

            // ── Buttons ──
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
                                  offset: const Offset(0, 6),
                                )
                              ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
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

// ════════════════════════════════════════════════
// EDIT SHEET — now actually calls the API
// ════════════════════════════════════════════════
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
    // ✅ Find the saved color index (or default to 0)
    _colorIdx = _WsColor.palette.indexWhere(
        (c) => c.value == widget.currentColor.value);
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

    // ✅ 1. Save color locally and notify the card immediately
    await _WsColor.save(widget.workspace.id, _accent);
    widget.onColorSaved(_accent);

    // ✅ 2. Call PUT API (editWorkspace is now in the cubit)
    final ok = await context.read<WorkspaceCubit>().editWorkspace(
          workspaceId: widget.workspace.id,
          name: _nameCtrl.text.trim(),
          description: _descCtrl.text.trim(),
          iconCode: _emojiCode,
          visibility: widget.workspace.visibility,
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
                  width: 38,
                  height: 38,
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

            // ── Icon + Color ──
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
                        width: 70,
                        height: 70,
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
                                  offset: const Offset(0, 6),
                                )
                              ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
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

// ════════════════════════════════════════════════
// EMOJI PICKER SHEET
// ════════════════════════════════════════════════
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

// ════════════════════════════════════════════════
// VISIBILITY PICKER
// ════════════════════════════════════════════════
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
      children: List.generate(
        3,
        (i) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? 8.0 : 0),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                decoration: BoxDecoration(
                  color: selected == i
                      ? accent.withOpacity(0.07)
                      : const Color(0xFFF8F7FF),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: selected == i
                        ? accent
                        : const Color(0xFFE8E4FF),
                    width: selected == i ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected == i
                              ? accent
                              : const Color(0xFFCCC8E8),
                          width: 2,
                        ),
                      ),
                      child: selected == i
                          ? Center(
                              child: Container(
                                width: 9,
                                height: 9,
                                decoration: BoxDecoration(
                                    color: accent,
                                    shape: BoxShape.circle),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Icon(_opts[i].$1,
                        color: selected == i
                            ? accent
                            : AppColors.textMuted,
                        size: 17),
                    const SizedBox(height: 4),
                    Text(_opts[i].$2,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: selected == i
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
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// SMALL HELPERS
// ════════════════════════════════════════════════
class _Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          width: 36,
          height: 4,
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
  const _Dot(
      {required this.color,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 26,
          height: 26,
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

class _Chip extends StatelessWidget {
  final String email;
  final Color color;
  final VoidCallback onRemove;
  const _Chip(
      {required this.email,
      required this.color,
      required this.onRemove});

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.09),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 9,
              backgroundColor: color,
              child: Text(
                email.isNotEmpty ? email[0].toUpperCase() : '?',
                style: GoogleFonts.poppins(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 5),
            Text(email,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500)),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: onRemove,
              child:
                  Icon(Icons.close_rounded, size: 12, color: color),
            ),
          ],
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
              const Icon(Icons.add_rounded, color: Colors.white, size: 20),
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
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                    child: Text('💼',
                        style: TextStyle(fontSize: 36))),
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
                width: 60,
                height: 60,
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