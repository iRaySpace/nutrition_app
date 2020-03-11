import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:nutrition_app/app/screens/food_screen.dart';


class RecommendationScreen extends StatefulWidget {
  RecommendationScreen({@required this.recommendations});

  final List<Map> recommendations;

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  int _currentPage = 0;
  int _pages = 0;

  @override
  void initState() {
    super.initState();
    _vibrate();
  }

  Future<void> _vibrate() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
  }

  void _onContinue(BuildContext context) {
    // pages are zero-index
    if ((_currentPage + 1) != _pages) {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Please read until the last page.'),
      ));
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => FoodScreen()),
    ); 
  }

  List<Widget> _buildPages() {
    _pages = 0;
    return widget.recommendations.map((recommendation) {
      _pages = _pages + 1;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFEA4C46),
              Color(0xFFDC1C13),
            ],
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error,
                size: 128.0,
                color: Colors.white,
              ),
              SizedBox(height: 35.0),
              Text(
                'Excess ${recommendation['category']} of ${recommendation['value'].round()}!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                ),
              ),
              SizedBox(height: 25.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  '${recommendation['recommendation']}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            children: _buildPages(),
            onPageChanged: (value) => 
              setState(() => _currentPage = value),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                  Text(
                    '${_currentPage + 1 } of $_pages',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Builder(
                    builder: (context) => FlatButton(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => _onContinue(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
