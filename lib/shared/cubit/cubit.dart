import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_apps/modules/todo_app/archived_tasks/archivedTask.dart';
import 'package:flutter_apps/modules/todo_app/done_tasks/doneTask.dart';
import 'package:flutter_apps/modules/todo_app/new_tasks/newTask.dart';
import 'package:flutter_apps/shared/network/local/cache_helper.dart';

import 'package:flutter_apps/shared/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  late Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screen = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNabBarState());
  }

  void createDatabase() {
    openDatabase(
      'todo_app.db',
      version: 1,
      onCreate: (database, version) {
        print('database created ');
        database
            .execute(
                'CREATE TABLE tasks( id INTEGER PRIMARY KEY, title TEXT , date TEXT , time TEXT , status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when Creating Table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreatDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn)  {
     return txn
          .rawInsert(
              'INSERT INTO tasks (title,date,time,status)VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value insert successful');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('Error when insert ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else
          archiveTasks.add(element);
      });

      emit(AppGetDatabaseState());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
      'UPDATE tasks SET status = ?  WHERE id = ?',
      ['$status  ', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isbuttomSheetshow = false;
  IconData fabIcon = Icons.edit;

  void ChangeBottomSheetState({required bool isshow, required IconData icon}) {
    isbuttomSheetshow = isshow;
    fabIcon = icon;
    emit(AppChangeSheetState());
  }

  bool isDark = false;
  void changeAppMode(/*{bool fromShared }*/) {
    // if(fromShared != null)
    //   isDark = fromShared;
    // else
    isDark = !isDark;
    // isDark = !isDark;
    // CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
    //   emit(AppChangeModeState());
    // });
    emit(AppChangeModeState());
  }
}
