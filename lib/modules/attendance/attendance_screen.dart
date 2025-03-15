import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:vacation/modules/attendance/states.dart';
import '../../shared/components/reusable_components.dart';
import '../../shared/constant/constant.dart';
import 'cubit.dart';

var nameController = TextEditingController();
var formKey = GlobalKey<FormState>();

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendeCubits, AttendeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AttendeCubits cubit = AttendeCubits.get(context);
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.landscapeLeft,
        //   DeviceOrientation.landscapeRight,
        // ]);
        return Scaffold(
            appBar: AppBar(
              backgroundColor:kPrimaryColor,
              leading:  IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),

              ),
              title: const Text(
                'تسجيل الحضور والإنصراف',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // TextFormField(
                      //   controller: namecontroller,
                      //   keyboardType: TextInputType.name,
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15),
                      //     ),
                      //     labelText: 'Your Name',
                      //     prefixIcon: Icon(Icons.title),
                      //   ),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Enter Your Name';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                // color: HexColor('3d8069'),
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  if (cubit.theAtende.isEmpty) {
                                    cubit.insertToDatabase(
                                      name: nameController.text,
                                      date: cubit.currentDate,
                                      attendeTime: cubit.currentTime,
                                    );
                                  } else if (cubit.theAtende.last['date'] !=
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now())) {
                                    cubit.insertToDatabase(
                                      name: nameController.text,
                                      date: cubit.currentDate,
                                      attendeTime: cubit.currentTime,
                                    );
                                  }
                                },
                                child: Text('حضور',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color:kPrimaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  if (cubit.theAtende.last['departureTime'] == '') {
                                    cubit.updateToDatabase();
                                  }
                                },
                                child: Text('انصراف',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  cubit.showAlertDialog(context);
                                },
                                child: Text('مسح الجدول',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            // color: HexColor('fbead5'),
                            color: kPrimaryLightColor,
                          ),
                          columns: const [
                            DataColumn(
                              label: Text('رقم'),
                            ),
                            DataColumn(
                              label: Text('التاريخ'),
                            ),
                            DataColumn(
                              label: Text('وقت الحضور'),
                            ),
                            DataColumn(
                              label: Text('وقت الانصراف'),
                            ),
                            DataColumn(
                              label: Text('مسح'),
                            ),
                          ],
                          rows: cubit.theAtende.map((model) {
                            return DataRow(
                                cells: [
                              DataCell(Text('${model['id']}')),
                              DataCell(Text('${model['date']}')),
                              DataCell(Text('${model['attendeTime']}',
                                style: TextStyle(
                                    color: DateFormat('HH:mm:ss')
                                        .parse(model['attendeTime'])
                                        .minute >15 && DateFormat('HH:mm:ss')
                                        .parse(model['attendeTime']).hour >= 8
                                        ? Colors.red
                                        : Colors.black
                                ),
                              )),
                              DataCell(Text('${model['departureTime']}')),
                              DataCell(IconButton(
                                onPressed: () {
                                  showAlertDialogForRow(context: context,date: model['date'] ,onTap:(){
                                    cubit.deleteData(id: model['id']);
                                    Navigator.pop(context);
                                  });                                 },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )),
                            ]);
                          },
                          ).toList(),
                          dataRowMaxHeight: 40,
                          columnSpacing: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
// Function to show the AlertDialog




