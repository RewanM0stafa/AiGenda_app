// presentation/screens/member_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../roles/models/workspce_role.dart';
import '../../../roles/utils/role_permissions_mapper.dart';
import '../../data/models/member_model.dart';
import '../../logic/member_cubit/member_cubit.dart';
import '../../logic/member_cubit/member_state.dart';

class MembersScreen extends StatelessWidget {
  final int workspaceId;
  final String workspaceName;

  /// True when the currently logged-in user is the Owner of this workspace.
  /// Controls whether the "Edit Permissions" button is rendered on each member card.
  final bool isCurrentUserOwner;

  const MembersScreen({
    super.key,
    required this.workspaceId,
    required this.workspaceName,
    required this.isCurrentUserOwner,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MembersCubit>()..getMembers(workspaceId),
      child: _MembersView(
        workspaceId: workspaceId,
        workspaceName: workspaceName,
        isCurrentUserOwner: isCurrentUserOwner,
      ),
    );
  }
}

// ════════════════════════════════════════════════
// ROOT VIEW
// ════════════════════════════════════════════════
class _MembersView extends StatelessWidget {
  final int workspaceId;
  final String workspaceName;
  final bool isCurrentUserOwner;

  const _MembersView({
    required this.workspaceId,
    required this.workspaceName,
    required this.isCurrentUserOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F2FA),
      body: Stack(
        children: [
          // ── Background blobs ──
          Positioned(
            top: -60, right: -40,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.18),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: 100, left: -60,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.gradientBlue.withOpacity(0.12),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _Header(workspaceName: workspaceName),
                Expanded(
                  child: BlocBuilder<MembersCubit, MembersState>(
                    builder: (context, state) {
                      if (state is MembersLoading) return const _LoadingView();
                      if (state is MembersError) {
                        return _ErrorView(message: state.message);
                      }
                      if (state is MembersSuccess) {
                        if (state.members.isEmpty) {
                          return _EmptyView(
                            onInvite: isCurrentUserOwner
                                ? () => _showInviteSheet(context)
                                : null,
                          );
                        }
                        return _MembersList(
                          members: state.members,
                          workspaceId: workspaceId,
                          isCurrentUserOwner: isCurrentUserOwner,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Invite FAB is only visible to the Owner.
      floatingActionButton: isCurrentUserOwner
          ? Builder(
              builder: (ctx) => _InviteButton(
                onTap: () => _showInviteSheet(ctx),
              ),
            )
          : null,
    );
  }

  void _showInviteSheet(BuildContext context) {
    final cubit = context.read<MembersCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _InviteSheet(workspaceId: workspaceId),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// HEADER
// ════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final String workspaceName;
  const _Header({required this.workspaceName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFE6E1F5)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primary, size: 17),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(workspaceName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF15073A),
                      letterSpacing: -0.3,
                    ),
                    overflow: TextOverflow.ellipsis),
                Text('Team Members',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          // Member count badge
          BlocBuilder<MembersCubit, MembersState>(
            builder: (_, state) {
              if (state is! MembersSuccess) return const SizedBox();
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_alt_rounded,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 5),
                    Text('${state.members.length}',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// MEMBERS LIST
// ════════════════════════════════════════════════
class _MembersList extends StatelessWidget {
  final List<MemberModel> members;
  final int workspaceId;
  final bool isCurrentUserOwner;

  const _MembersList({
    required this.members,
    required this.workspaceId,
    required this.isCurrentUserOwner,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      itemCount: members.length,
      itemBuilder: (context, index) => _AnimatedCard(
        delay: Duration(milliseconds: index * 60),
        child: _MemberCard(
          member: members[index],
          workspaceId: workspaceId,
          index: index,
          isCurrentUserOwner: isCurrentUserOwner,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// ANIMATED CARD WRAPPER
// ════════════════════════════════════════════════
class _AnimatedCard extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _AnimatedCard({required this.child, required this.delay});

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _opacity = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      );
}

// ════════════════════════════════════════════════
// MEMBER CARD
// ════════════════════════════════════════════════
class _MemberCard extends StatelessWidget {
  final MemberModel member;
  final int workspaceId;
  final int index;

  /// When false the "Edit Permissions" button is completely hidden.
  /// A member cannot modify their own or others' permissions.
  final bool isCurrentUserOwner;

  const _MemberCard({
    required this.member,
    required this.workspaceId,
    required this.index,
    required this.isCurrentUserOwner,
  });

  static const _avatarGradients = [
    [Color(0xFF6C4AB6), Color(0xFF4A90E2)],
    [Color(0xFF1D9E75), Color(0xFF0D9488)],
    [Color(0xFFE11D8E), Color(0xFF7C3AED)],
    [Color(0xFFF59E0B), Color(0xFFEF4444)],
    [Color(0xFF0EA5E9), Color(0xFF6C4AB6)],
    [Color(0xFF059669), Color(0xFF0D9488)],
  ];

  List<Color> get _gradient =>
      _avatarGradients[index % _avatarGradients.length];

  String get _initials {
    final parts = member.fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return member.fullName.isNotEmpty
        ? member.fullName[0].toUpperCase()
        : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEAE6F4)),
        boxShadow: [
          BoxShadow(
            color: _gradient[0].withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // ── Avatar ──
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: _gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: _gradient[0].withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Center(
                child: Text(_initials,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
              ),
            ),
            const SizedBox(width: 14),

            // ── Info ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(member.fullName,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF15073A)),
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (member.isOwner) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0xFFFFD700),
                              Color(0xFFFF9500),
                            ]),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFFFFB300).withOpacity(0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2))
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Colors.white, size: 10),
                              const SizedBox(width: 3),
                              Text('Owner',
                                  style: GoogleFonts.poppins(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(member.email,
                      style: GoogleFonts.poppins(
                          fontSize: 11.5, color: AppColors.textMuted),
                      overflow: TextOverflow.ellipsis),
                  if (member.permissions.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _PermissionBadge(count: member.permissions.length),
                  ],
                ],
              ),
            ),

            // ── Edit Permissions button ──
            // Only visible when:
            //   1. The current user is the Owner (isCurrentUserOwner == true)
            //   2. The card doesn't belong to the Owner themselves (no point editing)
            if (isCurrentUserOwner && !member.isOwner)
              GestureDetector(
                onTap: () => context.push(
                  RouteNames.permissions,
                  extra: {
                    'workspaceId': workspaceId,
                    'userId': member.userId,
                    'permissions': member.permissions,
                    'canUserModify': isCurrentUserOwner, // always true here — only owner reaches this
                  },
                ),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      _gradient[0].withOpacity(0.12),
                      _gradient[1].withOpacity(0.12),
                    ]),
                    borderRadius: BorderRadius.circular(11),
                    border:
                        Border.all(color: _gradient[0].withOpacity(0.2)),
                  ),
                  child: Icon(Icons.tune_rounded,
                      color: _gradient[0], size: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PermissionBadge extends StatelessWidget {
  final int count;
  const _PermissionBadge({required this.count});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined,
                size: 11, color: AppColors.primary.withOpacity(0.8)),
            const SizedBox(width: 4),
            Text('$count permissions',
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ],
        ),
      );
}

// ════════════════════════════════════════════════
// INVITE SHEET  (Owner only — FAB is hidden for non-owners)
// ════════════════════════════════════════════════
class _InviteSheet extends StatefulWidget {
  final int workspaceId;
  const _InviteSheet({required this.workspaceId});

  @override
  State<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<_InviteSheet> {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  /// Default role for new members. Owner can change before sending.
  WorkspaceRole _selectedRole = WorkspaceRole.viewer;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _invite() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Enter an email address.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _error = 'Enter a valid email address.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    await context.read<MembersCubit>().addMember(
          widget.workspaceId,
          email,
          RolePermissionsMapper.map(_selectedRole),
        );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFE0DCF0),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),

          // Title row
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: const Icon(Icons.person_add_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invite Member',
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF15073A),
                          letterSpacing: -0.2)),
                  Text("They'll receive an email invite.",
                      style: GoogleFonts.poppins(
                          fontSize: 11.5, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Email ──
          Text('Email Address',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF15073A))),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F7FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _error != null
                    ? AppColors.error.withOpacity(0.5)
                    : AppColors.primary.withOpacity(0.2),
              ),
            ),
            child: TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              autofocus: true,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: const Color(0xFF15073A)),
              decoration: InputDecoration(
                hintText: 'member@example.com',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textHint),
                prefixIcon: Icon(Icons.email_outlined,
                    color: AppColors.primary.withOpacity(0.6), size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
              ),
              onSubmitted: (_) => _invite(),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: AppColors.error, size: 14),
                const SizedBox(width: 5),
                Text(_error!,
                    style: GoogleFonts.poppins(
                        fontSize: 11.5, color: AppColors.error)),
              ],
            ),
          ],
          const SizedBox(height: 20),

          // ── Role Selector ──
          Text('Member Role',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF15073A))),
          const SizedBox(height: 10),
          _InlineRolePicker(
            selected: _selectedRole,
            onChanged: (r) => setState(() => _selectedRole = r),
          ),
          const SizedBox(height: 20),

          // ── Submit ──
          GestureDetector(
            onTap: _isLoading ? null : _invite,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 52,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _isLoading
                    ? LinearGradient(
                        colors: [AppColors.grey, AppColors.grey])
                    : AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(15),
                boxShadow: _isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        )
                      ],
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded,
                              color: Colors.white, size: 17),
                          const SizedBox(width: 8),
                          Text('Send Invitation',
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
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

// ── Inline Role Picker ─────────────────────────────────────────────────────
// Compact horizontal selector used inside the invite sheet.
class _InlineRolePicker extends StatelessWidget {
  final WorkspaceRole selected;
  final ValueChanged<WorkspaceRole> onChanged;

  const _InlineRolePicker({
    required this.selected,
    required this.onChanged,
  });

  static const _roles = [
    (WorkspaceRole.viewer, 'Viewer', Icons.visibility_outlined, Color(0xFF6B7280)),
    (WorkspaceRole.editor, 'Editor', Icons.edit_outlined, Color(0xFF4A90E2)),
    (WorkspaceRole.admin, 'Admin', Icons.admin_panel_settings_outlined, Color(0xFF1D9E75)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _roles.map((r) {
        final isSelected = selected == r.$1;
        final color = r.$4;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: r.$1 != WorkspaceRole.admin ? 8 : 0),
            child: GestureDetector(
              onTap: () => onChanged(r.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.1) : const Color(0xFFF8F7FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : const Color(0xFFE8E4FF),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(r.$3,
                        color: isSelected ? color : AppColors.textMuted,
                        size: 18),
                    const SizedBox(height: 4),
                    Text(r.$2,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? color : AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ════════════════════════════════════════════════
// INVITE FAB
// ════════════════════════════════════════════════
class _InviteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _InviteButton({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 7))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_add_rounded,
                  color: Colors.white, size: 19),
              const SizedBox(width: 8),
              Text('Invite Member',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ],
          ),
        ),
      );
}

// ════════════════════════════════════════════════
// EMPTY STATE
// ════════════════════════════════════════════════
class _EmptyView extends StatelessWidget {
  /// Null when the current user is not the owner (no invite action available).
  final VoidCallback? onInvite;
  const _EmptyView({this.onInvite});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 28,
                      offset: const Offset(0, 10))
                ],
              ),
              child: const Icon(Icons.people_alt_rounded,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            Text('No Members Yet',
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF15073A),
                    letterSpacing: -0.4)),
            const SizedBox(height: 10),
            Text(
              'Invite your team members to start\ncollaborating in this workspace.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13.5, color: AppColors.textMuted, height: 1.6),
            ),
            if (onInvite != null) ...[
              const SizedBox(height: 30),
              GestureDetector(
                onTap: onInvite,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6))
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_add_rounded,
                          color: Colors.white, size: 18),
                      const SizedBox(width: 8),
                      Text('Invite First Member',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════
// LOADING VIEW (shimmer)
// ════════════════════════════════════════════════
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        itemCount: 4,
        itemBuilder: (_, i) => _ShimmerCard(index: i),
      );
}

class _ShimmerCard extends StatefulWidget {
  final int index;
  const _ShimmerCard({required this.index});

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 0.7)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFEAE6F4)),
          ),
          child: Row(
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(_anim.value),
                    borderRadius: BorderRadius.circular(16)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 13,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(_anim.value),
                            borderRadius: BorderRadius.circular(6))),
                    const SizedBox(height: 8),
                    Container(
                        height: 11,
                        width: 160,
                        decoration: BoxDecoration(
                            color:
                                Colors.grey.withOpacity(_anim.value * 0.7),
                            borderRadius: BorderRadius.circular(6))),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

// ════════════════════════════════════════════════
// ERROR VIEW
// ════════════════════════════════════════════════
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.error_outline_rounded,
                    color: AppColors.error, size: 30),
              ),
              const SizedBox(height: 16),
              Text('Oops!',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF15073A))),
              const SizedBox(height: 6),
              Text(message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textMuted)),
            ],
          ),
        ),
      );
}