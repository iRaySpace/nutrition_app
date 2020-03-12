import 'package:flutter/material.dart';
import 'package:nutrition_app/core/models/description_model.dart';
import 'package:nutrition_app/core/repositories/intake_repository.dart';

class ProfileDescriptionScreen extends StatefulWidget {
  ProfileDescriptionScreen({
    Key key,
    @required this.name,
  }) : super(key: key);

  final String name;

  @override
  _ProfileDescriptionScreenState createState() => _ProfileDescriptionScreenState();
}

class _ProfileDescriptionScreenState extends State<ProfileDescriptionScreen> {
  DescriptionModel _descriptionModel;
  
  @override
  void initState() {
    super.initState();
    _descriptionModel = IntakeRepository().getDescription(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF56C596),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF56C596),
              Color(0xFF7BE495),
            ],
          )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.fastfood,
                  size: 128.0,
                ),
                SizedBox(height: 35.0),
                Text(
                  _descriptionModel.category,
                  style: TextStyle(
                    fontSize: 32.0,
                  ),
                ),
                SizedBox(height: 25.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    _descriptionModel.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
