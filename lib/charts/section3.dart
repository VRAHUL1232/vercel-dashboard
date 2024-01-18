import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LineChartWidget extends StatelessWidget {
  // Custom data for demonstration
  final List<List<dynamic>> customData = [
    [0, 0],
    [3, 1],
    [1, 2],
    [6, 1],
    [2, 2],
    [7, 0],
    [3, 1],
    [9, 2],
    [5, 2],
    [4, 1],
  ];

  LineChartWidget({super.key});

  double findMaxValue(List<List<dynamic>> data, int columnIndex) {
    return data
        .map<double>((row) => double.tryParse('${row[columnIndex]}') ?? 0)
        .reduce((max, value) => value > max ? value : max);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth*0.25,
      height: screenHeight*0.2,
      child: Stack(
        children: [
          LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(show: true),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: const Color.fromARGB(0, 255, 255, 255),
                  width: 2,
                ),
              ),
              minX: 0,
              maxX: findMaxValue(customData, 0) + 1,
              minY: 0,
              maxY: 10,
              lineBarsData: [
                LineChartBarData(
                  spots: _getSpots(),
                  isCurved: true,
                  colors: [Colors.blue],
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: true),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Acceleration',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getSpots() {
    return List.generate(
      customData.length,
      (index) {
        final dynamic value = customData[index][0];
        try {
          final double parsedValue = double.parse('$value');
          return FlSpot(index.toDouble(), parsedValue);
        } catch (e) {
          // ignore: avoid_print
          print('Error parsing value at index $index: $e');
          return FlSpot(index.toDouble(), 0);
        }
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LineChartWidget(),
  ));
}
