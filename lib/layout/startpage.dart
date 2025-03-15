import 'package:flutter/material.dart';
import 'package:vacation/modules/clock/clock.dart';
import 'package:vacation/modules/dashboard/dashboard.dart';
import 'package:vacation/modules/days/day_off.dart';
import 'package:vacation/modules/public%20vac/public_vac.dart';
import 'package:vacation/shared/assets/assets.dart';
import 'package:vacation/shared/constant/constant.dart';
import '../modules/attendance/attendance_screen.dart';
import '../modules/substitute_day/sub_day.dart';
import '../shared/components/reusable_components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              Image(image: const AssetImage(AssetsPaths.homePage), fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height*0.29,
                width: MediaQuery.of(context).size.width,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only( left: 16.0, right: 16.0,top:35, bottom: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: buildStartCard(text: 'تسجيل الاجازات', color: Colors.white, image:AssetsPaths.holidays ,onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const VacationDays()));
                              })),
                              const SizedBox(width: 20),
                              Expanded(child: buildStartCard(text: 'تسجيل البدلات', color: Colors.white,image:AssetsPaths.substitute ,onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SubstituteDay()));
                              })),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(child: buildStartCard(text: 'إذن ساعتين', color: Colors.white, image:AssetsPaths.clock,onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const ClockPermission()));
                              } )),
                              const SizedBox(width: 20),
                              Expanded(child: buildStartCard(text: 'حضور و إنصراف', color: Colors.white,image:AssetsPaths.attendance,onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceScreen()));
                              } )),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                style:  TextButton.styleFrom(backgroundColor: kPrimaryColor),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const PublicVacation()));
                                }, child: const Text("الأجازات الرسمية ",style: TextStyle(color: Colors.white),),),
                              TextButton(
                                style:  TextButton.styleFrom(backgroundColor: kPrimaryColor),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  const Dashboard()));
                                }, child: const Text(" تفاصيل الأجازات ",style: TextStyle(color: Colors.white),),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

      ),
    );
  }

}
