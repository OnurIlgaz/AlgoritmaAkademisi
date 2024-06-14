import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  final void Function(BuildContext, String) loseGame;
  final void Function(BuildContext) winGame;

  const Game({Key? key, required this.loseGame, required this.winGame})
      : super(key: key);

  void restart() {}

  String title() {
    return "Not implemented";
  }

  Widget gameRules() {
    return Text("Not implemented");
  }

  @override
  Widget build(BuildContext context) {
    return Text("Not implemented");
  }
}
