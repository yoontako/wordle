import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  final Function(String) onPressed;
  final List usedWords;
  const Keyboard({super.key, required this.onPressed, required this.usedWords});

  Widget singleButton(String char) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 60,
        height: 70,
        child: ElevatedButton(
          onPressed: () => onPressed(char),
          style: ElevatedButton.styleFrom(
              backgroundColor:
                  (usedWords.contains(char)) ? Colors.grey : Colors.white),
          child: Text(
            char,
            style: const TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            singleButton("Q"),
            singleButton("W"),
            singleButton("E"),
            singleButton("R"),
            singleButton("T"),
            singleButton("Y"),
            singleButton("U"),
            singleButton("I"),
            singleButton("O"),
            singleButton("P"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            singleButton("A"),
            singleButton("S"),
            singleButton("D"),
            singleButton("F"),
            singleButton("G"),
            singleButton("H"),
            singleButton("J"),
            singleButton("K"),
            singleButton("L"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: 60,
                height: 70,
                child: ElevatedButton(
                  onPressed: () => onPressed("enter"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Icon(
                    Icons.send,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            singleButton("Z"),
            singleButton("X"),
            singleButton("C"),
            singleButton("V"),
            singleButton("B"),
            singleButton("N"),
            singleButton("M"),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                width: 60,
                height: 70,
                child: ElevatedButton(
                  onPressed: () => onPressed("backspace"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Icon(
                    Icons.backspace,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
