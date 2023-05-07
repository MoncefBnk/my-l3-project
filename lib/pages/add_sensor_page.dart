// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddSensor extends StatefulWidget {
  const AddSensor({super.key});

  @override
  State<AddSensor> createState() => _AddSensorState();
}

class _AddSensorState extends State<AddSensor> {
  final _sensorIDController = TextEditingController();

  void _addData() {
    final String data = _sensorIDController.text;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? currentUserUID = user?.uid;

    if (currentUserUID != null) {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final DocumentReference currentUser = users.doc(currentUserUID);
      final CollectionReference sensors = currentUser.collection('sensors');

      sensors.add({'data': data});
    }
  }

  @override
  void dispose() {
    _sensorIDController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Sensor",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 170),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Please enter the correct sensor ID and it will be added ',
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
                  controller: _sensorIDController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Sensor ID",
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40.0),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: GestureDetector(
              onTap: () {
                _addData();
                Navigator.pop(context, _sensorIDController.text);
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Add Sensor',
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
