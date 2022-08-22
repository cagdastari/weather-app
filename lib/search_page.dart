import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final myController = TextEditingController();
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  var response;
  Future<void> checkData() async {
    response = await http.get(Uri.parse(
        'https://www.metaweather.com/api/location/search/?query=${myController.text}'));
    jsonDecode(response.body).isEmpty
        ? _showDialog()
        : Navigator.pop(context, myController.text);
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Uygun bir şehir ismi giriniz"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/search.jpg'))),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
            child: Column(
          children: [
            TextFormField(
              controller: myController,
              style: TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: 'Şehir Seçiniz',
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
            SizedBox(height: 5),
            TextButton(
                onPressed: () {
                  checkData();
                },
                child: Text('Şehri Seç'))
          ],
        )),
      ),
    );
  }
}
