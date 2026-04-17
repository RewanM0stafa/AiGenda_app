// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../config/dependency_injection.dart';
// import '../../../../config/routes/route_names.dart';
// import '../../logic/member_cubit/member_cubit.dart';
// import '../../logic/member_cubit/member_state.dart';

// class MembersScreen extends StatelessWidget {
//   final int workspaceId;
//   final String workspaceName;

//   const MembersScreen({
//     super.key,
//     required this.workspaceId,
//     required this.workspaceName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => getIt<MembersCubit>()..getMembers(workspaceId),
//       child: Builder( // 👈 ضفنا Builder هنا
//         builder: (context) { // الـ context ده دلوقتي يقدر يشوف الـ MembersCubit
//           return Scaffold(
//             appBar: AppBar(
//               title: Text(workspaceName),
//             ),
//             body: _MembersBody(workspaceId: workspaceId),
//             floatingActionButton: FloatingActionButton(
//               onPressed: () => _showAddMemberDialog(context, workspaceId),
//               child: const Icon(Icons.person_add),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// class _MembersBody extends StatelessWidget {
//   final int workspaceId;

//   const _MembersBody({required this.workspaceId});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<MembersCubit, MembersState>(
//       builder: (context, state) {
//         if (state is MembersLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (state is MembersError) {
//           return Center(child: Text(state.message));
//         }

//         if (state is MembersSuccess) {
//           if (state.members.isEmpty) {
//             return const Center(child: Text("No Members Yet"));
//           }

//           return ListView.builder(
//             itemCount: state.members.length,
//             itemBuilder: (_, index) {
//               final member = state.members[index];

//               return ListTile(
//                 title: Text(member.fullName),
//                 subtitle: Text(member.email),
//                 trailing: member.isOwner
//                     ? const Icon(Icons.star, color: Colors.amber)
//                     : IconButton(
//                   icon: const Icon(Icons.settings),
//                   onPressed: () {
//                     context.push(
//                       RouteNames.permissions,
//                       extra: {
//                         'workspaceId': workspaceId,
//                         'userId': member.userId,
//                         'permissions': member.permissions,
//                       },
//                     );                  },
//                 ),
//               );
//             },
//           );
//         }

//         return const SizedBox();
//       },
//     );
//   }
// }
// void _showAddMemberDialog(BuildContext parentContext, int workspaceId) {
//   final emailController = TextEditingController();

//   // 1. حفظنا الـ Cubit هنا في متغير
//   final membersCubit = parentContext.read<MembersCubit>();

//   showDialog(
//     context: parentContext,
//     builder: (dialogContext) {
//       return BlocProvider.value(
//         value: membersCubit,
//         child: AlertDialog(
//           title: const Text("Add Member"),
//           content: TextField(
//             controller: emailController,
//             decoration: const InputDecoration(labelText: "Email"),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 membersCubit.addMember(
//                   workspaceId,
//                   emailController.text,
//                 );

//                 Navigator.pop(dialogContext);
//               },
//               child: const Text("Add"),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/member_model.dart';
import '../../logic/member_cubit/member_cubit.dart';
import '../../logic/member_cubit/member_state.dart';

class MembersScreen extends StatelessWidget {
  final int workspaceId;
  final String workspaceName;

  const MembersScreen({
    super.key,
    required this.workspaceId,
    required this.workspaceName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MembersCubit>()..getMembers(workspaceId),
      child: _MembersView(
        workspaceId: workspaceId,
        workspaceName: workspaceName,
      ),
    );
  }
}

class _MembersView extends StatelessWidget {
  final int workspaceId;
  final String workspaceName;

  const _MembersView({
    required this.workspaceId,
    required this.workspaceName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<MembersCubit, MembersState>(
                builder: (context, state) {
                  if (state is MembersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                      ),
                    );
                  }
                  if (state is MembersError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: GoogleFonts.poppins(color: AppColors.error),
                      ),
                    );
                  }
                  if (state is MembersSuccess) {
                    if (state.members.isEmpty) {
                      return _EmptyMembers(
                        onInvite: () => _showAddMemberDialog(context),
                      );
                    }
                    return _MembersList(
                      members: state.members,
                      workspaceId: workspaceId,
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () => _showAddMemberDialog(context),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_add_outlined,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Invite Member',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
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
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workspaceName,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Team Members',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final cubit = context.read<MembersCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: _InviteMemberSheet(workspaceId: workspaceId),
      ),
    );
  }
}

// ── Members List ──
class _MembersList extends StatelessWidget {
  final List<MemberModel> members;
  final int workspaceId;

  const _MembersList({
    required this.members,
    required this.workspaceId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _MemberCard(
        member: members[index],
        workspaceId: workspaceId,
        index: index,
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final MemberModel member;
  final int workspaceId;
  final int index;

  const _MemberCard({
    required this.member,
    required this.workspaceId,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final initials = member.fullName.isNotEmpty
        ? member.fullName
            .trim()
            .split(' ')
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join()
        : '?';

    final avatarColors = [
      [const Color(0xFF6C4AB6), const Color(0xFF4A90E2)],
      [const Color(0xFF1D9E75), const Color(0xFF4A90E2)],
      [const Color(0xFFE11D8E), const Color(0xFF6C4AB6)],
      [const Color(0xFFF59E0B), const Color(0xFFE53935)],
    ];
    final colors = avatarColors[index % avatarColors.length];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        member.fullName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (member.isOwner) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFD97706), size: 10),
                            const SizedBox(width: 3),
                            Text(
                              'Owner',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFD97706),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.email,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '${member.permissions.length} permissions',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          if (!member.isOwner)
            GestureDetector(
              onTap: () => context.push(
                RouteNames.permissions,
                extra: {
                  'workspaceId': workspaceId,
                  'userId': member.userId,
                  'permissions': member.permissions,
                },
              ),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Invite Sheet ──
class _InviteMemberSheet extends StatefulWidget {
  final int workspaceId;
  const _InviteMemberSheet({required this.workspaceId});

  @override
  State<_InviteMemberSheet> createState() => _InviteMemberSheetState();
}

class _InviteMemberSheetState extends State<_InviteMemberSheet> {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 24,
        right: 24,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.cardBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_add_outlined,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                'Invite Member',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Email Address',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.poppins(
                fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'member@example.com',
              hintStyle: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textHint),
              prefixIcon: const Icon(Icons.email_outlined,
                  color: AppColors.textMuted, size: 20),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.15)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
                borderRadius: BorderRadius.circular(14),
                boxShadow: _isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Center(
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : Text(
                        'Send Invitation',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _invite() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    setState(() => _isLoading = true);
    await context
        .read<MembersCubit>()
        .addMember(widget.workspaceId, _emailCtrl.text.trim());
    if (mounted) Navigator.pop(context);
  }
}

// ── Empty Members ──
class _EmptyMembers extends StatelessWidget {
  final VoidCallback onInvite;
  const _EmptyMembers({required this.onInvite});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.people_outline_rounded,
                  color: Colors.white, size: 36),
            ),
            const SizedBox(height: 24),
            Text(
              'No Members Yet',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Invite your team members to start\ncollaborating on this workspace.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}