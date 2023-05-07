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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(),
    );
  }
}
