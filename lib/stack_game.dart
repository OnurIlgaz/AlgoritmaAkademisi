import 'dart:math';

import 'package:bilsem/game_class.dart';
import 'package:flutter/material.dart';

class StackGameWrapper extends Game {
  StackGameWrapper({required super.loseGame, required super.winGame});

  late var stackGame = StackGame(winGame: winGame, loseGame: loseGame);
  
  @override
  void restart() {
    stackGame.restart();
  }

  @override
  String title() {
    return "Stack Game";
  }

  @override
  Widget gameRules() {
    return const Text('Bir hamlede iki farklı kutu seçebilir ve seçtiğin kutulardan birer taş alabilirsin. Amaç en az 2 kutuda taşlar 0`a ulaştığında kalan kutudaki taşı minimum bırakmaktır.');
  }

  @override
  Widget build(BuildContext context) {
    return stackGame;
  }
}

class StackGame extends StatefulWidget {
  void Function(BuildContext) winGame;
  void Function(BuildContext, String) loseGame;
  StackGame({super.key, required this.winGame, required this.loseGame});

  var theState = StackGameState();

  void restart() {
    theState.setState(() {
      theState._loadData();
    });
  }

  @override
  State<StackGame> createState() {
    return theState;
  }
}

class StackGameState extends State<StackGame> {
  final int K = 3, minVal = 4, maxVal = 7;
  List<int> stacks = [];
  List<bool> selected = [];
  int answer = 0, movesMade = 0;

  void _move(int first, int second) { 
    setState(() {
      stacks[first]--;
      stacks[second]--;
    });
  }

  void _checkEnding() {
    int empty = 0;
    for(int i = 0; i < K; i++) {
      if(stacks[i] == 0) {
        empty++;
      }
    }
    if(empty < K - 1) {
      return;
    }
    var temp = stacks.map((e) => e).toList();
    temp.sort();
    if(answer == temp[K - 1]) {
      widget.winGame(context);
    }
    else {
      widget.loseGame(context, 'You left ${temp[K - 1]} stones, but the answer is $answer');
    }
  }

  void _loadData() {
    setState(() {
      // generate a stack and make sure it is even
      stacks = List.generate(K, (index) => Random().nextInt(maxVal - minVal + 1) + minVal);
      for(int i = 0; i < K; i++) {
        stacks[i] = (stacks[i] * (Random().nextDouble() * 1.5 + 1.0)).toInt();
      }
      selected = List.generate(K, (index) => false);
      int sum = 0;
      for(int i = 0; i < K; i++) {
        sum += stacks[i];
      }
      if(sum % 2 == 1) {
        stacks[0]--;
      }
      // calculate answer
      var temp = stacks.map((e) => e).toList();
      temp.sort();
      int diff = temp[1] - temp[0];
      temp[1] -= diff;
      temp[2] -= diff;
      while(temp[0] > 0 && temp[0] != temp[2]) {
        temp[2] -= 2;
        temp[0] -= 1;
      }
      if(temp[0] == temp[2]) {
        answer = 0;
      }
      else {
        answer = temp[2];
      }
      // reset moves
      movesMade = 0;
    });
  }

  void tap(int ind, bool? val) {
    if(val == null) return;
     selected[ind] = val;
    int cnt = 0;
    for(int i = 0; i < K; i++) {
      if(selected[i]) cnt++;
    }
    if(cnt == 2) {
      int first = -1, second = -1;
      for(int i = 0; i < K; i++) {
        if(selected[i]) {
          if(first == -1) {
            first = i;
          }
          else {
            second = i;
          }
        }
      }
      _move(first, second);
      _checkEnding();
      selected = List.generate(K, (index) => false);
      print(selected);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text("Hedef: $answer"),
          ),
          const SizedBox(height: 30,),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(var i in stacks) 
                  Padding(child: Tower(stones: i), padding: EdgeInsets.symmetric(horizontal: 10),),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for(int i = 0; i < K; i++)
                  stacks[i] == 0 ? Checkbox(value: selected[i], onChanged: (value) {}, fillColor: MaterialStateProperty.all(Colors.grey),) : Checkbox(value: selected[i], onChanged: (value) => setState((){tap(i, value);})),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Tower extends StatelessWidget {
  final int stones;
  Tower({required this.stones});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 430,
      width: 30,
      child: Column(
        children: [
          const Spacer(),
          Text(stones.toString()),
          for(int i = 0; i < stones; i++)
            Container(
              width: 30,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.black)
              ),
            ),
        ],
      ),
    );
  }
}