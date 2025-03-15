import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vacation/modules/attendance/states.dart';

class AttendeCubits extends Cubit<AttendeStates> {
  AttendeCubits() : super(AttendanceInitialState());
  static AttendeCubits get(context) => BlocProvider.of(context);

  Database? database;
  List<Map> theAtende = [];

  void createDatabase() async {
    await openDatabase(
      'theAtendance.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database.execute(
            'CREATE TABLE theAtende(id INTEGER PRIMARY KEY ,date TEXT,attendeTime TEXT,departureTime TEXT)')
            .then((value) {
          print('table created');
        });
      },
      onOpen: (database) {
        print('database openad');
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      print(value);
      emit(AttendanceCreateDatabase());
    });
  }

  String currentTime = '';
  String currentTimeDeparture = '';
  String currentDate = '';

  Future insertToDatabase({
    required String? name,
    required String? date,
    String? attendeTime,
    String? departureTime,
  }) async {
    await database?.transaction((txn) async {
      DateTime now = DateTime.now();
      String currentTime = DateFormat('HH:mm:ss').format(now);
      String currentTimeDeparture = '';
      String currentDate = DateFormat('yyyy-MM-dd').format(now);
      await txn
          .rawInsert(
          'INSERT INTO theAtende(date,attendeTime,departureTime)VALUES("$currentDate","$currentTime","$currentTimeDeparture")')
          .then((value) {
        print('$value inserted successfully');
        emit(AttendanceinsertToDatabase());
        getDataFromDatabase(database);
      });
      return null;
    });
  }
  Future updateToDatabase() async {
    await database?.transaction((txn) async {
      DateTime now = DateTime.now();
      int id =theAtende.last['id'];
      String currentTimeDeparture = DateFormat('HH:mm:ss').format(now);
      await txn
          .rawUpdate('''UPDATE theAtende SET departureTime= ? WHERE id= ?''',[currentTimeDeparture,id])
          .then((value) {
        print('$value Update successfully');
        emit(AttendanceUpdateDatabase());
        getDataFromDatabase(database);
      });
      return null;
    });
  }

  void getDataFromDatabase(database) async {
    theAtende = [];
    await database!.rawQuery('SELECT * FROM theAtende').then((value) {
      theAtende = value;
      print(value);
      emit(AttendancegetDataFromDatabase());
    });
  }


  void deleteData({ int ?id}) {
    database?.rawDelete(
      'DELETE FROM theAtende WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AttendanceDeleteDataFromDatabase());
    });
  }

  void deleteAllData() {
    database?.rawDelete(
        'DELETE FROM theAtende'
    ).then((value) {
      getDataFromDatabase(database);
      emit(AttendanceDeleteAllDataFromDatabase());
    });
  }


  Future<void> showAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('حذف كل بيانات الجدول؟',style: TextStyle(color: Colors.red),),
          content: const Text('عند الضغط علي حذف سيتم حذف كل البيانات',style:TextStyle(fontSize: 20,) ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                  deleteAllData();
                  Navigator.of(context).pop();
                  },
              child:  Text('حذف',style: TextStyle(color: HexColor('#E74C3C'),fontSize: 18,fontWeight: FontWeight.bold)),
            ),
          ],

        );

      },
    );
  }


  Future<void> showAlertDialogForRow(BuildContext context,model) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!',style: TextStyle(color: Colors.red),),
          content: Text('Are you sure you want to delete this row?',style:TextStyle(fontSize: 20,)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',style: TextStyle(color: Colors.black,fontSize: 17)),
            ),
            TextButton(
              onPressed: () {
                deleteData(id: model['id']);
                Navigator.of(context).pop();
              },
              child: Text('OK',style: TextStyle(color: Colors.black,fontSize: 17)),
            ),
          ],
        );
      },
    );
  }
}
