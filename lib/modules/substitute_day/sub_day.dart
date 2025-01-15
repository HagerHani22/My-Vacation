import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../../shared/components/reusable_components.dart';
import '../days/cubit/day_off_cubit.dart';
import 'cubit/sub_day_cubit.dart';
import 'cubit/sub_day_state.dart';

class SubstituteDay extends StatelessWidget {
  const SubstituteDay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubstituteDayCubit, SubstituteDayState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = SubstituteDayCubit.get(context);
        DayOffCubit.get(context).updateTotalDaysForType(context);

        return Scaffold(
          key: cubit.scaffoldKey,
          appBar: AppBar(
            leading: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,)),
            title: const Text('تسجيل البدلات',style: TextStyle(color: Colors.white),),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only( right: 8.0, left: 8.0, bottom: 20, top: 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: defaultCard( text: 'المتبقي بدل',function:  DayOffCubit.get(context).getRemainingDaysForType('بدل') , context: context)),
                      Expanded(child: defaultCard( text: 'المستنفد بدل',function:  DayOffCubit.get(context).tokenDaysForType('بدل') , context: context)),
                    ],
                  ),
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
                            DataColumn(label: Flexible(child: Center(child: Text('م'))),),
                            DataColumn(label: Flexible(child: Center(child: Text('التاريخ'))),),
                            DataColumn(label: Flexible(child: Center(child: Text('ملاحظة'))),),
                            DataColumn(label: Flexible(child: Center(child: Text('حذف'))),),
                          ],
                          rows: cubit.subDay.map((model) {
                            return DataRow(cells: [
                              DataCell(Center(child: Text('${model['id']}'))),
                              DataCell(Text('${model['date']}')),
                              DataCell(Text('${model['note']}',)),
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
                          // border: const TableBorder(
                          //     verticalInside:BorderSide(strokeAlign: 5,color: Colors.grey)
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
                if(cubit.isBottomSheetShown){
                  if(cubit.formKey.currentState!.validate()){
                    cubit.insertToDatabase(
                      date: cubit.dateController.text,
                      note: cubit.noteController.text,
                    );
                    Navigator.pop(context);
                    cubit.dateController.clear();
                    cubit.noteController.clear();
                  }                }else{
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
                                                log(DateFormat.yMMMEd('ar').format(value!));
                                                cubit.dateController.text =
                                                    DateFormat.yMMMEd('ar').format(value);
                                              });
                                            }),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: defaultFormField(
                                          // ispassword: false,

                                          controller: cubit.noteController,
                                          type: TextInputType.text,
                                          hintText: 'أضف ملاحظة',
                                          prefix: Icons.add_comment_sharp,
                                          color: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10)),
                                          validate: (value) {
                                            if (value!.isEmpty) {
                                              return 'اضف ملاحظتك';
                                            }
                                            return null;
                                          },

                                        ),
                                      ),
                                    ],
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
                                                  if(cubit.formKey.currentState!.validate()){
                                                    cubit.insertToDatabase(
                                                      date: cubit.dateController.text,
                                                      note: cubit.noteController.text,
                                                    );
                                                    Navigator.pop(context);
                                                    cubit.dateController.clear();
                                                    cubit.noteController.clear();
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

        );
      },
    );
  }
}
