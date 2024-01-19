import 'package:carmodel/charts/section1.dart';
import 'package:carmodel/charts/section2.dart';
import 'package:carmodel/charts/section3.dart';
import 'package:carmodel/charts/section4.dart';
import 'package:carmodel/charts/section5.dart';
import 'package:carmodel/charts/section6.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {// New variable

  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth <= 600) ? 1 : 3; // Adjust the threshold as needed
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight*0.07,horizontal: 10),
          child: Expanded(
            child: Column(
              children: [
                GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _calculateCrossAxisCount(context),
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 40.0,
                    crossAxisSpacing: 16.0,
                  ),
                  shrinkWrap: true,
                  children: [
                    const Brac(),
                    const BrakeChart(),
                    LineChartWidget(),
                    CornerChart(),
                    const Steer(),
                    const BrakePieChart()
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
