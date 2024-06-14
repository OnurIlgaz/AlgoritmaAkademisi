import 'dart:math';

import 'package:bilsem/game_class.dart';
import 'package:flutter/material.dart';

class GridGameWrapper extends Game {
  GridGameWrapper({required super.loseGame, required super.winGame});

  late var gridGame = GridGame(winGame: winGame, loseGame: loseGame);

  @override
  void restart() {
    gridGame.restart();
  }

  @override
  String title() {
    return 'Grid Game';
  }

  @override
  Widget gameRules() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Oyun bütün ışıklar açıldığında sonlanır. Bir ışığı açınca aynı zamanda hem solunda hem altında olan bütün ışıkların açık/kapalı durumları değişir. Bütün ışıkları minimum hamlede açarsan kazanırsın!'),
        SizedBox(height: 5),
        Image(image: AssetImage('images/aciklama.png')),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return gridGame;
  }
}

class GridGame extends StatefulWidget {
  void Function(BuildContext) winGame;
  void Function(BuildContext, String) loseGame;
  GridGame({super.key, required this.winGame, required this.loseGame});

  var theState = GridGameState();

  void restart() {
    theState.setState(() {
      theState._loadData();
    });
  }

  @override
  State<GridGame> createState() {
    return theState;
  }
}

class GridGameState extends State<GridGame> {
  final int K = 8;
  List<List<bool>> grid = [];
  int answer = 0, movesMade = 0;

  void _move(int x, int y) { 
    setState(() {
      for(int i = x; i < K; i++) {
        for(int j = 0; j <= y; j++) {
          grid[i][j] = !grid[i][j];
        }
      }
      movesMade++;
      bool check = true;
      for(int i = 0; i < K; i++) {
        for(int j = 0; j < K; j++) {
          check = check && !grid[i][j];
        }
      }
      if(check) {
        if(movesMade == answer) {
          widget.winGame(context);
        } else {
          widget.loseGame(context, 'You have made $movesMade moves, but the goal was $answer moves.');
        }
      }
    });
  }

  void _moveBasic(int x, int y) {
    for(int i = x; i < K; i++) {
      for(int j = 0; j <= y; j++) {
        grid[i][j] = !grid[i][j];
      }
    }
  }

  int calculateAnswer() {
    int answer = 0;
    var temp = List<List<bool>>.from(grid.map((row) => List<bool>.from(row)));
    for(int i = 0; i < K; i++) {
      for(int j = K - 1; j >= 0; j--) {
        if(grid[i][j]) {
          answer++; 
          _moveBasic(i, j);
        }
      }
    }
    grid = temp;
    return answer;
  }

  void _loadData() {
    grid = List<List<bool>>.generate(K, (i) => List<bool>.generate(K, (j) => Random().nextBool()));
    answer = calculateAnswer();
    movesMade = 0;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width, height = MediaQuery.of(context).size.height;
    double space = min(width, height) / (K + 1);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Moves made: $movesMade"),
        const SizedBox(height: 10,),
        Text("Goal: $answer"),
        const SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.all(space / 2),
          child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(K, (i) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,  
                    children: List.generate(K, (j) => SingleBlock(size: space, isAlive: grid[i][j], x: i, y: j, onTap: _move)),
                  )),
                ),
          ),
        ),
      ],
    );
  }
}

class SingleBlock extends StatelessWidget {
  final bool isAlive;
  final int x;
  final int y;
  final double size;
  final Function(int, int) onTap;

  const SingleBlock({super.key, required this.size, required this.isAlive, required this.x, required this.y, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(isAlive) { 
          onTap(x, y);
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isAlive ? Colors.grey.shade900 : Colors.white,
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
      )
    );
  }
}