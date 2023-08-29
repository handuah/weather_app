import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

import '../utils/constants.dart';

class CurrentWeather extends StatefulWidget {
  const CurrentWeather({super.key});

  @override
  State<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  final TextEditingController _cityCountryCon = TextEditingController();

  Map? weatherInfo;
  Map? forecastInfo;

  List weatherData = [];
  List forecastData = [];

  Future getCurrentWeather(String location) async {
    var res = await http.get(
      Uri.parse('$base_url/current.json?q=$location&key=$API_KEY'),
    );
    var jsonbody = res.body;
    var jsonData = jsonDecode(jsonbody);

    print(jsonData.runtimeType);

    setState(() {
      weatherInfo = jsonData as Map;
    });
    weatherData = weatherInfo!.entries.map((e) => weatherInfo).toList();
    // ignore: avoid_print
    print('Weatherdata here --> $weatherData');
  }

  Future getForecastWeather(String location) async {
    var res = await http.get(
      Uri.parse('$base_url/forecast.json?q=$location&days=8&key=$API_KEY'),
    );
    var jsonbody = res.body;
    var jsonData = jsonDecode(jsonbody);

    print(jsonData.runtimeType);

    setState(() {
      forecastInfo = jsonData as Map;
    });
    forecastData = forecastInfo!.entries.map((e) => forecastInfo).toList();
    // ignore: avoid_print
    print('ForeCast here --> $forecastData');
    print(forecastData.length);
  }

  bool searching = false;

  @override
  void initState() {
    super.initState();

    //on initial set the location to Accra
    getCurrentWeather('Accra');
    getForecastWeather('Accra');
  }

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
                            getCurrentWeather(_cityCountryCon.text);
                            getForecastWeather(_cityCountryCon.text);
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
                    height: size.height * 0.04,
                  ),
                  Text(
                    '${weatherData[0]['location']['name']} , ${weatherData[0]['location']['country']}',
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
                    height: size.height * 0.3,
                    child: OverflowBox(
                      minHeight: size.height * 0.3,
                      maxHeight: size.height * 0.3,
                      child: cloudy,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  // for (var weather in weatherData)
                  Text(
                    '${weatherData[0]['current']['temp_c']}\u00b0C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.040,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Text(
                    '${weatherData[0]['current']['condition']['text']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.022,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wind_power_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            '${weatherData[0]['current']['wind_kph']}km',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.022,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.water_drop_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            '${weatherData[0]['current']['wind_kph']}km',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.022,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.watch_outlined,
                            color: Colors.white,
                          ),
                          Text(
                            Jiffy.parse(weatherData[0]['location']['localtime']
                                    .toString())
                                .Hm,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.022,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Text(
                        'Daily Forecast',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.018,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                  Container(
                    height: size.height * 0.2,
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.02,
                        vertical: size.height * 0.01,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) {
                        return Container(
                          height: size.height * 0.2,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.height * 0.1,
                                child: OverflowBox(
                                  minHeight: size.height * 0.1,
                                  maxHeight: size.height * 0.1,
                                  child: cloudy,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.005,
                              ),
                              Text(
                                Jiffy.parse(forecastData[index]['forecast']
                                        ['forecastday'][index]['date'])
                                    .MMMMEEEEd
                                    .split(',')[0],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.018,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text(
                                '${forecastData[index]['forecast']['forecastday'][index]['day']['maxtemp_c']}\u00b0C',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.018,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                            ],
                          ),
                        );
                      }),
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: size.width * 0.02,
                        );
                      },
                      itemCount: forecastData.length,
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
