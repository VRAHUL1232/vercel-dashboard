import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';

class DataScreen extends StatefulWidget {

  const DataScreen({super.key});

  @override
  DataScreenState createState() => DataScreenState();
}

bool isLoading = false;

class DataScreenState extends State<DataScreen> {
  List<List<dynamic>> csvData = [[]];
  List<dynamic> csvColumn = [];

  @override
  void initState() {
    super.initState();
    readCSV();
  }

  Future<void> readCSV() async {
    isLoading = true;
    final data = await rootBundle.loadString('assets/csv/ILP.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(data);

    setState(() {
      csvData = rowsAsListOfValues;
      csvColumn = csvData[0];
      print(csvData);
      print(csvColumn);
      isLoading = false;
    });
  }

  Future<void> exportToExcel() async {
    final Excel excel = Excel.createExcel();
    final Sheet sheet = excel['Sheet1'];

    // Write CSV data to Excel sheet
    for (int i = 0; i < csvData.length; i++) {
      for (int j = 0; j < csvData[i].length; j++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
          ..value = csvData[i][j];
      }
    }

    // Save the Excel file
    // File('your_path/excel.xlsx').writeAsBytes(bytes);  // Uncomment to save the file (change 'your_path')
  }

 // ...

@override
Widget build(BuildContext context) {
  return (isLoading) ?  Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.black,))) :  Scaffold(
    appBar: AppBar(
      title: const Text('CSV Reader'),
      actions: [
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: () {
            exportToExcel(); // Call exportToExcel when the button is pressed
          },
        ),
      ],
    ),
    body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
  columns: List.generate(
          csvColumn.length,
          (index) => DataColumn(label: Text('Column $index')),
        )
, // Check if csvData is not empty before generating columns
  rows: List.generate(
          csvData.length,
          (index) => DataRow(
            cells: List.generate(
              csvData[index].length,
              (cellIndex) => DataCell(
                Text(csvData[index][cellIndex].toString()),
              ),
            ),
          ),
        ), // Check if csvData is not empty before generating rows
),

      ),
    ),
  );
}

}
