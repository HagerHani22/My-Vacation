
abstract class DayOffState {}

class DayOffInitial extends DayOffState {}

class DayOffCreateDatabaseState extends DayOffState {}
class DayOffInsertDatabaseState extends DayOffState {}
class DayOffInsertDatabaseErrorState extends DayOffState {}
class DayOffGetDatabaseState extends DayOffState {}
class DayOffGetDatabaseErrorState extends DayOffState {}

class ChangeBottomSheetState extends DayOffState {}
class ChangeCheckBoxState extends DayOffState {}

class DeleteDataFromDatabase extends DayOffState {}

class DayOffTotalDaysUpdatedState extends DayOffState {}
class DeductionDaysState extends DayOffState {}


class DayOffGetDataForMonthState extends DayOffState {}

