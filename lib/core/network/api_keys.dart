class ApiKeys {
  // Response Keys
  static const String id =
      "id"; //  confirm change email send( id + newemail + code)
  static const String firstName = 'firstName';
  // auth files
  static const String lastName = 'lastName';
  static const String secondName = "secondName";
  static const String email = 'email';
  static const String token = 'token';
  static const String refreshToken = "refreshToken";
  static const String expiredIn = "expiredIn";
  static const String expiryDate = "expiryDate";
  static const String message = "message";

  // Backward compatibility لو عندك ملفات قديمة بتستخدم lastName

  // Request Keys
  static const String userId = "userId"; //  confirm email send(userId + code)
  static const String code = "code";

  static const String password = 'password';
  static const String confirmPassword = "confirmPassword";

  static const String currentPassword = "currentPassword";
  static const String newPassword = "newPassword";

  static const String newEmail = "newemail";
  static const String confirmEmailId = "id";

  static const String jobTitle = "jobTitle";
  static const String dateOfBirth = "dateOfBirth";

  static const String avatarUrl = "avatarUrl";

  // workspace
  //static const id = "id";
  static const name = "name";
  static const description = "description";
  static const iconCode = "iconCode";
  static const visibility = "visibility";
  static const numberOfMembers = "numberofMembers";
  static const numberOfTasks = "numberofTasks";
  static const numberOfSpaces = 'numberOfSpaces';

  static const isOwnedByCurrentUser = "isOwnedByCurrentUser";

  // workspace - dashboard
  static const totalSpaces = "totalSpaces";
  static const totalTasks = "totalTasks";
  static const totalMembers = "totalMembers";
  static const completedTasks = "completedTasks";
  static const inProgressTasks = "inProgressTasks";
  static const todoTasks = "todoTasks";


  // member
  static const fullName = "fullName";
  static const isOwner = "isOwner";
  static const joinedAt = "joinedAt";
  static const permissions = "permissions";
  static const String dashboard = 'dashboard';

  //  space
  static const String isPublic = 'isPublic';
  static const String workspaceId = 'workspaceId';
  static const String targetWorkspaceId = 'targetWorkspaceId';

  // task
  static const String title = 'title';
  static const String priority = 'priority';
  static const String dueDate = 'dueDate';
  static const String status = 'status';
  static const String assignees = 'assignees';
  static const String spaceId = 'spaceId';

  // subtask
  static const String isCompleted = 'isCompleted';
  static const String subTaskId = 'subTaskId';
  static const String subTasks = 'subTasks';

  // filter
  static const String pageNumber = 'PageNumber';
  static const String pageSize = 'PageSize';
  static const String searchValue = 'SearchValue';
  static const String sortColumn = 'SortColumn';
  static const String sortOrder = 'SortOrder';

  // paginated _ response احتمال يتغيروا ع ما أعرف ال
  static const String items = 'items';
  static const String totalCount = 'totalCount';
  static const String hasNextPage = 'hasNextPage';
  static const String hasPreviousPage = 'hasPreviousPage';
}
