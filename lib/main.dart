import 'package:flutter/material.dart';
import 'package:my_cst2335_labs/dao/ToDoDAO.dart';
import 'package:my_cst2335_labs/dao/database.dart';
import 'package:my_cst2335_labs/dao/ToDoEntity.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController textController;
  List<ToDo>? items;
  ToDoDAO? toDoDao;
  ToDo? selectedItem;
  var size, height, width;

  Widget inputBox() => Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      // Button to add content of text field
      ElevatedButton(onPressed: () {
        setState(() {
          var item = ToDo(textController.text);
          items!.add(item); // add to list in memory
          toDoDao?.insertItem(item); // save item to database
          textController.text = "";
        });
      }, child: const Text("Add")),
      // Field for text input
      Expanded(child: TextField(controller: textController,
        decoration: const InputDecoration(
            hintText: "Enter a search term",
            border: OutlineInputBorder()
        ),
      ))
    ],
  );

  Widget toDoList() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      inputBox(),
      Expanded(child:
      // If to-do list is empty, display appropriate text. Otherwise, display list
      items == null || items!.isEmpty ? const Text("There are no items in the list") :
      ListView.builder(
          itemCount: items!.length,
          itemBuilder: (context, rowNum) =>
          // Uses gesture detector for item deletion
          GestureDetector(
            // Entry in list
            child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Item ${rowNum+1}:"), Text(items![rowNum].entry)
                ]),
            // select list object on tap
            onTap: () {
              setState(() {
                selectedItem = items![rowNum];
              });
            },
          )
        )
      )
    ],
  );

  Widget detailsPage() => Column(
    // return empty list of widgets if no item has been selected
    children: selectedItem == null ? [] : [
      Text("Name: ${selectedItem!.entry}"),
      Text("ID: ${selectedItem!.id}"),
      ElevatedButton(onPressed: () {

        },
        child: const Text("Delete",
          style: TextStyle(
            color: Colors.red
          )
        )
      )
    ],
  );

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    // load to do items from database
    $FloorAppDatabase.databaseBuilder('app_database.db').build().then((database) {
      toDoDao = database.toDoDAO;
      toDoDao!.getList().then((list) {
        setState(() {
          items = list;
        });
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        // Check if in landscape or portrait mode, and screen is wide enough for
        // Master-Detail pattern
        child: width > height && width > 720 ?
            Row(children: [
              Expanded(flex: (width/2).round(), child: toDoList()),
              Expanded(flex: (width/2).round(), child: detailsPage())
            ])
            : selectedItem == null ? toDoList() : detailsPage()
      ),
    );
  }
}
