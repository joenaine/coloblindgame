import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:colorblindgame/routes.dart';

List<Color> colors = [
  Colors.redAccent,
  Colors.greenAccent,
  Colors.blueAccent,
  Colors.amberAccent,
];

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final buttonStyle = ElevatedButton.styleFrom(
      // backgroundColor: Colors.blue,
      // foregroundColor: Colors.white,
      // borderRadius: BorderRadius.circular(10),
      padding: EdgeInsets.fromLTRB(75, 20, 75, 20));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('@2handaulet', style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var i = 0; i < colors.length; i++)
                    CircleAvatar(
                      backgroundColor: colors[i],
                      radius: 25,
                    ),
                ],
              ),
              const SizedBox(height: 30),
              const Text('ColorBlind', style: TextStyle(fontSize: 70)),
              const SizedBox(height: 50),
              ElevatedButton(
                child: const Text('Play', style: TextStyle(fontSize: 25)),
                onPressed: () {
                  // Navigator.pushNamed(context, '/game');
                  Navigator.of(context).push(Routes.createRoute(context));
                },
                style: buttonStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
