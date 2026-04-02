import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../config/routes/route_names.dart';
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
      child: Builder( // 👈 ضفنا Builder هنا
        builder: (context) { // الـ context ده دلوقتي يقدر يشوف الـ MembersCubit
          return Scaffold(
            appBar: AppBar(
              title: Text(workspaceName),
            ),
            body: _MembersBody(workspaceId: workspaceId),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddMemberDialog(context, workspaceId),
              child: const Icon(Icons.person_add),
            ),
          );
        },
      ),
    );
  }
}


class _MembersBody extends StatelessWidget {
  final int workspaceId;

  const _MembersBody({required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembersCubit, MembersState>(
      builder: (context, state) {
        if (state is MembersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MembersError) {
          return Center(child: Text(state.message));
        }

        if (state is MembersSuccess) {
          if (state.members.isEmpty) {
            return const Center(child: Text("No Members Yet"));
          }

          return ListView.builder(
            itemCount: state.members.length,
            itemBuilder: (_, index) {
              final member = state.members[index];

              return ListTile(
                title: Text(member.fullName),
                subtitle: Text(member.email),
                trailing: member.isOwner
                    ? const Icon(Icons.star, color: Colors.amber)
                    : IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    context.push(
                      RouteNames.permissions,
                      extra: {
                        'workspaceId': workspaceId,
                        'userId': member.userId,
                        'permissions': member.permissions,
                      },
                    );                  },
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
void _showAddMemberDialog(BuildContext parentContext, int workspaceId) {
  final emailController = TextEditingController();

  // 1. حفظنا الـ Cubit هنا في متغير
  final membersCubit = parentContext.read<MembersCubit>();

  showDialog(
    context: parentContext,
    builder: (dialogContext) {
      return BlocProvider.value(
        value: membersCubit,
        child: AlertDialog(
          title: const Text("Add Member"),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                membersCubit.addMember(
                  workspaceId,
                  emailController.text,
                );

                Navigator.pop(dialogContext);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      );
    },
  );
}