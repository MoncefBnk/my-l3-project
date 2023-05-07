// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:moncey2/sensor_widget/sensor_card2.dart';

class FavoritsPage extends StatefulWidget {
  const FavoritsPage({super.key});

  @override
  State<FavoritsPage> createState() => _FavoritsPageState();
}

class _FavoritsPageState extends State<FavoritsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();

    getFavIDs();
  }

  List favDataList = [];

  Future getFavIDs() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        favDataList.add(doc['fav']);
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar menu

      appBar: AppBar(
        //appbar title
        title: Text(
          "Favorits",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        //appbar alerts
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: favDataList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              SensorCard(sensorId: favDataList[index]),
              SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
