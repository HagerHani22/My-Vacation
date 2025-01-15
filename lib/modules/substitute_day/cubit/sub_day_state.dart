
abstract class SubstituteDayState {}

class SubDayInitial extends SubstituteDayState {}

class SubDayCreateDatabaseState extends SubstituteDayState {}
class SubDayInsertDatabaseState extends SubstituteDayState {}
class SubDayInsertDatabaseErrorState extends SubstituteDayState {}
class SubDayGetDatabaseState extends SubstituteDayState {}
class SubDayGetDatabaseErrorState extends SubstituteDayState {}

class ChangeBottomSheetState extends SubstituteDayState {}

class DeleteDataFromDatabase extends SubstituteDayState {}