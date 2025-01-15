import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../shared/components/reusable_components.dart';
import '../days/cubit/day_off_cubit.dart';
import '../days/cubit/day_off_state.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Color> colorList = [
    const Color(0xFF939185),
    const Color(0xffE6B9A6),
    const Color(0xffEEEDEB),
  ];
  List<String> vacationType = [' ','بدل', 'إعتيادي', 'عارضة',' '];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DayOffCubit, DayOffState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = DayOffCubit.get(context);
        cubit.updateTotalDaysForType(context);
        cubit.deductionDays('بالخصم');

        final scatterData = prepareScatterChartData(cubit);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                )),
            title: const Text(
              'تفاصيل الاجازات',
            ),
          ),
          body: SingleChildScrollView(
            child: Column(

              children: [
                defaultPieChart(
                  context: context,
                  colorList: colorList,
                  cubit: cubit,
                  data: DayOffCubit.get(context).totalDaysForType.map(
                          (key, value) =>
                          MapEntry(key, cubit.getRemainingDaysForType(key))),
                ),
                const Text(
                  'عدد الايام المتبقية',
                  style: TextStyle(
                      color: Color(0xFF213555),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey[400],
                ),
                defaultPieChart(
                  context: context,
                  colorList: colorList,
                  cubit: cubit,
                  data: DayOffCubit.get(context).totalDaysForType.map(
                          (key, value) => MapEntry(key, cubit.tokenDaysForType(key))),
                ),
                const Text(
                  'عدد الايام المستنفدة',
                  style: TextStyle(
                      color: Color(0xFF213555),
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey[400],
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.01,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'عدد الأجازات بالخصم : ',
                      style: TextStyle(
                          color: Color(0xFF213555),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      '${cubit.deductionDays('بالخصم')}',
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                const Text(
                  "مخطط يوضح عددد الأيام المستنفده خلال كل شهر ",
                  style: TextStyle( color: Color(0xFF213555),fontWeight: FontWeight.bold,fontSize: 18),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                const Text('* قم بالضغط علي النقط داخل المخطط لعرض التفاصيل',style: TextStyle(fontSize: 12,color: Colors.red,),),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                buildScatterChart(scatterData,cubit),
              ],
            ),
          ),
        );
      },
    );
  }

  // Prepare scatter chart data
  List<ScatterSpot> prepareScatterChartData(DayOffCubit cubit) {
    final scatterData = <ScatterSpot>[];
    final vacationTypes = vacationType;

    for (var type in vacationTypes) {
      final vacations = cubit.dayOff.where((item) => item['type'] == type).toList();
      final monthCounts = <String, double>{}; // Store total days per month

      for (var vacation in vacations) {
        final date = vacation['date'] as String;
        final month = DateFormat('MMMM', 'ar').format(DateFormat.yMMMEd('ar').parse(date));
        final numDays = double.tryParse(vacation['numDays'].toString()) ?? 0.0;

        monthCounts[month] = (monthCounts[month] ?? 0) + numDays;
      }

      for (var entry in monthCounts.entries) {
        final monthIndex = cubit.monthOrder.indexOf(entry.key);
        final typeIndex = vacationTypes.indexOf(type);
        if (monthIndex >= 0 && typeIndex >= 0){
          scatterData.add(ScatterSpot(
            typeIndex.toDouble(),
            monthIndex.toDouble(),
            // dotPainter:  FlDotCirclePainter(
            //   radius: 8, // Use total days as the radius
            //   color: colorList[typeIndex % colorList.length],
            // ),
          ));

        }
      }
    }

    return scatterData;
  }








  // Build scatter chart
  Widget buildScatterChart(List<ScatterSpot> scatterData, DayOffCubit cubit) {
    return SizedBox(
      height: 300,
      width: 330,
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: scatterData,
          minX: 0,
          maxX: vacationType.length.toDouble() - 1,
          minY:  0,
          maxY: cubit.monthOrder.length.toDouble() - 1,
          borderData: FlBorderData(show: true),
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < cubit.monthOrder.length) {
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                       cubit. monthOrder[value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                interval: 1,
                reservedSize: 50,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < vacationType.length) {
                    return FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        vacationType[value.toInt()],
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
                interval: 1,
                reservedSize: 50,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          scatterTouchData: ScatterTouchData(
            enabled: true,
            longPressDuration: Duration.zero ,
            touchTooltipData: ScatterTouchTooltipData(
              getTooltipItems: (ScatterSpot spot) {
                final type = vacationType[spot.x.toInt()];
                final month = cubit.monthOrder[spot.y.toInt()];
                final totalDays = cubit.dayOff
                    .where((item) =>
                item['type'] == type &&
                    DateFormat('MMMM', 'ar')
                        .format(DateFormat.yMMMEd('ar').parse(item['date']))
                        .toString() ==
                        month)
                    .map((item) => double.tryParse(item['numDays'].toString()) ?? 0.0)
                    .fold(0.0, (prev, curr) => prev + curr);

                return ScatterTooltipItem(
                  '$type\n$month: $totalDays أيام',
                  textStyle: const TextStyle(color: Colors.white),
                );
              },
            ),


          ),
        ),
      ),
    );
  }
}







