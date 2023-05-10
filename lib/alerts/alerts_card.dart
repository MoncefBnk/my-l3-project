// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:moncey2/pages/sensor_details2.dart';

class AlertCard extends StatefulWidget {
  const AlertCard({required this.alertId, super.key});

  final String alertId;

  @override
  State<AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  String alertTemperature = "";
  String alertHumidity = "";
  String alertLocation = "";
  String alertNomDuCapteur = "";
  String alertTime = "";

  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  void getDataFromFirebase() {
    final firestoreInstance = FirebaseFirestore.instance;

    firestoreInstance
        .collection("alerts")
        .doc(widget.alertId)
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          alertHumidity = documentSnapshot["alert_humidity"].toString();
          Timestamp timestamp = documentSnapshot["alert_time"];
          DateTime dateTime = timestamp.toDate();
          alertTime = DateFormat.yMMMd().add_jm().format(dateTime);
          alertTemperature = documentSnapshot["alert_temperature"].toString();
          alertLocation = documentSnapshot["alert_location"].toString();
          alertNomDuCapteur = documentSnapshot["alert_cause"].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        border: Border.all(color: Colors.red, width: 1),
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
                alertNomDuCapteur,
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer),
              SizedBox(width: 5),
              Text(
                alertTime,
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
                alertTemperature + " °C",
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
                alertHumidity + " %",
                style: GoogleFonts.cairo(
                    fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }
}
