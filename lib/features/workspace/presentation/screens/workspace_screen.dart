
import 'package:ajenda_app/features/profile/presentation/profile_widgets/shared_profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/dependency_injection.dart';
import '../../../../config/routes/route_names.dart';
import '../../logic/workspace_cubit/workspace_cubit.dart';
import '../../logic/workspace_cubit/workspace_state.dart';

class WorkspacesScreen extends StatelessWidget {
  const WorkspacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WorkspaceCubit>()..getWorkspaces(),
      child: Builder(
          builder: (newContext) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Workspaces"),
              ),
              body: const _WorkspacesBody(),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showCreateWorkspaceDialog(newContext),
                child: const Icon(Icons.add),
              ),
            );
          }
      ),
    );
  }
}

class _WorkspacesBody extends StatelessWidget {
  const _WorkspacesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceCubit, WorkspaceState>(
      builder: (context, state) {
        if (state is WorkspaceLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is WorkspaceError) {
          return Center(child: Text(state.message));
        }

        if (state is WorkspaceSuccess) {
          if (state.workspaces.isEmpty) {
            return const Center(child: Text("No Workspaces Yet"));
          }

          return ListView.builder(
            itemCount: state.workspaces.length,
            itemBuilder: (_, index) {
              final workspace = state.workspaces[index];

              return ListTile(
                title: Text(workspace.name),
                subtitle: Text(workspace.description),
                trailing: workspace.isOwnedByCurrentUser
                    ? const Icon(Icons.star, color: Colors.amber)
                    : null,
                onTap: () {
                  context.push(
                    RouteNames.members,
                    extra: {
                      'workspaceId': workspace.id,
                      'workspaceName': workspace.name,
                    },
                  );
                },
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
void _showCreateWorkspaceDialog(BuildContext context) {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final iconController = TextEditingController();

  final cubit = context.read<WorkspaceCubit>();

  showDialog(
    context: context,
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: Builder(
          builder: (dialogContext) {
            return AlertDialog(
              title: const Text("Create Workspace"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(onTap: () => context.pop(), child: backBtn()),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  TextField(
                    controller: iconController,
                    decoration: const InputDecoration(
                      labelText: "Icon Code (e.g. #1234)",
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {

                    dialogContext.read<WorkspaceCubit>().createWorkspace(
                      name: nameController.text,
                      description: descController.text,
                      iconCode: iconController.text.isNotEmpty ? iconController.text : "#0000",
                      visibility: 1,
                    );

                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Create"),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}




