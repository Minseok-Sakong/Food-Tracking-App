import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:numberpicker/numberpicker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(MyApp());
}

class Scan extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: ScanPage(title: 'Food Tracker'),
    );
  }
}

class ScanPage extends StatefulWidget {
  ScanPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? scanResult;
  String? counter;
  String? foodName;
  String? userName;

  final fireStorage = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:
        Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              scanResult == null
                  ? 'Scan a barcode'
                  : 'FDC ID = $scanResult',
            ),
            Text(
              //'$_counter',
              counter == null
                  ? ' '
                  : 'Food Name = $foodName',
              //style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              foodName == null
                  ? ' '
                  : 'Calories = $counter',
            ),
            FlatButton(
              onPressed: updateData,
              child: Text(
                  "Get"
              ),

            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanBarcode,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  Future scanBarcode() async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666",
        "Cancel",
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      scanResult = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() => this.scanResult = scanResult);
    fetchnutri();
  }
  void fetchnutri() async {
    var headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
    };

    var params = {
      'api_key': 'K9C4dtMFuLkjMk0GXA9RRp4j7A5i4BagdxWfZAmv',
    };
    var query = params.entries.map((p) => '${p.key}=${p.value}').join('&');

    var data = '{"query":"${scanResult}"}';

    var res = await http.post(Uri.parse('https://api.nal.usda.gov/fdc/v1/foods/search?$query'), headers: headers, body: data);
    if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
    //print(res.body);
    var jsonData = res.body;
    var test = json.decode(jsonData);
    //counter = test['nutrientNumber'];
    print(test["foods"][0]["foodNutrients"][3]["value"]);
    counter = test["foods"][0]["foodNutrients"][3]["value"].toString();
    foodName = test["foods"][0]["description"];
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
    });
  }
  Future<void> updateData() async {
    fireStorage.collection("ec463").add(
        {
          "Product" : "$foodName",
          "Calories" : "$counter kcal",
          "Barcode Number" : "$scanResult"
        }).then((value){
      print(value.id);
    });
  }

  Future<void> getList() async {
    fireStorage.collection("ec463").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
      });
    });
  }
}
