import 'package:bilsem/game_class.dart';
import 'package:bilsem/grid_game.dart';
import 'package:bilsem/knapsack.dart';
import 'package:bilsem/stack_game.dart';
import 'package:bilsem/start.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int currentLevel = 0;
  final int maxLevel = 10;
  late var games = <Game>[
    Start(loseGame: gameLost, winGame: gameWon, startGames: nextGame),
    StackGameWrapper(loseGame: gameLost, winGame: gameWon),
    KnapsackWrapper(loseGame: gameLost, winGame: gameWon),
    GridGameWrapper(loseGame: gameLost, winGame: gameWon),
  ];

  void gameWon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
      return AlertDialog(
        title: const Text('Tebrikler!'),
        content: const Text('Oyunu kazandınız!'),
        actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            nextGame();
          },
          child: const Text('Sonraki oyun'),
        ),
        ],
      );
      },
    );
  }

  void gameLost(BuildContext context, String reason) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Oyun bitti'),
          content: Text('Oyunu kaybettin. Sebep: $reason'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                restart(context);
              },
              child: const Text('Tekrar dene'),
            ),
          ],
        );
      },
    );
  }

  void restart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Oyun yeniden başlatıldı!'),
        duration: Duration(seconds: 2),
      ),
    );
    setState(() {
      games[currentLevel].restart();
    });
  }

  void getInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Nasıl Oynanır?'),
            content: games[currentLevel].gameRules(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Kapat'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )
          );
      },
    );
  }

  void nextGame() {
    if (currentLevel < maxLevel) {
      setState(() {
        currentLevel++;
        getInfo(context);
      });
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        appBar: AppBar(
          title: Text(games[currentLevel].title()),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                restart(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                getInfo(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () {
                nextGame();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Oyun atlanıldı!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
        body: games[currentLevel],
    );
  }  
}
