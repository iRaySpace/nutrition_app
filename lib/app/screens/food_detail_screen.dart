import 'package:flutter/material.dart';
import 'package:nutrition_app/core/models/food_model.dart';
import 'package:nutrition_app/core/repositories/food_repository.dart';
import 'widgets/food_details_column.dart';
import 'food_screen.dart';


class FoodDetailScreen extends StatefulWidget {
  final String name;
  FoodDetailScreen({
    Key key,
    @required this.name,
  }) : super(key: key);
  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  FoodModel _food;

  @override
  void initState() {
    super.initState();
    _food = FoodRepository().getFood(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.blueAccent[400],
              Colors.tealAccent[700],
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child: Container(
                height: 163,
                child: Center(
                  child: Text(
                    _food.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 28.0,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(63.0),
                      topRight: Radius.circular(63.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 45.0,
                      horizontal: 25.0,
                    ),
                    child: FoodDetailsColumn(
                      calories: _food.totalCalories.toStringAsFixed(2),
                      totalFat: _food.totalFat.toStringAsFixed(2),
                      saturatedFat: _food.saturatedFat.toStringAsFixed(2),
                      transFat: _food.transFat.toStringAsFixed(2),
                      cholesterol: _food.cholesterol.toStringAsFixed(2),
                      sodium: _food.sodium.toStringAsFixed(2),
                      totalCarbs: _food.totalCarbs.toStringAsFixed(2),
                      dietaryFiber: _food.dietaryFiber.toStringAsFixed(2),
                      totalSugars: _food.sugars.toStringAsFixed(2),
                      addedSugars: _food.addedSugars.toStringAsFixed(2),
                      protein: _food.protein.toStringAsFixed(2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        FlatButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.redAccent),  
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Add'),
          onPressed: () {
            print('Added');
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => FoodScreen()),
            );
          }
        ),
      ],
    );
  }
}
