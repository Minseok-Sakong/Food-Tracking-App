import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class fetchData extends StatefulWidget {
  const fetchData({Key? key}) : super(key: key);

  @override
  _fetchDataState createState() => _fetchDataState();
}

class _fetchDataState extends State<fetchData> {
  String? recipe;
  String? ingredients = '';
  bool isrecipe = false;
  int totalCal = 0;
  final recipeName = TextEditingController();
  final fireStorage = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("View Recipe")

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
          hintText: 'Enter a recipe name',
          suffixIcon: IconButton(
            icon: Icon(Icons.add_reaction_rounded),
            onPressed:() {
              recipe = recipeName.text.toString();
              showDialog(context: context, builder: (context){
                return AlertDialog(content: Text('Ready to fetch $recipe'));
              },
              );
              setState(() => isrecipe = true);
              //updateRecipe();
            },
          ),
        ),
      ),
      Spacer(),
      Text(
        '$ingredients',
        style: Theme.of(context).textTheme.headline6,
      ),
      Text(
        'Total Kcal: $totalCal',
        style: Theme.of(context).textTheme.headline6,
      ),
      Spacer()
      ]

    )
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed:
        isrecipe == false
            ? null
            : getList,
        label: Text('Fetch recipe'),
        icon: Icon(Icons.add),
      ),
    );
  }
  Future<void> getList() async {
    fireStorage.collection("$recipe").get().then((querySnapshot) {
      ingredients = '';
      totalCal = 0;
      querySnapshot.docs.forEach((result) {
        //print(result.data());
        ingredients = (ingredients! + result.data().toString() + '\n')!;
        //var example = json.decode(result.data());
        totalCal = totalCal + (int.parse(result.data()["Calories"])*(int.parse(result.data()["Serving"])));
      });
    });
    setState(() {});
    setState(() {});
  }
}
