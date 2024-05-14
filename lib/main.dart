import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<HomePage> {
  int xWins = 0;
  late List<String> board;
  late int moveCount;
  late String currentPlayer;
  int oWins = 0;

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      moveCount = 0;
    });
  }

  void makeMove(int index) {
    setState(() {
      if (board[index].isEmpty) {
        board[index] = currentPlayer;
        moveCount++;
        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
      }

      String? winner = checkWinner();
      if (winner != null) {
        showResultDialog(winner);
        updateWinCount(winner);
      } else if (moveCount == 9) {
        showResultDialog('draw');
      }
    });
  }

  String? checkWinner() {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];

    for (var condition in winConditions) {
      if (board[condition[0]] != '' &&
          board[condition[0]] == board[condition[1]] &&
          board[condition[1]] == board[condition[2]]) {
        return board[condition[0]];
      }
    }

    return null;
  }

  void updateWinCount(String winner) {
    if (winner == 'X') {
      setState(() {
        xWins++;
      });
    } else if (winner == 'O') {
      setState(() {
        oWins++;
      });
    }
  }

  void showResultDialog(String result) {
    String message;
    if (result == 'draw') {
      message = "Its a draw!";
    } else {
      message = 'Player $result wins!';
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff008287),
        title: const Text(
          'Game Over',
          style: TextStyle(
            color: Color(0xffD9B991),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              resetGame();
            },
            child: const Text(
              'RESTART',
              style: TextStyle(color: Color(0xffD9B991), fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff5A9B9B),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Column(
              children: [
                Text(
                  "John Doe",
                  style: TextStyle(
                    color: Color(0xffD9B991),
                    fontSize: 30,
                    height: 1,
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Color(0xffD9B991),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  "Score",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'X  : $xWins',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'O  : $oWins',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 312,
              height: 312,
              color: const Color(0xffD4B98E),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(9, (index) {
                  return GetContainer(
                    player: board[index],
                    onTap: () {
                      if (checkWinner() == null) {
                        makeMove(index);
                      }
                    },
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GetButton(
                  name: "Reset",
                  onPressed: resetGame,
                ),
                GetButton(
                  name: "New",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GetContainer extends StatelessWidget {
  final String player;
  final VoidCallback onTap;

  const GetContainer({required this.player, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.amber,
      highlightColor: Colors.amber,
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          color: Color(0xff5A9B9B),
        ),
        child: Center(
          child: Text(
            player,
            style: TextStyle(
              color: player == "X" ? Colors.white : const Color(0xff015A5F),
              fontSize: 60,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class GetButton extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;

  const GetButton({required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff008287),
        padding: const EdgeInsets.all(16.0),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
