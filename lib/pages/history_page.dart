// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistorPage extends StatefulWidget {
  const HistorPage({
    super.key,
    required this.historyID,
  });

  final String historyID;

  @override
  State<HistorPage> createState() => _HistorPageState();
}

class _HistorPageState extends State<HistorPage> {
  @override
  void initState() {
    super.initState();
    getHistory();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot> getHistory() async {
    int x = DateTime.now()
        .subtract(Duration(days: 30))
        .toUtc()
        .millisecondsSinceEpoch;
    QuerySnapshot qShot = await firestore
        .collection('sensor')
        .doc(widget.historyID)
        .collection('history')
        .orderBy('time', descending: true)
        .get();

    return qShot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: getHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                DateTime time = doc['time'].toDate();
                return ListTile(
                  title: Text('Temperature: ${doc['temperature'].toString()}'),
                  subtitle: Text('Humidity: ${doc['humidity'].toString()}'),
                  trailing: Text('Time: $time'),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
