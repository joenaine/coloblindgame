import 'package:colorblindgame/pages/game/game_model.dart';
import 'package:colorblindgame/pages/game/game_repository.dart';
import 'package:flutter/material.dart';
// import 'package:colorblindgame/game_data.dart';
import 'dart:async';
import 'dart:math';

import 'package:colorblindgame/logic/game_data.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  GameData gameData = GameData();

  late Timer timer;
  int timeLeft = 10;
  int gridSize = 2;
  Color? targetColor;
  Color? dummyColor;

  Random random = Random();

  @override
  void dispose() {
    timer.cancel();
    _nameController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    gridSize = gameData.getGridSize();
    gameData.targetIndex = random.nextInt(pow(gridSize, 2).toInt() - 1);
    nextColor();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (timer) {
        if (gameData.isPlaying) {
          if (timeLeft == 0) {
            setState(() {
              timer.cancel();
            });
            endGame();
          } else {
            setState(() {
              timeLeft--;
            });
          }
        }
      },
    );
  }

  void nextLevel() {
    setState(() {
      gameData.nextLevel(timeLeft);
      gridSize = gameData.getGridSize();
      timeLeft = 10;
    });
    nextColor();
  }

  void endGame() {
    setState(() {
      gameData.endGame();
    });
    gameOver();
  }

  void continuePlaying() {
    setState(() {
      gameData.isPlaying = true;
      // timeLeft = 10;
    });
    startTimer();
    nextLevel();
  }

  void nextColor() {
    // Random random = Random();
    int r = random.nextInt(255);
    int g = random.nextInt(255);
    int b = random.nextInt(255);

    int minOffset = 6;
    int offset = 50;

    if (gridSize == 3) {
      offset = 25;
    } else if (gridSize == 4) {
      offset = 12;
    } else if (gridSize == 5) {
      offset = 6;
    }

    // Offset is always guaranteed to be exactly the same.
    int rOffset = minOffset + random.nextInt(offset);
    int gOffset = minOffset + random.nextInt(offset);
    int bOffset = minOffset + random.nextInt(offset);

    if (r + rOffset > 255) rOffset = -rOffset;
    if (g + gOffset > 255) gOffset = -gOffset;
    if (b + bOffset > 255) bOffset = -bOffset;

    setState(() {
      targetColor = Color.fromRGBO(r + rOffset, g + gOffset, b + bOffset, 1.0);
      dummyColor = Color.fromRGBO(r, g, b, 1);
    });
  }

  // Avoid overflow when generating RGB colors
  int normalize(int value, {int min = 0, int max = 255}) {
    if (value < min) {
      return min;
    } else if (value > max) {
      return max;
    } else {
      return (min + (value * (max - min) / max)).floor();
    }
  }

  @override
  Widget build(BuildContext context) {
    // return SafeArea(

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text("Level: ${gameData.level}", style: TextStyle(fontSize: 40)),
            Text("Score: ${gameData.score}", style: TextStyle(fontSize: 30)),
            Text("Time left: $timeLeft", style: TextStyle(fontSize: 30)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                // primary: true,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: gridSize,
                // childAspectRatio: 1,
                children: List.generate(pow(gridSize, 2) as int, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          if (gameData.targetIndex == index) {
                            nextLevel();
                          } else {
                            endGame();
                          }
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: gameData.targetIndex == index
                              ? targetColor
                              : dummyColor,
                        )),
                  );
                }),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  String? notEmpty(String? value) {
    if (value == null || value.isEmpty) return 'Field can not be empty';
    final checkValue = value.replaceAll(RegExp(r"\s+\b|\b\s|\s|\b"), "");
    if (checkValue.isEmpty) return 'Field can not be empty';

    return null;
  }

  TextEditingController _nameController = TextEditingController();

  Future<void> gameOver() async {
    await showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              // Navigator.popUntil(context, ModalRoute.withName('/home'));
              Navigator.pushReplacementNamed(context, '/home');
              return false;
            },
            child: Form(
              key: _formKey,
              child: SimpleDialog(
                title: const Center(
                  child: Text(
                    'Game Over!',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                children: [
                  Divider(thickness: 3),
                  TextFormField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                        hintText: 'type name',
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 24)),
                    validator: (value) {
                      var defaultValidator = notEmpty(value);
                      return defaultValidator;
                    },
                  ),
                  Divider(thickness: 3),
                  SizedBox(height: 12),
                  SimpleDialogOption(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await GameRepository.submitScore(
                            recordModel: RecordModel(
                          name: _nameController.text.trim(),
                          level: gameData.level,
                          score: gameData.score,
                        ));
                        if (response) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      }
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('submit ',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.green)),
                        ]),
                  ),
                  // SimpleDialogOption(
                  //   onPressed: () {
                  //     Navigator.pop(context, true);
                  //     continuePlaying();
                  //   },
                  //   child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: const [
                  //         Text('Continue ',
                  //             style: TextStyle(
                  //                 fontSize: 30, color: Colors.redAccent)),
                  //       ]),
                  // ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Center(
                        child: Text('Home', style: TextStyle(fontSize: 30))),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
