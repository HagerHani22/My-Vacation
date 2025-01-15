import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'sub_day_state.dart';

class SubstituteDayCubit extends Cubit<SubstituteDayState> {
  SubstituteDayCubit() : super(SubDayInitial());

  static SubstituteDayCubit get(context) => BlocProvider.of(context);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var dateController = TextEditingController();
  var noteController = TextEditingController();
  bool isBottomSheetShown = false;

  List<Map> subDay = [];

  Database? database;
  void createDatabase() async {
    await openDatabase(
      'SubDay.db',
      version: 1,
      onCreate: (database, version) {
        log('database created');
        database.execute(
                'CREATE TABLE SubDay (id INTEGER PRIMARY KEY,date TEXT, note TEXT)'
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
      emit(SubDayCreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String date,
    required String note,
  }) async {
    await database?.transaction((txn) async {

      await txn
          .rawInsert('INSERT INTO SubDay(date,note) VALUES("$date","$note") ')
          .then((value) {
        log('$value inserted successfully');
        getDataFromDatabase();
        emit(SubDayInsertDatabaseState());
      }).catchError((error) {
        log('Error when inserting new row ${error.toString()}');
        emit(SubDayInsertDatabaseErrorState());
      });
      return null;
    });
  }

  Future<void> getDataFromDatabase() async {
    subDay =[];
     await database!.rawQuery('SELECT * FROM SubDay').then((value) {
       subDay = value;
       emit(SubDayGetDatabaseState());
     })
     .catchError((error) {
       log('error when getting data from database ${error.toString()}');
       emit(SubDayGetDatabaseErrorState());
     });
  }

  void deleteData({ int ?id}) {
    database?.rawDelete(
      'DELETE FROM SubDay WHERE id = ?',
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

}
