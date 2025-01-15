// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
//
// import '../../model/vacation.dart';
// import '../days/cubit/day_off_cubit.dart';
//
// Widget buildScatterChart(DayOffCubit cubit) {
//   final scatterData = cubit.getScatterData(cubit.dayOff);
//
//   return SfCartesianChart(
//     primaryXAxis: const CategoryAxis(
//       title: AxisTitle(text: 'نوع الإجازة'),
//     ),
//     primaryYAxis: const CategoryAxis(
//       title: AxisTitle(text: 'الشهر'),
//     ),
//     series: <ScatterSeries<VacationData, String>>[
//       ScatterSeries<VacationData, String>(
//         dataSource: scatterData,
//         xValueMapper: (VacationData data, _) => data.type,
//         yValueMapper: (VacationData data, _) => num.parse(data.month),
//         pointColorMapper: (VacationData data, _) => getColorForType(data.type),
//         markerSettings: const MarkerSettings(
//           isVisible: true,
//           shape: DataMarkerType.circle,
//           borderWidth: 2,
//           borderColor: Colors.black,
//         ),
//         dataLabelSettings: DataLabelSettings(
//           isVisible: true,
//           builder: (dynamic data, ChartPoint<dynamic> point, ChartSeries<dynamic, dynamic> series, int pointIndex, int seriesIndex) {
//             return Text('${data.numDays} أيام');
//           },
//         ),      ),
//     ],
//   );
// }
//
// Color getColorForType(String type) {
//   switch (type) {
//     case 'إعتيادي':
//       return Colors.blue;
//     case 'بدل':
//       return Colors.green;
//     case 'عارضة':
//       return Colors.orange;
//     default:
//       return Colors.grey;
//   }
// }