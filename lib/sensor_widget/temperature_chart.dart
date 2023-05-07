// ignore_for_file: prefer_const_constructors

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TempChart extends StatelessWidget {
  const TempChart(
      {Key? key,
      required this.value,
      required this.name,
      required this.unit,
      required this.trendData,
      required this.linePoint})
      : super(key: key);

  final double value;
  final String name;
  final String unit;
  final List<double> trendData;
  final Color linePoint;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        shadowColor: Colors.white,
        elevation: 24,
        color: Colors.lightBlue.shade100,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.thermostat,
                      size: 30,
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(name, style: GoogleFonts.cairo(color: Colors.red)),
                    SizedBox(
                      height: 10,
                    ),
                    Text('$value$unit',
                        style: GoogleFonts.cairo(color: Colors.red)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
                  child: Sparkline(
                    data: trendData,
                    lineWidth: 5.0,
                    lineColor: Colors.white,
                    averageLine: true,
                    fillMode: FillMode.above,
                    sharpCorners: false,
                    pointsMode: PointsMode.last,
                    pointSize: 20,
                    pointColor: linePoint,
                    useCubicSmoothing: true,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
