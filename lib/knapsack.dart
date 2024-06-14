import 'dart:math';

import 'package:bilsem/game_class.dart';
import 'package:flutter/material.dart';

class KnapsackWrapper extends Game {
  void Function(BuildContext, String) loseGame;
  void Function(BuildContext) winGame;
  KnapsackWrapper({required this.loseGame, required this.winGame}) : super(loseGame: loseGame, winGame: winGame);

  late var knapsackGame = Knapsack(winGame: winGame, loseGame: loseGame);

  @override
  void restart() {
    knapsackGame.restart();
  }

  @override
  String title() {
    return "Knapsack Game";
  }

  @override
  Widget gameRules() {
    return const Text('Bir çanta büyüklüğü verilir. Ardından bir çok eşya ve her eşyanın kapladığı alan ve verimi verilir. Maximum çantanın kapasitesi kadar eşya alındığında ve çantanın verimliliği maksimum olacak şekilde eşyaları almaya çalış!.');
  }

  @override
  Widget build(BuildContext context) {
    return knapsackGame;
  }
}

class Knapsack extends StatefulWidget {
  void Function(BuildContext) winGame;
  void Function(BuildContext, String) loseGame;
  int kapasite = 10, n = 5;
  final int minKapasite = 8, maxKapasite = 10;
  final int minN = 5, maxN = 7;
  int minSum = 4, maxSum = 0;
  List <int> values = [], weights = [];
  List <bool> selected = [];
  Knapsack({required this.winGame, required this.loseGame});

  late var theState = _KnapsackState();

  void restart() {
    theState.setState(() {
      theState._loadData();
    });
  }

  @override
  State<Knapsack> createState() => theState;
}

class _KnapsackState extends State<Knapsack> {
  void _loadData() {
    setState(() {
      widget.kapasite = (widget.minKapasite + (widget.maxKapasite - widget.minKapasite) * Random().nextDouble()).toInt();
      widget.n = (widget.minN + (widget.maxN - widget.minN) * Random().nextDouble()).toInt();
      widget.maxSum = widget.kapasite;
      widget.values = List.generate(widget.n, (index) => (Random().nextInt(widget.maxSum - widget.minSum) + widget.minSum - 1));
      widget.weights = List.generate(widget.n, (index) => (widget.maxSum - widget.values[index]));
      widget.selected = List.generate(widget.n, (index) => false);
    });
  }

  void checkEnd() {
    int sum = 0;
    for (int i = 0; i < widget.n; i++) {
      if(widget.selected[i]) {
        sum += widget.values[i];
      }
    }
    // calculate knapsack in a traditional way using knapsack algorithm
    int n = widget.n;
    int capacity = widget.kapasite;
    List<int> values = widget.values;
    List<int> weights = widget.weights;

    List<int> dp = List.filled(capacity + 1, 0);

    for (int i = 1; i <= n; i++) {
      for (int j = capacity; j >= weights[i - 1]; j--) {
        dp[j] = max(values[i - 1] + dp[j - weights[i - 1]], dp[j]);
      }
    }
    if (dp[capacity] == sum) {
      widget.winGame(context);
    }
    else {
      widget.loseGame(context, 'Çantanın verimi ${dp[capacity]} olabilirken siz $sum verimde bir çanta oluiturdunuz.');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  int calculateCurrentCapacity() {
    int ret = 0;
    for(int i = 0; i < widget.n; i++) {
      if(widget.selected[i]) {
        ret += widget.weights[i];
      }
    }
    return ret;
  }

  void selectItem(int index) {
    setState(() {
      if(widget.selected[index] == false && calculateCurrentCapacity() + widget.weights[index] > widget.kapasite) {
        return;
      }
      widget.selected[index] = !widget.selected[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Maximum Capacity: ${widget.kapasite}'),
            Text('Current Capacity: ${calculateCurrentCapacity()}'),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(widget.n, (index) {
                return ListTile(
                  title: Text('Item $index'),
                  subtitle: Text('Value: ${widget.values[index]}, Weight: ${widget.weights[index]}'),
                  trailing: Checkbox(
                    value: widget.selected[index],
                    onChanged: (value) {
                      selectItem(index);
                    },
                  ),
                );
              }),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            checkEnd();
          },
          child: Text('Okay'),
        ),
      ],
    );
  }
}