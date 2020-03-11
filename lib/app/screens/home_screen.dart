import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutrition_app/app/screens/food_detail_screen.dart';
import 'package:nutrition_app/app/screens/widgets/food_detail_card.dart';
import 'package:nutrition_app/app/shared_widgets/app_drawer.dart';
import 'package:nutrition_app/core/models/intake_model.dart';
import 'package:nutrition_app/core/repositories/intake_repository.dart';
import 'package:nutrition_app/core/repositories/profile_repository.dart';
import 'widgets/gradient_appbar.dart';
import 'food_screen.dart';
import 'recommendation_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _caloriesTaken = 0.0;
  double _recommendedCalories = 0.0;
  List<IntakeModel> _intakesToday = [];
  List<Map> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _caloriesTaken = IntakeRepository().getCaloriesTakenToday();
    _intakesToday = IntakeRepository().getIntakesToday();
    _recommendedCalories = ProfileRepository().getRecommendedIntake();
    _recommendations = IntakeRepository()
        .getRecommendations(_recommendedCalories);
  }
  
  void _addNewIntake() {
    double remaining = _recommendedCalories - _caloriesTaken;
    if (remaining < 0 || _recommendations.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RecommendationScreen(
          recommendations: _recommendations,
        )),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => FoodScreen()),
      );
    }
  }

  List<Widget> _buildFoodsTaken() {
    List<Widget> foodsTaken = _intakesToday.map((intake) =>
      InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) =>
                FoodDetailScreen(name: intake.foodName, disableAdd: true)),
          );
        },
        child: FoodDetailCard(
          title: '= ${intake.totalCalories.toStringAsFixed(2)} calories',
          content: intake.foodName,
        ),
      )
    ).toList();

    if (foodsTaken.length > 0) {
      return <Widget>[
        Text(
          'Foods Taken',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 21.0,
            color: Colors.black45,
          ),
        ),
        SizedBox(height: 15.0),
      ] + foodsTaken;
    }

    return [
      Text(
        'Foods Taken',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 21.0,
          color: Colors.black45,
        ),
      ),
      SizedBox(height: 15.0),
      Text(
        'Please log your intakes.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black45,
        ),
      ),
    ];
  }

  Color _getColorCalorieTaken() {
    // Range for indicator
    double lessThan = _recommendedCalories - 200;
    if (_caloriesTaken > lessThan) {
      return Colors.red;
    }
    return Colors.tealAccent[700];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        beginColor: Colors.greenAccent[400],
        endColor: Colors.tealAccent[700],
      ),
      appBar: GradientAppBar(
        title: Text('Home'),
        beginColor: Colors.greenAccent[400],
        endColor: Colors.tealAccent[700],
      ),
      body: Container(
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 35.0),
              Text(
                'Calorie Taken',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21.0,
                  fontWeight: FontWeight.w500,
                  color: _getColorCalorieTaken(),
                ),
              ),
              Text(
                _caloriesTaken.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.w700,
                  color: _getColorCalorieTaken(),
                )
              ),
              SizedBox(height: 35.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(width: 5.0, color: Colors.blueAccent),
                    bottom: BorderSide(width: 1.0, color: Colors.black12),
                    left: BorderSide(width: 1.0, color: Colors.black12),
                    right: BorderSide(width: 1.0, color: Colors.black12),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    Text(
                      'Recommended Daily Calorie',
                      style: TextStyle(
                        fontSize: 21.0,
                        color: Colors.black45,
                      ),
                    ),
                    Text(
                      _recommendedCalories.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 36.0,
                        color: Colors.teal,
                      )
                    ),
                    SizedBox(height: 15.0),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildFoodsTaken(),
                ),
              ),
              SizedBox(height: 35.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3.0,
        child: Icon(Icons.add),
        backgroundColor: Colors.tealAccent[700],
        onPressed: _addNewIntake,
      ),
    );
  }
}
