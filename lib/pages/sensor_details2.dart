// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moncey2/pages/edit_sensor_page.dart';
import 'package:moncey2/pages/history_page.dart';
import 'package:quickalert/quickalert.dart';

class SensorDetails extends StatefulWidget {
  const SensorDetails({
    required this.alertHigh,
    required this.alertLow,
    required this.sensoreId,
    required this.sensorlocation,
    required this.sensorName,
    required this.sensorTemp,
    required this.sensorHumidity,
    super.key,
  });

  final String alertHigh;
  final String sensorName;
  final String alertLow;
  final String sensoreId;
  final String sensorlocation;
  final String sensorTemp;
  final String sensorHumidity;

  @override
  State<SensorDetails> createState() => _SensorDetails();
}

class _SensorDetails extends State<SensorDetails> {
  void deleteSensor() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? currentUserUID = user?.uid;

    final sensorIdToDelete = widget.sensoreId;
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentUserUID);
    final sensorSubcollectionRef = userDocRef.collection('sensors');
    final favoritesSubcollectionRef = userDocRef.collection('favorites');

    sensorSubcollectionRef
        .where('data', isEqualTo: sensorIdToDelete)
        .get()
        .then((querySnapshot) {
      for (final doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
    favoritesSubcollectionRef
        .where('fav', isEqualTo: sensorIdToDelete)
        .get()
        .then((querySnapshot) {
      for (final doc in querySnapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sensor Details',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 25, bottom: 75, left: 25, right: 25),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.9),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Container(
                  child: Center(
                    child: Text(
                      widget.sensorName,
                      style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 200,
                ),
                Container(
                  height: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Information about the sensor',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'ID : ' + widget.sensoreId,
                          style: GoogleFonts.cairo(
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Sensor Location : ' + widget.sensorlocation,
                          style: GoogleFonts.cairo(
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Alert Low: ' + widget.alertLow + "°C",
                              style: GoogleFonts.cairo(
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'Alert High: ' + widget.alertHigh + "°C",
                              style: GoogleFonts.cairo(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.thermostat,
                              size: 30,
                              color: Colors.red,
                            ),
                            Text(
                              widget.sensorTemp + " °C",
                              style: GoogleFonts.cairo(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 30),
                            Icon(
                              Icons.water_drop,
                              size: 30,
                              color: Colors.blue,
                            ),
                            Text(
                              widget.sensorHumidity + " %",
                              style: GoogleFonts.cairo(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: 185,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HistorPage(
                                          historyID: widget.sensoreId,
                                        )),
                              );
                            },
                            child: Text('History'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                QuickAlert.show(
                                  context: context,
                                  type: QuickAlertType.custom,
                                  barrierDismissible: true,
                                  confirmBtnText: "Yes",
                                  onConfirmBtnTap: () {
                                    deleteSensor();
                                    Navigator.pop(context);
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      widget: Text(
                                        'You have succesfully deleted the sensor',
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      confirmBtnText: "Dissmiss",
                                      onConfirmBtnTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      confirmBtnTextStyle: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      title: "",
                                    );
                                  },
                                  confirmBtnTextStyle: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  cancelBtnText: "No",
                                  confirmBtnColor: Colors.lightBlue,
                                  cancelBtnTextStyle: GoogleFonts.cairo(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  showCancelBtn: true,
                                  widget: Text(
                                    "Do you really want to delete this sensor ?",
                                    style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                              child: Icon(Icons.delete),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditSensor(
                                          editSensorId: widget.sensoreId)),
                                );
                              },
                              child: Text("Edit Sensor"),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlue),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  color: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
