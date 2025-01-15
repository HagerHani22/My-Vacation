import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'clock_permission_state.dart';

class ClockPermissionCubit extends Cubit<ClockPermissionState> {
  ClockPermissionCubit() : super(ClockPermissionInitial());

  static ClockPermissionCubit get(context) => BlocProvider.of(context);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var numHoursController = TextEditingController();
  String? dropdownValue;
  bool isBottomSheetShown = false;


  List<Map> clock = [];

  Database? database;
  void createDatabase() async {
    await openDatabase(
      'clock.db',
      version: 1,
      onCreate: (database, version) {
        log('database created');
        database.execute(
                'CREATE TABLE clock (id INTEGER PRIMARY KEY, time TEXT,date TEXT,numHours TEXT)'
        ).then((value) {
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
      emit(ClockCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String date,
    required String time,
    required String numHours,
  }) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert('INSERT INTO clock(date,time,numHours) VALUES("$date","$time","$numHours") ')
          .then((value) {
        log('$value inserted successfully');
        getDataFromDatabase();
        emit(ClockInsertDatabaseState());
      }).catchError((error) {
        log('Error when inserting new row ${error.toString()}');
        emit(ClockInsertDatabaseErrorState());
      });
      return null;
    });
  }

  Future<void> getDataFromDatabase() async {
    clock =[];
     await database!.rawQuery('SELECT * FROM clock').then((value) {
       clock = value;
       emit(ClockGetDatabaseState());
     })
     .catchError((error) {
       log('error when getting data from database ${error.toString()}');
       emit(ClockGetDatabaseErrorState());
     });
  }

  void deleteData({ int ?id}) {
    database?.rawDelete(
      'DELETE FROM clock WHERE id = ?',
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
  int getTotalLoggedHoursForCycle(DateTime start, DateTime end) {
    final logs = clock.where((log) {
      final logDate = DateFormat.yMMMEd('ar').parse(log['date']);
      return logDate.isAfter(start) && logDate.isBefore(end);
    }).toList();

    return logs.fold<int>(0, (total, log) {
      int hours = 0;
      if (log['numHours'] == 'ساعه') {
        hours = 1;
      } else if (log['numHours'] == 'ساعتين') {
        hours = 2;
      }

      return total + hours;
    });
  }



  final currentMonth = DateTime.now().month - 1;
  final currentYear = DateTime.now().year;

  DateTime get startOfMonthCycle => DateTime(currentYear, currentMonth, 21);
  DateTime get endOfMonthCycle => DateTime(currentMonth == 12 ? currentYear + 1 : currentYear, currentMonth % 12 + 1, 20);

  int get totalLoggedHours => getTotalLoggedHoursForCycle(startOfMonthCycle, endOfMonthCycle);







}
