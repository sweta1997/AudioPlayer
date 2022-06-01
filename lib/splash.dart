import 'package:flutter/material.dart';
import 'package:music_player/tracks.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Tracks()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FittedBox(
        child: Column(
          children: <Widget>[
            Image.asset('assets/images/logo.png'),
            const Text("SOUL",
            style: TextStyle(fontSize: 40,color: Colors.purple, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
          ],
        ),
      )),
    );
  }
}
