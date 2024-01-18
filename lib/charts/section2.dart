import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BrakeChart extends StatefulWidget {
  const BrakeChart({Key? key}) : super(key: key);

  @override
  _BrakeChartState createState() => _BrakeChartState();
}

class _BrakeChartState extends State<BrakeChart> {
  // Custom data for demonstration
  List<List<dynamic>> customData = [
    ['Acceleration', 'Cornering'],
    [0, 0],
    [2, 1],
    [3, 2],
    [3, 1],
    [2, 2],
    [3, 0],
    [0, 1],
    [2, 2],
    [3, 2],
    [2, 1],
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
                  spots: _getSpots(0), // Acceleration (index 0)
                  isCurved: true,
                  colors: [const Color.fromARGB(255, 243, 145, 33)],
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: true),
                ),
                LineChartBarData(
                  spots: _getSpots(1), // Cornering (index 1)
                  isCurved: true,
                  colors: [Color.fromARGB(255, 0, 179, 255)],
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: true),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Acceleration',
                style: TextStyle(
                  color: Color.fromARGB(255, 243, 145, 33),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Cornering',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 179, 255),
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

          // Display a point for the raw values
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
