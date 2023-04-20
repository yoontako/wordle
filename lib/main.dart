import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wordle/keyboard_widget.dart';

class ApiClient {
  Future<String?> fetchWord() async {
    final url =
        Uri.parse('https://random-word-api.herokuapp.com/word?length=5');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        print(body.first);
        return body.first.toString().toUpperCase();
      } else {
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return null;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Wordle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> lines = [
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  int cursorLine = 0;
  int typingLine = 0;
  String answer = "";
  bool showAnswer = false;

  Widget charCell(int line, int number) {
    final currentWord = lines[line];
    String displayChar = "";
    if (currentWord.length > number) {
      displayChar = currentWord[number];
    }
    Color color = Colors.white;
    if (line < cursorLine) {
      if (lines[line][number] == answer[number]) {
        color = Colors.green;
      } else if (answer.contains(lines[line][number])) {
        color = Colors.yellow;
      } else {
        color = Colors.grey;
      }
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.grey),
          color: color,
        ),
        child: Center(
          child: Text(
            displayChar,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget drawCharCells() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            charCell(0, 0),
            charCell(0, 1),
            charCell(0, 2),
            charCell(0, 3),
            charCell(0, 4),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            charCell(1, 0),
            charCell(1, 1),
            charCell(1, 2),
            charCell(1, 3),
            charCell(1, 4),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            charCell(2, 0),
            charCell(2, 1),
            charCell(2, 2),
            charCell(2, 3),
            charCell(2, 4),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            charCell(3, 0),
            charCell(3, 1),
            charCell(3, 2),
            charCell(3, 3),
            charCell(3, 4),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            charCell(4, 0),
            charCell(4, 1),
            charCell(4, 2),
            charCell(4, 3),
            charCell(4, 4),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            charCell(5, 0),
            charCell(5, 1),
            charCell(5, 2),
            charCell(5, 3),
            charCell(5, 4),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    fetchWord();
  }

  Future<void> fetchWord() async {
    final client = ApiClient();
    final word = await client.fetchWord();
    if (word == null) {
      return;
    }
    setState(() {
      answer = word;
    });
  }

  bool validation(String word) {
    if (word.length < 5) {
      return false;
    }
    // TODO: 単語のヴァリデーションチェック
    // TODO: 単語の読み込みが完了していない
    return true;
  }

  void pressed(String char) {
    if (cursorLine > 5) {
      return;
    }
    if (char == "backspace") {
      if (lines[cursorLine].isNotEmpty) {
        setState(() {
          lines[cursorLine] =
              lines[cursorLine].substring(0, lines[cursorLine].length - 1);
        });
      }
      return;
    }
    if (char == "enter") {
      if (validation(lines[cursorLine])) {
        if (cursorLine == 5) {
          setState(() {
            showAnswer = true;
          });
        }
        setState(() {
          cursorLine++;
        });
      } else {
        const snackBar = SnackBar(
          content: Text('入力が不正です。'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return;
    }
    if (lines[cursorLine].length < 5) {
      setState(() {
        lines[cursorLine] += char;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  lines = [
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                  ];
                  cursorLine = 0;
                  typingLine = 0;
                  answer = "";
                  showAnswer = false;
                });
                fetchWord();
              },
              icon: const Icon(Icons.restore)),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(),
              Column(
                children: [
                  (answer == "")
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 10,
                            ),
                            Text("単語を選択しています..."),
                          ],
                        )
                      : drawCharCells(),
                  (showAnswer)
                      ? Text(
                          "答え: $answer",
                          style: const TextStyle(fontSize: 40),
                        )
                      : Container(),
                ],
              ),
              (answer != "")
                  ? Keyboard(
                      usedWords: lines.join("").split(''),
                      onPressed: (char) => pressed(char),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
