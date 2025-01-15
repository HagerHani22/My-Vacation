
abstract class ClockPermissionState {}

class ClockPermissionInitial extends ClockPermissionState {}

class ClockCreateDatabaseState extends ClockPermissionState {}
class ClockInsertDatabaseState extends ClockPermissionState {}
class ClockInsertDatabaseErrorState extends ClockPermissionState {}
class ClockGetDatabaseState extends ClockPermissionState {}
class ClockGetDatabaseErrorState extends ClockPermissionState {}

class ChangeBottomSheetState extends ClockPermissionState {}

class DeleteDataFromDatabase extends ClockPermissionState {}