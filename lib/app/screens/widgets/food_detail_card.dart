import 'package:flutter/material.dart';


class FoodDetailCard extends StatelessWidget {
  final String title;
  final String content;
  
  FoodDetailCard({
    @required this.title,
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.0),
        side: BorderSide(
          color: Colors.black26,
          width: 1.0
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Text(
              this.content,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
              )  
            ),
            Text(
              this.title,
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}
