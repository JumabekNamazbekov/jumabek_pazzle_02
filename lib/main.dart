import 'package:flutter/material.dart';


void main() => runApp(PuzzleGame());

class PuzzleGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Кетти Жумабек',
      theme: ThemeData.dark(),
      home: PuzzleBoard(),
    );
  }
}

class PuzzleBoard extends StatefulWidget {
  @override
  _PuzzleBoardState createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends State<PuzzleBoard> {
  late List<int> pieces;
  late List<Widget> puzzlePieces;
  late int emptyPieceIndex;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    pieces = List.generate(16, (index) => index + 1)..shuffle();
    emptyPieceIndex = pieces.indexOf(16);
    puzzlePieces = List.generate(16, (index) => _buildPiece(index));
  }

  Widget _buildPiece(int index) {
    bool isVisible = pieces[index] != 16;
    return Visibility(
      visible: isVisible,
      child: GestureDetector(
        onTap: () {
          if (_isValidMove(index)) {
            setState(() {
              _movePiece(index);
              if (_isPuzzleSolved()) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Congratulations!'),
                      content: Text('You solved the puzzle!'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Play Again'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            startGame();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            });
          }
        },
        child: Container(
          color: Colors.blue,
          child: Center(
            child: Text(
              '${pieces[index]}',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidMove(int index) {
    final List<List<int>> moves = [
      [1, -1, -4, 4],
      [1, -1, -4, 4],
      [-4, -4, -1, 1],
      [-4, -4, -1, 1]
    ];
    final int selectedPieceRow = index ~/ 4;
    final int selectedPieceColumn = index % 4;

    for (int i = 0; i < moves.length; i++) {
      int emptyPieceRow = emptyPieceIndex ~/ 4;
      int emptyPieceColumn = emptyPieceIndex % 4;

      if ((selectedPieceRow + moves[i][0] == emptyPieceRow) &&
          (selectedPieceColumn == emptyPieceColumn)) {
        return true;
      } else if ((selectedPieceRow + moves[i][1] == emptyPieceRow) &&
          (selectedPieceColumn == emptyPieceColumn)) {
        return true;
      } else if ((selectedPieceColumn + moves[i][2] == emptyPieceColumn) &&
          (selectedPieceRow == emptyPieceRow)) {
        return true;
      } else if ((selectedPieceColumn + moves[i][3] == emptyPieceColumn) &&
          (selectedPieceRow == emptyPieceRow)) {
        return true;
      }
    }
    return false;
  }

  void _movePiece(int index) {
    setState(() {
      int temp = pieces[index];
      pieces[index] = pieces[emptyPieceIndex];
      pieces[emptyPieceIndex] = temp;
      emptyPieceIndex = index;
    });
  }

  bool _isPuzzleSolved() {
    List<int> sortedPieces = List.from(pieces);
    sortedPieces.sort();

    if (pieces.toString() == sortedPieces.toString()) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Game'),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: puzzlePieces,
      ),
    );
  }
}