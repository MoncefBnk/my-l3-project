// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moncey2/navbar/alerts_page.dart';
import 'package:moncey2/navbar/nav_bar.dart';
import 'package:moncey2/pages/add_sensor_page.dart';

import 'package:moncey2/sensor_widget/sensor_card2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    getSensorIDs();
  }

  List dataList = [];

  Future getSensorIDs() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('sensors')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        dataList.add(doc['data']);
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final sensorSubcollectionRef = userDocRef.collection('sensors');

    return Scaffold(
      //appbar menu
      drawer: NavBar(),
      appBar: AppBar(
        //appbar title
        title: Text(
          "Home",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        //appbar alerts

        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlertsPage(),
                  ),
                );
              },
              child: Icon(Icons.notifications),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: sensorSubcollectionRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final sensorDocs = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: sensorDocs.length,
            itemBuilder: (context, index) {
              final sensorData = sensorDocs[index]['data'];
              return Column(
                children: [
                  SensorCard(sensorId: sensorData),
                  SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSensor()),
          );

          if (result != null) {
            setState(() {
              dataList.add(result);
            });
          }
        },
      ),
    );
  }
}
