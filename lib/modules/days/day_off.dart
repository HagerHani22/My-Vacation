import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../shared/components/reusable_components.dart';
import 'cubit/day_off_cubit.dart';
import 'cubit/day_off_state.dart';

class VacationDays extends StatefulWidget {
  const VacationDays({super.key});

  @override
  State<VacationDays> createState() => _VacationDaysState();
}

class _VacationDaysState extends State<VacationDays> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DayOffCubit, DayOffState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = DayOffCubit.get(context);
        cubit.updateTotalDaysForType(context);

        return Scaffold(
          key: cubit.scaffoldKey,
          appBar: AppBar(
            leading: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
            title: const Text('تسجيل الاجازات',style: TextStyle(color: Colors.white),),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only( right: 8.0, left: 8.0, bottom: 70, top: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      defaultCard(text: 'المتبقي إعتيادي', function: cubit.getRemainingDaysForType('إعتيادي'), context: context,),
                      defaultCard( text: 'المتبقي عارضة', function: cubit.getRemainingDaysForType('عارضة'), context: context, ),
                      defaultCard( text: 'المتبقي بدل',function: cubit.getRemainingDaysForType('بدل') , context: context, ),
                      defaultCard(text: 'المجموع', function: cubit.totalRemainingDays, context: context, ),
                    ],
                  ),
                  // SizedBox(height:MediaQuery.of(context).size.height*0.01),
                  // Divider(
                  //   thickness: 2,
                  //   indent: 10,
                  //   endIndent: 10,
                  //   color: HexColor('#ECF0F1'),),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //
                  //   children: [
                  //     defaultCard(text: 'المستنفد إعتيادي', function: cubit.tokenDaysForType('إعتيادي'), context: context),
                  //     defaultCard( text: 'المستنفد عارضة', function: cubit.tokenDaysForType('عارضة'), context: context),
                  //     defaultCard( text: 'المستنفد بدل',function: cubit.tokenDaysForType('بدل') , context: context),
                  //     defaultCard(text: 'المجموع', function: cubit.TotalTakenDays, context: context),
                  //   ],
                  // ),
                  // SizedBox(height:MediaQuery.of(context).size.height*0.01),
                  Divider(
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                    color: HexColor('#ECF0F1'),),
                  Row(
                    children: [
                      Expanded(
                        child: DataTable(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          columns: const [
                            DataColumn(
                              label: Flexible(child: Center(child: Text('م'))),
                            ),
                            DataColumn(
                              label: Flexible(child: Center(child: Text('التاريخ'))),
                            ),
                            DataColumn(
                              label: Flexible(child: Text('عدد الايام')),
                            ),
                            DataColumn(
                              label: Flexible(child: Center(child: Text('نوع الأجازة'))),
                            ),
                            DataColumn(
                              label: Flexible(child: Center(child: Text('حذف'))),
                            ),

                          ],
                          rows: cubit.dayOff.map((model) {
                            return DataRow(
                                color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                                  return (model['type'] == 'بالخصم') ? Colors.red.withOpacity(0.1) : null;
                                }),
                                cells: [
                              DataCell(Center(child: Text('${model['id']}'))),
                              DataCell(Center(child: Text('${model['date']}'))),
                              DataCell(Center(child: Text('${model['numDays']}'))),
                              DataCell(Center(child: Text('${model['type']}',style: TextStyle(
                                color: (model['type'] == 'بالخصم') ? Colors.red : HexColor('#2C3E50'),
                              ),))),
                              DataCell(Center(child: IconButton(onPressed: () {
                                showAlertDialogForRow(context: context,date: model['date'] ,onTap:(){
                                  cubit.deleteData(id: model['id']);
                                  Navigator.pop(context);
                                });
                            }, icon: const Icon(Icons.delete,color: Colors.red,)))),
                            ]);

                          }).toList(),
                          columnSpacing: 5,
                          dataRowMaxHeight: 44,
                          dataRowMinHeight: 20,
                          horizontalMargin: 0,

                          // headingRowColor: MaterialStateProperty.all(
                          //   Colors.cyan
                          // ),
                          headingTextStyle:  TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                          color: HexColor('#2C3E50')),
                          dataTextStyle:  TextStyle(
                            color: HexColor('#2C3E50'),
                            fontSize: 16,
                          ),

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
              if(cubit.isBottomSheetShown){
                if(cubit.getRemainingDaysForType('بدل')>0||cubit.getRemainingDaysForType('عارضة')>0||cubit.getRemainingDaysForType('إعتيادي')>0){
                  if(cubit.formKey.currentState!.validate()){
                    cubit.insertToDatabase(
                      date: cubit.dateController.text,
                      type: cubit.vacationTypeDropdownValue!,
                      numDays: cubit.numDaysController.text,
                    );
                    Navigator.pop(context);
                    cubit.dateController.clear();
                    cubit.numDaysController.clear();
                    cubit.vacationTypeDropdownValue = null;
                  }
                }else{
                  if(cubit.isChecked!){
                    if(cubit.isBottomSheetShown){
                      if(cubit.formKey.currentState!.validate()){
                        cubit.insertToDatabase(
                          date: cubit.dateController.text,
                          type: cubit.vacationTypeDropdownValue='بالخصم',
                          numDays: cubit.numDaysController.text,
                        );
                        Navigator.pop(context);
                        cubit.dateController.clear();
                        cubit.numDaysController.clear();
                        cubit.vacationTypeDropdownValue = null;
                      }}
                  }
                }
              }

                else{
                  cubit.scaffoldKey.currentState?.showBottomSheet(
                          (context) => SizedBox(
                        height: MediaQuery.of(context).size.height*0.32,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 30.0),
                            child: Form(
                              key: cubit.formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: defaultFormField(
                                            controller: cubit.dateController,
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
                                                borderRadius: BorderRadius.circular(10)),
                                            onTap: () {
                                              showDatePicker(
                                                  context: context,
                                                  firstDate: DateTime.parse('2024-12-21'),
                                                  initialDate: DateTime.now(),
                                                  lastDate: DateTime.parse('2099-01-21'))
                                                  .then((value) {
                                                if (value != null) {
                                                  log(DateFormat.yMMMEd('ar').format(value));
                                                  cubit.dateController.text =
                                                      DateFormat.yMMMEd('ar').format(value);
                                                }

                                              });
                                            }),
                                      ),
                                      SizedBox(width: MediaQuery.of(context).size.width*0.02),
                                      Expanded(
                                        child: defaultFormField(
                                            controller: cubit.numDaysController,
                                            type: TextInputType.number,
                                            label: 'عدد الايام',
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return 'اضف عدد الايام';
                                              }
                                              if (value.startsWith('.')) {
                                                value = '0$value';
                                              }
                                              if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                                                return 'الرجاء إدخال عدد صحيح أو\n عشري باستخدام النقطة فقط';
                                              }
                                              if (cubit.vacationType.contains(cubit.vacationTypeDropdownValue)) {
                                                num remainingDaysForType = DayOffCubit.get(context)
                                                    .getRemainingDaysForType(cubit.vacationTypeDropdownValue!);

                                                double enteredDays = double.tryParse(value) ?? 0.0;

                                                if (enteredDays > remainingDaysForType) {
                                                  return 'عدد الأيام لا يمكن أن يتجاوز \n$remainingDaysForType';
                                                }
                                              }

                                              return null;
                                            },
                                            prefix: Icons.add_card,
                                            color: Colors.white,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10)),
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01),

                                  cubit.getRemainingDaysForType('بدل')>0||cubit.getRemainingDaysForType('عارضة')>0||cubit.getRemainingDaysForType('إعتيادي')>0?
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*.45,
                                    child: DropdownButtonFormField(
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      dropdownColor: Colors.grey[200],
                                      validator: (value) {
                                        if(cubit.getRemainingDaysForType('بدل')>0||cubit.getRemainingDaysForType('عارضة')>0||cubit.getRemainingDaysForType('إعتيادي')>0){
                                        if(value == null ){
                                            return 'هذا الحقل فارغ';
                                        }}
                                        return null;
                                      },
                                      value: (cubit.vacationTypeDropdownValue != null &&
                                          (cubit.vacationType.where((type) =>
                                          cubit.getRemainingDaysForType(type) > 0))
                                              .contains(cubit.vacationTypeDropdownValue))
                                          ? cubit.vacationTypeDropdownValue
                                          : null,
                                      onChanged: (String? newValue) {
                                        cubit.vacationTypeDropdownValue = newValue!;
                                      },
                                      hint: const Text('اختر نوع الأجازة'),
                                      items:(cubit.vacationType.where((type) =>
                                      DayOffCubit.get(context).getRemainingDaysForType(type) > 0))
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  )
                            :BlocBuilder<DayOffCubit, DayOffState>(
                                  builder: (context, state) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            const Text(' *',
                                              style: TextStyle(fontSize: 24.0, color: Colors.red),
                                            ),
                                            const Text('لا يوجد أجازات متبقية الأجازة هتكون بالخصم',
                                              style: TextStyle(fontSize: 17.0),
                                            ),
                                            Checkbox(
                                              value: cubit.isChecked,
                                              onChanged: (bool? newValue) {
                                                if (newValue != null) {
                                                  cubit.checkboxState(checked: newValue);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        cubit.isChecked == false
                                            ? const Center(
                                              child: Text(
                                                    'يجب الموافقة على الشروط',
                                                    style: TextStyle(color: Colors.red, fontSize: 14),
                                                 ),
                                            )
                                            : Container()
                                      ],
                                    );
                                              },
                                            ),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: HexColor('#2C3E50'),
                                            ),
                                            child: TextButton(
                                                onPressed: () {
                                                  if(cubit.getRemainingDaysForType('بدل')>0||cubit.getRemainingDaysForType('عارضة')>0||cubit.getRemainingDaysForType('إعتيادي')>0){
                                                    if(cubit.formKey.currentState!.validate()){
                                                      cubit.insertToDatabase(
                                                        date: cubit.dateController.text,
                                                        type: cubit.vacationTypeDropdownValue!,
                                                        numDays: cubit.numDaysController.text,
                                                      );
                                                      Navigator.pop(context);
                                                      cubit.dateController.clear();
                                                      cubit.numDaysController.clear();
                                                      cubit.vacationTypeDropdownValue = null;
                                                    }
                                                  }else{
                                                    if(cubit.isChecked!){
                                                      if(cubit.isBottomSheetShown){
                                                        if(cubit.formKey.currentState!.validate()){
                                                          cubit.insertToDatabase(
                                                            date: cubit.dateController.text,
                                                            type: cubit.vacationTypeDropdownValue='بالخصم',
                                                            numDays: cubit.numDaysController.text,
                                                          );
                                                          Navigator.pop(context);
                                                          cubit.dateController.clear();
                                                          cubit.numDaysController.clear();
                                                          cubit.vacationTypeDropdownValue = null;
                                                        }}
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                  'حفظ',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color:Colors.white,
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
                      )
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(isShow: false);
                  });
                  cubit.changeBottomSheetState(isShow: true);
                }

              },
              child: const Icon(Icons.add)
          ),
          // floatingActionButtonLocation:  FloatingActionButtonLocation.endDocked,

        );
      },
    );
  }
}

