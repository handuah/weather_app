import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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
  Map? autoCompleteInfo;

  List weatherData = [];
  List forecastData = [];
  List autoCompleteList = [];

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

  Future getAutoComplete(String location) async {
    var res = await http.get(
      Uri.parse('$base_url/search.json?q=$location&days=8&key=$API_KEY'),
    );
    var jsonbody = res.body;
    var jsonData = jsonDecode(jsonbody);

    print(jsonData.runtimeType);

    setState(() {
      autoCompleteList = jsonData;
    });
    // autoCompleteList = autoCompleteInfo!.entries.map((e) => autoCompleteInfo).toList();
    // ignore: avoid_print
    print('AutoComplete here --> $autoCompleteList');
    print(autoCompleteList.length);
  }

  bool searching = false;

  @override
  void initState() {
    super.initState();

    //on initial set the location to Accra
    getCurrentWeather('Johannesburg');
    getForecastWeather('Johannesburg');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: weatherData.isNotEmpty && forecastData.isNotEmpty
            ? SingleChildScrollView(
                child: Container(
                  height: size.height,
                  width: size.width,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    backgroundBlendMode: BlendMode.darken,
                    image: DecorationImage(
                     
                      image: NetworkImage(
                        'https://www.huntsmarine.com.au/cdn/shop/articles/Looking-at-the-clouds-can-help-you-predict-bad-weather-_697_6052888_0_14103285_1000_1024x1024.jpg?v=1500990343',
            
                      ),
                      fit: BoxFit.cover,
                    
                    ),
                  ),
                  // color: HexColor('#023e8a'),

                  child: Stack(
                    children: [
                      Padding(
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
                                // keyboardType: searching? TextInputType.text : TextInputType.none,
                                onChanged: (value) {
                                  if (value.isNotEmpty &&
                                      value.characters.length > 3) {
                                    setState(() {
                                      searching = true;
                                    });
                                    getAutoComplete(value);
                                  }
                                  if (value.isEmpty) {
                                    setState(() {
                                      searching = false;
                                    });
                                  }
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
                                      setState(() {
                                        _cityCountryCon.clear();
                                      });
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
                                  prefixIcon:
                                      const Icon(Icons.pin_drop_outlined),
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

                            weatherData[0]['current']['condition']['text'] == 'Mist' ||
                                    weatherData[0]['current']['condition']['text'] ==
                                        'Fog'
                                ? SizedBox(
                                    height: size.height * 0.3,
                                    child: OverflowBox(
                                      minHeight: size.height * 0.3,
                                      maxHeight: size.height * 0.3,
                                      child: mist,
                                    ),
                                  )
                                : weatherData[0]['current']['condition']['text'] == 'Partly cloudy' ||
                                        weatherData[0]['current']['condition']['text'] ==
                                            'Cloudy' ||
                                        weatherData[0]['current']['condition']
                                                ['text'] ==
                                            'Overcast'
                                    ? SizedBox(
                                        height: size.height * 0.3,
                                        child: OverflowBox(
                                          minHeight: size.height * 0.3,
                                          maxHeight: size.height * 0.3,
                                          child: cloudy,
                                        ),
                                      )
                                    : weatherData[0]['current']['condition']['text'] ==
                                                'Patchy rain possible' ||
                                            weatherData[0]['current']
                                                    ['condition']['text'] ==
                                                'Patchy light rain' ||
                                            weatherData[0]['current']
                                                    ['condition']['text'] ==
                                                'Light rain' ||
                                            weatherData[0]['current']
                                                    ['condition']['text'] ==
                                                'Moderate rain at times' ||
                                            weatherData[0]['current']['condition']['text'] == 'Moderate rain' ||
                                            weatherData[0]['current']['condition']['text'] == 'Heavy rain at times' ||
                                            weatherData[0]['current']['condition']['text'] == 'Heavy rain' ||
                                            weatherData[0]['current']['condition']['text'] == 'Light rain shower' ||
                                            weatherData[0]['current']['condition']['text'] == 'Moderate or heavy rain shower' ||
                                            weatherData[0]['current']['condition']['text'] == 'Torrential rain shower'
                                        ? SizedBox(
                                            height: size.height * 0.3,
                                            child: OverflowBox(
                                              minHeight: size.height * 0.3,
                                              maxHeight: size.height * 0.3,
                                              child: rain,
                                            ),
                                          )
                                        : weatherData[0]['current']['condition']['text'] == 'Moderate or heavy rain with thunder' || weatherData[0]['current']['condition']['text'] == 'Patchy light rain with thunder' || weatherData[0]['current']['condition']['text'] == 'Thundery outbreaks possible'
                                            ? SizedBox(
                                                height: size.height * 0.3,
                                                child: OverflowBox(
                                                  minHeight: size.height * 0.3,
                                                  maxHeight: size.height * 0.3,
                                                  child: thunderstorm,
                                                ),
                                              )
                                            : weatherData[0]['current']['condition']['text'] == 'Sunny' || weatherData[0]['current']['condition']['text'] == 'Clear'
                                                ? SizedBox(
                                                    height: size.height * 0.3,
                                                    child: OverflowBox(
                                                      minHeight:
                                                          size.height * 0.3,
                                                      maxHeight:
                                                          size.height * 0.3,
                                                      child: sunny,
                                                    ),
                                                  )
                                                : weatherData[0]['current']['condition']['text'] == 'Patchy snow possible' || weatherData[0]['current']['condition']['text'] == 'Blowing snow'
                                                    ? SizedBox(
                                                        height:
                                                            size.height * 0.3,
                                                        child: OverflowBox(
                                                          minHeight:
                                                              size.height * 0.3,
                                                          maxHeight:
                                                              size.height * 0.3,
                                                          child: snow,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        height:
                                                            size.height * 0.3,
                                                        child: OverflowBox(
                                                          minHeight:
                                                              size.height * 0.3,
                                                          maxHeight:
                                                              size.height * 0.3,
                                                          child: sunny,
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
                                      // Jiffy.parse(weatherData[0]['location']
                                      //             ['localtime']
                                      //         .toString())
                                      //     .Hm,
                                      weatherData[0]['location']['localtime']
                                          .toString()
                                          .split(' ')[1],
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
                                  horizontal: size.width * 0.00,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Mist' ||
                                                forecastData[index]['forecast']
                                                            ['forecastday'][index]['day']
                                                        ['condition']['text'] ==
                                                    'Fog'
                                            ? SizedBox(
                                                height: size.height * 0.1,
                                                child: OverflowBox(
                                                  minHeight: size.height * 0.1,
                                                  maxHeight: size.height * 0.1,
                                                  child: mist,
                                                ),
                                              )
                                            : forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Partly cloudy' ||
                                                    forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] ==
                                                        'Cloudy' ||
                                                    forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] ==
                                                        'Overcast'
                                                ? SizedBox(
                                                    height: size.height * 0.1,
                                                    child: OverflowBox(
                                                      minHeight:
                                                          size.height * 0.1,
                                                      maxHeight:
                                                          size.height * 0.1,
                                                      child: cloudy,
                                                    ),
                                                  )
                                                : forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Patchy rain possible' ||
                                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Patchy light rain' ||
                                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Light rain' ||
                                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Moderate rain at times' ||
                                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Moderate rain' ||
                                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Heavy rain at times' ||
                                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Heavy rain' ||
                                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Light rain shower' ||
                                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Moderate or heavy rain shower' ||
                                                        forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Torrential rain shower'
                                                    ? SizedBox(
                                                        height:
                                                            size.height * 0.1,
                                                        child: OverflowBox(
                                                          minHeight:
                                                              size.height * 0.1,
                                                          maxHeight:
                                                              size.height * 0.1,
                                                          child: rain,
                                                        ),
                                                      )
                                                    : forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Moderate or heavy rain with thunder' || forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Patchy light rain with thunder' || forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Thundery outbreaks possible'
                                                        ? SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.1,
                                                            child: OverflowBox(
                                                              minHeight:
                                                                  size.height *
                                                                      0.1,
                                                              maxHeight:
                                                                  size.height *
                                                                      0.1,
                                                              child:
                                                                  thunderstorm,
                                                            ),
                                                          )
                                                        : forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Sunny' || forecastData[index]['forecast']['forecastday'][index]['day']['condition']['text'] == 'Clear'
                                                            ? SizedBox(
                                                                height:
                                                                    size.height *
                                                                        0.1,
                                                                child:
                                                                    OverflowBox(
                                                                  minHeight:
                                                                      size.height *
                                                                          0.1,
                                                                  maxHeight:
                                                                      size.height *
                                                                          0.1,
                                                                  child: sunny,
                                                                ),
                                                              )
                                                            : weatherData[0]['current']['condition']['text'] == 'Patchy snow possible' || weatherData[0]['current']['condition']['text'] == 'Blowing snow'
                                                                ? SizedBox(
                                                                    height:
                                                                        size.height *
                                                                            0.1,
                                                                    child:
                                                                        OverflowBox(
                                                                      minHeight:
                                                                          size.height *
                                                                              0.1,
                                                                      maxHeight:
                                                                          size.height *
                                                                              0.1,
                                                                      child:
                                                                          snow,
                                                                    ),
                                                                  )
                                                                : SizedBox(
                                                                    height:
                                                                        size.height *
                                                                            0.1,
                                                                    child:
                                                                        OverflowBox(
                                                                      minHeight:
                                                                          size.height *
                                                                              0.1,
                                                                      maxHeight:
                                                                          size.height *
                                                                              0.1,
                                                                      child:
                                                                          sunny,
                                                                    ),
                                                                  ),
                                        SizedBox(
                                          height: size.height * 0.005,
                                        ),
                                        Text(
                                          Jiffy.parse(forecastData[index]
                                                          ['forecast']
                                                      ['forecastday'][index]
                                                  ['date'])
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
                      Positioned(
                        top: size.height * 0.1,
                        left: size.width * 0.03,
                        child: searching
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.02),
                                child: Container(
                                  height: size.height * 0.08,
                                  width: size.width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),
                                  child: ListView.separated(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.02,
                                      vertical: size.height * 0.024,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _cityCountryCon.text =
                                                '${autoCompleteList[index]['name']}, ${autoCompleteList[index]['country']}';
                                            searching = false;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.pin_drop_outlined,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              '${autoCompleteList[index]['name']}, ${autoCompleteList[index]['country']}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: size.height * 0.020,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider();
                                    },
                                    itemCount: autoCompleteList.length,
                                  ),
                                ),
                              )
                            : const Center(),
                      ),
                    ],
                  ),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: size.height * 0.04),
                    Text(
                      'Getting Weather Data',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.height * 0.028,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
