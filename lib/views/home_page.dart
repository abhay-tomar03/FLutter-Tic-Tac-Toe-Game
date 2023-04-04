import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:game/views/MainPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var rowCount = TextEditingController();
  var columnCount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tick Tack Game',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 300,
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: Center(
                      child: Image.asset('assets/images/game.jpeg',
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 100,
                ),
                TextField(
                    controller: rowCount,
                    decoration: const InputDecoration(
                      hintText: "Enter Row",
                      labelText: "Row",
                    )),
                TextField(
                    controller: columnCount,
                    decoration: InputDecoration(
                      hintText: "Enter Column",
                      labelText: "Column",
                    )),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      String row = rowCount.text;
                      String col = columnCount.text;
                      print('Row : $row , col: $col ');
                      print(columnCount.text.runtimeType);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage(
                                rowCount.text.toString(),
                                columnCount.text.toString())),
                      );
                    },
                    child: Text('Next'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
