//import 'package:conditional_builder/conditional_builder.dart';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_apps/component/components.dart';
import 'package:flutter_apps/component/constant.dart';

import 'package:flutter_apps/shared/cubit/cubit.dart';
import 'package:flutter_apps/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppState state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screen[cubit.currentIndex],
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isbuttomSheetshow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
//                     insertToDatabase(
//                         title: titleController.text,
//                         time: timeController.text,
//                         date: dateController.text)
//                         .then((value) {
//                       getDataFromDatabase(database).then((value) {
//
// // setState(() {
// //
// //   isbuttomSheetshow = false;
// //   setState(() {
// //     fabIcon = Icons.edit;
// //   });
// // tasks = value;
// // print(tasks);
// //  });
//                       });
//                     });
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                defaultFormFile(
                                    controller: titleController,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                    lable: 'Task Title',
                                    prefix: Icons.title,
                                    type: TextInputType.text),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormFile(
                                    controller: timeController,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                        print(value.format(context));
                                      });
                                    },
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    lable: 'Task Time',
                                    prefix: Icons.watch_later_outlined,
                                    type: TextInputType.datetime),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultFormFile(
                                    controller: dateController,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-09-29'),
                                      ).then((value) {
//       print(DateFormat.yMMMd().format(value));
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    lable: 'Task Date',
                                    prefix: Icons.calendar_today,
                                    type: TextInputType.datetime),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20,
                      )
                      .closed
                      .then((value) {
                    cubit.ChangeBottomSheetState(
                      isshow: false,
                      icon: Icons.edit,
                    );
                    //   cubit.isbuttomSheetshow = false;
                    //   setState(() {
                    //     fabIcon = Icons.edit;
                    //   });
                  });
                  cubit.ChangeBottomSheetState(
                    isshow: true,
                    icon: Icons.add,
                  );
                  // cubit.isbuttomSheetshow = true;
                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
                print(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }

//
// Future<String> getName() async {
//   return 'saeed bark';
// }

// create database and table
}
