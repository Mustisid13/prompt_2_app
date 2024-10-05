import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> previousGames = [];

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  _loadScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      previousGames = prefs.getStringList('scores') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Previous Games:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: previousGames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(previousGames[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Start New Game'),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String player1 = 'Player 1';
  String player2 = 'Player 2';
  int player1Wins = 0;
  int player2Wins = 0;
  int round = 1;
  bool isGameOver = false;
  int filledCells = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe Game'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Players' scores and round information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Round $round',
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text('$player1: $player1Wins  |  $player2: $player2Wins',
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 20),
            // Tic Tac Toe Board
            GridView.builder(
              shrinkWrap: true,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (!isGameOver && board[index] == '') {
                      setState(() {
                        board[index] = currentPlayer;
                        filledCells++;
                        currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
                        checkWinner();
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: board[index] == ''
                          ? Colors.grey[300]
                          : board[index] == 'X'
                              ? Colors.lightBlue
                              : Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            if (isGameOver)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    resetBoard();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Next Round',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
          ],
        ),
      ),
    ); }

  void checkWinner() {
    // Check all winning conditions
    List<List<int>> winningConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winningConditions) {
      String a = board[condition[0]];
      String b = board[condition[1]];
      String c = board[condition[2]];

      if (a == b && b == c && a != '') {
        setState(() {
          isGameOver = true;
        });
        updateScore(a);
        return;
      }
    }

    // Check for a draw (if all cells are filled and no winner)
    if (filledCells == 9 && !isGameOver) {
      setState(() {
        isGameOver = true;
      });
      showDraw();
    }
  }

  void updateScore(String winner) {
    if (winner == 'X') {
      player1Wins++;
    } else {
      player2Wins++;
    }

    if (player1Wins == 2 || player2Wins == 2 || round == 3) {
      showFinalWinner();
    } else {
      showWinner(winner);
    }
  }

  void showWinner(String winner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Round Over'),
          content: Text('$winner wins this round!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetBoard();
              },
              child: const Text('Next Round'),
            ),
          ],
        );
      },
    );
  }

  void showDraw() {
    _saveResult("Round $round: Draw");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Round Over'),
          content: const Text('It\'s a draw!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetBoard();
              },
              child: const Text('Next Round'),
            ),
          ],
        );
      },
    );
  }

  void showFinalWinner() {
    String finalWinner = player1Wins > player2Wins ? player1 : player2;
    _saveResult("Final Winner: $finalWinner");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('$finalWinner wins the game!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text('Return to Home'),
            ),
          ],
        );
      },
    );
  }

  void resetBoard() {
    setState(() {
      board = List.filled(9, '');
      isGameOver = false;
      currentPlayer = 'X';
      round++;
      filledCells = 0;
    });
  }

  // Save result to SharedPreferences
  void _saveResult(String result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> scores = prefs.getStringList('scores') ?? [];
    scores.add(result);
    prefs.setStringList('scores', scores);
  }
}
