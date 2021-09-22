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

import 'fetch_data.dart';



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
      title: 'My Recipe Pal',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: ScanPage(title: 'My Recipe Pal'),
    );
  }
}

class ScanPage extends StatefulWidget {
  ScanPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? scanResult;
  String? counter;
  String? foodName;
  String? userName;
  String? recipeDatabase;
  String? servingDatabase;
  bool recipeadded = false;

  final fireStorage = FirebaseFirestore.instance;
  final recipeName = TextEditingController();
  final serving = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              MaterialPageRoute route = MaterialPageRoute(builder: (context) => fetchData());
              Navigator.push(context, route);
            },
            child: Text("View Recipe/Daily Food Intake"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body:
        Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: recipeName,
            decoration:  InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a recipe name or dailyfoodintake',
              suffixIcon: IconButton(
                icon: Icon(Icons.add_reaction_rounded),
                onPressed:() {
                  recipeDatabase = recipeName.text.toString();
                  showDialog(context: context, builder: (context){

                    return AlertDialog(content: Text('New Recipe has beed added'));
                  },
                  );
                  setState(() => recipeadded = true);
                  //updateRecipe();
                },
              ),
            ),
            ),

            Spacer(),
            Text(
              recipeadded == false
                  ? ''
                  : 'Now scan products for the recipe',
              style: Theme.of(context).textTheme.headline6,
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
            TextField(
              controller: serving,
              decoration:  InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Scan & Enter Servings',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add_reaction_rounded),
                  onPressed:() {
                    servingDatabase = serving.text.toString();
                    showDialog(context: context, builder: (context){
                      return AlertDialog(content: Text('New ingredient added to $recipeDatabase'));
                    },
                    );
                    //setState(() => recipeadded = true);
                    updateData();
                  },
                ),
              ),
            ),

            Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
        recipeadded == false
        ? null
        : scanBarcode,
        label: Text('Scan Barcode'),
        icon: Icon(Icons.add),
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

    });
  }
  Future<void> updateData() async {
    fireStorage.collection("$recipeDatabase").doc("$foodName").set(
        {
          "Food Name" : "$foodName",
          "Calories" : "$counter",
          "Serving" : "$servingDatabase"
        });
  }
  Future<void> updateRecipe() async {
    fireStorage.collection("$recipeDatabase").add(
        {}).then((value){
      print(value.id);
    });
  }
}

