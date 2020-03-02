import 'package:flutter/material.dart';
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
              Color(0xFFFFE729),
              Color(0xFFFF8270),
            ],
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.fastfood,
                size: 128.0,
                color: Colors.white,
              ),
              SizedBox(height: 35.0),
              Text(
                'Excess ${recommendation['category']} of ${recommendation['value'].round()}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text('${recommendation['recommendation']}'),
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
