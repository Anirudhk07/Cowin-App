import 'package:cowin/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new _HomeScreen());
  }
}

class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Title"),
      ),
      body: new Center(
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) => {
                postRequest3(value),
              },
              decoration:
                  new InputDecoration(labelText: "Enter your Beneficary Id"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
            ),
          ],
        ),
      ),
    );
  }
}
