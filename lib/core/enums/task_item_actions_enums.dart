enum TaskItemActionsEnums {

  markAsRead(name: "Mark As Done"),
  edit(name: "Edit"),
  delete(name: "Delete");

  final String name;

  const TaskItemActionsEnums({required this.name});
}
