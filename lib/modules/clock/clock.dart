import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import '../../layout/startpage.dart';
import '../../shared/components/reusable_components.dart';
import '../../shared/constant/constant.dart';
import 'cubit/clock_permission_cubit.dart';
import 'cubit/clock_permission_state.dart';

class ClockPermission extends StatefulWidget {
  const ClockPermission({super.key});

  @override
  State<ClockPermission> createState() => _ClockPermissionState();
}

class _ClockPermissionState extends State<ClockPermission> {
  late ClockPermissionCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = ClockPermissionCubit.get(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cubit.totalLoggedHours >= 2) {
        showAlertDialogForWarning(context: context);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClockPermissionCubit, ClockPermissionState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ClockPermissionCubit.get(context);
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            key: cubit.scaffoldKey,
            appBar: AppBar(
              leading: IconButton(onPressed: () {Navigator.pop(context);},
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white,)),
              title: const Text(
                'إذن الساعتين',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only( right: 8.0, left: 8.0, bottom: 70, top: 8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DataTable(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            columns: const [
                              DataColumn(label: Flexible(child: Center(child: Text('م')))),
                              DataColumn(label: Flexible(child: Center(child: Text('التاريخ'))),),
                              DataColumn(label: Flexible(child: Center(child: Text('الوقت'))),),
                              DataColumn(label: Flexible(child: Center(child: Text('عدد الساعات'))),),
                              DataColumn(label: Flexible(child: Center(child: Text('حذف'))),),
                            ],
                            rows: cubit.clock.map((model) {
                              return DataRow(cells: [
                                DataCell(Center(child: Text('${model['id']}'))),
                                DataCell(Text('${model['date']}')),
                                DataCell(Center(child: Text('${model['time']}',))),
                                DataCell(Center(child: Text('${model['numHours']}'))),
                                DataCell(Center(child: IconButton(
                                        onPressed: () {
                                          showAlertDialogForRow(context: context,date: model['date'] ,onTap:(){
                                            cubit.deleteData(id: model['id']);
                                            Navigator.pop(context);
                                          });                                      },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )))),
                              ]);
                            }).toList(),
                            columnSpacing: 5,
                            dataRowMaxHeight: 44,
                            dataRowMinHeight: 20,
                            horizontalMargin: 0,

                            // headingRowColor: MaterialStateProperty.all(
                            //   Colors.cyan
                            // ),
                            headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: kPrimaryColor),
                            dataTextStyle: const TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                            ),
                            // border: const TableBorder(
                            //   verticalInside:BorderSide(strokeAlign: 5,color: Colors.grey)
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (cubit.formKey.currentState!.validate()) {

                      final selectedDate = DateFormat.yMMMEd('ar').parse(cubit.dateController.text);

                      if (selectedDate.isBefore(cubit.startOfMonthCycle) || selectedDate.isAfter(cubit.endOfMonthCycle)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('التاريخ المحدد خارج الدورة الشهرية')),
                        );
                        return;
                      }

                      final selectedHours = cubit.dropdownValue == 'ساعه' ? 1 : 2;

                      if (cubit.totalLoggedHours + selectedHours > 2) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('لقد قمت بتسجيل الحد الأقصى للساعات المسموح بها هذا الشهر')),
                        );
                        return;
                      }
                      cubit.insertToDatabase(
                        date: cubit.dateController.text,
                        time: cubit.timeController.text,
                        numHours: cubit.dropdownValue!,
                      );
                      Navigator.pop(context);
                      cubit.dateController.clear();
                      cubit.timeController.clear();
                      cubit.dropdownValue = null;
                    }
                  } else {
                    cubit.scaffoldKey.currentState
                        ?.showBottomSheet((context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.32,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 30.0),
                                  child: Form(
                                    key: cubit.formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: defaultFormField(
                                                  controller:
                                                      cubit.dateController,
                                                  label: 'التاريخ',
                                                  validate: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'أضف التاريخ';
                                                    }
                                                    return null;
                                                  },
                                                  prefix: Icons.date_range,
                                                  color: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  onTap: () {
                                                    showDatePicker(
                                                            context: context,
                                                            firstDate:
                                                                DateTime.parse('2024-12-21'),
                                                            initialDate: DateTime.now(),
                                                            lastDate: DateTime.parse('2099-01-21'))
                                                        .then((value) {
                                                      log(DateFormat.yMMMEd().format(value!));
                                                      cubit.dateController.text = DateFormat.yMMMEd('ar').format(value);
                                                    });
                                                  }),
                                            ),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.02),
                                            Expanded(
                                              child: defaultFormField(
                                                  controller:
                                                      cubit.timeController,
                                                  type: TextInputType.datetime,
                                                  label: 'الوقت',
                                                  validate: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'اضف الوقت';
                                                    }
                                                    return null;
                                                  },
                                                  prefix:
                                                      Icons.access_time_outlined,
                                                  color: Colors.white,
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  onTap: () {
                                                    showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay.now(),
                                                    ).then((value) {
                                                      if (value != null) {
                                                        log(value.format(context));
                                                        cubit.timeController.text = value.format(context);
                                                      }
                                                    });
                                                  }),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                        SizedBox(width: MediaQuery.of(context).size.width * .45,
                                          child: DropdownButtonFormField(
                                            isExpanded: true,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                            dropdownColor: Colors.grey[200],
                                            validator: (value) {
                                              if (value == null) {
                                                return 'هذا الحقل فارغ';
                                              }
                                              return null;
                                            },
                                            value: cubit.dropdownValue,
                                            onChanged: (String? newValue) {
                                              // setState(() {
                                              cubit.dropdownValue = newValue!;
                                              // });
                                            },
                                            hint: const Text('اختر عدد الساعات'),
                                            items: <String>['ساعه', 'ساعتين']
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    color: HexColor('#2C3E50'),
                                                  ),
                                                  child: TextButton(
                                                      onPressed: () {
                                                        if (cubit.formKey.currentState!.validate()) {
                                                          final selectedDate = DateFormat.yMMMEd('ar').parse(cubit.dateController.text);

                                                          if (selectedDate.isBefore(cubit.startOfMonthCycle) || selectedDate.isAfter(cubit.endOfMonthCycle)) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(content: Text('التاريخ المحدد خارج الدورة الشهرية')),
                                                            );
                                                            return;
                                                          }

                                                          final selectedHours = cubit.dropdownValue == 'ساعه' ? 1 : 2;

                                                          if (cubit.totalLoggedHours + selectedHours > 2) {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              const SnackBar(content: Text('لقد قمت بتسجيل الحد الأقصى للساعات المسموح بها هذا الشهر')),
                                                            );
                                                            return;
                                                          }
                                                          cubit.insertToDatabase(
                                                            date: cubit.dateController.text,
                                                            time: cubit.timeController.text,
                                                            numHours: cubit.dropdownValue!,
                                                          );
                                                          Navigator.pop(context);
                                                          cubit.dateController.clear();
                                                          cubit.timeController.clear();
                                                          cubit.dropdownValue = null;
                                                        }
                                                      },
                                                      child: const Text(
                                                        'حفظ',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.white,
                                                        ),
                                                      ))),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(isShow: false);
                    });
                    cubit.changeBottomSheetState(isShow: true);
                  }
                },
                child: const Icon(Icons.add)),

          ),
        );
      },
    );
  }
}


Future<void> showAlertDialogForWarning({
  required BuildContext context,
}) async {
  return  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title:  Column(
          children: [
            Icon(Icons.warning,color: HexColor('#E74C3C'),size: 50),
            Center(child: Text('تنبيه',style: TextStyle(color: HexColor('#E74C3C'),fontSize: 24,fontWeight: FontWeight.bold))),
          ],
        ),
        content: const Text('لقد قمت بتسجيل الحد الأقصى للساعات المسموح بها هذا الشهر'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child:  const Text('حسناً',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}