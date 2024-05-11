import 'package:flutter/material.dart';

class NewsBlogDisplayScreen extends StatefulWidget {
  const NewsBlogDisplayScreen(this.object);

  final dynamic object;

  @override
  _NewsBlogDisplayScreenState createState() => _NewsBlogDisplayScreenState();
}

class _NewsBlogDisplayScreenState extends State<NewsBlogDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.object.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.object.description,
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
