import 'package:carmodel/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../dashboard.dart';
import 'gears.dart';

class GearAndBattery extends StatefulWidget {
  GearAndBattery({
    Key? key,
    required this.constraints,
  }) : super(key: key);

  final BoxConstraints constraints;
  final List<String> acc = ["LOW", "MEDIUM", "HIGH"];

  @override
  // ignore: library_private_types_in_public_api
  _GearAndBatteryState createState() => _GearAndBatteryState();
}

class _GearAndBatteryState extends State<GearAndBattery> {
  // ignore: deprecated_member_use
  final DatabaseReference _indi8Reference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child('COOLANT TEMP');
  // ignore: deprecated_member_use
  final DatabaseReference _indi9Reference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child('ENGINE TEMP');

  final DatabaseReference _brkReference =
      // ignore: deprecated_member_use
      FirebaseDatabase.instance.reference().child('rpi_sensors').child('brake');
  final DatabaseReference _accReference = FirebaseDatabase.instance
      .ref()
      .child('rpi_sensors')
      .child('acceleration');
  final DatabaseReference _brakeReference = FirebaseDatabase.instance
      // ignore: deprecated_member_use
      .reference()
      .child('rpi_sensors')
      .child('brake');
  late int brvalue;
  Color brakeColor = lightRed;
  late int accvalue;
  Color accColor = lightRed;
  late int coolant;
  late int engine1;
  late int br;

  late final BoxConstraints constraints;
  @override
  void initState() {
    super.initState();
    coolant = 0;
    engine1 = 0;
    _indi8Reference.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          coolant = event.snapshot.value as int;
        });
      }
    });
    _indi9Reference.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          engine1 = event.snapshot.value as int;
        });
      }
    });

    _brkReference.onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          br = event.snapshot.value as int;
        });
      }
    });
    accvalue = 0;
    _accReference.onValue.listen((event) {
      if (event.snapshot.exists) {
        accvalue = event.snapshot.value as int;

        // Map the gear value to the corresponding index in widget.gears
        int mappedIndex = _getAccMappedIndex(accvalue);

        // Update the selectedGearIndex based on the mapped index
        setState(() {
          accvalue = mappedIndex;
        });
      }
    });
    brvalue = 0;
    _brakeReference.onValue.listen((event) {
      if (event.snapshot.exists) {
        brvalue = event.snapshot.value as int;

        // Map the gear value to the corresponding index in widget.gears
        int mappedIndex = _getBrakeMappedIndex(brvalue);

        // Update the selectedGearIndex based on the mapped index
        setState(() {
          brvalue = mappedIndex;
        });
      }
    });
  }

  int _getAccMappedIndex(int gearvalue) {
    switch (accvalue) {
      case 0:
        accColor = lightRed;
        return widget.acc.indexOf("LOW");
      case 1:
        accColor = lightYellow;
        return widget.acc.indexOf("MEDIUM");
      case 2:
        accColor = lightGreen;
        return widget.acc.indexOf("HIGH");
      default:
        return 0;
    }
  }

  int _getBrakeMappedIndex(int gearvalue) {
    switch (brvalue) {
      case 0:
        brakeColor = lightRed;
        return widget.acc.indexOf("LOW");
      case 1:
        brakeColor = lightYellow;
        return widget.acc.indexOf("MEDIUM");
      case 2:
        brakeColor = lightGreen;
        return widget.acc.indexOf("HIGH");
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      // color: Colors.blueGrey.withOpacity(0.15),
      width: widget.constraints.maxWidth * 0.74,
      height: widget.constraints.maxHeight * 0.22,
      child: LayoutBuilder(
        builder: (context, gearConstraints) => Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: GearPrinter(),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 0,
                    ),
                    Column(
                      children: [
                        const Gears(),
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.055),
                          child: SizedBox(
                            width: gearConstraints.maxWidth * 0.72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: screenWidth * 0.01),
                                Text(
                                  "ENGINE TEMPERATURE: ${engine1.toStringAsFixed(1)}° C",
                                  style: TextStyle(
                                      fontSize: 1.1.w,
                                      fontWeight: FontWeight.w400,
                                      color: temperatureColor),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "COOLANT TEMPERATURE: ${coolant.toStringAsFixed(1)}° C",
                                    style: TextStyle(
                                      fontSize: 1.1.w,
                                      fontWeight: FontWeight.w400,
                                      color: temperatureColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: gearConstraints.maxHeight * 0.10,
              left: gearConstraints.maxWidth * 0.10,
              height: gearConstraints.maxHeight * 0.38,
              child: CustomPaint(
                painter: AvgWattPerKmPrinter(),
                // Acceleration
                child: SizedBox(
                  width: screenWidth *
                      0.15, // Increased width to accommodate the power icon
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: screenWidth * 0.01, left: screenWidth * 0.014),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "Accn   ",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 1.6.w),
                        ),
                        Text(
                          widget.acc[accvalue],
                          style: TextStyle(color: accColor, fontSize: 1.2.w),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: gearConstraints.maxHeight * 0.10,
                right: gearConstraints.maxWidth * 0.12,
                width: gearConstraints.maxWidth * 0.20,
                height: gearConstraints.maxHeight * 0.38,
                child: CustomPaint(
                  painter: OdoPrinter(),
                  child: SizedBox(
                    width: screenWidth *
                        0.15, // Increased width to accommodate the power icon
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: screenWidth * 0.01, right: screenWidth * 0.014),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            "Brake   ",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 1.6.w),
                          ),
                          Text(
                            widget.acc[brvalue],
                            style:
                                TextStyle(color: brakeColor, fontSize: 1.2.w),
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class BatteryStatusCliper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.8, 0)
      ..lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class AvgWattPerKmPrinter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 146, 29, 0)
      ..style = PaintingStyle.fill;

    // paint.shader = LinearGradient(colors: colors)
    double strokeWidth = 0.6.h;
    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.35, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * 0.35, strokeWidth);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class OdoPrinter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 146, 29, 0)
      ..style = PaintingStyle.fill;

    // paint.shader = LinearGradient(colors: colors)
    double strokeWidth = 0.6.h;
    Path path = Path()
      ..lineTo(size.width * 0.65, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.65, strokeWidth);
    // ..lineTo(size.width, 0);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
