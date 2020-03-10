import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:nutrition_app/core/models/profile_intake_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrition_app/core/models/intake_model.dart';
import 'package:nutrition_app/core/models/recommendation_model.dart';


class IntakeRepository {
  SharedPreferences _prefs;
  List<IntakeModel> _intakes;
  List<RecommendationModel> _recommendations;

  // singleton
  IntakeRepository._internal() : _intakes = [], _recommendations = [];
  static IntakeRepository _instance = IntakeRepository._internal();
  factory IntakeRepository() => _instance;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadRecommendations();
    _loadData();
  }

  Future<void> addIntake(IntakeModel intake) async {
    _intakes.add(intake);
    final List<Map> intakes = _intakes.map((intake) => intake.toJson()).toList();
    _prefs.setString('intakeData', json.encode(intakes));
  }

  double getCaloriesTaken() {
    double caloriesTaken = 0.0;
    _intakes.forEach((intake) {
      caloriesTaken = caloriesTaken + intake.totalCalories;
    });
    return caloriesTaken;
  }

  double getCaloriesTakenToday() {
    double caloriesTaken = 0.0;
    final formatter = DateFormat('yyyy-MM-dd');
    final String now = formatter.format(DateTime.now());
    _intakes.forEach((intake) {
      final postingDate = formatter.format(intake.postedOn);
      if (postingDate == now) {
        caloriesTaken = caloriesTaken + intake.totalCalories;
      }
    });
    return caloriesTaken;
  }

  double _getRecommended(calories, category) {
    if (category == 'Fat') {
      return calories * 0.3 / 9;
    } else if (category == 'Sat') {
      return calories * 0.1 / 9;
    } else if (category == 'Trans') {
      return calories * 0.01 / 9;
    } else if (category == 'Carbs') {
      return calories * 0.5 / 4;
    } else if (category == 'Added Sugar') {
      return calories * 0.1 / 4;
    } else if (category == 'Sodium') {
      return calories * 1.15;
    } else if (category == 'Protein') {
      return calories * 0.2 / 4;
    }
    return 0.0;
  }

  ProfileIntakeModel getRecommendedIntake(calories) {
    return ProfileIntakeModel(
      fat: _getRecommended(calories, 'Fat'),
      saturatedFat: _getRecommended(calories, 'Sat'),
      transFat: _getRecommended(calories, 'Trans'),
      carbs: _getRecommended(calories, 'Carbs'),
      addedSugar: _getRecommended(calories, 'Added Sugar'),
      sodium: _getRecommended(calories, 'Sodium'),
      protein: _getRecommended(calories, 'Protein'),
    );
  }

  ProfileIntakeModel getTakenIntake() {
    double takenFat = 0.0;
    double takenSaturatedFat = 0.0;
    double takenTransFat = 0.0;
    double takenCarbs = 0.0;
    double takenAddedSugar = 0.0;
    double takenSodium = 0.0;
    double takenProtein = 0.0;
    final intakeToday = getIntakesToday();
    intakeToday.forEach((intake) {
      takenFat = takenFat + intake.totalFat;
      takenSaturatedFat = takenSaturatedFat + intake.saturatedFat;
      takenTransFat = takenTransFat + intake.transFat;
      takenCarbs = takenCarbs + intake.totalCarbs;
      takenAddedSugar = takenAddedSugar + intake.addedSugars;
      takenSodium = takenSodium + intake.sodium;
      takenProtein = takenProtein + intake.protein;
    });
    return ProfileIntakeModel(
      fat: takenFat,
      saturatedFat: takenSaturatedFat,
      transFat: takenTransFat,
      carbs: takenCarbs,
      addedSugar: takenAddedSugar,
      sodium: takenSodium,
      protein: takenProtein,
    );
  }

  Map<String, double> getTakenByWeek(category) {
    Map<String, double> takenByWeek = {};
    
    List<String> weekdates = _getDateRangeFromNow(6);
    weekdates.forEach((weekdate) => takenByWeek[weekdate] = 0.0);

    final formatter = DateFormat('MM-dd');
    _intakes.forEach((intake) {
      String intakeDate = formatter.format(intake.postedOn);
      if (takenByWeek.containsKey(intakeDate) == true) {
        takenByWeek[intakeDate] = takenByWeek[intakeDate] + 
          _getIntakeByCategory(intake, category);
      }
    });

    return takenByWeek;
  }

  Map<String, double> getTakenByMonthly(category) {
    Map<String, double> takenByMonthly = {};
    List<String> monthdates = _getMonthRangeFromNow(5);
    monthdates.forEach((monthdate) => takenByMonthly[monthdate] = 0.0);

    final formatter = DateFormat('MM-yyyy');
    _intakes.forEach((intake) {
      String intakeDate = formatter.format(intake.postedOn);
      if (takenByMonthly.containsKey(intakeDate) == true) {
        takenByMonthly[intakeDate] = takenByMonthly[intakeDate] + 
          _getIntakeByCategory(intake, category);
      }
    });
    return takenByMonthly;
  }

  List<IntakeModel> getIntakesToday() {
    List<IntakeModel> intakes = [];
    final formatter = DateFormat('yyyy-MM-dd');
    final String now = formatter.format(DateTime.now());
    _intakes.forEach((intake) {
      final String postedDate = formatter.format(intake.postedOn);
      if (postedDate == now) {
        intakes.add(intake);
      }
    });
    return intakes;
  }


  ///
  /// Returns the excess of food intakes
  /// 
  List<Map> getRecommendations(calories) {
    final List<Map> recommendations = [];

    final takenIntake = getTakenIntake().toRecommendationsJson();
    final recommendedIntake = getRecommendedIntake(calories)
        .toRecommendationsJson();

    print(takenIntake);
    print(recommendedIntake);
    
    takenIntake.forEach((category, value) {
      final differenceIntake = recommendedIntake[category] - takenIntake[category];
      if (differenceIntake < 0) {
        final recommendationData = _recommendations.firstWhere((recommendation) =>
          recommendation.category == category).toJson();
        recommendationData.addAll({'value': differenceIntake.abs()});
        recommendations.add(recommendationData);
      }
    });

    return recommendations;
  }

  List<String> _getDateRangeFromNow(days) {
    final today = DateTime.now();
    List<DateTime> dateTimes = List.generate(days, (i) =>
      today.subtract(Duration(days: days - i)));
    dateTimes.add(today);
    final formatter = DateFormat('MM-dd');
    return dateTimes.map((dateTime) =>
      formatter.format(dateTime)
    ).toList();
  }

  List<String> _getMonthRangeFromNow(months) {
    final today = DateTime.now();
    List<DateTime> dateTimes = List.generate(months, (i) {
      return DateTime(
        today.year,
        today.month - i,
        today.day
      );
    });
    final formatter = DateFormat('MM-yyyy');
    return dateTimes.reversed.map((dateTime) =>
      formatter.format(dateTime)
    ).toList();
  }

  double _getIntakeByCategory(IntakeModel intake, category) {
    if (category == 'Calorie') {
      return intake.totalCalories;
    } else if (category == 'Fat') {
      return intake.totalFat;
    } else if (category == 'Saturated') {
      return intake.saturatedFat;
    } else if (category == 'Trans') {
      return intake.transFat;
    } else if (category == 'Carbohydrates') {
      return intake.totalCarbs;
    } else if (category == 'Added Sugar') {
      return intake.addedSugars;
    } else if (category == 'Sodium') {
      return intake.sodium;
    } else if (category == 'Protein') {
      return intake.protein;
    }
    return 0.0;
  }

  void _loadData() {
    final intakeData = _prefs.getString('intakeData');
    if (intakeData != null) {
      List<dynamic> intakes = json.decode(intakeData);
      _intakes = intakes.map((intake) => IntakeModel.fromJson(intake)).toList();
    }
  }

  Future<void> _loadRecommendations() async {
    String data = await rootBundle.loadString('assets/recommendations.json');
    List<dynamic> recommendations = json.decode(data);
    _recommendations = recommendations.map((recommendation) => RecommendationModel.fromJson(recommendation)).toList();
  }
}
