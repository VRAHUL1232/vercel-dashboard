import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:csv/csv.dart' as csv;
import 'package:flutter/services.dart';

class BrakePieChart extends StatefulWidget {
  const BrakePieChart({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BrakePieChartState createState() => _BrakePieChartState();
}

class _BrakePieChartState extends State<BrakePieChart> {
  List<List<dynamic>> csvData = [];
  Map<int, int> brakeCountMap = {};
  int brake3Count = 0; // Variable to store the count of 'Brake 3'

  @override
  void initState() {
    super.initState();
    _loadCSVData();
  }

  Future<void> _loadCSVData() async {
    final String data = await rootBundle.loadString('assets/csv/ILP.csv');
    final List<List<dynamic>> csvList =
        const csv.CsvToListConverter().convert(data);

    // Skip the first row (header) if it exists
    if (csvList.isNotEmpty && csvList[0].first == 'Brake') {
      csvList.removeAt(0);
    }

    setState(() {
      csvData = csvList;
      _countBrakeValues();
    });
  }

  void _countBrakeValues() {
    brakeCountMap.clear();
    brake3Count = 0; // Reset the count of 'Brake 3'

    for (var row in csvData) {
      int brakeValue = int.tryParse('${row[0]}') ?? -1;
      if (brakeValue >= 0 && brakeValue <= 3) {
        brakeCountMap[brakeValue] = (brakeCountMap[brakeValue] ?? 0) + 1;
        if (brakeValue == 3) {
          brake3Count++;
        }
      }
    }
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
          // Use FlPieChart instead of LineChart
          PieChart(
            PieChartData(
              sections: _getSections(),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              // other configurations...
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(192, 43, 42, 41),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Sudden Brake',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 30,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Low',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 60,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(192, 43, 42, 41),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Medium',
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 90,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(192, 43, 42, 41),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'High', // Display the count for 'Brake 3'
                style: TextStyle(
                  color: Colors.green,
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

  List<PieChartSectionData> _getSections() {
    return brakeCountMap.entries.map((entry) {
      final int brakeValue = entry.key;
      final int count = entry.value;

      final double percentage = (count / csvData.length) * 100;

      return PieChartSectionData(
        color: getColor(brakeValue),
        value: count.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 50,
      );
    }).toList();
  }

  Color getColor(int brakeValue) {
    // You can define your own color logic based on the brakeValue
    // For simplicity, I'm using a predefined color list
    List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
    ];
    return colors[brakeValue % colors.length];
  }
}

void main() {
  runApp(const MaterialApp(
    home: BrakePieChart(),
  ));
}
