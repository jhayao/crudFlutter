import 'package:flutter/material.dart';

import 'package:crud/include/UserPreference.dart';

import '../pages/auth_page.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // title: const Text("About"),

            ),
        body: Center(
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    // const SizedBox(height: 10,),
                    const Text(
                      "About",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Image.asset('assets/images/logo.png'),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "ENHANCED SCHEDULER AND TIME MANAGEMENT APPLICATION WITH TARDINESS EVALUATION FOR STUDENTS",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "This app is designed to provide a system to determine how frequent the user / student get late in their undertakings particularly in attendings school activities. This is also created to provide future solutions on how these situations to be solved which are encountered by the clients of this app. More importanly, this platform intends to improve the user's management of time endevour.",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
