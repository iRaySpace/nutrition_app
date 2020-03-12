import 'package:flutter/material.dart';
import 'package:nutrition_app/app/screens/profile_description_screen.dart';
import 'package:nutrition_app/app/screens/widgets/gradient_appbar.dart';
import 'package:nutrition_app/app/shared_widgets/app_drawer.dart';
import 'package:nutrition_app/core/models/profile_intake_model.dart';
import 'package:nutrition_app/core/repositories/profile_repository.dart';
import '../../core/repositories/intake_repository.dart';
import 'widgets/profile_info_card.dart';


final info = [
  'Saturated',
  'Transfat',
  'Carbohydrates',
  'Added Sugar',
  'Sodium',
  'Protein',
];


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileIntakeModel _recommended;
  ProfileIntakeModel _taken;

  @override
  void initState() {
    super.initState();
    final recommendedCalories = ProfileRepository().getRecommendedIntake();
    _recommended = IntakeRepository().getRecommendedIntake(recommendedCalories);
    _taken = IntakeRepository().getTakenIntake();
  }

  Text _getSurplusDeficitText(double recommended, double taken) {
    final double intakeDifference = recommended - taken;
    if (intakeDifference < 0) {
      return Text(
        'Remaining: ${intakeDifference.toStringAsFixed(2)}',
        style: TextStyle(color: Colors.white),
      );
    }
    return Text(
      'Remaining: ${intakeDifference.toStringAsFixed(2)}',
      style: TextStyle(color: Colors.white),
    );
  }

  Color _getColor(double recommended, double taken) {
    final double intakeDifference = recommended - taken;
    if (intakeDifference < 0) {
      return Colors.red;
    }
    return Colors.green;
  }

  void _navigateToDescription(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) =>
        ProfileDescriptionScreen(name: category)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        beginColor: Colors.greenAccent[400],
        endColor: Colors.tealAccent[700],
      ),
      appBar: GradientAppBar(
        title: Text('Profile Intake'),
        beginColor: Colors.greenAccent[400],
        endColor: Colors.tealAccent[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileInfoCard(
              title: 'Saturated Fat (mg)',
              subtitle: 'Recommended: ${_recommended.saturatedFat.toStringAsFixed(2)}',
              secondSubtitle: 'Current: ${_taken.saturatedFat.toStringAsFixed(2)}',
              othersText: _getSurplusDeficitText(_recommended.saturatedFat, _taken.saturatedFat),
              color: _getColor(_recommended.saturatedFat, _taken.saturatedFat),
              textColor: Colors.white,
              onTap: () => _navigateToDescription('Saturated Fat'),
            ),
            ProfileInfoCard(
              title: 'Trans Fat (mg)',
              subtitle: 'Recommended: ${_recommended.transFat.toStringAsFixed(2)}',
              secondSubtitle: 'Current: ${_taken.transFat.toStringAsFixed(2)}',
              othersText: _getSurplusDeficitText(_recommended.transFat, _taken.transFat),
              color: _getColor(_recommended.transFat, _taken.transFat),
              textColor: Colors.white,
              onTap: () => _navigateToDescription('Trans Fat'),
            ),
            ProfileInfoCard(
              title: 'Carbohydrates (g)',
              subtitle: 'Recommended: ${_recommended.carbs.toStringAsFixed(2)}',
              secondSubtitle: 'Current: ${_taken.carbs.toStringAsFixed(2)}',
              othersText: _getSurplusDeficitText(_recommended.carbs, _taken.carbs),
              color: _getColor(_recommended.carbs, _taken.carbs),
              textColor: Colors.white,
              onTap: () => _navigateToDescription('Carbohydrates'),
            ),
            ProfileInfoCard(
              title: 'Added Sugar (g)',
              subtitle: 'Recommended: ${_recommended.addedSugar.toStringAsFixed(2)}',
              secondSubtitle: 'Current: ${_taken.addedSugar.toStringAsFixed(2)}',
              othersText: _getSurplusDeficitText(_recommended.addedSugar, _taken.addedSugar),
              color: _getColor(_recommended.addedSugar, _taken.addedSugar),
              textColor: Colors.white,
              onTap: () => _navigateToDescription('Added Sugar'),
            ),
            ProfileInfoCard(
              title: 'Sodium (mg)',
              subtitle: 'Recommended: ${_recommended.sodium.toStringAsFixed(2)}',
              secondSubtitle: 'Current: ${_taken.sodium.toStringAsFixed(2)}',
              othersText: _getSurplusDeficitText(_recommended.sodium, _taken.sodium),
              color: _getColor(_recommended.sodium, _taken.sodium),
              textColor: Colors.white,
              onTap: () => _navigateToDescription('Sodium'),
            ),
            ProfileInfoCard(
              title: 'Protein (g)',
              subtitle: 'Recommended: ${_recommended.protein.toStringAsFixed(2)}',
              secondSubtitle: 'Current: ${_taken.protein.toStringAsFixed(2)}',
              othersText: _getSurplusDeficitText(_recommended.protein, _taken.protein),
              color: _getColor(_recommended.protein, _taken.protein),
              textColor: Colors.white,
              onTap: () => _navigateToDescription('Proteins'),
            ),
          ],
        ),
      ),
    );
  }
}
