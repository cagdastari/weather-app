import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var sehir;
  var sicaklik;
  var locationData;
  var woeid;
  var data;
  var temp;
  var hava = 's';
  var currentLoc;
  late Position position;

  Future<void> getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
    );
    currentLoc = await http.get(Uri.parse(
        'https://www.metaweather.com/api/location/search/?lattlong=${position.latitude},${position.longitude}'));
    currentLoc = jsonDecode(currentLoc.body);
    sehir = currentLoc[1]['title'];
    print(sehir);
  }

  Future<void> getLocationData(var sehir) async {
    locationData = await http.get(Uri.parse(
        'https://www.metaweather.com/api/location/search/?query=$sehir'));
    var parsedData = jsonDecode(locationData.body);
    woeid = parsedData[0]['woeid'];
  }

  Future<void> getTempData(var sehirid) async {
    data = await http
        .get(Uri.parse('https://www.metaweather.com/api/location/$sehirid/'));
    var dataDecode = jsonDecode(data.body);
    setState(() {
      hava = dataDecode['consolidated_weather'][0]["weather_state_abbr"];
      sicaklik = dataDecode['consolidated_weather'][0]["the_temp"].round();
    });
    sicaklik = '$sicaklik°';
  }

  void summon() async {
    await getCurrentLocation();
    await getLocationData(sehir);
    getTempData(woeid);
  }

  void searchSummon() async {
    await getLocationData(sehir);
    getTempData(woeid);
  }

  @override
  void initState() {
    summon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/$hava.jpg'))),
      child: sicaklik == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: Image.network(
                          'https://www.metaweather.com/static/img/weather/png/$hava.png'),
                    ),
                    Text(
                      '$sicaklik',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 70),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$sehir',
                          style: TextStyle(fontSize: 30),
                        ),
                        IconButton(
                            onPressed: () async {
                              sehir = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage()));
                              sehir = sehir.toUpperCase();
                              searchSummon();
                            },
                            icon: Icon(Icons.search))
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
