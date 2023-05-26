// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
            return Padding(
              padding: EdgeInsets.only(top: 20),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  DateTime time = doc['time'].toDate();
                  var formatter = DateFormat('MMM d, y h:mm a');
                  var formattedTime = formatter.format(time);
                  return SizedBox(
                    height: 80,
                    child: ListTile(
                      title: Text('$formattedTime'),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(vertical: 9),
                        child: Row(
                          children: [
                            Icon(
                              Icons.thermostat,
                              size: 30,
                              color: Colors.red,
                            ),
                            Text('${doc['temperature'].toString()} °C'),
                            SizedBox(width: 20),
                            Icon(
                              Icons.water_drop,
                              size: 30,
                              color: Colors.blue,
                            ),
                            Text('${doc['humidity'].toString()} %'),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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
