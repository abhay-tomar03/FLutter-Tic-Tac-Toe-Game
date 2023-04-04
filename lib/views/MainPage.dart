import 'package:flutter/material.dart';
import 'utils.dart';

class MainPage extends StatefulWidget {
  var rowInput;
  var colInput;

  // we have to make a constructor

  MainPage(this.rowInput, this.colInput);

  @override
  _MainPageState createState() => _MainPageState();
}

class Player {
  static const none = '';
  static const X = 'X';
  static const O = 'O';
}

class Utils {
  static List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}

class _MainPageState extends State<MainPage> {
  static final countMatrix = 0;
  static final double size = 60;

  String lastMove = Player.none;
  late List<List<String>> matrix;

  @override
  void initState() {
    super.initState();

    setEmptyFields();
  }

  void setEmptyFields() => setState(() => matrix = List.generate(
        int.parse(widget.rowInput),
        (_) => List.generate(int.parse(widget.colInput), (_) => Player.none),
      ));

  Color getBackgroundColor() {
    final thisMove = lastMove == Player.X ? Player.O : Player.X;

    return getFieldColor(thisMove).withAlpha(150);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: getBackgroundColor(),
        appBar: AppBar(
          title: Text('Tick Tack Toe Game '),
          actions: [
            IconButton(
              onPressed: () {
                setEmptyFields();
              },
              icon: const Icon(Icons.refresh),
            )
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: Utils.modelBuilder(matrix, (x, value) => buildRow(x)),
            ),
          ),
        ),
      );

  Widget buildRow(int x) {
    final values = matrix[x];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Utils.modelBuilder(
            values,
            (y, value) => buildField(x, y),
          ),
        ),
      ),
    );
  }

  Color getFieldColor(String value) {
    switch (value) {
      case Player.O:
        return Colors.blue;
      case Player.X:
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  Widget buildField(int x, int y) {
    final value = matrix[x][y];
    final color = getFieldColor(value);

    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size, size),
          primary: color,
        ),
        child: Text(value, style: TextStyle(fontSize: 32)),
        onPressed: () => selectField(value, x, y),
      ),
    );
  }

  void selectField(String value, int x, int y) {
    if (value == Player.none) {
      final newValue = lastMove == Player.X ? Player.O : Player.X;

      setState(() {
        lastMove = newValue;
        matrix[x][y] = newValue;
      });

      if (isWinner(x, y)) {
        showEndDialog('Player $newValue Won');
      } else if (isEnd()) {
        showEndDialog('Undecided Game');
      }
    }
  }

  bool isEnd() =>
      matrix.every((values) => values.every((value) => value != Player.none));

  /// Check out logic here: https://stackoverflow.com/a/1058804

  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = matrix[x][y];
    final n = int.parse(widget.rowInput);

   
      for (int i = 0; i < n; i++) {
        if (matrix[x][i] == player) col++;
        if (matrix[i][y] == player) row++;
        if (matrix[i][i] == player) diag++;
        if (matrix[i][n - i - 1] == player) rdiag++;
      }

      return row == n || col == n || diag == n || rdiag == n;

  }

  Future showEndDialog(String title) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text('Press to Restart the Game'),
          actions: [
            ElevatedButton(
              onPressed: () {
                setEmptyFields();
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            )
          ],
        ),
      );
}
