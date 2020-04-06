import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartImpl extends StatelessWidget {
  final Map<String, double> dataMap;
  final Color textColor;

  PieChartImpl({this.textColor, this.dataMap, Key key}) : super(key: key);

  final List<Color> colorList = [
    Colors.blue[600],
    Colors.green[600],
    Colors.red[600],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: PieChart(
          legendStyle: textColor != null
              ? TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: textColor)
              : TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32.0,
          chartRadius: MediaQuery.of(context).size.width / 2.7,
          showChartValuesInPercentage: true,
          showChartValues: true,
          showChartValuesOutside: true,
          chartValueBackgroundColor: Colors.grey[200],
          colorList: colorList,
          showLegends: true,
          legendPosition: LegendPosition.top,
          decimalPlaces: 1,
          showChartValueLabel: true,
          initialAngle: 0,
          chartValueStyle: defaultChartValueStyle.copyWith(
            color: Colors.grey[900],
          ),
          chartType: ChartType.disc,
        ),
      ),
    );
  }
}
