import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vibration/vibration.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const ShakeCounterApp());
}

class ShakeCounterApp extends StatelessWidget {
  const ShakeCounterApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shake Counter',
      home: const ShakeCounterPage(),
    );
  }
}

class ShakeCounterPage extends StatefulWidget {
  const ShakeCounterPage({Key? key});

  @override
  _ShakeCounterPageState createState() => _ShakeCounterPageState();
}

class _ShakeCounterPageState extends State<ShakeCounterPage> {
  int shakeCount = 0;
  int score = 0;
  int countdown = 5; // Countdown time in seconds
  Random random = Random();
  List<String> diceFaces = [
    'assets/dice1.svg',
    'assets/dice2.svg',
    'assets/dice3.svg',
    'assets/dice4.svg',
    'assets/dice5.svg',
    'assets/dice6.svg',
  ];
  String currentDiceFace = 'assets/dice1.svg';
  Color backgroundColor = Colors.white;
  bool changeBackgroundColor = false;
  bool isCounting = false;

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
          Vibration.vibrate(duration: 100);
          rollDice();
          if (!isCounting) {
            isCounting = true;
            startCountdown();
          }

          // Change background color and set a timer to reset it after 3 seconds
          changeBackgroundColor = true;
          backgroundColor = Colors.primaries[random.nextInt(Colors.primaries.length)];
          Timer(const Duration(seconds: 3), () {
            setState(() {
              changeBackgroundColor = false;
              backgroundColor = Colors.white;
              Vibration.cancel();
            });
          });
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

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        countdown--;
      });
      if (countdown == 0) {
        timer.cancel();
        if (shakeCount == 11) {
          score = 0;
        } else {
          score++;
        }
        isCounting = false;
        countdown = 5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Number To Build',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '11',
              style: TextStyle(fontSize: 65),
            ),
            const SizedBox(height: 30),
            const Text(
              'Shake Count:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$shakeCount',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: $score',
              style: TextStyle(fontSize: 36),
            ),
            Text(
              'Countdown: $countdown seconds',
              style: TextStyle(fontSize: 23),
            ),
            GestureDetector(
              onTap: rollDice,
              child: SvgPicture.asset(
                currentDiceFace,
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: changeBackgroundColor ? backgroundColor : Colors.white,
    );
  }
}
