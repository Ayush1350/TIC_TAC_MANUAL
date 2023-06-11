import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {

  List<List<String>> _board = [];
  String ?_currentPlayer;
  String ?_winner;

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    _board = List.generate(3, (_) => List.filled(3, ''));
    _currentPlayer = 'X';
    _winner = null;
  }

  void _playMove(int row, int col) {
    if (_board[row][col].isEmpty && _winner == null) {
      setState(() {
        _board[row][col] = _currentPlayer!;
        _checkWinner(row, col);
        _currentPlayer = (_currentPlayer == 'X') ? 'O' : 'X';
      });
    }
  }

  void _checkWinner(int row, int col) {
    String player = _board[row][col];
    bool won = true;

    // Check row
    for (int i = 0; i < 3; i++) {
      if (_board[row][i] != player) {
        won = false;
        break;
      }
    }
    if (won) {
      _winner = player;
      return;
    }

    won = true;

    // Check column
    for (int i = 0; i < 3; i++) {
      if (_board[i][col] != player) {
        won = false;
        break;
      }
    }
    if (won) {
      _winner = player;
      return;
    }

    won = true;

    // Check diagonal
    if (row == col) {
      for (int i = 0; i < 3; i++) {
        if (_board[i][i] != player) {
          won = false;
          break;
        }
      }
      if (won) {
        _winner = player;
        return;
      }
    }

    won = true;

    // Check anti-diagonal
    if (row + col == 2) {
      for (int i = 0; i < 3; i++) {
        if (_board[i][2 - i] != player) {
          won = false;
          break;
        }
      }
      if (won) {
        _winner = player;
        return;
      }
    }

    // Check for draw
    bool draw = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j].isEmpty) {
          draw = false;
          break;
        }
      }
    }
    if (draw) {
      _winner = 'Draw';
    }
  }

  void _resetGame() {
    setState(() {
      _initBoard();
    });
  }

  Widget _buildBoard() {
    return Column(
      children: <Widget>[
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: 9,
          itemBuilder: (context, index) {
            int row = index ~/ 3;
            int col = index % 3;
            return GestureDetector(
              onTap: () => _playMove(row, col),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    _board[row][col],
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16.0),
        Text(
          (_winner != null)
              ? (_winner == 'Draw')
              ? 'It\'s a draw!'
              : 'Player $_winner wins!'
              : 'Player $_currentPlayer\'s turn',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _resetGame,
          child: Text('Reset Game'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: _buildBoard(),
      ),
    );
  }
}
