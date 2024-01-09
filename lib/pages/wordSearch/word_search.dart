import 'package:flutter/material.dart';

class WordSearchPage extends StatefulWidget {
  const WordSearchPage({super.key});

  @override
  State<WordSearchPage> createState() => _WordSearchPageState();
}

class _WordSearchPageState extends State<WordSearchPage> {
  int rows = 0;
  int columns = 0;
  List<List<TextEditingController>> controllers = [];

  TextEditingController rowController = TextEditingController();
  TextEditingController columnController = TextEditingController();

  TextEditingController searchController = TextEditingController();
  String searchResult = '';
  List<List<bool>> highlightedCells =
      List.generate(5, (_) => List.filled(5, false));

  bool isInitializedGrid = false;

  @override
  void initState() {
    super.initState();
  }

  void initializeGrid() {
    rows = int.tryParse(rowController.text)!;
    columns = int.tryParse(columnController.text)!;
    controllers = List.generate(
        rows, (i) => List.generate(columns, (j) => TextEditingController()));
    setState(() {
      isInitializedGrid = true;
    });
  }

  bool isValidSearch() {
    String searchText = searchController.text;
    if (searchText.isEmpty) {
      return false;
    }

    int len = searchText.length;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        if (j + len <= columns &&
            controllers[i][j].text == searchText[0] &&
            controllers[i][j + len - 1].text == searchText[len - 1]) {
          String rowText =
              controllers[i].sublist(j, j + len).map((c) => c.text).join();
          if (rowText == searchText) {
            highlightCells(i, j, i, j + len - 1);
            return true;
          }
        }

        if (i + len <= rows &&
            controllers[i][j].text == searchText[0] &&
            controllers[i + len - 1][j].text == searchText[len - 1]) {
          String columnText =
              List.generate(len, (k) => controllers[i + k][j].text).join();
          if (columnText == searchText) {
            highlightCells(i, j, i + len - 1, j);
            return true;
          }
        }
      }
    }

    return false;
  }

  void highlightCells(
      int startRow, int startColumn, int endRow, int endColumn) {
    setState(() {
      for (int i = startRow; i <= endRow; i++) {
        for (int j = startColumn; j <= endColumn; j++) {
          highlightedCells[i][j] = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Search Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: rowController,
                    decoration: InputDecoration(label: Text("Rows")),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    controller: columnController,
                    decoration: InputDecoration(label: Text("Columns")),
                  ),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  child: Text("Create Grid"),
                  onPressed: () {
                    if (int.tryParse(rowController.text)! > 0 &&
                        int.tryParse(columnController.text)! > 0) {
                      setState(() {
                        initializeGrid();
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(isInitializedGrid
                ? "Enter characters in grid"
                : "create a grid"),
            SizedBox(
              height: 20,
            ),
            isInitializedGrid
                ? Expanded(
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 1.0,
                          mainAxisSpacing: 1.0,
                          childAspectRatio: 3),
                      itemCount: rows * columns,
                      itemBuilder: (context, index) {
                        int row = index ~/ columns;
                        int column = index % columns;
                        return TextFormField(
                          autofocus: true,
                          controller: controllers[row][column],
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(),
                            filled: true,
                            fillColor: highlightedCells[row][column]
                                ? Colors.yellow
                                : Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
            isInitializedGrid
                ? TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        labelText: 'Enter characters to search in grid'),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            isInitializedGrid
                ? SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              highlightedCells = List.generate(
                                  rows, (_) => List.filled(columns, false));
                              isValidSearch();
                            });
                          },
                          child: Text('Search'),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            isInitializedGrid = false;
                            setState(() {});
                          },
                          child: Text('Reset'),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
