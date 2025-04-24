import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twinko_cards/components/custom_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int tries = 0;
  int score = 0;

  List<String> images = List.generate(8, (index) => "${index + 1}.png");
  List<String> shuffledImages = [];
  List<int> flippedCards = [];
  List<int> matchedCards = [];

  @override
  void initState() {
    super.initState();
    initGame();
    Future.delayed(Duration(seconds: 2), () {
      initGame();
    });
  }

  void initGame() {
    tries = 0;
    score = 0;
    shuffledImages = List.from(images)..addAll(images);
    shuffledImages.shuffle();
    matchedCards = [];

    flippedCards = List.generate(shuffledImages.length, (index) => index);

    setState(() {});

    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        flippedCards.clear();
      });
    });
    setState(() {});
  }

  void onCardTapped(int index) {
    if (flippedCards.length == 2 || flippedCards.contains(index)) return;

    setState(() {
      flippedCards.add(index);
    });

    if (flippedCards.length == 2) {
      tries++;
      if (shuffledImages[flippedCards[0]] == shuffledImages[flippedCards[1]]) {
        score++;
        matchedCards.addAll(flippedCards);
      }

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          flippedCards.clear();
        });
      });

      if (matchedCards.length == shuffledImages.length) gameOver();
    }
  }

  void gameOver() {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: Text("Game Over"),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: !kIsWeb
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              if (!kIsWeb)
                TextButton(
                  onPressed: () {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else {
                      exit(0);
                    }
                  },
                  child: const Text(
                    'Exit',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              TextButton(
                onPressed: () async {
                  initGame();
                  Navigator.pop(context);
                },
                child: const Text(
                  "Play again",
                  style: TextStyle(
                    color: Color(0xFF0266B7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customContainer(context, "Score", score),
                customContainer(context, "Tries", tries),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              itemCount: shuffledImages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: !kIsWeb ? 4 : 8),
              itemBuilder: (context, index) {
                bool isFlipped = flippedCards.contains(index);
                bool isMatched = matchedCards.contains(index);
                return CustomCard(
                  image: shuffledImages[index],
                  onTap: () => onCardTapped(index),
                  isFlipped: isFlipped || isMatched,
                );
              },
            ),
            customButton(context, "Play again"),
          ],
        ),
      ),
    );
  }

  Container customContainer(BuildContext context, String title, int number) {
    return Container(
      height: !kIsWeb ? MediaQuery.of(context).size.width / 5 : 80,
      width: !kIsWeb ? MediaQuery.of(context).size.width / 3 : 80,
      decoration: BoxDecoration(
        color: Color(0xFF0266B7),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2.0,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          Text(
            "$number",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        ],
      ),
    );
  }

  Material customButton(BuildContext context, String textButton) {
    return Material(
      color: Color(0xFF0266B7),
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () => initGame(),
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Colors.white.withValues(alpha: 0.3),
        hoverColor: Colors.white.withValues(alpha: 0.1),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 20.0,
          height: MediaQuery.of(context).size.height / 12,
          child: Center(
            child: Text(
              textButton,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
