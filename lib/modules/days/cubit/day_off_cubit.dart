import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../substitute_day/cubit/sub_day_cubit.dart';
import 'day_off_state.dart';

class DayOffCubit extends Cubit<DayOffState> {
  DayOffCubit() : super(DayOffInitial());

  static DayOffCubit get(context) => BlocProvider.of(context);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var dateController = TextEditingController();
  var typeController = TextEditingController();
  var numDaysController = TextEditingController();
  String? vacationTypeDropdownValue;
  bool isBottomSheetShown = false;
  bool? isChecked  = false;
  List<Map> dayOff = [];
  List<String> vacationType = ['بدل', 'إعتيادي', 'عارضة'];


  final monthOrder =
  [' ', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر', ' '];





  Database? database;
  void createDatabase() async {
    await openDatabase(
      'DayOff.db',
      version: 1,
      onCreate: (database, version) {
        log('database created');
        database
            .execute(
                'CREATE TABLE DayOff (id INTEGER PRIMARY KEY, type TEXT,date TEXT,numDays INTEGER)')
            .then((value) {
          log('table created');
        }).catchError((error) {
          log('error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        log('database opened');
        database = database;
      },
    ).then((value) {
      database = value;
      getDataFromDatabase();
      emit(DayOffCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String date,
    required String type,
    required String numDays,
  }) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO DayOff(date,type,numDays) VALUES("$date","$type","$numDays") ')
          .then((value) {
        log('$value inserted successfully');
        getDataFromDatabase();
        emit(DayOffInsertDatabaseState());
      }).catchError((error) {
        log('Error when inserting new row ${error.toString()}');
        emit(DayOffInsertDatabaseErrorState());
      });
      return null;
    });
  }

  Future<void> getDataFromDatabase() async {
    dayOff = [];
    await database!.rawQuery('SELECT * FROM DayOff').then((value) {
      dayOff = value;
      emit(DayOffGetDatabaseState());
    }).catchError((error) {
      log('error when getting data from database ${error.toString()}');
      emit(DayOffGetDatabaseErrorState());
    });
  }

  void deleteData({int? id}) {
    database?.rawDelete(
      'DELETE FROM DayOff WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase();
      emit(DeleteDataFromDatabase());
    });
  }

  void changeBottomSheetState({
    required bool isShow,
  }) {
    isBottomSheetShown = isShow;
    emit(ChangeBottomSheetState());
  }
  void checkboxState({
    required bool checked,
  }) {
    isChecked  = checked;
    emit(ChangeCheckBoxState());
  }

  Map<String, int> totalDaysForType = {
    'عارضة': 6,
    'إعتيادي': 15,
  };

  void updateTotalDaysForType(BuildContext context) {
    int substituteDays = SubstituteDayCubit.get(context).subDay.length;
    totalDaysForType['بدل'] = substituteDays ;
    emit(DayOffTotalDaysUpdatedState());
  }

  double getRemainingDaysForType(String type) {
    num totalDaysForCurrentType = totalDaysForType[type] ?? 0;

    double usedDaysForType = dayOff.where((item) => item['type'] == type).fold(0, (sum, item) {
      double numDays = double.tryParse(item['numDays'].toString()) ?? 0;
      return sum + numDays;
    });

    return totalDaysForCurrentType - usedDaysForType;
  }

  double get totalRemainingDays {
    double usedDays = dayOff.fold(0, (sum, item) {
      double numDays = double.tryParse(item['numDays'].toString()) ?? 0;
      return sum + numDays;
    });

    double totalRemainingDays = totalDaysForType.values.fold(0, (sum, totalDays) {
          return sum + totalDays;
        }) -
        usedDays;

    return totalRemainingDays;
  }

  double tokenDaysForType(String type) {

    double usedDaysForType = dayOff.where((item) => item['type'] == type).fold(0, (sum, item) {
      double numDays = double.tryParse(item['numDays'].toString()) ?? 0;
      return sum + numDays;
    });

    return usedDaysForType;
  }

  double get TotalTakenDays {
    double usedDays = dayOff.fold(0, (sum, item) {
      double numDays = double.tryParse(item['numDays'].toString()) ?? 0;
      return sum + numDays;
    });

        usedDays;

    return usedDays;
  }

  double deductionDays(String type) {

    double usedDaysForType = dayOff.where((item) => item['type'] == 'بالخصم').fold(0, (sum, item) {
      double numDays = double.tryParse(item['numDays'].toString()) ?? 0;
      return sum + numDays;
    });

    return usedDaysForType;

  }


}
