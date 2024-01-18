import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CornerChart extends StatelessWidget {
  // Custom data for demonstration
  final List<List<dynamic>> customData = [
    [0, 0],
    [2, 1],
    [1, 2],
    [3, 1],
    [2, 2],
    [1, 2],
    [2, 1],
    [0, 2],
    [1, 2],
    [2, 1],
  ];

  CornerChart({super.key});

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
                  width: 1,
                ),
              ),
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 3,
              lineBarsData: [
                LineChartBarData(
                  spots: _getSpots(0), // Use 0 as the column index for 'Brake'
                  isCurved: true,
                  colors: [Colors.blue],
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: true),
                ),
                LineChartBarData(
                  spots:
                      _getSpots(1), // Use 1 as the column index for 'Cornering'
                  isCurved: true,
                  colors: [Colors.red],
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
                'Brake',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Cornering',
                style: TextStyle(
                  color: Colors.red,
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

  List<FlSpot> _getSpots(int columnIndex) {
    return List.generate(
      customData.length,
      (index) {
        final dynamic value = customData[index][columnIndex];
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
    home: CornerChart(),
  ));
}
