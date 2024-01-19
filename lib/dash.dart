import 'package:carmodel/charts/section1.dart';
import 'package:carmodel/charts/section2.dart';
import 'package:carmodel/charts/section3.dart';
import 'package:carmodel/charts/section4.dart';
import 'package:carmodel/charts/section5.dart';
import 'package:carmodel/charts/section6.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
                const Rating(
                  title: 'Driver Behaviour',
                  section: 1,
                ),
                const Rating(
                  title: 'Vehicle condition rating',
                  section: 2,
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

class Rating extends StatelessWidget {
  final String title;
  final int section;

  const Rating({required this.title, required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TenStarRatingBar(section: section),
        ),
      ],
    );
  }
}

class TenStarRatingBar extends StatefulWidget {
  final int section;

  const TenStarRatingBar({required this.section, super.key});

  @override
  TenStarRatingBarState createState() => TenStarRatingBarState();
}

class TenStarRatingBarState extends State<TenStarRatingBar> {
  late Map<int, double> _ratings;

  @override
  void initState() {
    super.initState();
  }

  double _calculateStarSize(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth <= 600) ? 20 : 16;
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: _ratings[widget.section] ?? 10,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 10,
      itemSize: 7,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
        size: _calculateStarSize(context),
      ),
      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
      ignoreGestures: true,
      onRatingUpdate: (rating) {},
    );
  }
}
