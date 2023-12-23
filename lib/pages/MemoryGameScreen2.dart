import 'dart:math';
import 'package:flutter/material.dart';

class MemoryGameScreen2 extends StatefulWidget {
  @override
  _MemoryGameScreen2State createState() => _MemoryGameScreen2State();
}

class _MemoryGameScreen2State extends State<MemoryGameScreen2> {
   List<String> emojis = ['🍎', '🍌', '🍓', '🍒', '🍇', '🍊'];
  late String targetEmoji;
  late String selectedEmoji;
  late String resultText;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    setState(() {
      targetEmoji = emojis[Random().nextInt(emojis.length)];
      selectedEmoji = '';
      resultText = '';
    });
  }

  void checkAnswer() {
    if (selectedEmoji == targetEmoji) {
      setState(() {
        resultText = 'Correct! 🎉';
      });
    } else {
      setState(() {
        resultText = 'Wrong! Try again. ❌';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select the emoji that matches:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              targetEmoji,
              style: const TextStyle(fontSize: 60),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: emojis
                  .map((emoji) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmoji = emoji;
                            checkAnswer();
                          });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selectedEmoji == emoji
                                ? Colors.blue
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            emoji,
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              resultText,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: startNewGame,
              child: const Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
  /*List<String> emojis = [
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', // Add more as per your requirement
  ];

  late List<String> cards;
  late List<bool> flipped;
  late int previousIndex;
  late int matches;
  late int moves;
  late Timer timer;

  _MemoryGameScreen2State() {
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
    cards = [...emojis, ...emojis];
    cards.shuffle();
    flipped = List<bool>.filled(cards.length, false);
    previousIndex = -1;
    matches = 0;
    moves = 0;
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
    setState(() {
      if (!flipped[index]) {
        flipped[index] = true;
        if (previousIndex != -1) {
          if (cards[index] == cards[previousIndex]) {
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
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                flipped[index] = false;
                flipped[previousIndex] = false;
              });
            });
          }
          previousIndex = -1;
        } else {
          previousIndex = index;
        }
        moves++;
      }
    });
  }

  void showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Rules'),
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
            'Enjoy playing the Memory Game and have fun matching the pairs of emojis!'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
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
                  onPressed: () {
                    // Restart the game
                    initializeGame();
                  },
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(height: 16.0),
                FloatingActionButton(
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
  }*/
}
