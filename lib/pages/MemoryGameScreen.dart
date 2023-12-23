import 'dart:async';
import 'package:flutter/material.dart';

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<String> emojis = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻',
    '🐼', // Add more as per your requirement
  ];

  late List<String> cards;
  late List<bool> flipped;
  late int previousIndex;
  late int matches;
  late int moves;
  late Timer timer;
  _MemoryGameScreenState() {
    cards = [];
    flipped = [];
    previousIndex = -1;
    matches = 0;
    moves = 0;
  }
  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    setState(() {
      cards = [...emojis, ...emojis];
    cards.shuffle();
    flipped = List<bool>.filled(cards.length, false);
    previousIndex = -1;
    matches = 0;
    moves = 0;
    });
    
    startTimer();
  }

  void startTimer() {
    timer = Timer(const Duration(seconds: 60), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Time\'s Up!'),
            content: Text('Your score: $matches out of ${emojis.length}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  initializeGame();
                },
                child: const Text('Play Again'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void handleCardTap(int index) {
    //print("current Index $index");
    setState(() {
      if (!flipped[index]) {
        if (previousIndex == -1) {
          // First card tap
          flipped[index] = true;
          previousIndex = index;
          //print("after first $previousIndex");
        } else {
          // Second card tap
          flipped[index] = true;
          //print("after sec $previousIndex");

          if (cards[index] == cards[previousIndex]) {
            // Match found
            matches++;
            if (matches == emojis.length) {
              timer.cancel();
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Congratulations!'),
                    content:
                        Text('You have completed the game with $moves moves.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          initializeGame();
                        },
                        child: const Text('Play Again'),
                      ),
                    ],
                  );
                },
              );
            }
          } else {
            //print("check $previousIndex");
            // No match

            final prev = previousIndex;
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                //print(index);
                //print("previous$prev");
                flipped[index] = false;
                flipped[prev] = false;
              });
            });
          }

          previousIndex = -1;
          moves++;
        }
      }
    });
  }

  void showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Rules'),
          content: const Text(
              'Memory Game is a simple game where you need to match pairs of cards with the same emoji.\n\n'
              'Instructions:\n'
              '1. Tap on a card to reveal its emoji.\n'
              '2. Tap on another card to reveal its emoji.\n'
              '3. If the emojis on the two cards match, they stay face up, and you earn a point.\n'
              '4. If the emojis don\'t match, both cards flip back face down.\n'
              '5. Continue flipping pairs of cards until you have matched all the pairs.\n'
              '6. The game is complete when all pairs are matched.\n'
              '7. Try to complete the game with the minimum number of moves.\n'
              '8. You have a time limit to complete the game before time runs out.\n\n'
              'Enjoy playing the Memory Game and have fun matching the pairs of emojis!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: cards.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => handleCardTap(index),
                child: Container(
                  color: flipped[index] ? Colors.white : Colors.blue,
                  child: Center(
                    child: Text(
                      flipped[index] ? cards[index] : '',
                      style: const TextStyle(fontSize: 32.0),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    // Restart the game
                    initializeGame();
                  },
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(height: 16.0),
                FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    // Show game rules dialog
                    showRulesDialog();
                  },
                  child: const Icon(Icons.help),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
