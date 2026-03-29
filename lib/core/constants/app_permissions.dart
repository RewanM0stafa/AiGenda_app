class AppPermissions {
  // Workspaces
  static const workspacesAdd = "workspaces:add";
  static const workspacesRead = "workspaces:read";
  static const workspacesUpdate = "workspaces:update";
  static const workspacesDelete = "workspaces:delete";

  // Spaces
  static const spacesAdd = "spaces:add";
  static const spacesRead = "spaces:read";
  static const spacesUpdate = "spaces:update";
  static const spacesDelete = "spaces:delete";

  // Tasks
  static const tasksAdd = "tasks:add";
  static const tasksRead = "tasks:read";
  static const tasksUpdate = "tasks:update";
  static const tasksDelete = "tasks:delete";

  // Notes
  static const notesAdd = "notes:add";
  static const notesRead = "notes:read";
  static const notesUpdate = "notes:update";
  static const notesDelete = "notes:delete";

  static const all = [
    spacesAdd,
    spacesUpdate,
    spacesDelete,
    tasksAdd,
    tasksUpdate,
    tasksDelete,
    notesAdd,
    notesUpdate,
    notesDelete,
  ];
}