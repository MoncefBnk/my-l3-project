// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _helpController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _helpController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  Future submitReport() async {
    if (notEmpty()) {
      await addSupport(
        _subjectController.text.trim(),
        _helpController.text.trim(),
        _emailController.text.trim(),
      );
    }
  }

  Future addSupport(
      String support_subject, String support_help, String email) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("support")
        .add({
      'support_user_email': email,
      'support_subject': support_subject,
      'support_help': support_help,
    });
  }

  bool notEmpty() {
    if (_emailController.text.trim() != "" ||
        _helpController.text.trim() != "" ||
        _subjectController.text.trim() != "") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Support',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.support,
                  size: 75,
                ),
                SizedBox(height: 20),
                Text(
                  "Edit your account details below",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(height: 20.0),

                //username text field

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.0),

                //firstname text field

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Subject",
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.0),

                //Lastname text field

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: SizedBox(
                    height: 200,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.lightBlue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: TextField(
                          controller: _helpController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Your Reclamation",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.0),
                //PhoneNumber text field

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      submitReport();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
