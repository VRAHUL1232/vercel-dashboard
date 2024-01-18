import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Steer extends StatefulWidget {
  const Steer({Key? key}) : super(key: key);

  @override
  _SteerState createState() => _SteerState();
}

class _SteerState extends State<Steer> {
  // Custom data for demonstration
  List<List<dynamic>> customData = [
    ['Brake', 'Steering Position'],
    [0, 0],
    [1, 17],
    [2, 19],
    [3, 14],
    [2, 18],
    [0, 09],
    [2, 16],
    [4, 4],
    [2, 14],
    [2, 22],
  ];

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
                    color: const Color.fromARGB(0, 255, 255, 255), width: 4),
              ),
              minX: 0,
              maxX: 10,
              minY: 0,
              maxY: 20, // Adjust the max value as needed
              lineBarsData: [
                LineChartBarData(
                  spots: _getSpots(0),
                  isCurved: true,
                  colors: [Colors.blue],
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: true),
                ),
                LineChartBarData(
                  spots: _getSpots(1),
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
                '1/4 th ofSteering Position ',
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
      customData.length - 1,
      (index) {
        final dynamic value = customData[index + 1][columnIndex];
        try {
          final double parsedValue = double.tryParse('$value') ?? 0;
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
  runApp(const MaterialApp(
    home: Steer(),
  ));
}
