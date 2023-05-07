// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EditSensor extends StatefulWidget {
  const EditSensor({
    super.key,
    required this.editSensorId,
  });

  final String editSensorId;

  @override
  State<EditSensor> createState() => _EditSensorState();
}

class _EditSensorState extends State<EditSensor> {
  String editLocation = "";
  String editNomDuCapteur = "";
  String editSensoralertHigh = "";
  String editSensoralertLow = "";

  final _sensorNameController = TextEditingController();
  final _sensorLocationController = TextEditingController();
  final _sensorAlertHighController = TextEditingController();
  final _sensorAlertLowController = TextEditingController();

  @override
  void dispose() {
    _sensorNameController.dispose();
    _sensorLocationController.dispose();
    _sensorAlertHighController.dispose();
    _sensorAlertLowController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getDataFromFirebase();
  }

  editSensor() {
    if (alertHighLowConfirmed()) {
      updateData(
        _sensorNameController.text.trim(),
        _sensorLocationController.text.trim(),
        int.parse(_sensorAlertHighController.text.trim()),
        int.parse(_sensorAlertLowController.text.trim()),
      );

      getDataFromFirebase();
    }
  }

  Future updateData(
    String sensor_name,
    String sensor_location,
    int high_alert_temp,
    int low_alert_temp,
  ) async {
    await FirebaseFirestore.instance
        .collection('sensor')
        .doc(widget.editSensorId)
        .update({
      'sensor_name': sensor_name,
      'sensor_location': sensor_location,
      'high_alert_temp': high_alert_temp,
      'low_alert_temp': low_alert_temp,
    });
  }

  bool alertHighLowConfirmed() {
    if (int.parse(_sensorAlertHighController.text.trim()) >
        int.parse(_sensorAlertLowController.text.trim())) {
      return true;
    } else {
      return false;
    }
  }

  void getDataFromFirebase() {
    final firestoreInstance = FirebaseFirestore.instance;

    firestoreInstance
        .collection("sensor")
        .doc(widget.editSensorId)
        .snapshots()
        .listen((documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          editSensoralertHigh = documentSnapshot["high_alert_temp"].toString();
          editSensoralertLow = documentSnapshot["low_alert_temp"].toString();
          editLocation = documentSnapshot["sensor_location"].toString();
          editNomDuCapteur = documentSnapshot["sensor_name"].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Sensor",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Edit the sensor information as needed',
              style:
                  GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 50.0),

          // snesor Id  textfield
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.editSensorId,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),

          // sensor name textfield
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _sensorNameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: editNomDuCapteur,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),

          // Sensor Location textfield
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightBlue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: TextField(
                  controller: _sensorLocationController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: editLocation,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _sensorAlertLowController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: editSensoralertLow + " °C",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _sensorAlertHighController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: editSensoralertHigh + " °C",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                editSensor();
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Edit Sensor',
                    style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
