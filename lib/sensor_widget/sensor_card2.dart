// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:moncey2/pages/sensor_details2.dart';

class SensorCard extends StatefulWidget {
  const SensorCard({required this.sensorId, super.key});

  final String sensorId;

  @override
  State<SensorCard> createState() => _SensorCardState();
}

class _SensorCardState extends State<SensorCard> {
  String temperature = "";
  String humidity = "";
  String location = "";
  String nomDuCapteur = "";
  String sensoralertHigh = "";
  String sensoralertLow = "";

  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  void getDataFromFirebase() {
    final firestoreInstance = FirebaseFirestore.instance;

    firestoreInstance
        .collection("sensor")
        .doc(widget.sensorId)
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          humidity = documentSnapshot["current_humidity"].toString();
          sensoralertHigh = documentSnapshot["high_alert_temp"].toString();
          sensoralertLow = documentSnapshot["low_alert_temp"].toString();
          temperature = documentSnapshot["current_temp"].toString();
          location = documentSnapshot["sensor_location"].toString();
          nomDuCapteur = documentSnapshot["sensor_name"].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SensorDetails(
                    alertHigh: sensoralertHigh,
                    alertLow: sensoralertLow,
                    sensoreId: widget.sensorId,
                    sensorlocation: location,
                    sensorName: nomDuCapteur,
                    sensorTemp: temperature,
                    sensorHumidity: humidity,
                  )

              //SensorDetails(
              //alertHigh: sensoralertHigh,
              //alertLow: sensoralertLow,
              //sensoreId: widget.sensorId,
              //sensorlocation: location,
              //sensorName: nomDuCapteur,
              //sensorTemp: temperature,),
              ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          border: Border.all(color: Colors.lightBlue, width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text(
                  nomDuCapteur,
                  style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_downward),
                Text(
                  " Alert low : " + sensoralertLow + " °C",
                  style: GoogleFonts.cairo(fontSize: 16),
                ),
                SizedBox(width: 20),
                Icon(Icons.arrow_upward),
                Text(
                  " Alert low : " + sensoralertHigh + " °C",
                  style: GoogleFonts.cairo(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.thermostat,
                  size: 30,
                  color: Colors.red,
                ),
                Text(
                  temperature + " °C",
                  style: GoogleFonts.cairo(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 70),
                Icon(
                  Icons.water_drop,
                  size: 30,
                  color: Colors.blue,
                ),
                Text(
                  humidity + " %",
                  style: GoogleFonts.cairo(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
