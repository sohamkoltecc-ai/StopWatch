import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const StopwatchApp());
}

class StopwatchApp extends StatelessWidget {
  const StopwatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const StopwatchScreen(),
    );
  }
}

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? timer;

  int milliseconds = 0;
  bool isRunning = false;

  List<String> laps = [];

  void startPause() {
    if (isRunning) {
      timer?.cancel();

      setState(() {
        isRunning = false;
      });

      return;
    }

    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() {
        milliseconds += 10;
      });
    });
  }

  void resetWatch() {
    timer?.cancel();

    setState(() {
      milliseconds = 0;
      isRunning = false;
      laps.clear();
    });
  }

  void addLap() {
    if (milliseconds == 0) return;

    setState(() {
      laps.add(formatTime());
    });
  }

  String formatTime() {
    int hundredths = (milliseconds ~/ 10) % 100;
    int seconds = (milliseconds ~/ 1000) % 60;
    int minutes = milliseconds ~/ 60000;

    return "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}:"
        "${hundredths.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.amber,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "STOPWATCH",
          style:  TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 12,
        shadowColor: Colors.amberAccent,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),

          Container(
            width: 300,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber, width: 2),
              boxShadow: [
                BoxShadow(color: Colors.amber, blurRadius: 20, spreadRadius: 2),
              ],
            ),

            child: Text(
              formatTime(),
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: Colors.amber, thickness: 1.0),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: laps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Text(
                      "${laps.length - index}",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 23)),
                    ),
                  ),
                  title: Text(
                    laps[index],
                    style: const TextStyle(color: Colors.amber),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(color: Colors.amber, thickness: 1.0),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: buildButton(isRunning ? "Pause" : "Start", startPause),
            ),
            SizedBox(width: 10),
            Expanded(child: buildButton("Lap", addLap)),
            SizedBox(width: 10),
            Expanded(child: buildButton("Reset", resetWatch)),
          ],
        ),
      ),
    );
  }
}
