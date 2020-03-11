import 'package:flutter/material.dart';
import 'package:nutrition_app/core/models/food_model.dart';
import 'package:nutrition_app/core/repositories/food_repository.dart';
import 'widgets/food_card.dart';
import 'food_detail_screen.dart';

class FoodScreen extends StatefulWidget {
  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  List<FoodModel> _foods;

  void _navigateToDetail(String foodName) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FoodDetailScreen(name: foodName)),
    );
  }

  List<Widget> _buildFoodCards() {
    _foods.sort((a, b) => a.name.compareTo(b.name));
    return _foods.map((food) =>
      FoodCard(
        title: food.name,
        subtitle: '${food.totalCalories} Calories',
        onTap: () => _navigateToDetail(food.name),
      )
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _foods = FoodRepository().getFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.greenAccent[400],
              Colors.tealAccent[700],
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child: Container(
                height: 163.0,
                child: Center(
                  child: Text(
                    'Select Food',
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
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 25.0,
                      horizontal: 11.0,
                    ),
                    child: Column(children: _buildFoodCards()),
                  ),
                ),
              ), 
            ),
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        FlatButton(
          child: Text('Back'),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        )
      ],
    );
  }
}
