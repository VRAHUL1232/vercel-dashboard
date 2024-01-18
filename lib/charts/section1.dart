import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Brac extends StatefulWidget {
  const Brac({Key? key}) : super(key: key);

  @override
  _BracState createState() => _BracState();
}

class _BracState extends State<Brac> {
  List<FlSpot> accelerationSpots = [];
  List<FlSpot> brakeSpots = [];

  @override
  void initState() {
    super.initState();
    _generateSampleData();
  }

  void _generateSampleData() {
    // Sample data for acceleration and brake variables
    List<double> accelerationData = [0, 1, 2, 1, 3, 0, 3, 2, 2, 1];
    List<double> brakeData = [0, 1, 2, 3, 1, 3, 2, 1, 0, 1];

    // Create FlSpot objects for acceleration
    accelerationSpots = List.generate(
      accelerationData.length,
      (index) => FlSpot(index.toDouble(), accelerationData[index]),
    );

    // Create FlSpot objects for brake
    brakeSpots = List.generate(
      brakeData.length,
      (index) => FlSpot(index.toDouble(), brakeData[index]),
    );
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
              maxY: 4,
              lineBarsData: [
                LineChartBarData(
                  spots: accelerationSpots,
                  isCurved: true,
                  colors: [Colors.red],
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(show: true),
                ),
                LineChartBarData(
                  spots: brakeSpots,
                  isCurved: true,
                  colors: [Colors.blue],
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
                  color: Colors.red,
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
}
