import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class CurrentWeather extends StatefulWidget {
  const CurrentWeather({super.key});

  @override
  State<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  final TextEditingController _cityCountryCon = TextEditingController();

  List weatherData = [];

  Future getCurrentWeather(String? citiName, String countryName) async {
    var res = await http.get(
      Uri.parse(
          '$base_url/current?city=$citiName&country=$countryName&key=$API_KEY'),
    );
    var jsonbody = res.body;
    var jsonData = jsonDecode(jsonbody);

    print(jsonData.runtimeType);

    setState(() {
      weatherData = jsonData['data'];
    });
    // ignore: avoid_print
    print('Weatherdata here --> $weatherData');
  }

  bool searching = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://t3.ftcdn.net/jpg/00/86/56/12/360_F_86561234_8HJdzg2iBlPap18K38mbyetKfdw1oNrm.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.02,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                    width: size.width,
                    child: TextField(
                      controller: _cityCountryCon,
                      onChanged: (value) {
                        // if (value.isNotEmpty) {
                        //   if (value.contains(',')) {
                        //     getCurrentWeather(
                        //         value.split(',')[0], value.split(',')[1]);
                        //   }
                        // }
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter City or Country',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.amber),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            getCurrentWeather(
                                _cityCountryCon.text.split(',')[0],
                                _cityCountryCon.text..split(',')[1]);
                          },
                          child: Container(
                            height: size.height * 0.07,
                            width: size.width * 0.17,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: const Icon(
                              Icons.search_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        prefixIcon: const Icon(Icons.pin_drop_outlined),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Text(
                    'Accra, Ghana',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.028,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SizedBox(
                    height: 200,
                    child: OverflowBox(
                      minHeight: 200,
                      maxHeight: 200,
                      child: cloudy,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    '29 Degrees Celsius',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.028,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    'Very Cloudy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.028,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
