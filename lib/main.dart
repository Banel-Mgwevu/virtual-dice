import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

void main() {
  runApp(ShakeCounterApp());
}

class ShakeCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShakeCounterPage(),
    );
  }
}

class ShakeCounterPage extends StatefulWidget {
  @override
  _ShakeCounterPageState createState() => _ShakeCounterPageState();
}

class _ShakeCounterPageState extends State<ShakeCounterPage> {
  int shakeCount = 0;
  Random random = Random();
  List<String> diceFaces = [
    'assets/dice1.svg',
    'assets/dice2.svg',
    'assets/dice3.svg',
    'assets/dice4.svg',
    'assets/dice5.svg',
    'assets/dice6.svg',
  ];
  String currentDiceFace = 'assets/dice_face1.svg'; // Initial face

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((AccelerometerEvent event) {
      double threshold = 12.0;

      if (event.x.abs() >= threshold ||
          event.y.abs() >= threshold ||
          event.z.abs() >= threshold) {
        setState(() {
          shakeCount++;
          rollDice(); // Roll the dice on shake
        });
      }
    });
  }

  void rollDice() {
    String newFace = diceFaces[random.nextInt(diceFaces.length)];
    setState(() {
      currentDiceFace = newFace;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shake Counter App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Shake Count:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$shakeCount',
              style: TextStyle(fontSize: 48),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: rollDice, // Trigger the dice roll on tap
              child: SvgPicture.asset(
                currentDiceFace,
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
