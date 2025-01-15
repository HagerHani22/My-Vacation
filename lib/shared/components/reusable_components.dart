
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../modules/days/cubit/day_off_cubit.dart';




Widget defaultFormField({
  required TextEditingController controller,
   TextInputType? type,
  onTap,
  validate,
  onChange,
  String? label,
  String? hintText,
  IconData? prefix,
  String? value,
  IconData? suffix,
  Function()? suffixPressed,
  InputBorder ?border,
  Color? color,
  submit,
}) =>
    TextFormField(
      onFieldSubmitted: submit,
      initialValue: value,
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      onChanged: onChange,
      validator: validate,
      textAlign:  TextAlign.right,
      decoration: InputDecoration(
        fillColor: color,
        filled: true,
        labelText: label,
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(prefix),
        ),
        suffixIcon: IconButton(onPressed: suffixPressed, icon: Icon(suffix)),

        border: border,
      ),
    );



Widget defaultCard(
    {
      required context,
      required String text,
      required double function,
    })
{
  return SizedBox(
    width: MediaQuery.of(context).size.width*0.23,
    height: MediaQuery.of(context).size.height*0.12,
    child: Card(
      // color: HexColor('#ECF0F1'),
      child: Padding(
        padding: const EdgeInsets.all( 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('$text:  $function', style:function<0 ? const TextStyle(fontWeight: FontWeight.bold,color:Colors.red) :  TextStyle(fontWeight: FontWeight.bold,color:HexColor('#2C3E50') ),),
          ],
        ),
      ),
    ),
  );
}



Widget buildStartCard({
  required String text,
  required Color color,
  required String image,
  required VoidCallback onTap
}) {
  return Builder(
    builder: (context) {
      return GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: MediaQuery.of(context).size.width* 0.2,
          height: MediaQuery.of(context).size.height*0.21,
          child: Card(
            // color: HexColor('#ECF0F1'),
            child: Center(
              child: Column(
                children: [
                   SizedBox(height: MediaQuery.of(context).size.height*0.03),
                  Image(image: AssetImage(image),width: 60, height: 60),
                   SizedBox(height: MediaQuery.of(context).size.height*0.02),
                  Text(
                    text,
                    style: TextStyle(
                      color: color == Colors.black ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  );
}




Future<void> showAlertDialogForRow({
  required BuildContext context,
  required VoidCallback onTap,
  required String date,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text('حذف هذا اليوم؟',style: TextStyle(color: HexColor('#E74C3C'),fontSize: 20,fontWeight: FontWeight.bold),)),
        content:  Text('عند الضغط علي حذف سيتم حذف يوم \n  $date نهائيا! ',style:const TextStyle(fontSize: 16,)),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('إلغاء',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: onTap,
            child:  Text('حذف',style: TextStyle(color: HexColor('#E74C3C'),fontSize: 18,fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}




Widget defaultPieChart({
  required BuildContext context,
  required DayOffCubit cubit,
  required List<Color> colorList,
  required Map<String, double> data,
}){
  return Center(
    child: PieChart(
        // Pass in the data for
        // the pie chart
        dataMap: data,
        // Set the colors for the
        // pie chart segments
        colorList: colorList,
        // Set the radius of the pie chart
        chartRadius: MediaQuery.of(context).size.width / 2.5,
        ringStrokeWidth: 20,
        // Set the animation duration of the pie chart
        animationDuration: const Duration(seconds: 3),
        // Set the options for the chart values (e.g. show percentages, etc.)
        chartValuesOptions: const ChartValuesOptions(
            showChartValues: true,
            showChartValuesOutside: false,
            showChartValuesInPercentage: false,
            chartValueStyle: TextStyle(color: Color(0xFF213555), fontWeight: FontWeight.bold, fontSize: 15),
            showChartValueBackground: false),
        // Set the options for the legend of the pie chart
        legendOptions:  const LegendOptions(
            showLegends: true,
            legendShape: BoxShape.rectangle,
            legendTextStyle: TextStyle(fontSize: 15, color: Color(0xFF213555)),
            legendPosition: LegendPosition.left,
            showLegendsInRow: false),
        // Set the list of gradients for
        // the background of the pie chart
      ),
  );
}

