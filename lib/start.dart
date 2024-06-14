import 'package:bilsem/game_class.dart';
import 'package:flutter/material.dart';

class Start extends Game {
  void Function() startGames;
  Start({required super.loseGame, required super.winGame, required this.startGames});
  
  @override
  void restart() {}

  @override
  String title() {
    return "Ana Sayfa";
  }

  @override
  Widget gameRules() {
    return const Text("Sıralı oyunlar oynayarak problem çözme ve algoritma becerilerinizi geliştirin.");
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Center(
          child: Text(
            'Problem Çözme ve Algoritma Soruları',
            style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          ),
          const SizedBox(height: 10),
          const Image(image: AssetImage('images/thinking_man.jpeg'), width: 250, height: 250),
          const SizedBox(height: 10),
          TextButton(
            onPressed: startGames,
            child: Text(
              'Başla',
              style: TextStyle(
              fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
                decoration: TextDecoration.underline,
                decorationColor: Colors.red,
              ),
            ),
          )
        ],
      )
    );
  }
}